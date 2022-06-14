; Vernamova sifra na architekture DLX
; Pavel Marek xmarek75

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xmarek75!"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   lb r6, 1 	; nactu cislo jedna do r2   				klic je ma(+13, -1)

loop:	
	lb r1, login(r6)	; ulozim pismeno na pozici r6 ze slova login do r1
	slti  r8,r1,97 		; if(r1 < 97) ? r8 = 1 , r8 = 0    kontrola jestli to je pismeno
	bnez r8, end       	; branch if r8 not equals zero  
	nop
	

	addi r1, r1, 13		; k resitru r1 prictu integer 13
	sgti r8, r1, 122	; if(r1 > 122)? r8 = 1 , r8 = 0
	beqz r8, continue	; branch if r8 equals zero, navesti continue
	nop
	addi r1, r1, -122	;
	addi r1, r1, 96		;
	
continue:
	sb cipher(r6), r1      	; do cipher na pozici r6 ulozim r1
	
	;dalsi pismeno tentokrat budu odcitat podle klice, -1
	addi r6, r6, 1		; zvysim pocitadlo o jedna
	
	lb r1, login(r6)	; ulozim pismeno na pozici r6 ze slova login do r1
	slti  r8,r1,97 		; if(r1 < 97) ? r8 = 1 , r8 = 0    kontrola jestli to je pismeno
	bnez r8, end      	; branch if r8 not equals zero 
	nop
	addi r1, r1, -1		; r1 - 1
	
	slti r8, r1, 97 	; if(r1<97)? then r8 = 1 else r8 =0
	beqz r8, next		; if(r8 == 0) jump next
	nop
	
	addi r1, r1, 26   ; jelikoz klic je ma, a -> -1, tak nejnizsi pozice je 96, staci preklopit na z, pricist 26

next:	 			
	
	sb cipher(r6), r1      	; do cipher na pozici r6 ulozim r1
	addi r6, r6, 1		; zvysim pocitadlo o jedna
j loop
	


end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
