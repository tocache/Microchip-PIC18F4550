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

    org 0x0200
tabla7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0X7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
;Disp7seg:  0     1     2     3     4     5     6     7     8     9     E     E     E     E     E     E 
 
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    clrf TRISD			;Salida para el display 7 seg
    bcf TRISB, 7		;Salida para la onda cuadrada
    movlw 0xC1			;Tmr0 ON, 8bit, PSA=0, Prescaler 1:4
    movwf T0CON
    movlw UPPER tabla7s		;Para apuntar puntero de tabla TBLPTR hacia "tabla7s"
    movwf TBLPTRU		;(TBLPTRU:TBLPTRH:TBLPTRL) -> 21 bits
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL

inicio:
    btfss PORTB, 5
    goto rapidisimo
    movlw 0xC1
    movwf T0CON
    goto paltacho
rapidisimo:
    movlw 0xC0
    movwf T0CON
paltacho:    
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
    movlw 0x00
    call displayada
    bsf LATB, 7
    movlw .231
    movwf TMR0L
nan1:
    btfss INTCON, TMR0IF
    goto nan1
    bcf INTCON, TMR0IF
    bcf LATB, 7
    movlw .31
    movwf TMR0L
nan2:
    btfss INTCON, TMR0IF
    goto nan2
    goto finalon
    
sel_30:
    movlw 0x01
    call displayada
    bsf LATB, 7
    movlw .181
    movwf TMR0L
nan3:
    btfss INTCON, TMR0IF
    goto nan3
    bcf INTCON, TMR0IF
    bcf LATB, 7
    movlw .81
    movwf TMR0L
nan4:
    btfss INTCON, TMR0IF
    goto nan4
    goto finalon

sel_70:
    movlw 0x02
    call displayada
    bsf LATB, 7
    movlw .81
    movwf TMR0L
nan5:
    btfss INTCON, TMR0IF
    goto nan5
    bcf INTCON, TMR0IF
    bcf LATB, 7
    movlw .181
    movwf TMR0L
nan6:
    btfss INTCON, TMR0IF
    goto nan6
    goto finalon
    
sel_100:
    movlw 0x03
    call displayada
    bsf LATB, 7
    goto finalon

finalon:
    bcf INTCON, TMR0IF
    goto inicio

displayada:
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    return
    end