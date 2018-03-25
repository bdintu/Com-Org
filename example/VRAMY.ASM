        .model  tiny
        .data
ChrClr  db      'A', 02h        ; Char and Color

        .code
        org     0100h
main:   mov     ah, 00h         ; Set to 80x25
        mov     al, 03h
        int     10h

        mov     ax, 0B800h      ; Point to VRAM addr
        mov     es, ax

        mov     di, 0000h
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*24
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*1
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*23
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*2
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*22
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*3
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*21
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*4
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*20
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*5
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*19
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*6
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*18
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     di, 0000h
        mov     cx, 80*7
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     cx, 80
        mov     ax, word ptr ChrClr
        rep     stosw
        mov     cx, 80*17
        mov     ax, word ptr ChrClr
        mov     ah, 00h         ; Hide them!
        rep     stosw
        mov     ah, 00h         ; Wait for a keypress
        int     16h

        mov     ax, 0003h       ; Clear screen back
        int     10h

        ret
        end     main
