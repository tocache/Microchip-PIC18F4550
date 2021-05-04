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
    bsf TRISB, 0    ;RB0 es una entrada
    bsf TRISB, 1    ;RB1 es una entrada
    bcf TRISD, 0    ;RD0 es una salida
    bcf TRISD, 1    ;RD1 es una salida
inicio:
    btfss PORTB, 1  ;pregunto si RD7 es uno
    goto noes	    ;viene aqui cuando es falso y salta a label noes
    bcf LATD, 1	    ;viene aqui cuando es verdadero RB1=0
    goto otro	    ;salta a label inicio
noes:
    bsf LATD, 1	    ;RB1=1
    goto otro	    ;salta a label inicio
otro:
    btfss PORTB, 0  ;pregunto si RD7 es uno
    goto noes2	    ;viene aqui cuando es falso y salta a label noes
    bcf LATD, 0	    ;viene aqui cuando es verdadero RB1=0
    goto inicio	    ;salta a label inicio
noes2:
    bsf LATD, 0	    ;RB1=1
    goto inicio	    ;salta a label inicio    
    end