.model tiny

.data
xaxis   db 0ah
yaxis   db 18h
player  db ' <_/^\_> $'
seed    dw ?

.code 
org     0100h

main:
xor     ax, ax
mov     ah, 00h
mov     al, 03h
int     10h

mov     ax, 0B800h
mov     es, ax

mainloop:
mov     ah, 01h
int     16h
jnz     changePos
jmp     drawplayer

changePos:
mov     ah, 00h
int     16h
cmp     al, 'a'
je      decXpos
cmp     al, 's'
je      incXpos
jmp     endchangePos

decXpos:
cmp     xaxis, 0
je      endchangePos
dec     xaxis
jmp     endchangePos
incXpos:
cmp     xaxis, 71
je      endchangePos
inc     xaxis
jmp     endchangePos

endchangePos:

drawplayer:
mov     cx, 0
printplayer:
push    ax
push    dx

mov     ax, 80
mov     dl, yaxis
mul     dl
add     al, xaxis
mov     dx, 2
mul     dx
mov     di, ax ; <-------- resault

pop     dx
pop     ax

mov     bx, cx
push    cx
mov     ah, 0fh
mov     cx, 1
mov     al, player[bx]
rep     stosw
pop     cx

inc     xaxis
inc     cx
cmp     cx, 9
jne     printplayer
sub     xaxis, 9

jmp     mainloop

exit:
ret
end main