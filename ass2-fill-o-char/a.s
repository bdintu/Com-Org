.MODEL tiny

.DATA
	x		db 0	; position axis-x
	y		db 0	; position axis-y
	xdt		db 0	; direct axis-x
	ydt		db 0	; direct axis-y
	round	db 4	; run 2 round
	xory	db 0	;

.CODE
ORG 100h

MAIN:

;INIT:
;	mov ch, 1		; direct axis-y round 2
;	mov cl, 1		; direct axis-x round 1
;	mov dh, 24		; position axis-y round 2
;	mov dl, 79		; position axis-x round 2
;	push cx			; push direct round 2 to stack
;	push dx			; push position round 2 to stack
;
;	mov ch, 0		; round 1
;	mov cl, 0	
;	mov dh, 0
;	mov dl, 0
;	push cx			; push round 1 to stack
;	push dx

CLS:
	mov ah, 0h		; Clear Screen
	mov al, 3h
	int 10h

;CHK_ROUND:
;	cmp round, 0
;	jz JMP_EXIT
;	dec round

;LOAD:
;	pop dx			; pop direct of top stack to register
;	pop cx			
;	mov x, dl		; mov dl(pos-x) to x
;	mov y, dh		; mov dh(pos-y) to y
;	mov xdt, cl		; mov cl(dir-x) to x
;	mov ydt, ch		; mov ch(dir-y) to y

SET_POS:
	mov ah, 02h		; Set Position
	mov dh, y
	mov dl, x
	int 10h

WRITE_CHAR:
	mov ah, 02h
	mov dl, 'o'		; Write 'o'
	int 21h

SET_DELAY:
	mov cx, 10000	; set range to loop

	DELAY:
		loop DELAY	; loop cx times
	
CHK_XORY:
	cmp xory, 0
	jz CHK_X
	jmp CHK_Y

JMP_EXIT:
	jmp EXIT

CHK_X:				; check direct x
	cmp xdt, 0		; if xdt = 0 (left -> right)
	jz INC_X		;	INC_X
	jmp DEC_X		; else (1) (right -> left)
					;	DEC_X

INC_X:
	cmp x, 79		; if x = 79
	je CHK_Y		;	CHK_Y (check Y-axis)
					; else
	inc x			;	x++

	cmp xory, 1
	je XOR_Y
	jmp SET_POS

DEC_X:
	cmp x, 0		; if x = 0
	je CHK_Y		;	CHK_Y (checkY-axis)
					; else
	dec x			;	x--

	cmp xory, 1
	je XOR_Y
	jmp SET_POS

XOR_Y:
	xor ydt, 1
	jmp SET_POS

CHK_Y:
	cmp ydt, 0		; if ydt = 0 (top -> down)
	jz INC_Y		;	INC_Y
	jmp DEC_Y		; else (down to top)
					;	DEC_Y
	
INC_Y:
	cmp y, 24		; if y = 24
	je CHK_X	;	New Round
					; else
	inc y			;	y++

	cmp xory, 0
	je XOR_X
	jmp SET_POS		;	SET_POS

DEC_Y:
	cmp y, 0		; if y = 0
	je CHK_X		;	New Round
					; else
	dec y			;	y--

	cmp xory, 0
	je XOR_X
	jmp SET_POS		;	SET_POS

XOR_X:
	xor xdt, 1
	jmp SET_POS

EXIT:
	ret

END MAIN
