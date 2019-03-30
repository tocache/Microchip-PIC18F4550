;Este es un comentario
;Plantilla hecha por Kalun Lau
;Micontroladores 2019 UPC San Miguel
    
    list p=18f4550	;Modelo de microcontrolador a usar
    #include <p18f4550.inc>
    
;Aquí van las directivas de preprocesador (bits de configuracion)
    CONFIG  FOSC = XT_XT    ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON       ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF       ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF       ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF    ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF       ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x0020	;Bloque de nombre de registros GPR
	papaya
	mandarina
	maracuya
	endc
	
    org 0x0000		;Vector de RESET
    goto papanatas
    
    org 0x0020		;Zona de programa de usuario
papanatas:
    bcf TRISD, 0	;Puerto RD0 como salida
lazo:
    bsf LATD, 0
    call retrasado
    bcf LATD, 0
    call retrasado
    goto lazo
    
retrasado:
    movlw .100
    movwf papaya
otro1:
    call anid1
    decfsz papaya, 1
    goto otro1
    return

anid1:
    movlw .100
    movwf mandarina
otro2:
    nop
    call anid2
    decfsz mandarina, 1
    goto otro2
    return

anid2:
    movlw .23
    movwf maracuya
otro3:
    nop
    decfsz maracuya, 1
    goto otro3
    return
    
    end