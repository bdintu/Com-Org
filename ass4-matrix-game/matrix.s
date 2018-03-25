RAIN_SIZE	equ		0ah
X_MAX		equ		25 + RAIN_SIZE

.model	tiny

.data
	head	db 80	dup(?)

.code
	org		0100h
main:

set_video:
	mov		ah,		00h
	mov		al,		03h
	int		10h

hid_cursor:
	mov		ch,		32
	mov		ah,		01h
	int 	10h

init:
	mov		ax,		0b800h
	mov		es,		ax

;	call	rand				; ret si
	mov		si,			01h
	cmp		head[si],	0
	jne		rander_init
	mov		head[si],	01h
	
rander_init:
	mov		si,		01h
rander_body:
	cmp		head[si],	00h
	je		rander_inc

	mov		ah,		'J'
	mov		al,		02h
	call	print
;	call	set_color
	call	delay
	inc		head[si]

rander_inc:
	inc		si
	cmp		si,		80
	jne		rander_body

	jmp exit

;rand:
;	ret

print:
	push	ax
	mov		ax,		80				; 2*(80*head[si] + si) -1
	mov		dl,		head[si]
	mul		dl
	add		ax,		si
	mov		dx,		2
	mul		dx
	sub		ax,		1
	mov		di,		ax

	pop		ax
	mov		cx,		1
	rep		stosw
	ret

;set_color:
;	mov		dl,		head[si]
;	sub		bl,		
;	ret

delay:
	mov		cx,		65535
	abc:
		nop
		loop	abc
	ret

exit:
	ret
	end		main
