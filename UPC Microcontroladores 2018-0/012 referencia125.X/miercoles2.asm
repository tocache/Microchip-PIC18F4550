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
	combinado
	endc
    
    org 0x0000			;vector de RESET
    goto programa
    
    org 0x0020
programa:
    bsf OSCCON, 6
    bsf OSCCON, 5
    bsf OSCCON, 4
    bsf OSCCON, IOFS
    movlw 0xE0
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V

inicio:
    movf PORTD, W
    andlw 0x03
    movwf combinado
    movlw 0x00
    cpfseq combinado
    goto falso1
    movlw 0xE0
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V
    goto final
falso1:
    movlw 0x01
    cpfseq combinado
    goto falso2
    movlw 0xE5
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V
    goto final
falso2:
    movlw 0x02
    cpfseq combinado
    goto falso3
    movlw 0xEA
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V
    goto final
falso3:
    movlw 0xEF
    movwf CVRCON	;Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V
    goto final
final:
    goto inicio    
    end



