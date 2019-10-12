;Este es un comentario
;Para los comentarios se antecede el punto y coma
;Programa hecho por Sifu Kalun

;Aqui se detallan los bits de configuración
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    list p=18f4550	    ;Modelo de microcontrolador usado
    #include <p18f4550.inc> ;Libreria de nombre de registros
    
    org 0x0000		    ;Vector de RESET
    goto atiendanpe
    
    org 0x0020		    ;Zona de programa de usuario
atiendanpe:
    movlw 0xFC
    movwf TRISD		    ;Puertos RD0 y RD1 como salidas
laronda:
    btfss PORTB, 0
    goto falsssss
    movlw 0x01
    movwf LATD
    goto laronda
falsssss:
    movlw 0x02
    movwf LATD
    goto laronda
    end
    