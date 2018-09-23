   list p=18f4550  ;directiva para decirle al programa el modelo de microcontrolador que se va a usar
    #include <p18f4550.inc> ;llamada a la librería de nombre de los registros del PIC18F4550
    
    ;A continuación las directivas de configuración del microcontrolador
    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;vector de RESET
    goto programa

    org 0x0600
mensaje db 0x76, 0x3f, 0x38, 0x77

    org 0x0020
programa:
    clrf TRISD	    ;ponemos todo el puerto D como salida
    movlw 0xF0
    movwf TRISB	    ;ponemos la mitad del puerto B como salida
    movlw UPPER mensaje   ;Dirijo la dirección del puntero de tabla a mensaje
    movwf TBLPTRU
    movlw HIGH  mensaje
    movwf TBLPTRH
    movlw LOW  mensaje
    movwf TBLPTRL
    movlw 0x0F
    movwf LATB	    ;Los cuatro displays deshabilitados
    
inicio:
    TBLRD*+	    ;Acción de lectura e incremento del puntero de tabla
    movff TABLAT, LATD
    bcf LATB, 3	    ;Habilito display 3
    call retardito
    bsf LATB, 3	    ;Deshabilito display 3
    TBLRD*+	    ;Acción de lectura e incremento del puntero de tabla
    movff TABLAT, LATD
    bcf LATB, 2	    ;Habilito display 2
    call retardito
    bsf LATB, 2	    ;Deshabilito display 2
    TBLRD*+	    ;Acción de lectura e incremento del puntero de tabla
    movff TABLAT, LATD
    bcf LATB, 1	    ;Habilito display 1
    call retardito
    bsf LATB, 1	    ;Deshabilito display 1
    TBLRD*+	    ;Acción de lectura e incremento del puntero de tabla
    movff TABLAT, LATD
    bcf LATB, 0	    ;Habilito display 0
    call retardito
    bsf LATB, 0	    ;Deshabilito display 0
    movlw LOW  mensaje
    movwf TBLPTRL   ;mandamos el puntero de tabla al inicio
    goto inicio
    
retardito:
    return
    
    end