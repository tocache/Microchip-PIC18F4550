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
	ind	;Indicador para saber la dirección del desplazamiento, vamos a usar el bit0
    endc

    org 0x0000			;vector de RESET
    goto programa
    
    org 0x0020			;zona libre para escribir programa
programa:
    clrf TRISD	    ;Coloca a 00000000 el registro TRISD para que todo el puerto sea salida
    bcf ind, 0	    ;bit0 de ind en cero, para indicar que el desplazamiento es a la izquierda al inicio
    movlw 0x01
    movwf LATD	    ;le damos un valor inicial de 0x01 al puerto de salida (PortD)
inicio:
    btfsc ind, 0    ;Preguntamos si el bit0 de ind es igual a cero
    goto falsoo
    movlw 0x80
    cpfseq PORTD    ;Preguntamos si ya llegó al límite izquierdo
    goto aunno1
    bsf ind, 0	    ;Cambiamos el bit0 de ind a 1 para indicar que el desplazamiento es a la derecha
    goto final
aunno1:
    rlncf LATD, f   ;Desplazamiento del puerto, uno a la izquierda, puede que no funcione
    call retardo
    goto final
falsoo:
    movlw 0x01
    cpfseq PORTD    ;PReguntamos si ya llegó al límite derecho
    goto aunno2
    bcf ind, 0	    ;Cambiamos el bit0 de ind a 0 para indicar que el desplazamiento es a la izquierda
    goto final
aunno2:
    rrncf LATD, f   ;Desplazamiento del puerto, uno a la derecha, puede que no funcione
    call retardo
    goto final
    
final:    
    goto inicio
;Subrutina de retardo    
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
    movlw .25
    movwf ivar
otro3:
    nop		    ;este nop se va a repetir 50000 veces
    decfsz ivar, 1
    goto otro3
    return
    end


