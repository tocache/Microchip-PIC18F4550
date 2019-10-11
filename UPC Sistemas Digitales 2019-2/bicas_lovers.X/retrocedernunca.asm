;Este es un comentario

    list p=18f4550		;Modelo del microcontrolador usado
    #include <p18f4550.inc>	;Libreria de nombre de registros
    
;Aqui se declaran los bits de configuracion (directivas de preprocesador)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			;Vector de RESET
    goto confegoro
    
    org 0x0020			;Zona de programa de usuario
confegoro:    
    movlw 0xFC
    movwf TRISD			;Puertos RD0 y RD1 como salidas
consuenio:
    btfss PORTB, 0		;Pregunto el estado de RB0 si es uno
    goto muycaro		;Salta aqui cuando RB0 es 0
    bsf LATD, 0			;Salta aqui cuando RB0 es 1
    bcf LATD, 1
    goto consuenio		;Salta a etiqueta consuenio
muycaro:    
    bcf LATD, 0
    bsf LATD, 1
    goto consuenio		;Salta a etiqueta consuenio
    end