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

;Aquí va el cblock o declaración de nombres de GPR    
    cblock 0x000
    ESTADO
    endc
    
    org 0x0000		    ;Vector de RESET
    goto init_conf
    
    org 0x0008		    ;Vector de interrupcion high priority
    goto INT0_TMR0_ISR
    
    org 0x0018		    ;Vector de interrupcion low priority
    goto TMR1_ISR

    org 0x0020		    ;Zona de programa de usuario
init_conf:
    bcf TRISD, 0
    bcf TRISD, 1
    movlw 0x88
    movwf T0CON		    ;Configuracion del Timer0
    movlw 0x01
    movwf T1CON		    ;Configuracion del Timer1
    bsf RCON, IPEN	    ;Activo las prioridades en las interrupciones
    bcf IPR1, TMR1IP	    ;Mandar a Timer1 a la baja prioridad
    bsf PIE1, TMR1IE	    ;Activo la interrupcion del TMR1
    movlw 0xF0
    movwf INTCON	    ;Activo interrupciones INT0, TMR0, GIEH y GIEL
    clrf ESTADO		    ;Forzamos estado inicial a cero (RD0 1.5K y RD1 3.5K)
loop:
    nop
    nop
    goto loop
    
INT0_TMR0_ISR:		    ;Rutina de interrupcion high priority
;    bcf INTCON, GIEH	    ;Apagamos temporalmente el interrupcion GIEH para que no se produzcan otras interrupciones 
    btfss INTCON, INT0IF    ;Pregunto si ocurrio INT0
    goto el_otro
    btg ESTADO, 0	    ;Basculo el estado
    bcf INTCON, INT0IF	    ;Bajo la bandera de INT0
el_otro:
    btfss INTCON, TMR0IF    ;Pregunto si se desbordo TMR0
    goto nada_mas1
    btfss ESTADO, 0	    ;Pregunto a que puerto debe de salir la señal SIG1
    goto para_RD0
    btg LATD, 1
    goto nada_mas1
para_RD0:
    btg LATD, 0
nada_mas1:
    movlw 0xFE
    movwf TMR0H
    movlw 0xB3
    movwf TMR0L		    ;Cargamos cuenta inicial en TMR0
    bcf INTCON, TMR0IF	    ;Bajamos la bandera de TMR0
;    bsf INTCON, GIEH	    ;Encendemos nuevamente GIEH
    retfie		    ;Retorno cuando solo haya ocurrido INT0
    
TMR1_ISR:		    ;Rutina de interrupcion low priority
    btfss ESTADO, 0
    goto para_RD1
    btg LATD, 0
    goto nada_mas2
para_RD1:
    btg LATD, 1
nada_mas2:
    movlw 0xFF
    movwf TMR1H
    movlw 0x72
    movwf TMR1L		    ;Cargamos cuenta inicial en TMR1
    bcf PIR1, TMR1IF	    ;Bajamos la bandera de TMR1
    retfie
    end