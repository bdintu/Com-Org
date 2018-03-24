        .model  tiny                    ; For .COM file

        .data
hexstr  db      '00h',0Dh,0Ah,'$'       ; Hex Display
hextab  db      '0123456789ABCDEF'      ; Lookup Table

        .code
        org     0100h
main:
        mov     ah, 00h                 ; Get an ASCII char
        int     16h
        cmp     al, 27                  ; Is ESC? (#27)
        je      doExit                  ; Yes = Exit

        mov     si, offset hextab       ; Point to Lookup Table

        mov     bl, al                  ; Copy an ASCII char to BL
        and     bx, 000Fh               ; Use only 4 bits
        mov     ah, [si+bx]             ; Which HEX letter?
        mov     hexstr[1], ah           ; Change LAST digit

        mov     bl, al                  ; Copy an ASCII char to BL again
        and     bx, 00F0h               ; Use only 4 bits
        shr     bx, 4                   ; Shift it to rightmost digit
        mov     ah, [si+bx]             ; Which HEX letter?
        mov     hexstr[0], ah           ; Change FIRST digit

        mov     ah, 09h                 ; Show modified HEX string
        mov     dx, offset hexstr
        int     21h
        jmp     main                    ; Do it again

doExit:
        int     20h                     ; Job's done!

        end     main
