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

    org 0x0000
    goto init_conf

    org 0x0020
init_conf:  clrf TRISD		;RD como salida
inicio:	    btfss PORTB, 0
	    goto falso0
	    bcf LATD, 0
	    goto siguiente0
falso0:	    bsf LATD, 0
siguiente0: btfss PORTB, 1
	    goto falso1
	    bcf LATD, 1
	    goto siguiente1
falso1:	    bsf LATD, 1
siguiente1: btfss PORTB, 2
	    goto falso2
	    bcf LATD, 2
	    goto siguiente2
falso2:	    bsf LATD, 2
siguiente2: btfss PORTB, 3
	    goto falso3
	    bcf LATD, 3
	    goto siguiente3
falso3:	    bsf LATD, 3
siguiente3: btfss PORTB, 4
	    goto falso4
	    bcf LATD, 4
	    goto siguiente4
falso4:	    bsf LATD, 4
siguiente4: btfss PORTB, 5
	    goto falso5
	    bcf LATD, 5
	    goto siguiente5
falso5:	    bsf LATD, 5
siguiente5: btfss PORTB, 6
	    goto falso6
	    bcf LATD, 6
	    goto siguiente6
falso6:	    bsf LATD, 6
siguiente6: btfss PORTB, 7
	    goto falso7
	    bcf LATD, 7
	    goto inicio
falso7:	    bsf LATD, 7
	    goto inicio
	    end			;fin del programa