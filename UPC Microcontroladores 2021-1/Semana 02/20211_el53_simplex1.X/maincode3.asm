;este es un comentario
    list p=18f4550		;modelo de procesador
    #include<p18f4550.inc>	;libreria de nombre de registros
    
    ;Bits de configuracion del microcontrolador
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    CONFIG  MCLRE = OFF

    org 0x0000
    goto init_conf

    org 0x0020
init_conf:  clrf TRISD		;RD como salida
inicio:	    comf PORTB, W	;complemento de PORTB y lo almacena en Wreg
	    movwf LATD		;mueve el contenido de Wreg a RD
	    goto inicio
	    end			;fin del programa