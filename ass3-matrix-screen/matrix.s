.model tiny

.data
	head		db 80 dup (?)	; array x-axis keep head position random
	char		db ?			; char random, seed random

.code
	org     0100h

main:

;rand_seed
	mov		ah,		00h			; Read System-Timer Time Counter
	int		1ah					; System Timer and Clock Services
								; ret {cx= High-order part of clock count, dx= Low-order part of clock count}

	mov		ax,		dx
 	mov		char,	dl

	mov		si,		00h
rand_head:						; while 80 time for random y-position head
								; char = f(char) = (5*char + 7) % 37 (prime number)
	mov		al,		char
	mov		dl,		05h			; dl = 5
	mul		dl					; ax = al * dl
	add		ax,		07h			; ax += 7
	mov		dl,		25h			; dl = 37
	div		dl					; {da, ax} = ax % dl

	mov		char, ah
	mov		head[si], ah

	inc		si
	cmp		si,		50h
	jl		rand_head

;set_video
	mov		ah,		00h			; Set Video Mode
	mov		al,		03h			; Type:text, Resolution:80x25
	int 	010h				; Video and Screen Services

	mov		bh,		00h			; Display page number
	mov		cx,		01h			; Number of times to write character
	mov		dx,		00h
	mov		si,		00h

set_cursor:
	mov		ah,		02h			; Set Cursor Position
	int		010h				; Video and Screen Services

;set_color
	mov		bl,		head[si]
	sub		bl,		dh			; bl = bl - dh
								; head -= y-axis_rander

	cmp		bl,		00h			; position 0 form head
	jc		color_white

	cmp		bl,		01h			; position 1 form head
	jc		color_lgray

	cmp		bl,		02h			; position 2 form head
	jc		color_gray

	cmp     bl,     05h         ; position 3-5 form head
	jc		color_lgreen

	cmp     bl,     09h         ; position 6-9 form head
	jc		color_green

	jmp		color_black			; (bl>9 || bl<0) print fount color (black)ground

color_black:
	mov		bl, 00h
	jmp		rand_char

color_green:
	mov		bl, 02h
	jmp     rand_char

color_lgray:
	mov		bl, 07h
	jmp     rand_char

color_gray:
	mov		bl, 08h
	jmp     rand_char

color_lgreen:
	mov		bl, 0ah
	jmp     rand_char

color_white:
	mov		bl, 0fh

rand_char:
	push	dx
	mov		al,		char		; char = [33, 126] = f(char) = (char%94) +33
	mov		dl,		5eh			; dl = 94
	div		dl					; ax = al % dl
	add		ax,		21h			; ax += 33 
	mov		char,	ah
	pop		dx

;print_char
	mov		ah,		9h        	; Write Character and Attribute at Cursor
	mov		al,		char		; ASCII value of character
	int		10h					; Video and Screen Services

;chk_endline
	cmp		dl,		50h      	; if x = 80
	je		newline      		; 	newline
	inc		dl					; inc x
	inc		si					; inc si
	jmp		set_cursor

newline:
	cmp		dh,		18h       	; if y = 25
	je		ch_head				; 	change head	
	mov		dl,		00h        	; y = 0
	mov		si,		00h			; si = 0
	inc		dh					; inc y
	jmp		set_cursor

ch_head:
;delay
	mov		ah,		86h			; Wait
	mov		cx,		01h			; Hight time	
	mov		dx,		00h			; Low time
	int		15h					; Cassette and Extended Services 

	mov		si,		00h
inc_head:
	inc		head[si]			; head[si]++
	cmp		head[si],	25h		; if head[si] == 37
	jne		inc_si
	mov		head[si],	00h		;	head[si] = 0

inc_si:
	inc		si					; si++
	cmp		si,		50h			; if si == 80
	jne		inc_head
	jmp		set_cursor

exit:
	ret
	end     main
