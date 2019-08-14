;Este es un comentario
;Plantilla desarrollada por Kalun
;UPC Monterrico 14 de agosto del 2019
    
    list p=18f4550	        ;Modelo del microcontrolador a usar
    #include<p18f4550.inc>	;Libreria de nombres de registros
    
    ;Aca iran los bits de configuracion (directivas de preprocesador}
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  
    org 0x0000			;Vector de RESET
    goto confug			;Salto a la etiqueta 'confug'
    
    org 0x0020			;Zona de programa de usuario
confug:
    bcf TRISD, 0		;Puerto RD0 como salida
    ;NOTA: no es necesario establecer los GPIO como entrada, son asi por defecto ante un Power-on Reset
looper:
    btfss PORTB, 0		;Pregunto si el RB0 es igual a uno
    goto falsaso		;Salta aqui cuando es falso
    bcf LATD, 0			;Salta aqui cuando es verdadero y pone RD0 a cero
    goto looper			;Salta a la etiqueta 'looper'
falsaso:
    bsf LATD, 0			;Pone RD0 a uno
    goto looper			;Salta a la etiqueta 'looper'
    end				;Fin del programa


