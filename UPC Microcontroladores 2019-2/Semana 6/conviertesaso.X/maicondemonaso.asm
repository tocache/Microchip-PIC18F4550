    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			;Vector de RESET
    goto inicion

inicion:
    clrf TRISD			;Puerto por donde saldra el resultado del ADC
    ;Primero ADCON2, luego ADCON1 y finalmente ADCON0
    ;ADCON2: Tiempo de conversion y justificacion del resultado
    ;ADCON1: Seleccionar quienes son analogicos y quienes digitales
    ;ADCON0: Control del ADC
    movlw 0x24		;8TAD, FOsc/4 y just izq
    movwf ADCON2
    movlw 0x0E		;AN0 habilitado solamente
    movwf ADCON1	
    movlw 0x01		;Encendemos el ADC
    movwf ADCON0

lecturon:
    bsf ADCON0, 1
buclon:
    btfsc ADCON0, 1
    goto buclon
    movff ADRESH, LATD
    goto lecturon
    end
    