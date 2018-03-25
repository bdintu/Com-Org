.model tiny


.data
column 	db 80 DUP(0)
seed 	dw ?

.code
org 	0100h

main:

mov 	ah, 00h
mov 	al, 03h
int 	10h

mov 	ax, 0B800h
mov 	es, ax

;set begin rand(seed)
mov 	ah, 2ch
int 	21h
mov 	seed, dx

mainLoop:

; one times in main loop
; program generate a new column >> column[si] != 0
; after generate program print all rain drop 1 line
; then delay and (press any key)? exit program : go mainloop;  

call 	startcolumn
xor 	si, si
call	printRain
call	delay

mov     ah, 0Bh         ;Press any key to exit
int     21h
cmp     al, 00h
jz      mainLoop
jmp		exit

;-------------------------------------- FUNCTION -------------------------------------
incsi:
	inc 	si
printRain:
	cmp 	si, 80			; cmp, is this the end column
	je 		endprintRain	; yes, end print rain
	cmp 	column[si], 0	; column[si] > 0 is rain matrix
	je 		incsi			; inc si if that column doesn't rain matrix
	call 	print			; print 1 rain matrix
	jmp 	incsi			; go back until the end of column

endprintRain:
ret

startcolumn:
	call	newcolumn		; random find new column
	cmp		column[si], 0	; if that column doesn't have rain that the new rain column
	jne		startcolumn
	inc		column[si]		; this tell new rain has generate :: rain matrix --> column[si] > 0
ret

newcolumn:
	call 	rand
	mov 	ax, seed
	xor 	dx, dx
	mov 	cx, 79
	div 	cx
	mov 	si, dx		
	inc 	si			; si store only value 1 - 79
ret

rand:
	mov		ax, seed
	xor 	dx, dx
	mov		cx, 94
	div		cx			;div ax, cx -- dx contain remainder
	add		dl, 33		;dl store number 33 to 126
	mov		ah, dl
	mov		seed, ax  	;manage seed to next random -- ax is result [div ax, cx]
ret	

printc:
	; ah store ascii from random function {rand}
	; al set color. set color in print function below
	push 	ax
	push 	dx

	mov 	ax, 80
	mov 	dl, column[si]
	mul 	dl
	add 	ax, si
	mov 	dx, 2
	mul 	dx
	sub 	ax, 1
	mov 	di, ax

	pop 	dx
	pop 	ax
	
	mov 	al, 0fh
	mov 	cx, 1
	rep 	stosw

	dec 	column[si]
	ret


delay:
	push	dx
	mov 	ah, 86h
	mov 	cx, 0001h
	mov 	dx, 0000h
	int 	15h
	pop 	dx
ret

print:
; rain length is 8

	CALL 	RAND
	CALL 	printc
	CALL 	RAND 
	CALL 	printc
	
	CALL 	RAND
	CALL 	printc 
	CALL 	RAND
	CALL 	printc 
	CALL 	RAND
	CALL 	printc 
	CALL 	RAND
	CALL	printc
	 
	CALL 	RAND
	CALL 	printc 
	CALL	RAND
	CALL 	printc

	mov		ah, ' '		; delete last character
	call 	printc

	add 	column[si], 10 		; 9 is len(rain) + 1
	cmp		column[si], 34		; -----------------------------------
	JNE		b					; reposition if last rain is on below
	mov		column[si], 0		; -----------------------------------
b:	  
ret

exit:

ret
end main