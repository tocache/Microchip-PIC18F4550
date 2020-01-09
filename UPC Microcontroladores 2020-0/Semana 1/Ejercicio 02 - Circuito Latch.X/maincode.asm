    list p=18f4550		;Modelo del microcontrolador
    #include<p18f4550.inc>	;Libreria de nombre de registros
    
    ;Aquí van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de RESET
    goto configuro		;Salto a etiqueta
    
    org 0x0020			;Zona de programa de usuario
configuro:
    movlw 0xFC
    movwf TRISB			;Puertos RB0 y RB1 como salidas
    bcf LATB, 0			;Condiciones iniciales de las salidas
    bsf LATB, 1
inicio:
    btfss PORTB, 2		;Pregunto si presione el boton en RB2
    goto inicio			;No he presionado el boton en RB2
    btg LATB, 0			;Accion de complemento a ambas salidas
    btg LATB, 1
otro:
    btfsc PORTB, 2		;Pregunto si deje de presionar el boton en RB2
    goto otro			;Aun sigo presionando el boton en RB2
    goto inicio
    end


