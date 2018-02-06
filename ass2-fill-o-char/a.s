.MODEL tiny

.DATA
	xory	db		; direction level 2 {
					;	0 : Top to Down | Down to TOP
					;	1 : Left to Rigth | Rigth to Left
					; }

.CODE
ORG 100h

MAIN:

INIT:
	mov xory, 0		; set xory
	mov ch, 0		; direction y (0: top to down, 1: down to top)
	mov cl, 0		; direction x (0: left to right, 1: right to left)
	mov dh, 0		; position cursor y-axis
	mov dl, 0		; position cursor x-axis

CLS:
	mov ah, 0h		; Clear Screen
	mov al, 3h
	int 10h

SET_POS:
	mov ah, 02h		; Set Cursor
	int 10h

WRITE_CHAR:
	push cx			
	mov ah, 0ah		; Write char om cursor
	mov al, 4fh		; 'O'
	mov bh, 0h
	mov cx, 01h
	int 10h
	pop cx

DELAY:
	push dx
	push cx
	mov ah, 86h		; delay
	mov cx, 0h
	mov dx, 2710h
	int 15h
	pop cx
	pop dx
	
CHK_XORY:			; check direction level 2
	cmp xory, 0		; if xory = 0 
	jz CHK_X		;	check x-axis
					; else
	jmp CHK_Y		;	check y-axis

CHK_X:				; check direct x-axis
	cmp cl, 0		; if dir-x = 0 (left -> right)
	jz INC_X		;	INC_X
					; else (right to left)
	jmp DEC_X		;	DEC_X

CHK_Y:				; check direction y-axis
	cmp ch, 0		; if dir-y = 0 (top -> down)
	jz INC_Y		;	INC_Y
					; else (down to top)
	jmp DEC_Y		;	DEC_Y

INC_X:
	cmp dl, 79		; if x = 79
	je CHK_Y		;	check y-axis
					; else
	inc dl			;	x++
	jmp CHK_XORY_Y	;	check xory y-axis

DEC_X:
	cmp dl, 0		; if x = 0
	je CHK_Y		;	check y-axis
					; else
	dec dl			;	x--
	jmp CHK_XORY_Y	;	check xory y-axis
	
INC_Y:
	cmp dh, 24		; if y = 24
	je CHK_X	;		check x-axis
					; else
	inc dh			;	y++
	jmp CHK_XORY_X	;	check xory x-axis

DEC_Y:
	cmp dh, 0		; if y = 0
	je CHK_X		;	cehck x-axis
					; else
	dec dh			;	y--
	jmp CHK_XORY_X	;	check xory x-axis

CHK_XORY_X:
	cmp xory, 0		; if xory = 0 (top to down |  down to top)
	je XOR_X		;	xor x, 1
	jmp SET_POS

CHK_XORY_Y:
	cmp xory, 1		; if xory = 1 (left to right | right to top) 
	je XOR_Y		;	xor y, 1
	jmp SET_POS

XOR_X:
	xor cl, 1		; invert xory
	jmp SET_POS

XOR_Y:
	xor ch, 1		; invert xory
	jmp SET_POS

EXIT:
	ret

END MAIN
