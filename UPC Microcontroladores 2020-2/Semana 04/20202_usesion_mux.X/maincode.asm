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

    org 0x0430
t_chau	db 0x58, 0x74, 0x5F, 0x1C
	
    org 0x0440
t_bica db 0x7C, 0x04, 0x58, 0x5F    
    
    org 0x0020
init_conf:
    clrf TRISD
    movlw 0xF0
    movwf TRISB
    movlw 0x0F
    movwf LATB
    movlw 0x04
    movwf TBLPTRH
    
loop:
    btfsc PORTB, 6
    goto sel_tbica
sel_tchau:
    movlw 0x30
    movwf TBLPTRL
    call multiplex
    goto loop
sel_tbica:
    movlw 0x40
    movwf TBLPTRL
    call multiplex
    goto loop 
    
multiplex:
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 3	    ;habilito disp0
    nop
    nop
    nop
    nop
    bsf LATB, 3	    ;deshabilito disp0
    TBLRD*+
    movff TABLAT, LATD	    ;digito 0 a RD
    bcf LATB, 2	    ;habilito disp0
    nop
    nop
    nop
    nop
    bsf LATB, 2	    ;deshabilito disp0
    TBLRD*+
    movff TABLAT, LATD	    ;digito 0 a RD
    bcf LATB, 1	    ;habilito disp0
    nop
    nop
    nop
    nop
    bsf LATB, 1	    ;deshabilito disp0
    TBLRD*+
    movff TABLAT, LATD	    ;digito 0 a RD
    bcf LATB, 0	    ;habilito disp0
    nop
    nop
    nop
    nop
    bsf LATB, 0	    ;deshabilito disp0
    return    
    end