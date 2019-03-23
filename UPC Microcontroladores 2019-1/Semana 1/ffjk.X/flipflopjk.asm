;Este es un comentario
;Plantilla hecha por Kalun Lau
;Curso de microcontroladores - UPC San Miguel 2019
    
    list p=18f4550	    ;Modelo de microcontrolador
    #include <p18f4550.inc> ;Llamado a la librería de nombres de registros

;A continuación las directivas de preprocesador    
    CONFIG  FOSC = XT_XT    ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON       ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF       ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF       ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF    ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF       ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		    ;Vector de RESET
    goto megamon
    
    org 0x0020		    ;Zona de programa de usuario
megamon:
    movlw 0xFC
    movwf TRISD		    ;Puertos RD(1:0) como salidas
    bsf LATD, 1
loooser:
    btfss PORTB, 0	    ;Pregunto si hay reloj
    goto loooser	    ;No hubo reloj
    btfss PORTB, 1	    ;Pregunto si J es uno
    goto jotacero	    ;Salta para aquí cuando es cero
    btfss PORTB, 2	    ;Pregunto si K es uno (J es uno)
    goto juno_kacero		    ;Salto aqui cuando es cero
    
    ;modo basculación J=1 K=1
    btfss PORTD, 0
    goto falsobas
    bcf LATD, 0
    bsf LATD, 1
    goto relojcero
falsobas:
    bsf LATD, 0
    bcf LATD, 1
    goto relojcero

    ;modo J=1 K=0
juno_kacero:
    bsf LATD, 0
    bcf LATD, 1
    goto relojcero
    
jotacero:
    btfss PORTB, 2
    goto jcero_kcero
    ;modo J=0 K=1
    bcf LATD, 0
    bsf LATD, 1
    goto relojcero

jcero_kcero:
    ;modo J=0 K=0 
    goto relojcero
    
relojcero:
    btfsc PORTB, 0
    goto relojcero
    goto loooser
    end


