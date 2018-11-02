;Programa para emular el decodificador 74LS48, cuando la combinación de entrada
;es mayor a 9 se emitirá "E" en el display
    
;Entrada es RB(3:0) y Salida es RD(6:0)
;Por: Kalun    
;Opción 1: Empleando el Program Counter
    
    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Librería de nombres
    
    ;Zona de los bits de configuración del microcontroleitor    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

temporal equ 0x20
 
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISD			;Todo el puertoD como salida

inicio:
    movf PORTB, W		;Leemos el RB y lo mandamos a W
    andlw 0x0F			;Enmascaramiento
    movwf temporal		;Necesitamos hacer W+W 
    addwf temporal, W
    call tablaton
    movwf LATD
    goto inicio
    
tablaton:
    addwf PCL, f
    retlw 0x3F	;0
    retlw 0x06	;1
    retlw 0x5B	;2
    retlw 0x4F	;3
    retlw 0x66	;4
    retlw 0x6D	;5
    retlw 0x7D	;6
    retlw 0x07	;7
    retlw 0x7F	;8
    retlw 0x67	;9
    retlw 0x79	;E
    retlw 0x79	;E
    retlw 0x79	;E
    retlw 0x79	;E
    retlw 0x79	;E
    retlw 0x79	;E
    
    end
    
    