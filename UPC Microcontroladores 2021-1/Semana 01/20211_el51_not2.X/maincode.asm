    list p=18f4550		;modelo del procesador
    #include<p18f4550.inc>	;libreria de nombres de registros
    
    ;Detalle de los bits de configuracion modificados
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
    ;configuraciones iniciales de la app
    bsf TRISB, 5	    ;RB5 como entrada
    bcf TRISD, 5	    ;RD5 como salida
    
inicio:    
    ;programa de usuario
    btfss PORTB, 5	    ;pregunto si RB5=1
    goto noescierto	    ;cuando es falso, salto a label noescierto
    bcf LATD, 5		    ;cuando es verdadero, mando RD5=0
    goto inicio		    ;salto a label inicio
noescierto:
    bsf LATD, 5		    ;coloco RD5=1
    goto inicio		    ;salto a label inicio
    end				;fin del programa