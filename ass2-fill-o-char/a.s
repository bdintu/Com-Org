.MODEL tiny

.DATA
	xory	db

.CODE
ORG 100h

MAIN:

INIT:
	mov xory, 0
	mov ch, 0
	mov cl, 0	
	mov dh, 0
	mov dl, 0

CLS:
	mov ah, 0h		; Clear Screen
	mov al, 3h
	int 10h

SET_POS:
	mov ah, 02h		; Set Position
	int 10h

WRITE_CHAR:
	push cx
	mov ah, 0ah
	mov al, 4fh
	mov bh, 0h
	mov cx, 01h
	int 10h
	pop cx

DELAY:
	push dx
	push cx
	mov ah, 86h
	mov cx, 0h
	mov dx, 2710h
	int 15h
	pop cx
	pop dx
	
CHK_XORY:
	cmp xory, 0
	jz CHK_X
	jmp CHK_Y

CHK_X:				; check direct x
	cmp cl, 0		; if xdt = 0 (left -> right)
	jz INC_X		;	INC_X
	jmp DEC_X		; else (1) (right -> left)
					;	DEC_X

CHK_Y:
	cmp ch, 0		; if ydt = 0 (top -> down)
	jz INC_Y		;	INC_Y
	jmp DEC_Y		; else (down to top)
					;	DEC_Y

INC_X:
	cmp dl, 79		; if x = 79
	je CHK_Y		;	CHK_Y (check Y-axis)
					; else
	inc dl			;	x++

	cmp xory, 1
	je XOR_Y
	jmp SET_POS

DEC_X:
	cmp dl, 0		; if x = 0
	je CHK_Y		;	CHK_Y (checkY-axis)
					; else
	dec dl			;	x--

	cmp xory, 1
	je XOR_Y
	jmp SET_POS
	
INC_Y:
	cmp dh, 24		; if y = 24
	je CHK_X	;	New Round
					; else
	inc dh			;	y++

	cmp xory, 0
	je XOR_X
	jmp SET_POS		;	SET_POS

DEC_Y:
	cmp dh, 0		; if y = 0
	je CHK_X		;	New Round
					; else
	dec dh			;	y--

	cmp xory, 0
	je XOR_X
	jmp SET_POS		;	SET_POS

XOR_X:
	xor cl, 1		; xdt
	jmp SET_POS

XOR_Y:
	xor ch, 1
	jmp SET_POS

EXIT:
	ret

END MAIN
