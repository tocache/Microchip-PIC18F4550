    list p=18f4550		;modelo del procesador
    #include<p18f4550.inc>	;libreria de nombres de registros
    
    ;Aqui estaran la declaracion de los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			;vector de reset
    goto init_conf
    
    org 0x0020			;zona de programa de usuario
init_conf:
    ;configuraciones iniciales
    bsf TRISB, 2	    ;RB2 como entrada
    bcf TRISD, 2	    ;RD2 como salida
    
inicio:
    ;rutina principal
    btfss PORTB, 2	    ;Pregunto si RB2=1
    goto noes		    ;viene aqui cuando es falso, salta a noes
    bcf LATD, 2		    ;viene aqui cuando es verdadero, pone RD2=0
    goto inicio		    ;regresa a label inicio
noes:
    bsf LATD, 2		    ;poner RD2=1
    goto inicio		    ;regresa a label inicio
    end