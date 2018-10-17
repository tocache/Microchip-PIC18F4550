;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

    org 0x0000				;Vector de RESET
    goto configuro
    
    org 0x0020				;Zona de programa de usuario
configuro:
    ;Instrucciones de configuración inicial del programa de usuario
    bsf TRISD, 0			;Puerto D0 como entrada
    bsf TRISD, 1			;Puerto D1 como entrada
    bcf TRISB, 0			;Puerto B0 como salida
inicio:
    ;Rutina principal de la aplicación
    btfsc PORTD, 1
    goto falsete1
    btfsc PORTD, 0
    goto falsete2
    bcf LATB, 0
    goto inicio
falsete1:
    btfsc PORTD, 0
    goto falsete3
    bsf LATB, 0
    goto inicio
falsete2:
    bsf LATB, 0
    goto inicio
falsete3:
    bsf LATB, 0
    goto inicio
    
    end					;Fin de todo el archivo
    