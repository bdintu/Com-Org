        .model  tiny

        .code
        org     0100h
main:   mov     ax, 0B800h
        mov     es, ax
        mov     di, 0
        mov     cx, 80*20
        mov		al, 'H'
        ;mov     ax, 2841h
        rep     stosw

        ret
        end     main
