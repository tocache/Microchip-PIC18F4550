;este es un comentario
    list p=18f4550		;modelo de procesador
    #include<p18f4550.inc>	;libreria de nombre de registros
    
    ;Bits de configuracion del microcontrolador
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    ;Declaración de nombre a registros GPR (mis variables)
var_i equ 0x000
var_j equ 0x001
var_k equ 0x002
 
    org 0x0000
    goto init_conf

    org 0x0020
init_conf:  bcf TRISD, 2		;RD2 como salida
inicio:	    btg LATD, 2			;encendemos el LED
	    call delay_long		;llamada a subrutina de retardo
	    goto inicio
	    
;Subrutina de retardo largo    
delay_long:    
    movlw .40
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    ;goto delay_long
    return

bucle1:
    movlw .40
    movwf var_j
otro2:
    nop
    nop
    call bucle2		;Salto a subrutina
    decfsz var_j,f
    goto otro2
    return
    
bucle2:
    movlw .20
    movwf var_k
otro3:
    nop
    decfsz var_k,f
    goto otro3
    return	    
	    end			;fin del programa