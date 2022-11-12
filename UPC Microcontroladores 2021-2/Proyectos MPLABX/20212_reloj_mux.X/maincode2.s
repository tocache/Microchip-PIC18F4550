    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT reloj, class=CODE, reloc=2, abs

;Etiquetas a los GPR    
horas		    EQU 000H
minutos		    EQU 001H
segundos	    EQU 002H
digbyte_temporal    EQU 003H
digbyte_centena	    EQU 004H
digbyte_decena	    EQU 005H
digbyte_unidad	    EQU 006H

reloj:    
    ORG 00000H
    goto configuro
    
    ORG 00008H
    goto TMR1_ISR
    
    ORG 00018H
    goto TMR0_ISR
    
    ORG 00400H
tabla7s:    db 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 67H   

    ORG 00020H
configuro:
    movlw 80H
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0F0H
    movwf TRISB		;RB3-RB0 como salidas
    clrf LATB		;Condicion inicial de los habilitadores
    movlw 10
    movwf horas
    movlw 15    
    movwf minutos
    movlw 50   
    movwf segundos	;Configuracion de la hora por defecto
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL	;TBLPTR apunta a 400H
;    movlw 07H
;    movwf T1CON	    ;Tmr1 ON, PSC 1:1, T13CKI (T1OSCEN=0) sin cristal para Proteus
    movlw 0FH
    movwf T1CON	    ;Tmr1 ON, PSC 1:1, XTAL32K (T1OSCEN=1) con cristal 32K
;    movlw 01H
;    movwf PIE1	    ;TMR1IE=1
    bsf PIE1, 0
;    movlw 0C0H
;    movwf INTCON    ;GIE=1,PEIE=1
    bsf INTCON, 6
    bsf INTCON, 7
    
loop:
    movff minutos, digbyte_temporal     ;Mandar decena del minuto
    call digbyte
    movf digbyte_decena, 0
    call decodifica
    bsf LATB, 0
    nop
    bcf LATB, 0
    movf digbyte_unidad, 0	        ;Mandar unidad del minuto
    call decodifica
    bsf LATB, 1
    nop
    bcf LATB, 1
    movff segundos, digbyte_temporal    ;Mandar decena del segundo
    call digbyte
    movf digbyte_decena, 0
    call decodifica
    bsf LATB, 2
    nop
    bcf LATB, 2
    movf digbyte_unidad, 0	       ;Mandar unidad del segundo
    call decodifica
    bsf LATB, 3
    nop
    bcf LATB, 3
    clrf TBLPTRL
    goto loop

decodifica:
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    return
    
digbyte:
    clrf digbyte_centena
    clrf digbyte_decena
    clrf digbyte_unidad
    movf digbyte_temporal, 0
    movlw 100
otro1:
    incf digbyte_centena, 1
    subwf digbyte_temporal, 1
    btfsc STATUS, 0		;Pregunto si resultado de resta fue negativo
    goto otro1
    decf digbyte_centena, 1
    addwf digbyte_temporal, 1
otro2:
    movlw 10
    incf digbyte_decena, 1
    subwf digbyte_temporal, 1
    btfsc STATUS, 0		;Pregunto si resta salio negativo
    goto otro2
    decf digbyte_decena, 1
    addwf digbyte_temporal, 1
    movff digbyte_temporal, digbyte_unidad
    return
    
TMR1_ISR:
    movlw 080H
    movwf TMR1H
    clrf TMR1L	    ;49152 ;32768
    movlw 59
    cpfseq segundos	;Lógica del secundero
    goto aunno1
    clrf segundos	;Lógica del minutero
    movlw 59
    cpfseq minutos
    goto aunno2
    clrf minutos
    goto final
aunno1:
    incf segundos, 1
    goto final
aunno2:
    incf minutos, 1
final:
    bcf PIR1, 0    
    retfie
    
TMR0_ISR:
    retfie
    
    end reloj





