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

    cblock 0x0020
	boton
	endc
    
    org 0x0000			;vector de RESET
    goto programa

    org 0x0020			;zona libre para escribir programa

programa:
    bsf OSCCON, 6
    bsf OSCCON, 5
    bsf OSCCON, 4	    ;FOsc sea 8MHz
    bcf TRISC, 2	    ;Puerto D0 como salida
    movlw .49
    movwf PR2		    ;Para el periodo
    movlw .36
    movwf CCPR1L	    ;Para el duty cycle
    movlw 0x0C
    movwf CCP1CON	    ;Modo PWM del CCP
    movlw 0x05
    movwf T2CON		    ;Establecemos el prescaler del Timer2 y lo encendemos
    
inicio:
    movf PORTD, w
    andlw 0x03
    movwf boton
    movlw 0x00
    cpfseq boton
    goto falso1
    movlw .12
    movwf CCPR1L	    ;Para el duty cycle
    goto otro
falso1:
    movlw 0x01
    cpfseq boton
    goto falso2
    movlw .24
    movwf CCPR1L	    ;Para el duty cycle    
    goto otro
falso2:
    movlw 0x02
    cpfseq boton
    goto falso3
    movlw .36
    movwf CCPR1L	    ;Para el duty cycle    
    goto otro    
falso3:
    movlw .44
    movwf CCPR1L	    ;Para el duty cycle    
    goto otro
otro:
    goto inicio
    end
    