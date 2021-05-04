    list p=18f4550	    ;modelo de procesador
    #include <p18f4550.inc> ;llamado a libreria de nombres
    
    ;Aqui van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)  
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000		    ;vector de reset
    goto init_conf	    ;salto al label init_conf
    
    org 0x0020		    ;zona de programa de usuario
init_conf:
    bsf TRISD, 7    ;RD7 es una entrada
    bcf TRISB, 1    ;RB1 es una salida
inicio:
    btfss PORTD, 7  ;pregunto si RD7 es uno
    goto noes	    ;viene aqui cuando es falso y salta a label noes
    bcf LATB, 1	    ;viene aqui cuando es verdadero RB1=0
    goto inicio	    ;salta a label inicio
noes:
    bsf LATB, 1	    ;RB1=1
    goto inicio	    ;salta a label inicio
    end