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

;Aquí va el cblock o declaaración de nombres de GPR    
    cblock 0x000
    NUM_A
    NUM_B
    endc

;NUM_A equ 0x000
;NUM_B equ 0x001
    
    org 0x0000
    goto init_conf

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    movlw 0xF8
    movwf TRISD		;RD0-RD2 como salidas
    clrf NUM_A		;Inicializando en cero
    clrf NUM_B		;Inicializando en cero
    
loop:
    movf PORTB, W	;leyendo el PORTB
esp:movwf NUM_A		;copiamos a NUM_A
    movwf NUM_B		;copiamos a NUM_B
    swapf NUM_A, W	;intercambiamos nibbles en NUM_A
    andlw 0x0F		;aplicamos enmascarmiento
    movwf NUM_A		;escribimos el resultado nuevamnete en NUM_A
    movf NUM_B, W	;leemos NUM_B
    andlw 0x0F		;aplicamos enmascaramiento
    movwf NUM_B		;escribimos el resultado nuevamente en NUM_B
compara:
    movf NUM_B, W	;mando NUM_B a W
    cpfsgt NUM_A	;evaluo si NUM_A > NUM_B
    goto falso1
    bsf LATD, 0		;RD0=1
    bcf LATD, 1		;RD1=0
    bcf LATD, 2		;RD2=0
    goto loop
falso1:
    movf NUM_B, W	;mando NUM_B a W
    cpfseq NUM_A	;evaluo NUM_A = NUM_B
    goto falso2
    bcf LATD, 0		;RD0=0
    bsf LATD, 1		;RD1=1
    bcf LATD, 2		;RD2=0
    goto loop
falso2:
    bcf LATD, 0		;RD0=0
    bcf LATD, 1		;RD1=0
    bsf LATD, 2		;RD2=1
    goto loop
    end
    
