.model  tiny
.data
bullet  db 10 DUP(21)

.code
org     0100h

main:
mov     ah, 00h
mov     al, 03h
int     10h

mov     ax, 0b800h
mov     es, ax


mainloop:
mov     ah, 01h
int     16h
jne     getch

xor     si, si
call    drawbullet
call    delay
jmp     mainloop

getch:
mov     ah, 00h
int     16h
call    createBullet
cmp     bullet[si], 21
jne     @A
mov     bullet[si], 20
@A:
jmp     mainloop

incsi:
inc     si
drawbullet:
    cmp     si, 10
    je      enddrawbullet
    cmp     bullet[si], 21
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

    cmp     bullet[si], -1
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

delay:
	push	dx
	mov 	ah, 86h
	mov 	cx, 0000h
	mov 	dx, 0ffffh
	int 	15h
	pop 	dx
ret

ret
end main