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
    endc

    org 0x0200
;teibol db 0x81, 0x42, 0x24, 0x18, 0x24, 0x42    
teibol db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02    
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISB			;Todo el puertoB como salida
    movlw UPPER teibol
    movwf TBLPTRU
    movlw HIGH teibol
    movwf TBLPTRH
    movlw LOW teibol
    movwf TBLPTRL
    
inicio:
    TBLRD*+
    movff TABLAT, LATB
    call delaymon
    movlw .13
    cpfsgt TBLPTRL
    goto inicio
    clrf TBLPTRL
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