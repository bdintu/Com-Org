        .model  tiny

        .data
msg     db      'Hello, world!$',0

        .code
        org     0100h
main:   mov     ah, 09h
        mov     dx, offset msg
        int     21h

        ret
        end     main
