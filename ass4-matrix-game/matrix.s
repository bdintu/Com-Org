RAIN_SIZE		equ		0ah
X_MAX			equ		25 + RAIN_SIZE
DEFAULT_RAIN	equ		-01h

.model	tiny

.data
	head	db 80	dup(DEFAULT_RAIN)

.code
	org		0100h
main:
; set_video
	mov		ah,		00h
	mov		al,		03h
	int		10h
; hid_cursor
	mov		ch,		32
	mov		ah,		01h
	int 	10h

init:
	mov		ax,		0b800h
	mov		es,		ax

;	call	rand				; ret si
	mov		si,			10h
	cmp		head[si],	DEFAULT_RAIN
	jne		rander_init
	mov		head[si],	00h

while1:

;getch:
;	mov		ah,		01h
;	int		09h
;	cmp		al,		00h
;	jne		exit_half
	
	rander_init:
		mov		si,		01h
	rander_test:
		cmp		si,		80
		je		while1
	rander_body:
		cmp		head[si],	DEFAULT_RAIN
		je		rander_inc

		mov		ah,		'J'
		call	print_rain
		call	delay
		inc		head[si]
	
		cmp		head[si],	20
		jne		rander_inc
		mov		head[si],	DEFAULT_RAIN

	rander_inc:
		inc		si
		jmp		rander_test

jmp		while1

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

exit_half:
	jmp		exit

print_rain:
					
	mov		al, 0fh				; white
	call	print
	dec		head[si]

	mov		al, 07h				; lgray
	call	print
	dec		head[si]

	mov		al, 07h				; lgray
	call	print
	dec		head[si]

	mov		al, 02h				; green
	call	print
	dec		head[si]

	mov		al, 02h				; green
	call	print
	dec		head[si]

	mov		al, 02h				; green
	call	print
	dec		head[si]

	mov		al, 0ah				; lgreen
	call	print
	dec		head[si]

	mov		al, 0ah				; lgreen
	call	print
	dec		head[si]
		
	mov		al, 0ah				; lgreen
	call	print
	dec		head[si]

	mov		al, 0ah				; lgreen
	call	print
	dec		head[si]

	mov		ah,	' '				; space
	mov		al, 00h				; black
	call	print
	add		head[si],		10

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
