;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT erretece,class=CODE,reloc=2,abs
    ORG 00000H		;Vector de reset
erretece:	goto configuracion
    
    ORG 00008H		;Vector de interrupcion
vector_hp:	goto TMR1_ISR
    
    ORG 00020H
configuracion:
    bcf TRISD, 7   ;RD7 como salida
;    movlw 07H
;   movwf T1CON	    ;Tmr1 ON, PSC 1:1, T13CKI (T1OSCEN=0) sin cristal para Proteus
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
    nop
    goto loop

TMR1_ISR:
    movlw 080H
    movwf TMR1H
    clrf TMR1L	    ;49152 ;32768
    btg LATD, 7	    ;Basculando RD7
    bcf PIR1, 0
    retfie
    end erretece
    