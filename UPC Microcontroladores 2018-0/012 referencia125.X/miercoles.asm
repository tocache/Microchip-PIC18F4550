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
    
    org 0x0020
programa:
    bsf OSCCON, 6
    bsf OSCCON, 5
    bsf OSCCON, 4
    bsf OSCCON, IOFS
    movlw 0xC0
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V

inicio:
    btfss PORTD,0
    goto trescincuentaynueve
    movlw 0xC0
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V
    goto otro
trescincuentaynueve:
    movlw 0xCF
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V
otro:    
    goto inicio
    end



