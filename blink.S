; blink.S para Arduino Uno (ATmega328P)
.global main
.section .text

main:
    sbi   0x04, 5      ; DDRB bit 5 = OUTPUT (pin 13)
loop:
    sbi   0x05, 5      ; PORTB bit 5 = HIGH (LED ON)
    call  delay        ; Retardo
    cbi   0x05, 5      ; PORTB bit 5 = LOW (LED OFF)
    call  delay
    rjmp  loop         ; Bucle infinito

delay:
    ldi   r18, 32      ; Ajusta este valor para cambiar la velocidad
d1: ldi   r19, 255
d2: ldi   r20, 255
d3: dec   r20
    brne  d3
    dec   r19
    brne  d2
    dec   r18
    brne  d1
    ret