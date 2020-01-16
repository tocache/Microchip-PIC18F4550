    list p=18f4550		;Modelo del microcontrolador
    #include<p18f4550.inc>	;Libreria de nombre de registros
    
    ;Aquí van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x020
	var_i			;Variables del retardo de 500ms (usado para desplazamiento)
	var_j
	var_k
	c_msg
    endc
    
    org 0x0600
tabla_uc db 0x00,0x00,0x00,0x00,0x37,0x06,0x39,0x50,0x3f,0x39,0x3f,0x54,0x78,0x50,0x3f,0x38,0x77,0x5e,0x3f,0x50,0x79,0x6d,0x00,0x00,0x00
    
    org 0x0000
    goto configuro
    
    org 0x0008
    goto interrupcion
    
    org 0x0020
configuro:    
    clrf TRISD		    ;Todos los puertos D comos salida
    bcf TRISB, 1
    bcf TRISB, 2
    bcf TRISB, 3
    bcf TRISB, 4	    ;Modo salida para los habilitadores de los displays
    movlw HIGH tabla_uc
    movwf TBLPTRH
    movlw LOW tabla_uc
    movwf TBLPTRL	    ;Direccion de TBLPTR a tabla_uc
    movlw 0xC8
    movwf T0CON		    ;Timer0 ON modo 8bit PSC 1:1
    movlw 0xA0
    movwf INTCON	    ;Interrupcion ON para TMR0
    bsf LATB, 1
    bsf LATB, 2
    bsf LATB, 3   
    bsf LATB, 4
    
inicio:
    clrf c_msg
otro:
    call retardo_500ms
    movlw .21
    cpfseq c_msg	    ;Pregunto si llegue a la ultima letra de la cadena
    goto aunno
    goto inicio
aunno:
    incf c_msg, f
    goto otro

interrupcion:
    movf c_msg, W
    movwf TBLPTRL
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 1
    call noops
    bsf LATB, 1
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 2
    call noops
    bsf LATB, 2
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 3
    call noops
    bsf LATB, 3
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 4
    call noops
    bsf LATB, 4
    bcf INTCON, TMR0IF
    retfie
    
noops:
    nop
    nop
    nop
    nop
    return
    
retardo_500ms:
    clrf var_i
otro1:
    call anid_1
    movlw .9
    cpfseq var_i
    goto falso1
    return
falso1:
    incf var_i,f
    goto otro1
    
anid_1:
    clrf var_j
otro2:
    call anid_2
    movlw .49
    cpfseq var_j
    goto falso2
    return
falso2:
    incf var_j, f
    goto otro2

anid_2:
    clrf var_k
otro3:
    nop
    nop
    movlw .59
    cpfseq var_k
    goto falso3
    return
falso3:
    incf var_k, f
    goto otro3
    end


