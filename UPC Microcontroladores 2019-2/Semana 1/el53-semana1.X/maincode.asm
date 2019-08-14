;Plantilla creada para las aplicaciones en MPASM
;Desarrollado por Kalun Lau
;UPC Monterrico 14 de agosto del 2019
    
    list p=18f4550		;Modelo del microcontrolador
    #include<p18f4550.inc>	;Llamada a la librería de nombres de registros
    
;Acá deben de colocar los bits de configuracion (directivas de pre procesador)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de RESET
    goto confeg			;Salto a la etiqueta 'confeg'
    
    org 0x0020			;Zona de programa de usuario
confeg:			    
    bcf TRISD, 0		;Puerto RD0 como salida
loops:
    btfss PORTB, 0		;Preguntamos a RB0 si es uno                   \
    goto falso			;Viene aqui si es falso                        | La condicional del flowchart
    bcf LATD, 0			;Viene aqui si es verdadero y poner a cero RD0 /
    goto loops
falso:
    bsf LATD, 0			;Pone a uno RD0
    goto loops
    end				;Fin del programa en MPASM
