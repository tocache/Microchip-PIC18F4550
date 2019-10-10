;Este es un comentario
;Plantilla hecha por el master of the universe
    
;Zona de declaracion de los bits de configuracion (directivas de preprocesador
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    list p=18f4550		;Para indicar el modelo del microcontrolador que estamos usando
    #include <p18f4550.inc>	;Declaracion de la libreria de nombre de registros
    
    org 0x0000			;Vector de reset
    goto iniciomon
    
    org 0x0020			;Zona de programa de usuario
iniciomon:    
    movlw 0xFC
    movwf TRISD
    btfss PORTB, 0
    goto mamadera
    movlw 0x02
    movwf LATD
    goto iniciomon
mamadera:
    movlw 0x01
    movwf LATD
    goto iniciomon
    end
    
    