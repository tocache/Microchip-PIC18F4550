    list p=18f4550	    ;modelo de microcontrolador
    #include<p18f4550.inc>  ;llamada a la libreria de nombres
    
;Aqui van los bits de configuracion (directivas de pre procesador)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    
    org 0x0000		    ;vector de RESET
    goto inicio
    
    org 0x0020		    ;Inicio del area de programa de usuario
inicio:
    bcf TRISD, 0	    ;Puerto RD0 como salida
    
looper:
    btfss PORTB, 0	    ;Pregunto si presione el boton
    goto looper		    ;No he presionado el boton
    btfsc PORTD, 0	    ;Pregunto si el LED esta apagado
    goto ledonpe	    ;Salta aqui si LED esta encendido
    bsf LATD, 0		    ;Salta aqui si LED esta apagado y lo enciendo
    goto otro		    ;Salto incondicional hacia etiqueta otro
ledonpe:
    bcf LATD, 0		    ;apagamos el LED
otro:
    btfsc PORTB, 0	    ;Pregunto si he dejado de precionar el boton
    goto otro		    ;Aun sigo presionando el boton
    goto looper		    ;Deje de presionar el boton
    end
    