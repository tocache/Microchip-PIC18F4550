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
	var_i
	var_j
	var_k
    endc
    
    org 0x0000
    goto configuro
    
    org 0x0020
configuro:    
    bcf TRISD, 0		;Salida para el LED

inicio:
    bsf LATD, 0
    call retardo_500ms
    bcf LATD, 0
    call retardo_500ms
    goto inicio
    
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
    movlw .99
    cpfseq var_k
    goto falso3
    return
falso3:
    incf var_k, f
    goto otro3
    end


