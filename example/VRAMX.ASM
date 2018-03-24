        .model  tiny
        .data
ChrClr  db      'A', 00h        ; Char and Color

        .code
        org     0100h
main:   mov     ah, 00h         ; Set to 80x25
        mov     al, 03h
        int     10h

refresh:mov     ax, 0B800h      ; Fill screen with ChrClr
        mov     es, ax
        mov     di, 0
        mov     cx, 80*25
        mov     ax, word ptr ChrClr
        rep     stosw

        push    ax              ; Random Clr with Ticks of the Day
        mov     ah, 00h
        int     1Ah
        shr     dl, 4           ; Try to slow down
        pop     ax
        add     al, dl
        and     al, 0Fh         ; Only foreground color
        mov     ChrClr[1], al   ; Save only Clr but not Chr

        mov     ah, 0Bh         ; Press any key to exit
        int     21h
        cmp     al, 00h
        jz      refresh

        ret
        end     main
