;Programa para un no inversor de 8 bits
    
    list p=18f4550		;modelo del microcontrolador
    #include <p18f4550.inc>	;libreria de nombre de registros
    
    ;Aqui van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de RESET
    goto configuro
    
    org 0x0020			;Zona de programa de usuario
configuro:
    movlw 0x00
    movwf TRISD			;Establezco RD todos como salida
    movlw 0xFF		    
    movwf TRISB			;No es necesario ya que los puertos son entrada por defecto

principal:
    movf PORTB, W		;Obtenemos el dato de RB y lo mandamos a W
    movwf LATD			;Enviamos el contenido de W hacia RD
    goto principal
    end				;Final del codigo