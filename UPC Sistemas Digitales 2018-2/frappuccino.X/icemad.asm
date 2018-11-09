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
  
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISD			;Salida para el display 7 seg
    bcf TRISB, 1
    
inicio:
    btfss PORTB, 3
    goto nana
    btfss PORTB, 2
    goto dos
    goto tres
nana:
    btfss PORTB, 2
    goto cero
    goto uno

cero:
    movlw 0x3F
    movwf LATD
    bcf LATB, 1
    goto inicio

uno:
    movlw 0x06
    movwf LATD
    bsf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
papapa1:    
    btfss INTCON, TMR0IF
    goto papapa1
    bcf INTCON, TMR0IF
    bcf LATB, 1
    movlw 0xC2
    movwf T0CON
    movlw .31
    movwf TMR0L
papapa2:    
    btfss INTCON, TMR0IF
    goto papapa2
    bcf INTCON, TMR0IF
    goto inicio
    
dos:
    movlw 0x5B
    movwf LATD
    bsf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pepepe1:    
    btfss INTCON, TMR0IF
    goto pepepe1
    bcf INTCON, TMR0IF
    bcf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pepepe2:    
    btfss INTCON, TMR0IF
    goto pepepe2
    bcf INTCON, TMR0IF
    bsf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pepepe3:    
    btfss INTCON, TMR0IF
    goto pepepe3
    bcf INTCON, TMR0IF
    bcf LATB, 1
    movlw 0xC2
    movwf T0CON
    movlw .81
    movwf TMR0L
pepepe4:    
    btfss INTCON, TMR0IF
    goto pepepe4
    bcf INTCON, TMR0IF
    goto inicio

tres:
    movlw 0x4F
    movwf LATD
    bsf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pipipi1:    
    btfss INTCON, TMR0IF
    goto pipipi1
    bcf INTCON, TMR0IF
    bcf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pipipi2:    
    btfss INTCON, TMR0IF
    goto pipipi2
    bcf INTCON, TMR0IF
    bsf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pipipi3:    
    btfss INTCON, TMR0IF
    goto pipipi3
    bcf INTCON, TMR0IF
    bcf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pipipi4:    
    btfss INTCON, TMR0IF
    goto pipipi4
    bcf INTCON, TMR0IF
    bsf LATB, 1
    movlw 0xC8
    movwf T0CON
    movlw .56
    movwf TMR0L
pipipi5:    
    btfss INTCON, TMR0IF
    goto pipipi5
    bcf INTCON, TMR0IF
    bcf LATB, 1
    movlw 0xC2
    movwf T0CON
    movlw .131
    movwf TMR0L
pipipi6:    
    btfss INTCON, TMR0IF
    goto pipipi6
    bcf INTCON, TMR0IF
    goto inicio
    end
    
