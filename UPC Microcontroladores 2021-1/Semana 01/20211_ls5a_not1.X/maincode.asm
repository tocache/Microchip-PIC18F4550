    list p=18f4550		    ;seleccion del procesador
    #include<p18f4550.inc>	    ;libreria de nombres de registros
    
    ;Declaracion de los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			    ;vector de reset
    goto init_conf		    ;salta a label init_conf
    
    org 0x0020			    ;zona de programa de usuario
init_conf:
    ;configuraciones iniciales de la app
    bsf TRISB, 4		    ;RB4 como entrada
    bcf TRISD, 4		    ;RD4 como salida
    
inicio:
    ;programa de la app
    btfss PORTB, 4		;pregunto si RB4 es uno
    goto noes			;cuando es falso, salta a label noes
    bcf LATD, 4			;RD4=0
    goto inicio			;salto a label inicio
noes:
    bsf LATD, 4			;RD4=1
    goto inicio			;salto a label inicio
    end				;fin del programa de usuario
    