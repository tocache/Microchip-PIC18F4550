;Este es un comentario, se antecede un ";"
    list p=18f4550	    ;Modelo del microcontrolador
    #include<p18f4550.inc>  ;Librería de nombre de registros
    
    ;Aquí se detallarán los bits de configuración del PIC
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

    org 0x0000		    ;Vector de RESET
    goto configura	    ;Salta a la etiqueta
    
    org 0x0020		    ;Zona de programa de usuario
configura:
    ;Aquí se colocan las configuraciones iniciales de la app
    bsf TRISB, 0	    ;Puerto B0 como entrada
    bsf TRISB, 1	    ;Puerto B1 como entrada
    bcf TRISD, 1	    ;Puerto D1 como salida
    
inicio:
    ;Rutina principal de la app
    btfsc PORTB, 0
    goto noescierto1
    btfsc PORTB, 1
    goto noescierto2
    bcf LATD, 1
    goto inicio
noescierto2:
    bsf LATD, 1
    goto inicio
noescierto1:
    btfsc PORTB, 1
    goto noescierto3
    bsf LATD, 1
    goto inicio
noescierto3:
    bcf LATD, 1
    goto inicio
    
    end			    ;Directiva que indica el fin del código de programa
    
    
    