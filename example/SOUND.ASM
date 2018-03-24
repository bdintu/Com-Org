;
; Credit: http://www.fysnet.net/snd.htm
;
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; This routine shows how to send sound (freq.) to the internal speaker.
; You can sound a frequency between 1 and 4000+.  Please Note that the
; human ear has a hard time hearing a frequency less than about 440.
; I use a timer function to wait for the duration.  I also have
; the freq. and duration in a buffer and get a single freq. and duration
; value each time.  This is so that you can make quite a few different
; sounds and just point SI to that buffer and then call this routine.
; The 00h,00h (asciiz) at the end of the buffer tells this routine to
; quit.
;

        .model tiny

        .code
        org  100h
main:   push ds
        pop  es
        mov  si, offset SomeTune
           
        mov  dx,61h                  ; turn speaker on
        in   al,dx                   ;
        or   al,03h                  ;
        out  dx,al                   ;
        mov  dx,43h                  ; get the timer ready
        mov  al,0B6h                 ;
        out  dx,al                   ;

LoopIt: lodsw                        ; load desired freq.
        or   ax,ax                   ; if freq. = 0 then done
        jz   short LDone             ;
        mov  dx,42h                  ; port to out
        out  dx,al                   ; out low order
        xchg ah,al                   ;
        out  dx,al                   ; out high order
        lodsw                        ; get duration
        mov  cx,ax                   ; put it in cx (16 = 1 second)
        call PauseIt                 ; pause it
        jmp  short LoopIt

LDone:  mov  dx,61h                  ; turn speaker off
        in   al,dx                   ;
        and  al,0FCh                 ;
        out  dx,al                   ;

        .exit                        ; exit to DOS

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; This routine waits for a specified amount of milliseconds (within 50ms)
; Since I want to keep it simple, I am going to use the BIOS timer tick
;  at 0040:006Ch. It increments 18.2 times a second.
;   (1000 milliseconds divided by 18.2 = ~55ms)
; This is not a very good delay.  Depending on when it is called,
;  it could delay up to 110ms.  However it will always delay at
;  least 55ms.
; If you do much with this, you will need a much better delay routine.
;  You can code a delay using the RDTSC instruction, if you know you
;  have a CPU that supports that instruction (all modern CPU's do).
; There are many other delay techniques to choose from.
PauseIt proc near uses ax cx es
        mov  ax,0040h
        mov  es,ax

        ; wait for it to change the first time
        mov  al,es:[006Ch]
@a:     cmp  al,es:[006Ch]
        je   short @a

        ; wait for it to change again
loop_it:mov  al,es:[006Ch]
@b:     cmp  al,es:[006Ch]
        je   short @b

        sub  cx,55
        jns  short loop_it

        ret
PauseIt endp


SomeTune        dw 1175, 4
dw 1175, 4
dw 1318, 8
dw 1175, 8
dw 1568, 8
dw 1397, 16
dw 1175, 4
dw 1175, 4
dw 1318, 8
dw 1175, 8
dw 1760, 8
dw 1568, 16
dw 1175, 4
dw 1175, 4
dw 2349, 8
dw 1975, 8
dw 1568, 8
dw 1397, 8
dw 1318, 8
dw 1047, 4
dw 1047, 4
dw 1975, 8
dw 1568, 8
dw 1760, 8
dw 1568, 16
dw  00h,00h

        end     main
