.global main
.section .text

; --- Registros de I/O ---
.equ DDRD,   0x0A
.equ PORTD,  0x0B
.equ DDRB,   0x04
.equ PORTB,  0x05

; --- UART ---
.equ UBRR0L, 0xC4
.equ UBRR0H, 0xC5
.equ UCSR0A, 0xC0
.equ UCSR0B, 0xC1
.equ UCSR0C, 0xC2
.equ UDR0,   0xC6

; --- Bits ---
.equ TXEN0,  3
.equ UDRE0,  5

main:
    ; Configurar pines de salida para los 4 relés
    sbi DDRD, 4
    sbi DDRD, 7
    sbi DDRB, 0
    sbi DDRB, 4

    ; Inicializar UART a 9600 baudios
    ldi r16, 103         ; UBRR0 = 103
    sts UBRR0L, r16
    ldi r16, 0
    sts UBRR0H, r16

    ldi r16, 0x08        ; (1<<TXEN0)
    sts UCSR0B, r16

    ldi r16, 0x06        ; (1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C, r16

loop:
    ; Relay 1
    sbi PORTD, 4
    rcall delay
    rcall send_msg1
    cbi PORTD, 4
    rcall delay

    ; Relay 2
    sbi PORTD, 7
    rcall delay
    rcall send_msg2
    cbi PORTD, 7
    rcall delay

    ; Relay 3
    sbi PORTB, 0
    rcall delay
    rcall send_msg3
    cbi PORTB, 0
    rcall delay

    ; Relay 4
    sbi PORTB, 4
    rcall delay
    rcall send_msg4
    cbi PORTB, 4
    rcall delay

    rjmp loop

; ------------------------
; Delay ~500 ms
; ------------------------
delay:
    ldi r18, 50
d1: ldi r19, 255
d2: ldi r20, 255
d3: dec r20
    brne d3
    dec r19
    brne d2
    dec r18
    brne d1
    ret

; ------------------------
; UART send
; ------------------------
uart_send:
us1: lds r17, UCSR0A
    sbrs r17, UDRE0
    rjmp us1
    sts UDR0, r16
    ret

; ------------------------
; Send strings
; ------------------------
send_msg1:
    ldi ZL, lo8(msg1)
    ldi ZH, hi8(msg1)
    rjmp send_str
send_msg2:
    ldi ZL, lo8(msg2)
    ldi ZH, hi8(msg2)
    rjmp send_str
send_msg3:
    ldi ZL, lo8(msg3)
    ldi ZH, hi8(msg3)
    rjmp send_str
send_msg4:
    ldi ZL, lo8(msg4)
    ldi ZH, hi8(msg4)
    rjmp send_str

send_str:
    lpm r16, Z+
    cpi r16, 0
    breq send_end
    rcall uart_send
    rjmp send_str
send_end:
    ret

; ------------------------
; Strings in flash
; ------------------------
.section .progmem.data
msg1: .asciz "Relay 1 ON\r\n"
msg2: .asciz "Relay 2 ON\r\n"
msg3: .asciz "Relay 3 ON\r\n"
msg4: .asciz "Relay 4 ON\r\n"
