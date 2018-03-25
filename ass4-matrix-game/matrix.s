RAIN_SIZE		equ		0ah
X_MAX			equ		25 + RAIN_SIZE
DEFAULT_RAIN	equ		-01h

.model	tiny

.data
	seed	dw	?
	head	db	80	dup(DEFAULT_RAIN)
	life	db	'9', 0fh

	alpha	db	'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
	
	titleS	db '//============================================================================\\'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                     ___ _ __   __ _  ___ ___                               ||'
			db '||                    / __| ''_ \ / _` |/ __/ _ \                             ||'
			db '||                    \__ \ |_) | (_| | (_|  __/                              ||'
			db '||                    |___/ .__/ \__,_|\___\___|                              ||'
			db '||                        |_|         _                                       ||'
			db '||                                   (_) __ _ _ __ ___                        ||'
			db '||                                   | |/ _` | ''_ ` _ \                      ||'
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
		   
	over	db '//============================================================================\\'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                      ____                                                  ||'
			db '||                     / ___| __ _ _ __ ___   ___                             ||'
			db '||                    | |  _ / _` | ''_ ` _ \ / _ \                           ||'
			db '||                    | |_| | (_| | | | | | |  __/                            ||'
			db '||                     \____|\__,_|_| |_| |_|\___|                            ||'
			db '||                                    ___                                     ||'
			db '||                                   / _ \__   _____ _ __                     ||'
			db '||                                  | | | \ \ / / _ \ ''__|                   ||'
			db '||                                  | |_| |\ V /  __/ |                       ||'
			db '||                                   \___/  \_/ \___|_|                       ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                            Your score:                                     ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                    Press Enter to go back to main menu                     ||'
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
	
; print_title


init:
	mov		ax,		0b800h
	mov		es,		ax

while1:

;getch
	mov		ah,		01h
	int		16h
	cmp		al,		1Bh
	je		exit_half

	call	rand_rainpos					; ret seed
	mov		si,			seed
	cmp		head[si],	DEFAULT_RAIN
	jne		rander_init
	mov		head[si],	00h
	
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
		call	print_life

		inc		head[si]
	
		cmp		head[si],	X_MAX
		jne		rander_inc
		mov		head[si],	DEFAULT_RAIN

		call	delay
	rander_inc:
		inc		si
		jmp		rander_test


jmp		while1

rand_rainpos:
	mov		ax,		7
	mov		dx,		seed
	mul		dx
	xor		dx,		dx
	mov		cx,		71
	div		cx
	add		dl,		4
	mov		seed,	dx
	ret

rand_ch:
	mov		ax,		7

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

print_life:
	mov		ax,		word ptr life
	mov		dh,		0
	mov		dl,		75
	call	print

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
