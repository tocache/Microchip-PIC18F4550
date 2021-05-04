    list p=18f4550	    ;modelo de procesador
    #include<p18f4550.inc>  ;declaración de librería de nombre de registros
    
    ;Declaración de bits de configuración
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    org 0x0000		    ;vector de reset
    goto pre_conf
    
    org 0x0020		    ;zona de programa de usuario
pre_conf:
    bcf TRISD, 0	    ;defino a RD0 como salida
    bsf TRISB, 0	    ;defino a RB0 como entrada
inicio:
    btfss PORTB, 0	    ;pregunto si RB0 es uno
    goto noes		    ;cuando lo anterior es falso
    bcf LATD, 0		    ;cuando fue verdadero, RD0=0
    goto inicio		    ;salto a inicio
noes:
    bsf LATD, 0		    ;RD0=1
    goto inicio		    ;salto a inicio
    end