;Programa para emular el decodificador 74LS47, cuando la combinación de entrada
;es mayor a 9 se emitirá "E" en el display
    
;Entrada es RB(3:0) y Salida es RD(6:0)
;Por: Kalun    

    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Librería de nombres
    
    ;Zona de los bits de configuración del microcontroleitor    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0200
tabla7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0X7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
;Disp7seg:  0     1     2     3     4     5     6     7     8     9     E     E     E     E     E     E
 
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISD			;Todo el puertoD como salida
    movlw UPPER tabla7s		;Para apuntar puntero de tabla TBLPTR hacia "tabla7s"
    movwf TBLPTRU		;(TBLPTRU:TBLPTRH:TBLPTRL) -> 21 bits
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL

inicio:
    clrf TBLPTRL		;Colocamos el TBLPTR en la primera posición de "tabla7s"
    movf PORTB, W		;Leemos el RB y lo almacenamos en W
    andlw 0x0F			;Enmascaramos los cuatro primeros bits
    addwf TBLPTRL		;Sumamos el contenido leído y enmascarado hacia el TBLPTR
    TBLRD*			;Acción de lectura del puntero (lo leído lo almacena en TABLAT)
    movff TABLAT, LATD		;El contenido de TABLAT lo enviamos al puerto RD
    goto inicio
    end
    