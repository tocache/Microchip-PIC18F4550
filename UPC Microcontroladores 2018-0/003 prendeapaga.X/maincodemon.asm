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
        ivar
        jvar
        kvar
    endc

    org 0x0000			;vector de RESET
    goto programa
    
    org 0x0020			;zona libre para escribir programa
programa:
    bcf TRISB, 0		;B.0 como salida donde va a titilar el LED
inicio:
    bsf LATB, 0
    call retardo
    bcf LATB, 0
    call retardo
    goto inicio

retardo:
    movlw .10
    movwf kvar
otro1:
    call bucle1
    decfsz kvar, 1
    goto otro1
    return

bucle1:
    movlw .100
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