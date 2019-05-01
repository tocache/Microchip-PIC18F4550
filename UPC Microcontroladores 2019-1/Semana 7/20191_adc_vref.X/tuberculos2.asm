;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include <p18f4550.inc>		;Llamo a la librería de nombre de los regs
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = XT_XT	  ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

singlitch EQU 0x0020
 
    org 0x0000
    goto configuro
    
    org 0x0020
    ;Según la librería el LCD esta conectado con el PIC: RS->RD0, RW->RD1, E->RD2, Datos->RD4-RD7
configuro:
    clrf TRISD			;Todo el puerto D como salida (LCD)
    ;Para el ADC debo de configurar ADCON2, ADCON1 y ADCON0
    movlw 0x24
    movwf ADCON2    ;Justificacion a la izquierda, 8TAD, FOSC/4
    movlw 0x1B
    movwf ADCON1    ;AN0 y VRef+(AN3) habilitado
    movlw 0x01
    movwf ADCON0    ;Encendemos el ADC

inicio:
    bsf ADCON0, 1   ;Inicio la conversion
aunno:
    btfsc ADCON0, 1 ;Pregunto si ya termino de convertir
    goto aunno	    ;Aun esta convirtiendo
    movff ADRESH, singlitch
    rrcf singlitch, f
    bcf singlitch, 7
    movff singlitch, LATD
    goto inicio
    end