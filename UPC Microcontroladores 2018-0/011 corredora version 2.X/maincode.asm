    list p=18f4550  ;directiva para decirle al programa el modelo de microcontrolador que se va a usar
    #include <p18f4550.inc> ;llamada a la librería de nombre de los registros del PIC18F4550
    
    ;A continuación las directivas de configuración del microcontrolador
    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x60	    ;Bloque de variables anexadas a registros en RAM
	dseg	;variable para la decena del segundo
	useg	;variable para la unidad del segundo
	dec	;variable para la decima de segundo
	cen	;variable para la centesima de segundo
	ticks	;tick que tiene que llegar a 10 para contabilizar una centésima
    endc

    org 0x0000			;vector de RESET
    goto programa

    org 0x0600
t_str db 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10

    org 0x0008			;vector de interrupcion de alta prioridad
    goto prioridad
    
    org 0x0018			;vector de interrupción de baja prioridad
    goto interrupcion
 
 
    org 0x0020			;zona libre para escribir programa
programa:
    bsf OSCCON, 6
    bsf OSCCON, 5
    bsf OSCCON, 4
    bsf OSCCON, IOFS
    clrf TRISD	    ;Coloca a 00000000 el registro TRISD para que todo el puerto sea salida
    clrf TRISB	    ;puerto B todos como salida
    movlw UPPER t_str
    movwf TBLPTRU
    movlw HIGH t_str
    movwf TBLPTRH
    movlw LOW t_str
    movwf TBLPTRL
    clrf LATB	    ;Para que en un inicio los habilitadores de los displays se encuentren apagados
    movlw 0xC8
    movwf T0CON	    ;Habilitamos el TImer0 para que temporice lo mas rápido posible
    movlw 0x91
    movwf T1CON	    ;Habilitar el Timer1 con FOsc/4 y Prescaler 1:2
    movlw 0x0B
    movwf CCP1CON   ;Habilitar el CCP el modo comparacion evento especial de disparo
    movlw 0x03
    movwf CCPR1H
    movlw 0xE8
    movwf CCPR1L    ;Valor de referencia para el comparador del CCP

    ;Area de configuración de las interrupciones
    bsf RCON, IPEN  ;Para habilitar la prioridad en las interrupciones
    movlw 0x04
    movwf PIE1	    ;Habilitamos la interrupción del CCP
    movlw 0xE0	    
    movwf INTCON    ;Prendemos la interrupcion por desborde del Timer0 y de perifericos
    bcf INTCON2, TMR0IP	;Para asignar la interrupcion del Timer0 en baja prioridad
    
    clrf TBLPTRL
    clrf dseg
    clrf useg
    clrf dec
    clrf cen
    clrf ticks

inicio:
    goto inicio

;rutina de la interrupción de baja prioridad (desborde del Timer0)
interrupcion:
    movf dseg, W
    movwf TBLPTRL    
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 0
    call nopes
    bcf LATB, 0
    movf useg, W
    movwf TBLPTRL    
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 1
    call nopes
    bcf LATB, 1
    movf dec, W
    movwf TBLPTRL    
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 2
    call nopes
    bcf LATB, 2
    movf cen, W
    movwf TBLPTRL    
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3
    call nopes
    bcf LATB, 3
    bcf INTCON, TMR0IF	    ;Bajamos la banderita de interrupcion por desborde del TImer0
    retfie

nopes:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return

;rutina de la interrupción de alta prioridad (match del comparador CCP)
prioridad:
    movlw .9
    cpfseq ticks
    goto nopis1
    clrf ticks
    movlw .9
    cpfseq cen
    goto nopis2
    clrf cen
    movlw .9
    cpfseq dec
    goto nopis3
    clrf dec
    movlw .9
    cpfseq useg
    goto nopis4
    clrf useg
    movlw .5
    cpfseq dseg
    goto nopis5
    clrf dseg
    goto fin_interr
nopis1: incf ticks, f
	goto fin_interr
nopis2: incf cen, f
	goto fin_interr
nopis3: incf dec, f
	goto fin_interr
nopis4: incf useg, f
	goto fin_interr
nopis5: incf dseg, f
	goto fin_interr
fin_interr:
	bcf PIR1, CCP1IF    ;Bajamos la banderita de la interrupción de match del CCP con el Timer1
	retfie
   
    end



