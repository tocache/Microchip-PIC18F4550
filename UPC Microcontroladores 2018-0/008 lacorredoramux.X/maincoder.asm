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
    endc

    org 0x0000			;vector de RESET
    goto programa

    org 0x0600
t_HOLA db 0x09, 0x40, 0x47, 0x08
     org 0x0610
t_COMO db 0x46, 0x40, 0x6A, 0x40
     org 0x0620
t_ESTA db 0x06, 0x12, 0x07, 0x08
 
    org 0x0008			;vecitor de interrupción de alta prioridad
    goto interrupcion
 
 
    org 0x0020			;zona libre para escribir programa
programa:
    clrf TRISD	    ;Coloca a 00000000 el registro TRISD para que todo el puerto sea salida
    clrf TRISB	    ;puerto B todos como salida
    movlw UPPER t_HOLA
    movwf TBLPTRU
    movlw HIGH t_HOLA
    movwf TBLPTRH
    clrf LATB	    ;Para que en un inicio los habilitadores de los displays se encuentren apagados
    movlw 0xC8
    movwf T0CON	    ;Habilitamos el TImer0 para que temporice lo mas rápido posible
    movlw 0xA0
    movwf INTCON    ;Prendemos la interrupcion por desborde del Timer0

inicio:    
    movlw LOW t_HOLA
    movwf TBLPTRL
    call retardo
    movlw LOW t_COMO
    movwf TBLPTRL
    call retardo
    movlw LOW t_ESTA
    movwf TBLPTRL
    call retardo
    goto inicio
    
interrupcion:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0
    call nopes
    bcf LATB, 0
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1
    call nopes
    bcf LATB, 1
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2
    call nopes
    bcf LATB, 2
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 3
    call nopes
    bcf LATB, 3
    movlw .4
    subwf TBLPTRL
    bcf INTCON, TMR0IF	    ;Bajamos la banderita de interrupcion por desborde del TImer0
    retfie

nopes:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return
    
;subrutina de retardo
retardo:
    movlw .20
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
    
    end
