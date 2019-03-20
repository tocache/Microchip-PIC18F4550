    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;librería de nombres

    
    ;Zona de los bits de configuración del microcontroleitor    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

  cblock 0x0020			;Zona de declaración de etiquetas a los
    cta_a			;registros GPR (variables)
    cta_b
    cta_c
    c_uni
    c_dec
    endc

    org 0x0200
tabla7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0X7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
;Disp7seg:  0     1     2     3     4     5     6     7     8     9     E     E     E     E     E     E

    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISB			;Todo el puertoB como salida
    movlw 0x80
    movwf TRISD			;Solo RB7 como entrada, el resto salidas
    movlw UPPER tabla7s
    movwf TBLPTRU
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL
    
inicio:
    btfss PORTD, 7
    goto downsazo
    goto upsazo

upsazo:
    movlw .9
    cpfseq c_uni
    goto sigueincuni
    clrf c_uni
    movlw .3
    cpfseq c_dec
    goto sigueincdec
    clrf c_dec
    goto visual
sigueincuni:
    incf c_uni
    goto visual
sigueincdec:
    incf c_dec
    goto visual
    
downsazo:
    movlw .0
    cpfseq c_uni
    goto siguedecuni
    movlw .9
    movwf c_uni
    movlw .0
    cpfseq c_dec
    goto siguedecdec
    movlw .3
    movwf c_dec
    goto visual
siguedecuni:
    decf c_uni
    goto visual
siguedecdec:
    decf c_dec
    goto visual

visual:
    clrf TBLPTRL
    movf c_uni, W
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    clrf TBLPTRL
    movf c_dec, W
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATB
    call delaymon
    goto inicio
    
    
;Subrutina de retardo    
delaymon:
    movlw .100
    movwf cta_a
otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return

bucle2:
    movlw .10
    movwf cta_b
otro2:
    call bucle3
    decfsz cta_b, f
    goto otro2
    return

bucle3:
    movlw .10
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return   
    
    end    