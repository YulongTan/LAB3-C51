;------------------------------------
;-  Generated Initialization File  --
;TABLE1是顺时针点亮数码管循环的表格
;------------------------------------

$include (C8051F310.inc)
	  LED BIT P0.0
	  BEEP	BIT P3.1
	  KINT BIT P0.1
	  ORG 0000H
	  LJMP MAIN
	  ORG 0003H
	  LJMP INTT0
	  ORG 0100H
MAIN: ACALL Init_Device
      CLR BEEP
;---------键盘扫描---------
KEYPRO:
      ACALL KEXAM
      JC KEYPRO
	  ACALL D10ms
	  ACALL KEXAM
	  JC KEYPRO ;无按键按下时C=1
	  ACALL D10ms
	  ACALL KEXAM
	  JC KEYPRO
KEY1: MOV R2, #0FEH
      MOV R3, #0FFH  ;列值寄存器
	  MOV R4, #00H  ;行值寄存器
KEY2: 
      CLR P2.0
	  SETB P2.1
	  SETB P2.2
	  SETB P2.3
	  NOP
	  NOP
	  NOP
      MOV C, P2.4
	  ANL C, P2.5
	  ANL C, P2.6
	  ANL C, P2.7
	  JNC KEY3  ;有键按下，转求列值
	  MOV A, R4  ;无键按下，行值寄存器加一
	  ADD A, #01H
	  MOV R4, A
	  SETB P2.0
      CLR P2.1
	  SETB P2.2
	  SETB P2.3
	  NOP
	  NOP
	  NOP
      MOV C, P2.4
	  ANL C, P2.5
	  ANL C, P2.6
	  ANL C, P2.7
	  JNC KEY3  ;有键按下，转求列值
	  MOV A, R4  ;无键按下，行值寄存器加一
	  ADD A, #01H
	  MOV R4, A
	  SETB P2.0
	  SETB P2.1
      CLR P2.2
	  SETB P2.3
	  NOP
	  NOP
	  NOP
      MOV C, P2.4
	  ANL C, P2.5
	  ANL C, P2.6
	  ANL C, P2.7
	  JNC KEY3  ;有键按下，转求列值
	  MOV A, R4  ;无键按下，行值寄存器加一
	  ADD A, #01H
	  MOV R4, A	  
      CLR P2.3
	  NOP
	  NOP
	  NOP
      MOV C, P2.4
	  ANL C, P2.5
	  ANL C, P2.6
	  ANL C, P2.7
	  JNC KEY3  ;有键按下，转求列值
	  CLR A
	  AJMP KEYPRO
      
KEY3: MOV A, P2
KEY4: INC R3
	  RLC A
	  JC KEY4 ;C=1时跳转
KEY5: ACALL D10ms
      ACALL KEXAM
	  JNC KEY5   ;有键按下,转向KEY4,等待键释放
	  SETB P2.0
	  SETB P2.1
	  SETB P2.2
	  SETB P2.3
	  MOV A, #03H
	  CLR C
	  SUBB A, R3
	  MOV B, #04H
	  MUL AB
	  ADD A, R4
	  AJMP KEYADR
	  AJMP KEYPRO
	  RET
;---------功能键地址转移------
KEYADR:CJNE A, #09H, KYARD1
       AJMP DIGPRO
KYARD1:JC DIGPRO
KEYTBL:MOV DPTR, #JMPTBL
       CLR C
	   SUBB A, #10
	   RL A
	   JMP @A+DPTR
JMPTBL:AJMP AA
       AJMP AA
	   AJMP AA
	   AJMP AA
	   AJMP AA
	   AJMP AA
       RET
;----------结束------------
;-------功能按键程序-------
AA:   CPL LED 
      AJMP KEYPRO
;-------结束-------------
;-------数字按键处理---
DIGPRO:CPL LED
       AJMP KEYPRO
;--------检测键盘是否按下-------
KEXAM:CLR P2.0
      CLR P2.1
	  CLR P2.2
	  CLR P2.3
	  NOP
	  NOP
	  NOP
	  MOV C, P2.4
	  ANL C, P2.5
	  ANL C, P2.6
	  ANL C, P2.7
	  SETB P2.0
	  SETB P2.1
	  SETB P2.2
	  SETB P2.3
	  RET
;--------检测结束--------------

;-----------键盘扫描结束--------------
	  AJMP $
;-----------------------------子程序区域---------------------------------------
;-----亮灯程序--------
LIG:  mov R3,#6
      mov dptr,#TABLE1
LP_LIG: clr a
	  movc a,@a+dptr
	  mov P1,a
	  acall D0_5S
	  inc dptr
	  DJNZ R3,LP_LIG
	  ajmp LIG
	  ret
;--------end----------
;-------delay 10ms-------
D10ms:MOV TMOD,#01H
      MOV TH0,#0ECH
	  MOV TL0,#0FH
	  SETB TR0
	  JNB TF0,$
	  CLR TF0
	  CLR TR0
	  RET
;--------end------------	
;-------中断0亮灯--------
      ORG 0200H
INTT0:CPL LED
      LCALL D0_5s
	  CPL LED
;      CPL BEEP
;	  LCALL D2s
;	  CPL BEEP
      RETI
;-------end---------
;-------delay 0.5s---------
D0_5S:MOV R7, #5
L_0_5:MOV TMOD,#01H
      MOV TH0,#38H
	  MOV TL0,#9EH
	  SETB TR0
	  JNB TF0,$
	  CLR TF0
	  DJNZ R7, L_0_5
	  CLR TR0
	  RET
;------end------
;-------delay 2s---------
D2s:  MOV R7, #20
L_2:  MOV TMOD,#01H
;      MOV TH0, #36H
;	  MOV TL0, #0D3H
      MOV TH0, #38H
	  MOV TL0, #91H
	  SETB TR0
	  JNB TF0,$
	  CLR TF0
	  DJNZ R7, L_2
	  CLR TR0
	  RET
;--------end-------
;-----------------------------子程序结束-------------------------------------------------
;--------------表格----------------
TABLE1:DB 0C0H,60H,30H,18H,0CH,84H
;------------表格结束---------------
; Peripheral specific initialization functions,
; Called from the Init_Device label
PCA_Init:
    anl  PCA0MD,    #0BFh
    mov  PCA0MD,    #000h
    ret

Timer_Init:
    mov  TMOD,      #001h
    mov  CKCON,     #002h
    ret

Port_IO_Init:
    ; P0.0  -  Unassigned,  Open-Drain, Digital
    ; P0.1  -  Unassigned,  Open-Drain, Digital
    ; P0.2  -  Unassigned,  Open-Drain, Digital
    ; P0.3  -  Unassigned,  Open-Drain, Digital
    ; P0.4  -  Unassigned,  Open-Drain, Digital
    ; P0.5  -  Unassigned,  Open-Drain, Digital
    ; P0.6  -  Unassigned,  Open-Drain, Digital
    ; P0.7  -  Unassigned,  Open-Drain, Digital

    ; P1.0  -  Unassigned,  Open-Drain, Digital
    ; P1.1  -  Unassigned,  Open-Drain, Digital
    ; P1.2  -  Unassigned,  Open-Drain, Digital
    ; P1.3  -  Unassigned,  Open-Drain, Digital
    ; P1.4  -  Unassigned,  Open-Drain, Digital
    ; P1.5  -  Unassigned,  Open-Drain, Digital
    ; P1.6  -  Unassigned,  Open-Drain, Digital
    ; P1.7  -  Unassigned,  Open-Drain, Digital
    ; P2.0  -  Unassigned,  Open-Drain, Digital
    ; P2.1  -  Unassigned,  Open-Drain, Digital
    ; P2.2  -  Unassigned,  Open-Drain, Digital
    ; P2.3  -  Unassigned,  Open-Drain, Digital

    mov  XBR1,      #040h
    ret

Oscillator_Init:
    mov  OSCICN,    #083h
    ret
	
Interrupts_Init:
    mov  IE,        #081h
    ret
; Initialization function for device,
; Call Init_Device from your main program
Init_Device:
    lcall PCA_Init
    lcall Timer_Init
    lcall Port_IO_Init
    lcall Oscillator_Init
	lcall Interrupts_Init
    ret

end