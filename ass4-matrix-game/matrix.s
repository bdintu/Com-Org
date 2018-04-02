RAIN_SIZE		equ		0ah
X_MAX			equ		21 + RAIN_SIZE
DEFAULT_RAIN	equ		-01h
DEFAULT_BULLET	equ		21
LIFE_POS		equ		2*(1*80 + 9)
COL_N			equ		0ah

.model	tiny

.data
	level 	dw 	0h
	seed	dw	?
	seed_ch	dw	?
	life	db	'9', 0fh

	rain	db	10	dup(DEFAULT_RAIN)
	rain_ch	db	10	dup(00h)
	lane	db	14, 20, 26, 32, 38, 44, 50, 56, 62, 68

	bullet  db	10 DUP(DEFAULT_BULLET)

	; ''.join([chr(i) for i in range(33, 127)])
	alpha	db	'!#$%&\()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}'	; 90

	gameS	db '//=========|                                                           |======\\'
			db '|| life: _ |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||   Balm  |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||   &     |     |     |     |     |     |     |     |     |     |     |      ||'
			db '|| Jay     |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '|| 0759    |     |     |     |     |     |     |     |     |     |     |      ||'
			db '|| 0744    |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||  Com    |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||   Org   |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |     |     |     |     |     |     |     |     |     |     |      ||'
			db '||         |## ##|## ##|## ##|## ##|## ##|## ##|## ##|## ##|## ##|## ##|      ||'
			db '||         |  Q  |  W  |  E  |  R  |  T  |  Y  |  U  |  I  |  O  |  P  |      ||'
			db '\\============================================================================//$'
;	pos		db '01234567890123456789012345678901234567890123456789012345678901234567890123456789'	
	titleS	db '//============================================================================\\'
			db '||                                                                            ||'
			db '||   OOOOO O           OOOO    OOOO                                           ||'
			db '||     O   O   OOO    OOOOOO  OOOOOO                                          ||'
			db '||     O   OOO OOO   OOOOOOOOOOOOOOOO              O           O  OOO    OOO  ||'
			db '||     O   O O O    OOO     OO     OOO             O               OOO  OOO   ||'
			db '||     O   O O OOO OOO              OOO    OOOOO OOOOO OO  OO  O    OOOOOO    ||'
			db '||                OOO                OOO       O   O    O  O   O     OOOO     ||'
			db '||               OOO                  OOO   OOOO   O     OO    O    OOOOOO    ||'
			db '||              OOO                    OOO  O  O   O    O  O   O   OOO  OOO   ||'
			db '||             OOO                      OOO OOOO   O     OO    O  OOO    OOO  ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                  press key numbber                                         ||'
			db '||                                                                            ||'
			db '||                       1 EASY    -- SLOWLY SPEED                            ||'
			db '||                       2 NORMAL  -- CHIELD LIFE                             ||'
			db '||                       3 VETERAN -- SUPER FAST RAIN                         ||'
			db '||                       4 EXIT                                               ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'			
			db '||                                                                            ||'
			db '\\============================================================================//$'
		   
	overS	db '//============================================================================\\'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||        OOOOOO                    OO  OOOOOO                                ||'
			db '||        OOOOOOO                   OO OOOOOOO                   OOOOO        ||'
			db '||        OO      OOOOO  OOOOO   OOOOO OO       OOOOO OO        OOOOOO        ||'
			db '||        OO OOOO OOOOOO OOOOOO OOOOOO OO OOOO OOOOOO OOOO OOOO OO  OO        ||'
			db '||        OO OOOO OO  OO OO  OO OO  OO OO OOOO     OO OOOOOOOOO OOOOOO        ||'
			db '||        OO   OO OO  OO OO  OO OO  OO OO   OO OOO OO OO OOO OO OO            ||'
			db '||        OOOOOOO OOOOOO OOOOOO OOOOOO OOOOOOO OOOOOO OO     OO OOOOO         ||'
			db '||         OOOOOO  OOOOO  OOOOO OOOOO  OOOOOO  OOOOO  O       O OOOOOO        ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                        Press Enter to exit program                         ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '||                                                                            ||'
			db '\\============================================================================//$'

	titleB	dw 1175, 2
			dw 1075, 2
			dw 1875, 4
			dw 1568, 4
			dw 1397, 4
			dw 1175, 2
			dw 1175, 2
			dw 1618, 4
			dw 1308, 4
			dw 1675, 4
			dw 1260, 4
			dw 1568, 4
			dw 1675, 2
			dw 1165, 2
			dw 2349, 4
			dw 2975, 4
			dw 1568, 4
			dw 1797, 4
			dw 1718, 4
			dw 2047, 2
			dw 2047, 2
			dw 1975, 4
			dw 1568, 4
			dw 1760, 4
			dw 1568, 4
			dw  00h,00h
			
	overB	dw 1568, 4
			dw 1165, 2
			dw 2349, 4
			dw 2975, 4
			dw 2047, 2
			dw 2047, 2
			dw 1075, 2
			dw 1875, 4
			dw 1975, 4
			dw 1568, 4
			dw 1397, 4
			dw 1175, 2
			dw 1175, 2
			dw 1568, 4
			dw 1797, 4
			dw 1718, 4
			dw 1175, 2
			dw 1618, 4
			dw 1308, 4
			dw 1675, 4
			dw 1260, 4
			dw 1568, 4
			dw 1675, 2
			dw 1760, 4
			dw 1568, 4
			dw  00h,00h

.code
	org		0100h
main:
	call	set_videoram
	call	clrscr
	call	hide_cursor

;print_mainS
	mov		si,		00h
	mov		dx,		00h
	mov     ah,		0fh
	printM:
		mov     di,		dx
		mov		al,		titleS[si]
		call	print
		inc		si
		add		dx,		2
		cmp		si,		80*24
		jne		printM
	
	mov 	level, 0ffffh	
	mov 	di, 2446
	mov     al, '*'
	mov 	ah, 02h
	mov 	cx, 1
	rep 	stosw

menu:
	mov		ah,		00h
	int		16h
	call 	set_level
	cmp 	al, 0dh							; enter ascii
	jne		menu
	cmp		level, 0h
	je		menu
	cmp 	level, 0aaaah
	jne 	print_gameS
	ret

print_gameS:
	mov		si,		00h
	mov		dx,		00h
	mov     ah,		0fh
	printG:
		mov     di,		dx
		mov		al,		gameS[si]
		call	print
		inc		si
		add		dx,		2
	
		cmp		si,		80*24
		jne		printG

	call	titleSound

while1:	
	call	delay

	call	rand_rain					; ret seed
	mov		si,			seed
	cmp		rain[si],	DEFAULT_RAIN
	jne		rander_init
	mov		rain[si],	DEFAULT_RAIN + 1

	call	rand_ch					; ret char to al
	mov		bx,		seed_ch
	mov		bl,		alpha[bx]
	mov		rain_ch[si]	, bl

	rander_init:
		mov		si,		00h
	rander_test:
		cmp		si,		COL_N
		je		main_bullet
	rander_body:
		cmp		rain[si],	DEFAULT_RAIN
		je		rander_inc
		
		mov		al,		rain_ch[si]
		call	print_rain

		call	chk_life
		call	print_life	
		cmp 	life, '0'
		je 		exit_half

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
		dec		rain[si]
		call	print_rain
		call	crachSound

		mov		rain[si],	DEFAULT_RAIN
		mov		bullet[si], DEFAULT_BULLET
	crash_inc:
		inc		si
		jmp		crash_test		 
goto_while1:
	jmp		while1

exit_half:
	jmp		exit

getch:
	mov     ah, 00h
	int     16h
	call    createBullet
	cmp 	al, 27
	jne		notesc
	ret
	notesc:
	cmp     bullet[si], DEFAULT_BULLET
	jne     @A
	mov     bullet[si], DEFAULT_BULLET -1
	@A:
	call	shootSound
	jmp     main_bullet

titleSound:                             ; start sound
        mov  si, offset titleB

        mov  dx,61h                  ; turn speaker on
        in   al,dx                   ;
        or   al,03h                  ;
        out  dx,al                   ;
        mov  dx,43h                  ; get the timer ready
        mov  al,0B6h                 ;
        out  dx,al                   ;

LoopIt:
		lodsw                        ; load desired freq.
        or   ax,ax                   ; if freq. = 0 then done
        jz   short LDone             ;
        mov  dx,42h                  ; port to out
        out  dx,al                   ; out low order
        xchg ah,al                   ;
        out  dx,al                   ; out high order
        lodsw                        ; get duration
        mov  cx,ax                   ; put it in cx (16 = 1 second)
        call PauseIt                 ; pause it
        jmp  short LoopIt

LDone:
		mov  dx,61h                  ; turn speaker off
        in   al,dx                   ;
        and  al,0FCh                 ;
        out  dx,al                   ;
		ret

PauseIt:                                ; some delay
        mov    ah, 86h
        mov    dx, 00h
        int    15h
		ret

overSound:                              ; game over sound

        mov  si, offset overB

        mov  dx,61h                  ; turn speaker on
        in   al,dx                   ;
        or   al,03h                  ;
        out  dx,al                   ;
        mov  dx,43h                  ; get the timer ready
        mov  al,0B6h                 ;
        out  dx,al                   ;

        call   LoopIt
        ret

shootSound:                             ; shoot sound
		mov      	al, 182         	; meaning that we're about to load
    	out       	43h, al         	; a new countdown value
    	mov      	ax, 2000		; countdown value is stored in ax. It is calculated by
                            			; dividing 1193180 by the desired frequency (with the
                            			; number being the frequency at which the main system
                            			; oscillator runs
    	out     	42h, al        		; Output low byte.
    	mov     	al, ah          		; Output high byte.
    	out     	42h, al               
    	in		al, 61h
                           			; to connect the speaker to timer 2
    	or      	al, 00000011b
    	out     	61h, al        	 	; Send the new value

	mov cx, 1000
	delay_sad1:
		shr dl, 15
	loop delay_sad1

		mov  	dx,61h                  	; turn speaker off
        in   	al,dx                   
        and  	al,0FCh                 
        out  	dx,al
	ret

crachSound:                             ; shoot sound
		mov      	al, 182         	; meaning that we're about to load
    	out       	43h, al         	; a new countdown value
    	mov      	ax, 800		; countdown value is stored in ax. It is calculated by
                            			; dividing 1193180 by the desired frequency (with the
                            			; number being the frequency at which the main system
                            			; oscillator runs
    	out     	42h, al        		; Output low byte.
    	mov     	al, ah          		; Output high byte.
    	out     	42h, al               
    	in		al, 61h
                           			; to connect the speaker to timer 2
    	or      	al, 00000011b
    	out     	61h, al        	 	; Send the new value

	mov cx, 4000
	delay_sad2:
		shr dl, 15
	loop delay_sad2

		mov  	dx,61h                  	; turn speaker off
        in   	al,dx                   
        and  	al,0FCh                 
        out  	dx,al
	ret

incsi:
inc     si
drawbullet:
    cmp     si, 10
    je      enddrawbullet
    cmp     bullet[si], DEFAULT_BULLET
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
    mov 	ah, 04h
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

set_level:
		cmp		al, '1'
		jne		@2
		mov 	level, 0ffffh
		mov 	di, 2446
		jmp 	@5
	@2:	cmp 	al, '2'
		jne		@3
		mov 	level, 08fffh
		mov 	di, 2606
		jmp 	@5
	@3:	cmp		al, '3'
		jne 	@4
		mov		level, 04fffh
		mov 	di, 2766
		jmp 	@5
	@4: cmp		al, '4'
		jne 	endset
		mov		level, 0aaaah
		mov 	di, 2926
	@5:
		push 	ax
		push 	di
		mov 	di, 2446
		mov     al, ' '
		mov 	ah, 0fh
		mov 	cx, 1
		rep 	stosw
		mov 	di, 2606
		mov     al, ' '
		mov 	ah, 0fh
		mov 	cx, 1
		rep 	stosw
		mov 	di, 2766
		mov     al, ' '
		mov 	ah, 0fh
		mov 	cx, 1
		rep 	stosw
		mov 	di, 2926
		mov     al, ' '
		mov 	ah, 0fh
		mov 	cx, 1
		rep 	stosw
		pop 	di
		pop 	ax

		push 	ax
		mov     al, '*'
		mov 	ah, 02h
		mov 	cx, 1
		rep 	stosw
		pop 	ax
	endset:
		ret

hide_cursor:
	mov		ch,		32
	mov		ah,		01h
	int 	10h
	ret

set_videoram:
	mov		ax,		0b800h
	mov		es,		ax
	ret
	
print:							; get ax, dx
	mov     di,		dx
	mov     cx,		1
	rep     stosw
	ret

clrscr:
	mov		ah,		00h
	mov		al,		' '
	mov		si,		00h
	mov		dx,		00h
	loop_clrscr:
		mov     di,		dx
		call	print
		inc		si
		add		dx,		2
		cmp		si,		80*24
		jne		loop_clrscr
	ret

delay:
	mov     cx,		00h
	mov     dx,		level
	mov     ah,		86h
	int     15H
	ret

rand_rain:
	mov		ah,		00h
	mov		ax,		seed
	
	mov		cx,		81
	mul		cx
	add		ax,		17

	mov		cx,		80
	xor		dx,		dx
	div		cx

	mov		seed,	dx
	ret

rand_ch:
	mov		ah,		00h
	mov		ax,		seed_ch
	
	mov		cx,		91
	mul		cx
	add		ax,		17

	mov		cx,		90
	xor		dx,		dx
	div		cx

	mov		seed_ch,	dx
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
; print_over
	mov		si,		00h
	mov		dx,		00h
	mov     ah,		0fh
	printO:
		mov     di,		dx
		mov		al,		overS[si]
		call	print
		inc		si
		add		dx,		2
	
		cmp		si,		80*24
		jne		printO
		
	call	overSound

	mov 	ah, 00h
	int 	16h

	ret
	end		main
