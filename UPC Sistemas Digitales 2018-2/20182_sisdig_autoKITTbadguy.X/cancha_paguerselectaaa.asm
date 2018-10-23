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
teibol1 db 0x81, 0x42, 0x24, 0x18, 0x24, 0x42    
 
    org 0x0300
teibol2 db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02    

    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISB			;Todo el puertoB como salida
    
inicio:
    btfss PORTD, 0
    goto falsazo
verdaderazo:
    movlw UPPER teibol1
    movwf TBLPTRU
    movlw HIGH teibol1
    movwf TBLPTRH
    movlw LOW teibol1
    movwf TBLPTRL
otrazo1:
    TBLRD*+
    movff TABLAT, LATB
    call delaymon
    movlw .5
    cpfsgt TBLPTRL
    goto otrazo1
    clrf TBLPTRL
    goto inicio
    
falsazo:
    movlw UPPER teibol2
    movwf TBLPTRU
    movlw HIGH teibol2
    movwf TBLPTRH
    movlw LOW teibol2
    movwf TBLPTRL
otrazo2:
    TBLRD*+
    movff TABLAT, LATB
    call delaymon
    movlw .13
    cpfsgt TBLPTRL
    goto otrazo2
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