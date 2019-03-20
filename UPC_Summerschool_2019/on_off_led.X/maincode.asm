;UPC Summer School 2019
;Template written by Kalun
    
    list p=18f4550		;The microcontroller of the project
    #include <p18f4550.inc>	;Library for the register's labels
    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

  cblock 0x0020			; Block declaration for RAM beggining at address 0x0020
    var_i
    var_j
    var_k
    endc
    
    org 0x0000			;Reset vector address
    goto beginning
    
    org 0x0020			;User program area
beginning:
    bcf TRISD, 0		;RD0 port as an output

loop:
    bsf LATD, 0			;RD0 high
    call delay_100ms		;100ms delay routine
    bcf LATD, 0			;RD0 low
    call delay_100ms		;100ms delay routine
    goto loop
    
delay_100ms:
    movlw .100
    movwf var_i
u1: call sub1
    decfsz var_i, f
    goto u1
    return

sub1:
    movlw .100
    movwf var_j
u2: call sub2
    decfsz var_j, f
    goto u2
    return
    
sub2:
    movlw .10
    movwf var_k
u3: decfsz var_k, f
    goto u3
    return
    
    end