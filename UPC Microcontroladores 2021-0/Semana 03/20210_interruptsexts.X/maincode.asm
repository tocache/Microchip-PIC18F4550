;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

;Aquí va el cblock o declaaración de nombres de GPR    
    cblock 0x000
    endc
    
    org 0x0000
    goto init_conf

    org 0x0008
    goto isr_ints
;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    movlw 0x0F
    movwf ADCON1	;Todos los pines que estaban analogicos que sean digitales
    movlw 0x08
    movwf TRISE		;RE0-RE2 como salidas digitales
    movlw 0xD8
    movwf INTCON3	;INT1 e INT2 activados
    movlw 0x90
    movwf INTCON	;INT0 activado
    
loop:
    btfss PORTB, 7
    goto loop
    clrf LATE
    goto loop
    
isr_ints:
    btfss INTCON, INT0IF
    goto siguiente1
    bsf LATE, 0
    bcf INTCON, INT0IF
siguiente1:
    btfss INTCON3, INT1IF
    goto siguiente2
    bsf LATE, 1
    bcf INTCON3, INT1IF
siguiente2:
    btfss INTCON3, INT2IF
    goto siguiente3
    bsf LATE, 2
    bcf INTCON3, INT2IF
siguiente3:    
    retfie
    end