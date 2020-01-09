    list p=18f4550		;Modelo del microcontrolador
    #include<p18f4550.inc>	;Libreria de nombre de registros
    
    ;Aquí van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

cuenta equ 0x00 

    org 0x0500
tabla db 0x00, 0x01, 0x03, 0x07, 0x0F, 0x0E, 0x0C, 0x08
    
    org 0x0000			;Vector de RESET
    goto configuro		;Salto a etiqueta
    
    org 0x0020			;Zona de programa de usuario
configuro:
    movlw 0xF0
    movwf TRISD			;Puertos RD0 al RD3 como salidas
    movlw high tabla
    movwf TBLPTRH
    movlw low tabla
    movwf TBLPTRL
    clrf cuenta
    
inicio:
    clrf TBLPTRL
    btfss PORTB, 0		;Pregunto si presione el boton en RB2
    goto inicio			;No he presionado el boton en RB2
    movlw .7
    cpfseq cuenta
    goto itera
    clrf cuenta
    call salida
    goto otro
    
itera:
    incf cuenta, f
    call salida
    goto otro
    
salida:
    movf cuenta, W
    addwf TBLPTRL, f
    TBLRD*
    movff TABLAT, LATD
    return

otro:
    btfsc PORTB, 0		;Pregunto si deje de presionar el boton en RB2
    goto otro			;Aun sigo presionando el boton en RB2
    goto inicio
    end



