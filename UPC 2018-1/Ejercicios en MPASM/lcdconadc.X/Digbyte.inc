digbyte MACRO arg0
       LOCAL       Exit0
       LOCAL       Exit1
       LOCAL       Exit2
       
       clrf        Dig0
       clrf        Dig1
       clrf        Dig2          
       
       movf        arg0, w
       movwf       Digtemp
       movlw       .100
Exit2
       incf        Dig2, f
       subwf       Digtemp, f
       btfsc       STATUS, C
       goto        Exit2
       decf        Dig2, f
       addwf       Digtemp, f
Exit1
       movlw       .10           
       incf        Dig1, f
       subwf       Digtemp, f
       btfsc       STATUS, C
       goto        Exit1
       decf        Dig1, f
       addwf       Digtemp, f
Exit0
       movf        Digtemp, w
       movwf       Dig0
       ENDM


