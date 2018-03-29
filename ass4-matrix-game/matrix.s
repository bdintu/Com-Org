RAIN_SIZE		equ		0ah
X_MAX			equ		21 + RAIN_SIZE
DEFAULT_RAIN	equ		-01h
DEFAULT_BULLET	equ		21
LIFE_POS		equ		2*(1*80 + 9)
COL_N			equ		0ah

.model	tiny

.data
	seed	dw	?
	life	db	'9', 0fh

	rain	db	10	dup(DEFAULT_RAIN)
	lane	db	14, 20, 26, 32, 38, 44, 50, 56, 62, 68

	bullet  db	10 DUP(DEFAULT_BULLET)

	; ''.join([chr(i) for i in range(33, 127)])
	alpha	db	'!#$%&\()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}'	; 90

	gameS	db '//=========|                                                           |======\\'
			db '|| life: 9 |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||    Balm |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||   Game  |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '|| 0759    |     |     |     |     |     |     |     |     |     |     |      ||'
			db '|| 0744    |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |#####|#####|#####|#####|#####|#####|#####|#####|#####|#####|      ||'
			db '||         |  Q  |  W  |  E  |  R  |  T  |  Y  |  U  |  I  |  O  |  P  |      ||'
			db '\\============================================================================//$'
;	pos		db '01234567890123456789012345678901234567890123456789012345678901234567890123456789'	
	titleS	db '//============================================================================\\'
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
		   
	overS	db '//============================================================================\\'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                      ____                                                  ||'
			db '||                     / ___| __ _ _ __ ___   ___                             ||'
			db '||                    | |  _ / _` | ''_ ` _ \ / _ \                            ||'
			db '||                    | |_| | (_| | | | | | |  __/                            ||'
			db '||                     \____|\__,_|_| |_| |_|\___|                            ||'
			db '||                                    ___                                     ||'
			db '||                                   / _ \__   _____ _ __                     ||'
			db '||                                  | | | \ \ / / _ \ ''__|                    ||'
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
	call	set_videoram
	call	clrscr
	call	hide_cursor

; printxy_title        
	mov		si,		00h
	mov		dx,		00h
	mov     ah,		0fh
	mov     cx,		1
	pritil:
		mov     di,		dx
		mov		al,		[gameS+si]
		call	print
		inc		si
		add		dx,		2
	
		cmp		si,		80*24
		jne		pritil

while1:	
	call	delay

	;mov		ah,		01h
	;int		16h
	;cmp		al,		1Bh						; isEsc
	;je		exit_half

	call	rand_rainpos					; ret seed
	mov		si,			seed
	cmp		rain[si],	DEFAULT_RAIN
	jne		rander_init
	mov		rain[si],	DEFAULT_RAIN + 1
	
	rander_init:
		mov		si,		00h
	rander_test:
		cmp		si,		COL_N
		je		main_bullet
	rander_body:
		cmp		rain[si],	DEFAULT_RAIN
		je		rander_inc

		call	rand_char				; ret char to al
		call	print_rain

		call	chk_life
		call	print_life	

		inc		rain[si]
	
		cmp		rain[si],	X_MAX
		jne		rander_inc
		mov		rain[si],	DEFAULT_RAIN

	rander_inc:
		inc		si
		jmp		rander_test
		
	main_bullet:
		mov     ah, 01h
		int     16h
		jne     getch

		xor     si, si
		call    drawbullet

	crash_init:
		mov		si,		00h
	crash_test:
		cmp		si,		COL_N
		je		goto_while1
	crash_body:
		mov		dh,		bullet[si]
		mov		dl,		rain[si]
		sub		dh,		dl				; bullet = bullet - rain
		cmp		bullet[si],		dl
		jge		crash_inc

		mov		al,		' '				; ret char to al
		call	print_rain

		mov		rain[si],	DEFAULT_RAIN
		mov		bullet[si], DEFAULT_BULLET
	crash_inc:
		inc		si
		jmp		crash_test		 
goto_while1:
	jmp		while1

getch:
	mov     ah, 00h
	int     16h
	call    createBullet
	cmp     bullet[si], DEFAULT_BULLET
	jne     @A
	mov     bullet[si], DEFAULT_BULLET -1
	@A:
	jmp     main_bullet

incsi:
inc     si
drawbullet:
    cmp     si, 10
    je      enddrawbullet
    cmp     bullet[si], DeFAULT_BULLET
    je      incsi

    dec 	bullet[si]
    ;draw bullet
    ;-------------------
    ; set position di
    ;-------------------
    push 	ax
    push 	dx
    mov 	ax, 80
    mov 	dl, bullet[si]
    mul 	dl
    add 	ax, 14

    push    ax
    mov     ax, 6
    mul     si
    mov     dx, ax
    pop     ax
    add     ax, dx
    
    mov 	dx, 2
    mul 	dx
    mov 	di, ax
    pop 	dx
    pop 	ax
    ;-------------------
    ; draw bullet
    ;-------------------
    mov     al, 'A'
    mov 	ah, 0fh
    mov 	cx, 1
    rep 	stosw
    ;-------------------
    ; delete bullet
    ;-------------------
    add     di, 158
    mov     al, ' '
    mov 	ah, 0fh
    mov 	cx, 1
    rep 	stosw
    
    cmp     bullet[si], 0
    je      @b
    jmp     incsi
    @b:
    push    ax
    mov     ax, si
    mov     dx, 6
    mul     dx
    add     ax, 14
    mov     dx, 2
    mul     dx
    mov     di, ax
    pop     ax
    mov     al, ' '
    mov 	ah, 0fh
    mov 	cx, 1
    rep 	stosw

    mov     bullet[si], 21
    jmp     drawbullet

    enddrawbullet:
ret

createBullet:
    Q:
    cmp     al, 'q'
    jne     W
    mov     si, 0
    ret
    W:
    cmp     al, 'w'
    jne     E
    mov     si, 1
    ret
    E:
    cmp     al, 'e'
    jne     R
    mov     si, 2
    ret
    R:
    cmp     al, 'r'
    jne     T
    mov     si, 3
    ret
    T:
    cmp     al, 't'
    jne     Y
    mov     si, 4
    ret
    Y:
    cmp     al, 'y'
    jne     U
    mov     si, 5
    ret
    U:
    cmp     al, 'u'
    jne      I
    mov     si, 6
    ret
    I:
    cmp     al, 'i'
    jne     O
    mov     si, 7
    ret
    O:
    cmp     al, 'o'
    jne     P
    mov     si, 8
    ret
    P:
    cmp     al, 'p'
    jne     endcreateBullet
    mov     si, 9

    endcreateBullet:
ret

exit_half:
	jmp		exit

hide_cursor:
	mov		ch,		32
	mov		ah,		01h
	int 	10h
	ret

set_videoram:
	mov		ax,		0b800h
	mov		es,		ax
	
print:							; get ax, dx
	mov     di,		dx
	mov     cx,		1
	rep     stosw
	ret

clrscr:
	mov		ah,		0
	mov		al,		' '
	mov		cx,		80*25
	mov		dx,		0
	call	print

;getch:
;	mov		ah,		01h
;	int		16h
;	ret

delay:
	mov     cx,		01h
	mov     dx,		0fffh
	mov     ah,		86h
	int     15H
	ret

rand_char:
	mov		al,		'J'
	ret

rand_rainpos:
	mov		ax,		7
	mov		dx,		seed
	mul		dx
	xor		dx,		dx
	mov		cx,		10
	div		cx
	add		dx,		1
	mov		seed,	dx
	ret

printxy:								; get ax, dx
	push	dx
	push	ax
	mov		ax,		80				; 2*(80*head[si] + si)
	mov		cl,		dh				; 2*(80*dh + dl)
	mul		cl
	
	xor		cx,		cx
	mov		cl,		dl
	add		ax,		cx
	mov		cx,		2
	mul		cx

	mov		dx,		ax
	pop		ax
	call	print
	pop		dx
	ret

chk_life:
	cmp		rain[si],	DEFAULT_BULLET
	jne		exit_chk_life
	dec		life
	exit_chk_life:
	ret

print_life:
	mov		ax,		word ptr life
	mov		dx,		LIFE_POS
	call	print
	ret

print_rain:
	mov		dl,		lane[si]
	mov		dh,		rain[si]

	mov		ah, 	0fh				; white
	call	printxy

	dec		dh
	mov		ah, 	07h				; lgray
	call	printxy

	dec		dh
	mov		ah, 	07h				; lgray
	call	printxy

	dec		dh
	mov		ah, 	02h				; green
	call	printxy

	dec		dh
	mov		ah, 	02h				; green
	call	printxy

	dec		dh
	mov		ah, 	02h				; green
	call	printxy

	dec		dh
	mov		ah, 	0ah				; lgreen
	call	printxy

	dec		dh
	mov		ah, 	0ah				; lgreen
	call	printxy

	dec		dh
	mov		ah, 	0ah				; lgreen
	call	printxy

	dec		dh
	mov		ah, 	0ah				; lgreen
	call	printxy

	dec		dh
	mov		ah, 	00h				; black
	mov		al,	' '
	call	printxy

	ret

exit:
	ret
	end		main
