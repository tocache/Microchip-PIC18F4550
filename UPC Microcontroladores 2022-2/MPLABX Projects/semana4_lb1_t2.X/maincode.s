    PROCESSOR 18F4550
    #include "cabecera.inc"

cuenta1 EQU 000H    
cuenta2 EQU 001H 
    
    PSECT rocoton, class=CODE, reloc=2, abs
rocoton:
    ORG 000000H
    goto configuro

    ORG 000020H
configuro:
    movlw 80H
    movwf TRISB	    ;RB(6:0) como salidas
    movwf TRISD	    ;RD(6:0) como salidas
    movlw 0FH
    movwf ADCON1    ;Todos los puertos ANx como digitales
    clrf cuenta1
    clrf cuenta2
    call deco_vis1
    call deco_vis2    
    
inicio:
    btfss PORTA, 0  ;pregunto si presione clk1
    goto siguiente1  ;no presione clk1, paso a evaluar clk2
    goto si_clk1    ;si presione clk1, salto a rutina de cuenta1
siguiente1:    
    btfss PORTA, 1  ;pregunto si presione clk2
    goto siguiente2  ;no presione clk2, paso a evaluar rst1
    goto si_clk2    ;si presione clk2, salto a rutina de cuenta2
siguiente2:
    btfss PORTA, 2  ;pregunto si presione rst1
    goto siguiente3  ;no presione rst1, paso a evaluar rst2
    goto si_rst1    ;si presione rst1, salto a rutina de reset1
siguiente3:
    btfss PORTA, 3  ;pregunto si presione rst1
    goto inicio	    ;no presione rst2, vuelvo al inicio
    goto si_rst2    ;si presione rst1, salto a rutina de reset1
    
si_clk1:
    movlw 9
    cpfseq cuenta1
    goto aun_no1
    clrf cuenta1
    goto sale1
aun_no1:
    incf cuenta1, f
sale1:
    call deco_vis1
    btfsc PORTA, 0
    bra $-2
    goto inicio
    
si_clk2:
    movlw 9
    cpfseq cuenta2
    goto aun_no2
    clrf cuenta2
    goto sale2
aun_no2:
    incf cuenta2, f
sale2:
    call deco_vis2
    btfsc PORTA, 1
    bra $-2
    goto inicio
    
si_rst1:
    clrf cuenta1
    call deco_vis1
    goto inicio
    
si_rst2:    
    clrf cuenta2
    call deco_vis2
    goto inicio

deco_vis1:
    movlw 0
    cpfseq cuenta1
    goto cta1_noes0
    movlw 3FH
    movwf LATB
    return
cta1_noes0:    
    movlw 1
    cpfseq cuenta1
    goto cta1_noes1
    movlw 06H
    movwf LATB
    return
cta1_noes1:    
    movlw 2
    cpfseq cuenta1
    goto cta1_noes2
    movlw 5BH
    movwf LATB
    return
cta1_noes2:    
    movlw 3
    cpfseq cuenta1
    goto cta1_noes3
    movlw 4FH
    movwf LATB
    return
cta1_noes3:    
    movlw 4
    cpfseq cuenta1
    goto cta1_noes4
    movlw 66H
    movwf LATB
    return
cta1_noes4:    
    movlw 5
    cpfseq cuenta1
    goto cta1_noes5
    movlw 6DH
    movwf LATB
    return
cta1_noes5:    
    movlw 6
    cpfseq cuenta1
    goto cta1_noes6
    movlw 7DH
    movwf LATB
    return
cta1_noes6:    
    movlw 7
    cpfseq cuenta1
    goto cta1_noes7
    movlw 07H
    movwf LATB
    return
cta1_noes7:    
    movlw 8
    cpfseq cuenta1
    goto cta1_noes8
    movlw 7FH
    movwf LATB
    return
cta1_noes8:    
    movlw 9
    cpfseq cuenta1
    return
    movlw 67H
    movwf LATB
    return

deco_vis2:
    movlw 0
    cpfseq cuenta2
    goto cta2_noes0
    movlw 3FH
    movwf LATD
    return
cta2_noes0:    
    movlw 1
    cpfseq cuenta2
    goto cta2_noes1
    movlw 06H
    movwf LATD
    return
cta2_noes1:    
    movlw 2
    cpfseq cuenta2
    goto cta2_noes2
    movlw 5BH
    movwf LATD
    return
cta2_noes2:    
    movlw 3
    cpfseq cuenta2
    goto cta2_noes3
    movlw 4FH
    movwf LATD
    return
cta2_noes3:    
    movlw 4
    cpfseq cuenta2
    goto cta2_noes4
    movlw 66H
    movwf LATD
    return
cta2_noes4:    
    movlw 5
    cpfseq cuenta2
    goto cta2_noes5
    movlw 6DH
    movwf LATD
    return
cta2_noes5:    
    movlw 6
    cpfseq cuenta2
    goto cta2_noes6
    movlw 7DH
    movwf LATD
    return
cta2_noes6:    
    movlw 7
    cpfseq cuenta2
    goto cta2_noes7
    movlw 07H
    movwf LATD
    return
cta2_noes7:    
    movlw 8
    cpfseq cuenta2
    goto cta2_noes8
    movlw 7FH
    movwf LATD
    return
cta2_noes8:    
    movlw 9
    cpfseq cuenta2
    return
    movlw 67H
    movwf LATD
    return
    
    end rocoton
    