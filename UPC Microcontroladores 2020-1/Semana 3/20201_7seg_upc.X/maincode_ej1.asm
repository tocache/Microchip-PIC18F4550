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

    ;Bloque para declaración de variables (ponerle nombres a los GPR)
    ;Dicho bloque empieza desde la dirección 0x020 de la memoria de datos
    cblock 0x020
    var_i
    var_j
    var_k
    endc
    
    org 0x0000		;Vector de RESET
    goto init_conf
    
    org 0x0008		;Vector de interrupción
    
    org 0x0020		;Zona de programa de usuario
init_conf:
	    movlw 0x80
	    movwf TRISD	    ;Puertos RD6-0 como salidas
loop:	    movlw 0x3E
	    movwf LATD
	    call delay_long
	    movlw 0x73
	    movwf LATD
	    call delay_long
	    movlw 0x39
	    movwf LATD
	    call delay_long
	    goto loop
	    
;Subrutina de retardo largo    
delay_long:    
    movlw .50
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    ;goto delay_long
    return

bucle1:
    movlw .50
    movwf var_j
otro2:
    call bucle2		;Salto a subrutina
    decfsz var_j,f
    goto otro2
    return
    
bucle2:
    movlw .50
    movwf var_k
otro3:
    nop
    decfsz var_k,f
    goto otro3
    return	    
	    end		;Fin del programa