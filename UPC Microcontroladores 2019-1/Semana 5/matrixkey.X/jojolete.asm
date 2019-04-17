;Nuestro primer programa en Assembler
;Para los comentarios usamos ";"

    list p=18f4550
    #include <p18f4550.inc>

    ;Declaración de las directivas de pre-procesador ó
    ;bits de configuración
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

  cblock 0x20
    f1
    f2
    f3
    f4
    endc
  
    org 0x0000
    goto configuracion
    
    org 0x0020
configuracion:
    bcf TRISE, 0	;Indicador de tecla presionada
    movlw 0x0F
    movwf TRISB		;Puertos RB0-RB3 como entradas y RB4-RB7 como salidas
    ;bcf INTCON2, RBPU	;Activacion de las resistencias internas de pull-up del RB
    clrf LATB
    
inicio:
    movlw b'11100000'
    movwf LATB
    movf PORTB, W
    andlw 0x0F	    ;Enmascaramiento de los cuatro primeros bits
    movwf f1
    comf f1, f
    movlw b'11010000'
    movwf LATB
    movf PORTB, W
    andlw 0x0F	    ;Enmascaramiento de los cuatro primeros bits
    movwf f2
    comf f2, f
    movlw b'10110000'
    movwf LATB
    movf PORTB, W
    andlw 0x0F	    ;Enmascaramiento de los cuatro primeros bits
    movwf f3
    comf f3, f    
    movlw b'01110000'
    movwf LATB
    movf PORTB, W
    andlw 0x0F	    ;Enmascaramiento de los cuatro primeros bits
    movwf f4
    comf f4, f    
    goto inicio
    end
    