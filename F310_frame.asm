;-------------------------------------------------------------------------------------------
;Filename: F310_frame.asm
;Description: F310 Generated Initialization; 
;			  F310 Application demo for C8051F310EVM
;             T0 used as 16bits timer to delay 1s for controlling LED and Beeper
;Designed by: cdh
;Date:  2012-10-10
;--------------------------------------------------------------------------------------------

$include (C8051F310.inc)

LED		BIT P0.0
BEEP	BIT P3.1
KINT	BIT P0.1


		ORG 0000H
		LJMP MAIN

		ORG 0100H
;--------------------------------------------------------------		
		;≥ı ºªØC8051F310£¨SYSCLK=24.5/8=3MHz, 
		;πÿ±’WDT
		;P0.0=PULL UP, P0.1=OPEN D, P3.1=PULL UP
		;T0,16bits Timer, TCLK=SYSCLK/48
;--------------------------------------------------------------																			    
MAIN:   ACALL Init_Device 
					 
;-------Add  your code here------------------------------------
;GOON:	SETB LED
;		CLR BEEP		
;		ACALL D1S
;		CLR LED	
;		SETB BEEP
;		ACALL D1S
;		
;		SJMP GOON

;-------Timer T0 delay 1s-----------------
D1S:    MOV TMOD,#01H
		MOV TH0,#0
		MOV TL0,#0
		SETB TR0
		JNB TF0,$
		CLR TF0
		CLR TR0
		RET
;-------Timer T0 delay 0.5s
;-------end of your code-------------------------------------------------


;------------------------------------------------------------------------
;-  Generated Initialization File                                      --
;------------------------------------------------------------------------

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
    ; P0.0  -  Unassigned,  Push-Pull,  Digital
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

    mov  P0MDOUT,   #001h
    mov  P3MDOUT,   #002h
    mov  XBR1,      #040h
    ret

; Initialization function for device,
; Call Init_Device from your main program
Init_Device:
    lcall PCA_Init
    lcall Timer_Init
    lcall Port_IO_Init
    ret

	end
