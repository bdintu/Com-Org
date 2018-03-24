        .model  tiny

        .code
        org     0100h
main:   mov     ah, 00h         ; Set to 80x25
        mov     al, 03h
        int     10h

        mov     ah, 02h         ; Move cursor XY
        mov     bh, 00h
        mov     dh, 13
        mov     dl, 40
        int     10h

        mov     ah, 09h         ; Write a colored char
        mov     al, '@'
        mov     bh, 00h
        mov     bl, 42h
        mov     cx, 0001h
        int     10h

        ret
        end     main
