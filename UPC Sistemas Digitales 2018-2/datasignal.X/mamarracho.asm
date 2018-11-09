;Por: Kalun    

    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Librería de nombres
    
    ;Zona de los bits de configuración del microcontroleitor    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  
temporal equ 0x0020

    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    bcf TRISD, 0
    bcf TRISD, 1
    movlw 0x01
    movwf TRISB

inicio:
    movlw 0xC0
    movwf T0CON
    btfss PORTB, 0
    goto cerrojo
    movlw 0x7E
    movwf LATB
    bcf LATD, 0
    bsf LATD, 1
    movlw .106
    movwf TMR0L
mani:    
    btfss INTCON, TMR0IF
    goto mani
    bsf LATD, 0
    bcf LATD, 1
    movlw .106
    movwf TMR0L
mani2:    
    btfss INTCON, TMR0IF
    goto mani2
    bcf LATD, 0
    bsf LATD, 1
    movlw .106
    movwf TMR0L
mani3:    
    btfss INTCON, TMR0IF
    goto mani3
    bsf LATD, 0
    bcf LATD, 1
    movlw 0x04
    movwf T0CON
    movlw .106
    movwf TMR0L
mani4:    
    btfss INTCON, TMR0IF
    goto mani4
    goto inicio
cerrojo:
    movlw 0x0C
    movwf LATB
    bsf LATD, 0
    bcf LATD, 1
    movlw .106
    movwf TMR0L
almendra:    
    btfss INTCON, TMR0IF
    goto almendra
    bcf LATD, 0
    bsf LATD, 1
    movlw .106
    movwf TMR0L
almendra2:    
    btfss INTCON, TMR0IF
    goto almendra2
    bsf LATD, 0
    bcf LATD, 1
    movlw .106
    movwf TMR0L
almendra3:    
    btfss INTCON, TMR0IF
    goto almendra3
    bcf LATD, 0
    bsf LATD, 1
    movlw 0x04
    movwf T0CON
    movlw .106
    movwf TMR0L
almendra4:    
    btfss INTCON, TMR0IF
    goto almendra4
    goto inicio
    end
    