.model	tiny

.data
	head	db 80	dup(?)

.code
	org		0100h
main:

set_video:
	mov		ah,		00h
	mov		al,		03h
	int		010h

init:
	mov		ax,		0b800h
	mov		es,		ax

	mov		si,			01h
	mov		head[si],	00h

	mov		cx,		25
rander:
	push	cx

	mov		ah,		'J'
	mov		al,		02h
	call	print
	call	delay
	inc		head[si]

	pop		cx
	loop	rander

	jmp exit

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

set_color:
	mov		dl,		head[si]
	sub		bl,		
	ret

delay:
	mov		cx,		65535
	abc:
		nop
		loop	abc
	ret

exit:
	ret
	end		main
