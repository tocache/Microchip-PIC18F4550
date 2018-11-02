;Generador de onda cuadra con entrada de selección de duty cycle
;Salida es RD0, entradas de selección de DC RB(1:0)
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
    bcf TRISD, 0		;Salida de la onda cuadrada
    movlw 0xC1			;Tmr0 ON, 8bit, PSA=0, Prescaler 1:4
    movwf T0CON

inicio:
    movf PORTB, W		;Leo el puerto B
    andlw 0x03			;Enmascaro para que pasen solo RB1 y RB0
    movwf temporal
    movlw 0x00
    cpfseq temporal
    goto otro1
    goto sel_10		;Opción para DC = 10%
otro1:
    movlw 0x01
    cpfseq temporal
    goto otro2
    goto sel_30		;Opción para DC = 30%
otro2:
    movlw 0x02
    cpfseq temporal
    goto sel_100	;Opción para DC = 100%
    goto sel_70		;Opción para DC = 70%

sel_10:    
    bsf LATD, 0
    movlw .231
    movwf TMR0L
nan1:
    btfss INTCON, TMR0IF
    goto nan1
    bcf INTCON, TMR0IF
    bcf LATD, 0
    movlw .31
    movwf TMR0L
nan2:
    btfss INTCON, TMR0IF
    goto nan2
    goto finalon
    
sel_30:    
    bsf LATD, 0
    movlw .181
    movwf TMR0L
nan3:
    btfss INTCON, TMR0IF
    goto nan3
    bcf INTCON, TMR0IF
    bcf LATD, 0
    movlw .81
    movwf TMR0L
nan4:
    btfss INTCON, TMR0IF
    goto nan4
    goto finalon

sel_70:    
    bsf LATD, 0
    movlw .81
    movwf TMR0L
nan5:
    btfss INTCON, TMR0IF
    goto nan5
    bcf INTCON, TMR0IF
    bcf LATD, 0
    movlw .181
    movwf TMR0L
nan6:
    btfss INTCON, TMR0IF
    goto nan6
    goto finalon
    
sel_100:
    bsf LATD, 0
    goto finalon

finalon:
    bcf INTCON, TMR0IF
    goto inicio
    end