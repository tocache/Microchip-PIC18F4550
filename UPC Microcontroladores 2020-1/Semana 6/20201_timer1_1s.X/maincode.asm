;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
;Cristal de trabajo 4MHz externo
    
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

variablon EQU 0x030
 
    org 0x0000		;Vector de RESET
    goto init_conf
    
    org 0x0008		;Vector de interrupción
    goto Tmr1_ISR	    ;2us
    
    org 0x0020		;Zona de programa de usuario
init_conf:
    bcf TRISD, 0	;Puerto RD0 como salida para una señal cuadrada
    ;Configuración del Timer1:
    movlw 0x07
    movwf T1CON		;TMR1 ON, PSC 1:1, 32K Osc disabled (T1OSCEN=0) para simulacion en Proteus
    ;Configuración de interrupciones:
    bsf PIE1, TMR1IE	;TMR1IE=1 . Timer1 se encuentra como periférico secundario
    movlw 0xC0
    movwf INTCON	;GIE=1, PEIE=1
    
loop:
    btfss PORTB, 0
    goto loop
    setf TMR1H
    setf TMR1L
    goto loop
    
Tmr1_ISR:
	    bcf PIR1, TMR1IF	    ;1us    Bajamos la bandera de desborde del Timer1
	    bsf TMR1H, 7	    ;1us    Precarga de numero 0xC000 (32768)
	    bsf TMR1H, 6	    
	    clrf TMR1L		    ;1us    al registro de cuentas de Timer1
	    btg LATD, 0		    ;1us    Complemento al puerto RD0
	    retfie		    ;2us
    
	    end		;Fin del programa