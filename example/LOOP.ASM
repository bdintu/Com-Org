        .model  tiny                    ; For .COM file

        .data

        .code
        org     0100h
main:
        mov     ah, 02h                 ; Show a Char
        mov     dl, '|'
        mov     cx, 12                  ; Do 12 times
p1:
        int     21h                     ; Show it
        loop    p1

        mov     dl, '-'
        mov     cx, 10                  ; Do 10 times
p2:
        int     21h                     ; Show it
        loop    p2

doExit:
        int     20h                     ; Job's done!

        end     main
