    list p=18f4550
    #include<p18f4550.inc>

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

cuenta EQU 0x00

    org 0x0500
tabla_hola db 0x76, 0x3F, 0x38, 0x77

    org 0x0550
tabla_upc db 0x00, 0x3E, 0x73, 0x39    
 
    org 0x0000
    goto configuro
    
    org 0x0020
configuro:
    ;Configuramos los puertos como salida
    clrf TRISD		;Todos los pines de RD como salidas
    movlw 0x0F
    movwf ADCON1	;Para que RA y RE sean puertos digitales
    clrf TRISE		;Todos los pines de RE como salidas
    bcf TRISA, 0	;RA0 como salida
    ;Deshabilitamos todos los displays
    bsf LATA, 0
    bsf LATE, 0
    bsf LATE, 1
    bsf LATE, 2
    
inicio:
    btfss PORTB, 0
    goto mensaje_hola
    goto mensaje_upc
    
mensaje_hola:    
    ;Asignamos la dirección 0x0500 al TBLPTR
    movlw LOW tabla_hola
    movwf TBLPTRL
    movlw HIGH tabla_hola
    movwf TBLPTRH
    goto disp1

mensaje_upc:    
    ;Asignamos la dirección 0x0550 al TBLPTR
    movlw LOW tabla_upc
    movwf TBLPTRL
    movlw HIGH tabla_upc
    movwf TBLPTRH
    goto disp1
    
disp1:
    TBLRD*+		    ;Acción de lectura de lo que apunta TBLPTR y luego se incrementa
    movff TABLAT, LATD
    bcf LATE, 0
    call microdelay	    ;Rutina de microretardo
    bsf LATE, 0
disp2:
    ;incf TBLPTRL, f
    TBLRD*+
    movff TABLAT, LATD
    bcf LATE, 1
    call microdelay	    ;Rutina de microretardo
    bsf LATE, 1
disp3:
    ;incf TBLPTRL, f
    TBLRD*+
    movff TABLAT, LATD
    bcf LATE, 2
    call microdelay	    ;Rutina de microretardo
    bsf LATE, 2
disp4:
    ;incf TBLPTRL, f
    TBLRD*
    movff TABLAT, LATD
    bcf LATA, 0
    call microdelay	    ;Rutina de microretardo
    bsf LATA, 0    
    ;clrf TBLPTRL
    goto inicio
    
microdelay:
    nop
    return
    
    end