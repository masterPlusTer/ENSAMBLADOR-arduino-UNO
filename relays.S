.global main
.section .text

main:
    ; Configurar pines como salida
    sbi 0x0A, 4        ; DDRD bit4 = salida (pin D4)
    sbi 0x0A, 7        ; DDRD bit7 = salida (pin D7)
    sbi 0x04, 0        ; DDRB bit0 = salida (pin D8)
    sbi 0x04, 4        ; DDRB bit4 = salida (pin D12)

loop:
    ; Relay 1 en pin 4
    sbi 0x0B, 4
    rcall delay
    cbi 0x0B, 4
    rcall delay

    ; Relay 2 en pin 7
    sbi 0x0B, 7
    rcall delay
    cbi 0x0B, 7
    rcall delay

    ; Relay 3 en pin 8
    sbi 0x05, 0
    rcall delay
    cbi 0x05, 0
    rcall delay

    ; Relay 4 en pin 12
    sbi 0x05, 4
    rcall delay
    cbi 0x05, 4
    rcall delay

    rjmp loop

; ------------------------
; Delay de ~500ms aprox
; ------------------------
delay:
    ldi r18, 50        ; bucle externo
d1: ldi r19, 255
d2: ldi r20, 255
d3: dec r20
    brne d3
    dec r19
    brne d2
    dec r18
    brne d1
    ret
