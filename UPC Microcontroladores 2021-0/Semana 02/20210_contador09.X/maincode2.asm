;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x000
    cuenta
    var_i
    var_j
    var_k
    endc
        
    org 0x0500
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
    
    org 0x0000
    goto init_conf

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    clrf TRISD	    ;Todo RD como salida
    movlw high tabla_7s
    movwf TBLPTRH
    movlw low tabla_7s
    movwf TBLPTRL	    ;TBLPTR apuntando a 0x0500
    clrf cuenta
    call visualizar	    ;subrutina para decodificar y visualizar
    call delaymon
loop:
    movlw .9		    ;pregunta si cuenta=9
    cpfseq cuenta
    goto nollega	    ;cuenta no es 9
    clrf cuenta		    ;cuenta es 9
    goto termino
nollega:
    incf cuenta, f
termino:
    call visualizar
    call delaymon
    goto loop	    ;boton soltado
    
visualizar:
    movff cuenta, TBLPTRL   ;apunto 
    TBLRD*
    movff TABLAT, LATD
    return

;subrutina de retardo    
delaymon:    
    movlw .50
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    return
bucle1:
    movlw .55
    movwf var_j
otro2:
    nop
    nop
    call bucle2		;Salto a subrutina
    decfsz var_j,f
    goto otro2
    return
bucle2:
    movlw .20
    movwf var_k
otro3:
    nop
    decfsz var_k,f
    goto otro3
    return      
    
    end