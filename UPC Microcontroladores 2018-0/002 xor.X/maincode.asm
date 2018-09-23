    list p=18f4550  ;directiva para decirle al programa el modelo de microcontrolador que se va a usar
    #include <p18f4550.inc> ;llamada a la librería de nombre de los registros del PIC18F4550
    
    ;A continuación las directivas de configuración del microcontrolador
    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			;vector de RESET
    goto programa
    
    org 0x0020			;zona libre para escribir programa
programa:
    ;bsf TRISD, 0		;D.0 como entrada
    ;bsf TRISD, 1		;D.1 como entrada
    movlw 0x03			;cargo el valor 0x03 hexadecimal (binario es 00000011) a registro W
    movwf TRISD			;muevo contenido de registro W hacia registro TRISD
    bcf TRISB, 0		;B.0 como salida

inicio:
    btfss PORTD, 0
    goto falso1
    btfss PORTD, 1
    goto falso2
    bcf LATB, 0			;Cuando la condición es D.0=1 y D.1=1
    goto final
falso2:
    bsf LATB, 0			;Cuando la condición es D.0=1 y D.1=0
    goto final
falso1:
    btfss PORTD, 1
    goto falso3
    bsf LATB, 0			;Cuando la condición es D.0=0 y D.1=1
    goto final
falso3:
    bcf LATB, 0			;Cuando la condición es D.0=0 y D.1=0
final:
    goto inicio
    end
    
