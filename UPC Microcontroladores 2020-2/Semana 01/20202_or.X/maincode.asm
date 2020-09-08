    ;Este es un comentario
    list p=18f4550			    ;Modelo del microcontrolador
    #include<p18f4550.inc>		    ;Libreria de nombre de registros
    
    ;Aqui van los bits de configuracion (pendiente)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000				    ;Vector de RESET
    goto configuro
    
    org 0x0020				    ;Zona de programa de usuario
configuro:
    bcf TRISD, 0			    ;puerto RD0 como salida
    bsf TRISB, 0			    ;puerto RB0 como entrada
    bsf TRISB, 1			    ;puerto RB1 como entrada
    
principal:				    ;Tu programa
    btfsc PORTB, 0
    goto falso
    btfsc PORTB, 1
    goto falso
    bcf LATD, 0
    goto principal
falso:
    bsf LATD, 0
    goto principal
    end					    ;Final del codigo