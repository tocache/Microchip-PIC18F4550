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
    
    org 0x0800
    tablita DB 0xC1, 0x8C, 0xC6, 0xFF, 0xAA	;Defino la tabla de decodificación de "UPC "
    ;Siendo 0xAA identificador de fin de la cadena de caracteres
    org 0x0900
    tablatota DB 0xC7, 0xC0, 0xFF, 0xEA, 0x88, 0xB9, 0xCF, 0xEA, 0xC0, 0xFF, 0xAA
    
    org 0x0020			;zona libre para escribir programa
programa:
    clrf TRISD	    ;Coloca a 00000000 el registro TRISD para que todo el puerto sea salida

inicio:
    movlw UPPER tablatota   ;Dirijo la dirección del puntero de tabla a tablatota
    movwf TBLPTRU
    movlw HIGH  tablatota
    movwf TBLPTRH
    movlw LOW  tablatota
    movwf TBLPTRL   
    
mensaje1:
    TBLRD*		;Leo lo que esta apuntando el puntero de tabla
    movlw 0xAA
    cpfseq TABLAT	;Pregunto si TABLAT tiene el valor de 0xAA (fin de cadena)
    goto falsote1
    goto otrote1

falsote1:
    movff TABLAT, LATD
    call retardo
    incf TBLPTRL, f
    goto mensaje1
    
otrote1:    
    movlw UPPER tablita   ;Dirijo la dirección del puntero de tabla a tablita
    movwf TBLPTRU
    movlw HIGH  tablita
    movwf TBLPTRH
    movlw LOW  tablita
    movwf TBLPTRL   

mensaje2:
    TBLRD*		;Leo lo que esta apuntando el puntero de tabla
    movlw 0xAA
    cpfseq TABLAT	;Pregunto si TABLAT tiene el valor de 0xAA (fin de cadena)
    goto falsote2
    goto otrote2

falsote2:
    movff TABLAT, LATD
    call retardo
    incf TBLPTRL, f
    goto mensaje2

otrote2:
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
    movlw .50
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

