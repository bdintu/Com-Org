.model  tiny
.data
bullet  db 10 DUP(22)

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
cmp     bullet[si], 22
jne     @A
mov     bullet[si], 21
@A:
jmp     mainloop

incsi:
inc     si
drawbullet:
    cmp     si, 10
    je      enddrawbullet
    cmp     bullet[si], 22
    je      incsi

    ;draw bullet
    push 	ax
    push 	dx

    mov 	ax, 80
    mov 	dl, bullet[si]
    mul 	dl
    add 	ax, si
    mov 	dx, 2
    mul 	dx
    mov 	di, ax

    pop 	dx
    pop 	ax

    mov     al, 'A'
    mov 	ah, 0fh
    mov 	cx, 1
    rep 	stosw
    
    add     di, 158
    mov     al, ' '
    mov 	ah, 0fh
    mov 	cx, 1
    rep 	stosw
    
    
    dec 	bullet[si]
    cmp     bullet[si], 0
    je      @B
    jmp     incsi

    @b:
    mov     bullet[si], 22

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
    jne      P
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
	mov 	dx, 0fffeh
	int 	15h
	pop 	dx
ret

ret
end main