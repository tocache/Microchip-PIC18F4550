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

    org 0x0000			;vector de reset
    goto init_conf		;salto a label init_conf
    
    org 0x0020			;zona de programa de usuario
init_conf:
    ;configuraciones iniciales
    bsf TRISB, 1		;RB1 entrada
    bcf TRISD, 1		;RD1 salida		
    
inicio:
    ;rutina principal
    btfss PORTB, 1	    ;pregunta si RB1=1
    goto falso		    ;viene aqui si es falso, salta a label falso
    bcf LATD, 1		    ;viene aqui si es verdad, RD1=0
    goto inicio		    ;salta a label inicio
falso:
    bsf LATD, 1		    ;RD1=1
    goto inicio		    ;salta a label inicio
    end				;fin del programa