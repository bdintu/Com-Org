RAIN_SIZE		equ		0ah
X_MAX			equ		25 + RAIN_SIZE
DEFAULT_RAIN	equ		-01h

.model	tiny

.data
	head	db	80	dup(DEFAULT_RAIN)
	life	db	'9', 00h
	
	titleMsg db '//============================================================================\\'
		   db '||                                                                            ||'
		   db '||                                                                            ||'
		   db '||                                                                            ||'
		   db '||                     ___ _ __   __ _  ___ ___                               ||'
		   db '||                    / __| ''_ \ / _` |/ __/ _ \                              ||'
		   db '||                    \__ \ |_) | (_| | (_|  __/                              ||'
		   db '||                    |___/ .__/ \__,_|\___\___|                              ||'
		   db '||                        |_|         _                                       ||'
		   db '||                                   (_) __ _ _ __ ___                        ||'
		   db '||                                   | |/ _` | ''_ ` _ \                       ||'
		   db '||                                   | | (_| | | | | | |                      ||'
		   db '||                                  _/ |\__,_|_| |_| |_|                      ||'
		   db '||                                 |__/                                       ||'
		   db '||                                                                            ||'
		   db '||                       EASY    -- UNLIMITED BULLETS                         ||'
		   db '||                       NORMAL  -- STARTS WITH 20 BULLETS                    ||'
		   db '||                       VETERAN -- 5 BULLETS TO YOU, CAN YOU SURVIVE?        ||'
		   db '||                       EXIT                                                 ||'
		   db '||                                                                            ||'
		   db '||                                                                            ||'
		   db '||                                                                            ||'
		   db '||                                                                            ||'
		   db '\\============================================================================//$'

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

show:
	mov		ax,		word ptr	life
	call	print

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

		mov		al,		'J'
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
	push	dx
	push	ax
	mov		ax,		80				; 2*(80*head[si] + si)
	mov		cl,		dh
	mul		cl
	
	xor		cx,		cx
	mov		cl,		dl
	add		ax,		cx
	mov		cx,		2
	mul		cx
	mov		di,		ax

	pop		ax
	mov		cx,		1
	rep		stosw
	pop		dx
	ret

exit_half:
	jmp		exit

print_rain:
	mov		dx,		si
	mov		dh,		head[si]

	mov		ah, 0fh				; white
	call	print

	dec		dh
	mov		ah, 07h				; lgray
	call	print

	dec		dh
	mov		ah, 07h				; lgray
	call	print

	dec		dh
	mov		ah, 02h				; green
	call	print

	dec		dh
	mov		ah, 02h				; green
	call	print

	dec		dh
	mov		ah, 02h				; green
	call	print

	dec		dh
	mov		ah, 0ah				; lgreen
	call	print

	dec		dh
	mov		ah, 0ah				; lgreen
	call	print

	dec		dh
	mov		ah, 0ah				; lgreen
	call	print

	dec		dh
	mov		ah, 0ah				; lgreen
	call	print

	dec		dh
	mov		ah, 00h				; black
	mov		al,	' '
	call	print

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
