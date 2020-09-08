;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  
    org 0x0000
    goto init_conf
    
    org 0x0020
init_conf:
    clrf TRISD
    
loop:
    movf PORTB, W	;Leer el contenido de PORTB y lo almacena en Wreg
    andlw 0x0F		;Enmascarar los cuatro primeros bits
    mullw .2		;Multiplicando Wreg por 2, el resultado estara en PRODL
    movf PRODL, W
    call tabla_PC
    movwf LATD
    goto loop
    
tabla_PC:
    addwf PCL, f
    retlw 0xBF		;0 (PCL+0)
    retlw 0x86		;1 (PCL+2)
    retlw 0xDB		;2
    retlw 0xCF		;3
    retlw 0xE6		;4
    retlw 0xED		;5
    retlw 0xFD		;6
    retlw 0x87		;7
    retlw 0xFF		;8
    retlw 0xE7		;9 (PCL+18)
    retlw 0x00
    retlw 0x00
    retlw 0x00
    retlw 0x00
    retlw 0x00
    retlw 0x00
    end
    
    