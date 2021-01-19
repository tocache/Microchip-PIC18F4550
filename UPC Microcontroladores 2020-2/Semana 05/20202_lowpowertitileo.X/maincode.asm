;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = OFF           ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000
    goto init_conf
    
    org 0x0008
    goto TMR0_ISR

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    bcf TRISD, 0
    movlw 0x30
    movwf OSCCON	;Por defecto el INTOSC esta en 1MHz
    movlw 0x90
    movwf T0CON		;TMR0 se desborda en 500ms aprox. psc 1:1 fosc/4 16bit
    movlw 0xA0
    movwf INTCON	;Interrupciones activadas para TMR0
    
loop:
    nop
    goto loop
    
TMR0_ISR:
    btg LATD, 0		;Basculamos la salida RD0
    bcf INTCON, TMR0IF	;Bajamos la bandera de TMR0
    retfie
    end