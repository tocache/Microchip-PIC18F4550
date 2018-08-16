;Este es un comentario
    list p=18f4550	    ;Modelo del microcontrolador
    #include<p18f4550.inc>  ;Llamada a librería de nombres

    ;Zona de bits de configuración
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    
    org 0x0000		    ;Vector de RESET
    goto setupcion
    
    org 0x0020		    ;Zona de programa de usuario
setupcion:		    ;A ejecutarse al inicio solamente
    bsf TRISB, 0	    ;Puerto RD0 como entrada
    bsf TRISB, 1	    ;Puerto RD1 como entrada
    bcf TRISD, 0	    ;Puerto RB0 como salida
    
inicio:			    ;Programa de la aplicación
    btfss PORTB, 0
    goto nanana
    btfss PORTB, 1
    goto nanana
    bsf LATD, 0
    goto inicio
nanana:
    bcf LATD, 0
    goto inicio
    end			    ;Fin de código de usuario
    