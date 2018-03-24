        .model tiny

        .code
        org  0100h
main:   xor  ax,ax                   ; reset mouse
        int  33h                     ;

        mov  ax,1003h                ;
        mov  bl,00h                  ; disable blinking
        int  10h                     ;

;Note: the character/attribute data at the current screen position
;      is ANDed with the screen mask
;      then XORed with the cursor mask
        mov  cx,00FFh                ; screen mask (clear out attrib)
        mov  dx,8F00h                ; cursor mask (set attrib color)
        mov  ax,000Ah                ; set text mouse cursor
        xor  bx,bx                   ; 0 = software cursor (1 = hardware)
        int  33h                     ;
           
        mov  ax,0001h                ; show mouse cursor
        int  33h                     ;

Wait4Press:
        mov  ax,0003h                ; wait for the user to press a
        int  33h                     ;  mouse button
        or   bx,bx                   ;
        jz   short Wait4Press        ;

        mov  ax,0002h                ; hide mouse cursor
        int  33h

        mov  ax,1003h                ;
        mov  bl,01h                  ; re-enable blinking
        int  10h                     ;

        .exit

        end     main
