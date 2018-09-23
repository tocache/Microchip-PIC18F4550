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

    cblock 0x60	    ;Bloque de variables anexadas a registros en RAM
        ivar	;Para la rutina de retardo
        jvar	;Para la rutina de retardo
        kvar	;Para la rutina de retardo
	elesb	;dígito menos significativo
	emesb	;digito mas significativo
    endc

    org 0x0000			;vector de RESET
    goto programa

    org 0x0600
tablamon db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
    
    org 0x0020			;zona libre para escribir programa
programa:
    clrf TRISD	    ;Coloca a 00000000 el registro TRISD para que todo el puerto sea salida
    clrf TRISB	    ;puerto B todos como salida
    bsf TRISC, 0	    ;puerto C.0 como entrada
    clrf elesb	    ;inicio en cero del digito menos significativo
    clrf emesb	    ;inicio en cero del digito mas significativo
    movlw UPPER tablamon
    movwf TBLPTRU
    movlw HIGH tablamon
    movwf TBLPTRH
    movlw LOW tablamon
    movwf TBLPTRL
    
inicio:
    btfss PORTC, 0  ;pregunto al puerto C si es igual a uno
    goto inicio	    ;aun no se ha presionado el boton
papanatas:
    movlw 0x0f
    cpfseq elesb    ;pregunto si el digito menos significativo es 0x0f
    goto falsete1
    movlw 0x0f
    cpfseq emesb
    goto falsete2
    goto yallegue

falsete1:
    incf elesb, f
    goto previo

falsete2:
    incf emesb, f
    clrf elesb
    goto previo

previo:
    movlw LOW tablamon	;Para el digito menos significativo
    movwf TBLPTRL
    movf elesb, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATB
    
    movlw LOW tablamon	;Para el digito mas significativo
    movwf TBLPTRL
    movf emesb, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    
    call retardo
    goto papanatas

;subrutina de retardo
retardo:
    movlw .10
    movwf kvar
otro1:
    call bucle1
    decfsz kvar, 1
    goto otro1
    return
bucle1:
    movlw .25
    movwf jvar
otro2:
    call bucle2
    decfsz jvar, 1
    goto otro2
    return

bucle2:
    movlw .50
    movwf ivar
otro3:
    nop		    ;este nop se va a repetir 50000 veces
    decfsz ivar, 1
    goto otro3
    return

yallegue:
    nop    
    end
    


