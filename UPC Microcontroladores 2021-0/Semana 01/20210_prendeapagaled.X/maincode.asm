;Este es un comentario
    list p=18f4550
    #include <p18f4550.inc>	;libreria de nombre de los registros sfr
    

;    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FOSC = XT_XT
    CONFIG  CPUDIV = OSC1_PLL2
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    cblock 0x000
    var_i
    var_j
    var_k
    endc
    
    org 0x0000		    ;Vector de reset
    goto configuro
    
    org 0x0020		    ;Zona de programa de usuario
configuro:
    bcf TRISD, 2    ;RD0 como salida
;    bcf OSCCON, 6
;    bcf OSCCON, 5
;    bcf OSCCON, 4   ;INTOSC - 31KHz
    
    
inicio:
    bsf LATD, 2	    ;prendo el led
;    call delaymon
    nop
    bcf LATD, 2	    ;apago el led
;   call delaymon
    nop
    goto inicio

delaymon:    
    movlw .50
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    return

bucle1:
    movlw .55
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
    end
