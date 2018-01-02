
;CodeVisionAVR C Compiler V2.05.3 Professional
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cur_dig=R5
	.DEF _displayCounter=R4
	.DEF _displayDigit=R7
	.DEF _seconds=R6
	.DEF _minutes=R9
	.DEF _hours=R8
	.DEF _day=R11
	.DEF _date=R10
	.DEF _month=R13
	.DEF _year=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_digit_G000:
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x9
_commonPins_G000:
	.DB  0x80,0x40,0x20,0x10

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x9F:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  _0x9F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "ds3231_twi.c"
;#include "ds3231_twi.h"
;
;void twi_start(void) {
; 0000 0003 void twi_start(void) {

	.CSEG
_twi_start:
;    TWCR = (1<<TWEA)|(1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
	LDI  R30,LOW(228)
	OUT  0x36,R30
;
;    while (!(TWCR & (1<<TWINT)))  {; }
_0x3:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x3
;}
	RET
;
;void twi_stop(void) {
_twi_stop:
;    TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWSTO);
	LDI  R30,LOW(148)
	OUT  0x36,R30
;}
	RET
;
;void twi_write(unsigned char _data)
;{
_twi_write:
;    TWDR = _data;
	ST   -Y,R26
;	_data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
;    TWCR = (1<<TWINT)|(1<<TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
;
;    while (!(TWCR & (1<<TWINT))) {;}
_0x6:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x6
;}
	RJMP _0x2000002
;
;unsigned char twi_read(unsigned char _ack) {
_twi_read:
;    unsigned char _data;
;
;    if (_ack==1)
	ST   -Y,R26
	ST   -Y,R17
;	_ack -> Y+1
;	_data -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x9
;    {
;        TWCR = (1<<TWEA)|(1<<TWINT) | (1<<TWEN);
	LDI  R30,LOW(196)
	RJMP _0x98
;    }
;    else
_0x9:
;    {
;        TWCR = (1<<TWINT) | (1<<TWEN);
	LDI  R30,LOW(132)
_0x98:
	OUT  0x36,R30
;    }
;    while (!(TWCR & (1<<TWINT)))
_0xB:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0xB
;    {
;    }
;    _data = TWDR;
	IN   R17,3
;    return _data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;   }
;
;unsigned char bcd (unsigned char data) {
_bcd:
;    return (((data & 0b11110000)>>4)*10 + (data & 0b00001111));
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	RCALL SUBOPT_0x0
	RCALL __ASRW4
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF)
	ADD  R30,R26
	RJMP _0x2000002
;}
; unsigned char decToBcd(unsigned char val)
; {
_decToBcd:
;   return ( (val/10*16) + (val%10) );
	ST   -Y,R26
;	val -> Y+0
	LD   R26,Y
	RCALL SUBOPT_0x1
	LDI  R26,LOW(16)
	MULS R30,R26
	MOV  R22,R0
	LD   R26,Y
	RCALL SUBOPT_0x2
	ADD  R30,R22
	RJMP _0x2000002
; }
;
;
;
;void ds3231_init(void){
_ds3231_init:
;twi_start();                           //������ ������� "C����" �� ���� I2C
	RCALL SUBOPT_0x3
;twi_write(DS3231_I2C_ADDRESS_WRITE);              // 104 is DS3231 device address
;twi_write(0x0E);                            //������������ � 14� ����
	LDI  R26,LOW(14)
	RCALL _twi_write
;twi_write(0b00000000);                       //���������� ����������� ��������
	LDI  R26,LOW(0)
	RCALL _twi_write
;twi_write(0b10001000);                       //���������� 1 �� ������ OSF � En32kHz
	LDI  R26,LOW(136)
	RCALL _twi_write
;twi_stop();
	RCALL _twi_stop
;
;
;}
	RET
;
;void rtc_get_time(unsigned char *secondsParam, unsigned char *minutesParam, unsigned char *hoursParam, unsigned char *dayParam, unsigned char *dateParam, unsigned char *monthParam, unsigned char *yearParam) {
_rtc_get_time:
;
;twi_start();                           //������ ������� "C����" �� ���� I2C
	ST   -Y,R27
	ST   -Y,R26
;	*secondsParam -> Y+12
;	*minutesParam -> Y+10
;	*hoursParam -> Y+8
;	*dayParam -> Y+6
;	*dateParam -> Y+4
;	*monthParam -> Y+2
;	*yearParam -> Y+0
	RCALL SUBOPT_0x3
;twi_write(DS3231_I2C_ADDRESS_WRITE);              // 104 is DS3231 device address
;twi_write(0x00);
	LDI  R26,LOW(0)
	RCALL _twi_write
;twi_stop();
	RCALL _twi_stop
;
;twi_start();
	RCALL _twi_start
;	twi_write(DS3231_I2C_ADDRESS_READ);
	LDI  R26,LOW(209)
	RCALL _twi_write
;
;     *secondsParam = bcd(twi_read(1)); // get seconds
	RCALL SUBOPT_0x4
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x5
;     *minutesParam = bcd(twi_read(1)); // get minutes
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x5
;     *hoursParam   = bcd(twi_read(1));   // get hours
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x5
;     *dayParam     = bcd(twi_read(1));
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x5
;     *dateParam    = bcd(twi_read(1));
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x5
;     *monthParam   = bcd(twi_read(1)); //temp month
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
;     *yearParam    = bcd(twi_read(0));
	LDI  R26,LOW(0)
	RCALL _twi_read
	MOV  R26,R30
	RCALL _bcd
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
;
;twi_stop();
	RCALL _twi_stop
;}
	ADIW R28,14
	RET
;
;
;void rtc_set_time(unsigned char secondsParam, unsigned char minutesParam, unsigned char hoursParam, unsigned char dayParam, unsigned char dateParam, unsigned char monthParam, unsigned char yearParam) {
_rtc_set_time:
;    twi_start();
	ST   -Y,R26
;	secondsParam -> Y+6
;	minutesParam -> Y+5
;	hoursParam -> Y+4
;	dayParam -> Y+3
;	dateParam -> Y+2
;	monthParam -> Y+1
;	yearParam -> Y+0
	RCALL SUBOPT_0x3
;    twi_write(DS3231_I2C_ADDRESS_WRITE);
;    twi_write(0);
	LDI  R26,LOW(0)
	RCALL _twi_write
;    twi_write(decToBcd(secondsParam));
	LDD  R26,Y+6
	RCALL SUBOPT_0x6
;    twi_write(decToBcd(minutesParam));
	LDD  R26,Y+5
	RCALL SUBOPT_0x6
;    twi_write(decToBcd(hoursParam));
	LDD  R26,Y+4
	RCALL SUBOPT_0x6
;    twi_write(decToBcd(dayParam));
	LDD  R26,Y+3
	RCALL SUBOPT_0x6
;    twi_write(decToBcd(dateParam));
	LDD  R26,Y+2
	RCALL SUBOPT_0x6
;    twi_write(decToBcd(monthParam));
	LDD  R26,Y+1
	RCALL SUBOPT_0x6
;    twi_write(decToBcd(yearParam));
	LD   R26,Y
	RCALL SUBOPT_0x6
;    twi_stop();
	RCALL _twi_stop
;}
	ADIW R28,7
	RET
;
;
;//didits pins
;#define DIGIT_1  128
;#define DIGIT_2  64
;#define DIGIT_3  32
;#define DIGIT_4  16
;
;#define PIN_A  1
;#define PIN_B  2
;#define PIN_C  4
;#define PIN_D  8
;
;
;#define MODE_SHOW_MAIN_INFO 0
;#define MODE_SET_DATE_YEAR 1
;#define MODE_SET_DATE_MONTH 2
;#define MODE_SET_DATE_DAY_OF_WEEK 3
;#define MODE_SET_DATE_DAY 4
;#define MODE_SET_TIME_HOUR 5
;#define MODE_SET_TIME_MINUTE 6
;#define MODE_SET_TIME_SECONDS 7
;#define MODE_SHOW_SECONDS 8
;
;#define BLANK_DIGIT 10
;
;static flash unsigned char digit[] = {
;	0,
;	PIN_A,
;	PIN_B,
;	PIN_B + PIN_A,
;	PIN_C,
;	PIN_C + PIN_A,
;	PIN_C + PIN_B,
;	PIN_C + PIN_B + PIN_A,
;	PIN_D,
;	PIN_D + PIN_A
;};
;
;static flash unsigned char commonPins[] = {
;	DIGIT_1,
;	DIGIT_2,
;	DIGIT_3,
;	DIGIT_4
;};
;
;unsigned char digit_out[4], cur_dig = 0;
;unsigned char displayCounter = 0;
;unsigned char displayDigit = 0;
;
;unsigned char seconds;
;unsigned char minutes;
;unsigned char hours;
;unsigned char day;
;unsigned char date;
;unsigned char month;
;unsigned char year;
;
;bit button_1_on1;
;bit button_2_on1;
;bit button_3_on1;
;bit button_1_on2;
;bit button_2_on2;
;bit button_3_on2;
;bit button_1_on3;
;bit button_2_on3;
;bit button_3_on3;
;
;unsigned char mode;
;unsigned char prevLastDigit;
;unsigned char lastDigit;
;bit show_point;
;bit lastDigitChanged;
;
;void doBtn1Action(void) {
; 0000 004C void doBtn1Action(void) {
_doBtn1Action:
; 0000 004D 	mode = mode < 7 ? (mode + 1) : 0;
	LDS  R26,_mode
	CPI  R26,LOW(0x7)
	BRSH _0xE
	RCALL SUBOPT_0x7
	ADIW R30,1
	RJMP _0xF
_0xE:
	LDI  R30,LOW(0)
_0xF:
	STS  _mode,R30
; 0000 004E }
	RET
;
;unsigned char getLastMonthDay(void) {
; 0000 0050 unsigned char getLastMonthDay(void) {
_getLastMonthDay:
; 0000 0051 	unsigned char retVal = 31;
; 0000 0052 	switch (month) {
	ST   -Y,R17
;	retVal -> R17
	LDI  R17,31
	MOV  R30,R13
	RCALL SUBOPT_0x0
; 0000 0053 	case 1:
	RCALL SUBOPT_0x8
	BREQ _0x15
; 0000 0054 	case 3:
	RCALL SUBOPT_0x9
	BRNE _0x16
_0x15:
; 0000 0055 	case 5:
	RJMP _0x17
_0x16:
	RCALL SUBOPT_0xA
	BRNE _0x18
_0x17:
; 0000 0056 	case 7:
	RJMP _0x19
_0x18:
	RCALL SUBOPT_0xB
	BRNE _0x1A
_0x19:
; 0000 0057 	case 8:
	RJMP _0x1B
_0x1A:
	RCALL SUBOPT_0xC
	BRNE _0x1C
_0x1B:
; 0000 0058 	case 10:
	RJMP _0x1D
_0x1C:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x1E
_0x1D:
; 0000 0059 	case 12:
	RJMP _0x1F
_0x1E:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x20
_0x1F:
; 0000 005A 		retVal = 31;
	LDI  R17,LOW(31)
; 0000 005B 		break;
	RJMP _0x13
; 0000 005C 	case 4:
_0x20:
	RCALL SUBOPT_0xD
	BREQ _0x22
; 0000 005D 	case 6:
	RCALL SUBOPT_0xE
	BRNE _0x23
_0x22:
; 0000 005E 	case 9:
	RJMP _0x24
_0x23:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x25
_0x24:
; 0000 005F 	case 11:
	RJMP _0x26
_0x25:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x27
_0x26:
; 0000 0060 		retVal = 30;
	LDI  R17,LOW(30)
; 0000 0061 		break;
	RJMP _0x13
; 0000 0062 	case 2:
_0x27:
	RCALL SUBOPT_0xF
	BRNE _0x13
; 0000 0063 		retVal = year % 4 == 0 ? 29 : 28;
	MOV  R26,R12
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __MODW21
	SBIW R30,0
	BRNE _0x29
	LDI  R30,LOW(29)
	RJMP _0x2A
_0x29:
	LDI  R30,LOW(28)
_0x2A:
	MOV  R17,R30
; 0000 0064 		break;
; 0000 0065 	}
_0x13:
; 0000 0066 	return retVal;
	MOV  R30,R17
	RJMP _0x2000001
; 0000 0067 }
;void doBtn2Action(void) {
; 0000 0068 void doBtn2Action(void) {
_doBtn2Action:
; 0000 0069 	switch (mode) {
	RCALL SUBOPT_0x7
; 0000 006A 	case MODE_SHOW_MAIN_INFO: {
	SBIW R30,0
	BRNE _0x2F
; 0000 006B 		mode = MODE_SHOW_SECONDS;
	LDI  R30,LOW(8)
	RJMP _0x99
; 0000 006C 		break;
; 0000 006D 	}
; 0000 006E 	case MODE_SET_DATE_YEAR: {
_0x2F:
	RCALL SUBOPT_0x8
	BRNE _0x30
; 0000 006F 		year = year < 99 ? (year + 1) : 0;
	LDI  R30,LOW(99)
	CP   R12,R30
	BRSH _0x31
	MOV  R30,R12
	RCALL SUBOPT_0x10
	RJMP _0x32
_0x31:
	LDI  R30,LOW(0)
_0x32:
	RCALL SUBOPT_0x11
; 0000 0070 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 0071 		break;
	RJMP _0x2E
; 0000 0072 	}
; 0000 0073 	case MODE_SET_DATE_MONTH: {
_0x30:
	RCALL SUBOPT_0xF
	BRNE _0x34
; 0000 0074 		month = month < 12 ? (month + 1) : 1;
	LDI  R30,LOW(12)
	CP   R13,R30
	BRSH _0x35
	MOV  R30,R13
	RCALL SUBOPT_0x10
	RJMP _0x36
_0x35:
	LDI  R30,LOW(1)
_0x36:
	RCALL SUBOPT_0x12
; 0000 0075 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 0076 		break;
	RJMP _0x2E
; 0000 0077 	}
; 0000 0078 	case MODE_SET_DATE_DAY_OF_WEEK: {
_0x34:
	RCALL SUBOPT_0x9
	BRNE _0x38
; 0000 0079 		day = day < 7 ? (day + 1) : 1;
	LDI  R30,LOW(7)
	CP   R11,R30
	BRSH _0x39
	MOV  R30,R11
	RCALL SUBOPT_0x10
	RJMP _0x3A
_0x39:
	LDI  R30,LOW(1)
_0x3A:
	RCALL SUBOPT_0x13
; 0000 007A 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 007B 		break;
	RJMP _0x2E
; 0000 007C 	}
; 0000 007D 	case MODE_SET_DATE_DAY: {
_0x38:
	RCALL SUBOPT_0xD
	BRNE _0x3C
; 0000 007E 		date = date < getLastMonthDay() ? (date + 1) : 1;
	RCALL _getLastMonthDay
	CP   R10,R30
	BRSH _0x3D
	MOV  R30,R10
	RCALL SUBOPT_0x10
	RJMP _0x3E
_0x3D:
	LDI  R30,LOW(1)
_0x3E:
	RCALL SUBOPT_0x14
; 0000 007F 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 0080 		break;
	RJMP _0x2E
; 0000 0081 	}
; 0000 0082 	case MODE_SET_TIME_HOUR: {
_0x3C:
	RCALL SUBOPT_0xA
	BRNE _0x40
; 0000 0083 		hours = hours < 23 ? (hours + 1) : 0;
	LDI  R30,LOW(23)
	CP   R8,R30
	BRSH _0x41
	MOV  R30,R8
	RCALL SUBOPT_0x10
	RJMP _0x42
_0x41:
	LDI  R30,LOW(0)
_0x42:
	RCALL SUBOPT_0x15
; 0000 0084 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 0085 		break;
	RJMP _0x2E
; 0000 0086 	}
; 0000 0087 	case MODE_SET_TIME_MINUTE: {
_0x40:
	RCALL SUBOPT_0xE
	BRNE _0x44
; 0000 0088 		minutes = minutes < 59 ? (minutes + 1) : 0;
	LDI  R30,LOW(59)
	CP   R9,R30
	BRSH _0x45
	MOV  R30,R9
	RCALL SUBOPT_0x10
	RJMP _0x46
_0x45:
	LDI  R30,LOW(0)
_0x46:
	RCALL SUBOPT_0x16
; 0000 0089 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 008A 		break;
	RJMP _0x2E
; 0000 008B 	}
; 0000 008C 	case MODE_SET_TIME_SECONDS: {
_0x44:
	RCALL SUBOPT_0xB
	BRNE _0x48
; 0000 008D 		seconds = 0;
	RCALL SUBOPT_0x17
; 0000 008E 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 008F 		break;
	RJMP _0x2E
; 0000 0090 	}
; 0000 0091 	case MODE_SHOW_SECONDS: {
_0x48:
	RCALL SUBOPT_0xC
	BRNE _0x2E
; 0000 0092 		mode = MODE_SHOW_MAIN_INFO;
	LDI  R30,LOW(0)
_0x99:
	STS  _mode,R30
; 0000 0093 		break;
; 0000 0094 	}
; 0000 0095 
; 0000 0096 	}
_0x2E:
; 0000 0097 
; 0000 0098 }
	RET
;
;void doBtn3Action(void) {
; 0000 009A void doBtn3Action(void) {
_doBtn3Action:
; 0000 009B 	switch (mode) {
	RCALL SUBOPT_0x7
; 0000 009C 	case MODE_SHOW_MAIN_INFO: {
	SBIW R30,0
	BRNE _0x4D
; 0000 009D 		//LED_BACKLIGT = ~LED_BACKLIGT;
; 0000 009E 		// LED_GREEN = ~LED_GREEN;
; 0000 009F 		break;
	RJMP _0x4C
; 0000 00A0 	}
; 0000 00A1 	case MODE_SET_DATE_YEAR: {
_0x4D:
	RCALL SUBOPT_0x8
	BRNE _0x4E
; 0000 00A2 		year = year > 0 ? (year - 1) : 99;
	LDI  R30,LOW(0)
	CP   R30,R12
	BRSH _0x4F
	MOV  R30,R12
	RCALL SUBOPT_0x18
	RJMP _0x50
_0x4F:
	LDI  R30,LOW(99)
_0x50:
	RCALL SUBOPT_0x11
; 0000 00A3 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00A4 		break;
	RJMP _0x4C
; 0000 00A5 	}
; 0000 00A6 	case MODE_SET_DATE_MONTH: {
_0x4E:
	RCALL SUBOPT_0xF
	BRNE _0x52
; 0000 00A7 		month = month > 1 ? (month - 1) : 12;
	LDI  R30,LOW(1)
	CP   R30,R13
	BRSH _0x53
	MOV  R30,R13
	RCALL SUBOPT_0x18
	RJMP _0x54
_0x53:
	LDI  R30,LOW(12)
_0x54:
	RCALL SUBOPT_0x12
; 0000 00A8 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00A9 		break;
	RJMP _0x4C
; 0000 00AA 	}
; 0000 00AB 	case MODE_SET_DATE_DAY_OF_WEEK: {
_0x52:
	RCALL SUBOPT_0x9
	BRNE _0x56
; 0000 00AC 		day = day > 1 ? (day - 1) : 7;
	LDI  R30,LOW(1)
	CP   R30,R11
	BRSH _0x57
	MOV  R30,R11
	RCALL SUBOPT_0x18
	RJMP _0x58
_0x57:
	LDI  R30,LOW(7)
_0x58:
	RCALL SUBOPT_0x13
; 0000 00AD 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00AE 		break;
	RJMP _0x4C
; 0000 00AF 	}
; 0000 00B0 	case MODE_SET_DATE_DAY: {
_0x56:
	RCALL SUBOPT_0xD
	BRNE _0x5A
; 0000 00B1 		date = date > 1 ? (date - 1) : getLastMonthDay();
	LDI  R30,LOW(1)
	CP   R30,R10
	BRSH _0x5B
	MOV  R30,R10
	RCALL SUBOPT_0x18
	RJMP _0x5C
_0x5B:
	RCALL _getLastMonthDay
_0x5C:
	RCALL SUBOPT_0x14
; 0000 00B2 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00B3 		break;
	RJMP _0x4C
; 0000 00B4 	}
; 0000 00B5 	case MODE_SET_TIME_HOUR: {
_0x5A:
	RCALL SUBOPT_0xA
	BRNE _0x5E
; 0000 00B6 		hours = hours > 0 ? (hours - 1) : 23;
	LDI  R30,LOW(0)
	CP   R30,R8
	BRSH _0x5F
	MOV  R30,R8
	RCALL SUBOPT_0x18
	RJMP _0x60
_0x5F:
	LDI  R30,LOW(23)
_0x60:
	RCALL SUBOPT_0x15
; 0000 00B7 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00B8 		break;
	RJMP _0x4C
; 0000 00B9 	}
; 0000 00BA 	case MODE_SET_TIME_MINUTE: {
_0x5E:
	RCALL SUBOPT_0xE
	BRNE _0x62
; 0000 00BB 		minutes = minutes > 0 ? (minutes - 1) : 59;
	LDI  R30,LOW(0)
	CP   R30,R9
	BRSH _0x63
	MOV  R30,R9
	RCALL SUBOPT_0x18
	RJMP _0x64
_0x63:
	LDI  R30,LOW(59)
_0x64:
	RCALL SUBOPT_0x16
; 0000 00BC 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00BD 		break;
	RJMP _0x4C
; 0000 00BE 	}
; 0000 00BF 	case MODE_SET_TIME_SECONDS: {
_0x62:
	RCALL SUBOPT_0xB
	BRNE _0x66
; 0000 00C0 		seconds = 0;
	RCALL SUBOPT_0x17
; 0000 00C1 		rtc_set_time(seconds, minutes, hours, day, date, month, year);
; 0000 00C2 		break;
	RJMP _0x4C
; 0000 00C3 	}
; 0000 00C4 	case MODE_SHOW_SECONDS: {
_0x66:
	RCALL SUBOPT_0xC
	BRNE _0x4C
; 0000 00C5 		mode = MODE_SHOW_MAIN_INFO;
	LDI  R30,LOW(0)
	STS  _mode,R30
; 0000 00C6 		break;
; 0000 00C7 	}
; 0000 00C8 	}
_0x4C:
; 0000 00C9 }
	RET
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
; 0000 00CC interrupt [9] void timer1_ovf_isr(void) {
_timer1_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00CD 	if(!PINC.0) {
	SBIC 0x13,0
	RJMP _0x68
; 0000 00CE 		if(button_1_on1) {
	SBRS R2,0
	RJMP _0x69
; 0000 00CF 			if(button_1_on2) {
	SBRS R2,3
	RJMP _0x6A
; 0000 00D0 				if(button_1_on3) {
	SBRS R2,6
	RJMP _0x6B
; 0000 00D1 					doBtn1Action();
	RCALL _doBtn1Action
; 0000 00D2 
; 0000 00D3 					button_1_on1 = 0;
	CLT
	RCALL SUBOPT_0x19
; 0000 00D4 					button_1_on2 = 0;
; 0000 00D5 					button_1_on3 = 0;
	RJMP _0x9A
; 0000 00D6 				} else {
_0x6B:
; 0000 00D7 					button_1_on3 = 1;
	SET
_0x9A:
	BLD  R2,6
; 0000 00D8 				}
; 0000 00D9 			} else {
	RJMP _0x6D
_0x6A:
; 0000 00DA 				button_1_on2 = 1;
	SET
	BLD  R2,3
; 0000 00DB 				button_1_on3 = 0;
	CLT
	BLD  R2,6
; 0000 00DC 			}
_0x6D:
; 0000 00DD 		} else {
	RJMP _0x6E
_0x69:
; 0000 00DE 			button_1_on1 = 1;
	SET
	RCALL SUBOPT_0x19
; 0000 00DF 			button_1_on2 = 0;
; 0000 00E0 			button_1_on3 = 0;
	BLD  R2,6
; 0000 00E1 		}
_0x6E:
; 0000 00E2 	}
; 0000 00E3 	if(!PINC.1) {
_0x68:
	SBIC 0x13,1
	RJMP _0x6F
; 0000 00E4 		if(button_2_on1) {
	SBRS R2,1
	RJMP _0x70
; 0000 00E5 			if(button_2_on2) {
	SBRS R2,4
	RJMP _0x71
; 0000 00E6 				if(button_2_on3) {
	SBRS R2,7
	RJMP _0x72
; 0000 00E7 					doBtn2Action();
	RCALL _doBtn2Action
; 0000 00E8 
; 0000 00E9 					button_2_on1 = 0;
	CLT
	RCALL SUBOPT_0x1A
; 0000 00EA 					button_2_on2 = 0;
; 0000 00EB 					button_2_on3 = 0;
	RJMP _0x9B
; 0000 00EC 				} else {
_0x72:
; 0000 00ED 					button_2_on3 = 1;
	SET
_0x9B:
	BLD  R2,7
; 0000 00EE 				}
; 0000 00EF 			} else {
	RJMP _0x74
_0x71:
; 0000 00F0 				button_2_on2 = 1;
	SET
	BLD  R2,4
; 0000 00F1 				button_2_on3 = 0;
	CLT
	BLD  R2,7
; 0000 00F2 			}
_0x74:
; 0000 00F3 		} else {
	RJMP _0x75
_0x70:
; 0000 00F4 			button_2_on1 = 1;
	SET
	RCALL SUBOPT_0x1A
; 0000 00F5 			button_2_on2 = 0;
; 0000 00F6 			button_2_on3 = 0;
	BLD  R2,7
; 0000 00F7 		}
_0x75:
; 0000 00F8 	}
; 0000 00F9 	if(!PINC.2) {
_0x6F:
	SBIC 0x13,2
	RJMP _0x76
; 0000 00FA 		if(button_3_on1) {
	SBRS R2,2
	RJMP _0x77
; 0000 00FB 			if(button_3_on2) {
	SBRS R2,5
	RJMP _0x78
; 0000 00FC 				if(button_3_on3) {
	SBRS R3,0
	RJMP _0x79
; 0000 00FD 					doBtn3Action();
	RCALL _doBtn3Action
; 0000 00FE 
; 0000 00FF 					button_3_on1 = 0;
	CLT
	RCALL SUBOPT_0x1B
; 0000 0100 					button_3_on2 = 0;
; 0000 0101 					button_3_on3 = 0;
	RJMP _0x9C
; 0000 0102 				} else {
_0x79:
; 0000 0103 					button_3_on3 = 1;
	SET
_0x9C:
	BLD  R3,0
; 0000 0104 				}
; 0000 0105 			} else {
	RJMP _0x7B
_0x78:
; 0000 0106 				button_3_on2 = 1;
	SET
	BLD  R2,5
; 0000 0107 				button_3_on3 = 0;
	CLT
	BLD  R3,0
; 0000 0108 			}
_0x7B:
; 0000 0109 		} else {
	RJMP _0x7C
_0x77:
; 0000 010A 			button_3_on1 = 1;
	SET
	RCALL SUBOPT_0x1B
; 0000 010B 			button_3_on2 = 0;
; 0000 010C 			button_3_on3 = 0;
	BLD  R3,0
; 0000 010D 		}
_0x7C:
; 0000 010E 	}
; 0000 010F 
; 0000 0110 //	if(!PINC.1) {
; 0000 0111 //		if(button_2_on) {
; 0000 0112 //			doBtn2Action();
; 0000 0113 //		}
; 0000 0114 //		button_2_on = !button_2_on;
; 0000 0115 //	}
; 0000 0116 //	if(!PINC.2) {
; 0000 0117 //		if(button_3_on) {
; 0000 0118 //			doBtn3Action();
; 0000 0119 //		}
; 0000 011A //		button_3_on = !button_3_on;
; 0000 011B //	}
; 0000 011C 	TCNT1=0;
_0x76:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 011D 	PORTB.6=~PORTB.6;
	SBIS 0x18,6
	RJMP _0x7D
	CBI  0x18,6
	RJMP _0x7E
_0x7D:
	SBI  0x18,6
_0x7E:
; 0000 011E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void) {
; 0000 0121 interrupt [5] void timer2_ovf_isr(void) {
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0122 	if(displayCounter == 0) {
	TST  R4
	BRNE _0x7F
; 0000 0123 		PORTD&= 0b00000000;
	IN   R30,0x12
	ANDI R30,LOW(0x0)
	OUT  0x12,R30
; 0000 0124 		displayDigit = digit_out[cur_dig];
	MOV  R30,R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_digit_out)
	SBCI R31,HIGH(-_digit_out)
	LD   R7,Z
; 0000 0125 		if(displayDigit < 10) {
	LDI  R30,LOW(10)
	CP   R7,R30
	BRSH _0x80
; 0000 0126 			PORTD=digit[displayDigit];
	MOV  R30,R7
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	LPM  R0,Z
	OUT  0x12,R0
; 0000 0127 			PORTD |= commonPins[cur_dig];
	IN   R30,0x12
	MOV  R26,R30
	MOV  R30,R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_commonPins_G000*2)
	SBCI R31,HIGH(-_commonPins_G000*2)
	LPM  R30,Z
	OR   R30,R26
	OUT  0x12,R30
; 0000 0128 		}
; 0000 0129 
; 0000 012A 
; 0000 012B 		cur_dig++;
_0x80:
	INC  R5
; 0000 012C 		if (cur_dig > 3) {
	LDI  R30,LOW(3)
	CP   R30,R5
	BRSH _0x81
; 0000 012D 			cur_dig = 0;
	CLR  R5
; 0000 012E 		}
; 0000 012F 	}
_0x81:
; 0000 0130 }
_0x7F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;unsigned char nextDigit(unsigned char digit) {
; 0000 0132 unsigned char nextDigit(unsigned char digit) {
_nextDigit:
; 0000 0133 	return (digit + 1) % 10;
	ST   -Y,R26
;	digit -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x10
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
_0x2000002:
	ADIW R28,1
	RET
; 0000 0134 }
;
;void displayMainInfo() {
; 0000 0136 void displayMainInfo() {
_displayMainInfo:
; 0000 0137     unsigned char j = 0;
; 0000 0138 	if(lastDigitChanged) {
	ST   -Y,R17
;	j -> R17
	LDI  R17,0
	SBRS R3,2
	RJMP _0x82
; 0000 0139 		for(j = 0; j < 10; j++) {
	LDI  R17,LOW(0)
_0x84:
	CPI  R17,10
	BRSH _0x85
; 0000 013A 			digit_out[0] = nextDigit(digit_out[0]);
	LDS  R26,_digit_out
	RCALL _nextDigit
	RCALL SUBOPT_0x1C
; 0000 013B 			digit_out[1] = nextDigit(digit_out[1]);
	__GETB2MN _digit_out,1
	RCALL _nextDigit
	RCALL SUBOPT_0x1D
; 0000 013C 			digit_out[2] = nextDigit(digit_out[2]);
	__GETB2MN _digit_out,2
	RCALL _nextDigit
	RCALL SUBOPT_0x1E
; 0000 013D 			digit_out[3] = nextDigit(digit_out[3]);
	__GETB2MN _digit_out,3
	RCALL _nextDigit
	__PUTB1MN _digit_out,3
; 0000 013E 			delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 013F 		}
	SUBI R17,-1
	RJMP _0x84
_0x85:
; 0000 0140 		lastDigitChanged = 0;
	CLT
	BLD  R3,2
; 0000 0141 	} else {
	RJMP _0x86
_0x82:
; 0000 0142 		digit_out[0] = hours / 10;
	MOV  R26,R8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1C
; 0000 0143 		digit_out[1] = hours % 10;
	MOV  R26,R8
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1D
; 0000 0144 		digit_out[2] = minutes / 10;
	MOV  R26,R9
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 0145 		lastDigit = minutes % 10;
	MOV  R26,R9
	RCALL SUBOPT_0x2
	STS  _lastDigit,R30
; 0000 0146 
; 0000 0147 		lastDigitChanged = prevLastDigit != lastDigit;
	LDS  R26,_prevLastDigit
	RCALL __NEB12
	BST  R30,0
	BLD  R3,2
; 0000 0148 		prevLastDigit = lastDigit;
	LDS  R30,_lastDigit
	STS  _prevLastDigit,R30
; 0000 0149 		digit_out[3] = lastDigit;
	LDS  R30,_lastDigit
	__PUTB1MN _digit_out,3
; 0000 014A 	}
_0x86:
; 0000 014B }
_0x2000001:
	LD   R17,Y+
	RET
;
;void displayInfo(void) {
; 0000 014D void displayInfo(void) {
_displayInfo:
; 0000 014E 	switch (mode) {
	RCALL SUBOPT_0x7
; 0000 014F 	case MODE_SHOW_MAIN_INFO:
	SBIW R30,0
	BRNE _0x8A
; 0000 0150 		displayMainInfo();
	RCALL _displayMainInfo
; 0000 0151 		break;
	RJMP _0x89
; 0000 0152 	case MODE_SET_DATE_YEAR:
_0x8A:
	RCALL SUBOPT_0x8
	BRNE _0x8B
; 0000 0153 		digit_out[0] = 8;
	RCALL SUBOPT_0x1F
; 0000 0154 		digit_out[1] = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
; 0000 0155 		digit_out[2] = year / 10;
	MOV  R26,R12
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 0156 		digit_out[3] = year % 10;
	MOV  R26,R12
	RJMP _0x9D
; 0000 0157 		break;
; 0000 0158 	case MODE_SET_DATE_MONTH:
_0x8B:
	RCALL SUBOPT_0xF
	BRNE _0x8C
; 0000 0159 		digit_out[0] = 8;
	RCALL SUBOPT_0x1F
; 0000 015A 		digit_out[1] = 2;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1D
; 0000 015B 		digit_out[2] = month / 10;
	MOV  R26,R13
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 015C 		digit_out[3] = month % 10;
	MOV  R26,R13
	RJMP _0x9D
; 0000 015D 		break;
; 0000 015E 	case MODE_SET_DATE_DAY_OF_WEEK:
_0x8C:
	RCALL SUBOPT_0x9
	BRNE _0x8D
; 0000 015F 		digit_out[0] = 8;
	RCALL SUBOPT_0x1F
; 0000 0160 		digit_out[1] = 3;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1D
; 0000 0161 		digit_out[2] = day / 10;
	MOV  R26,R11
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 0162 		digit_out[3] = day % 10;
	MOV  R26,R11
	RJMP _0x9D
; 0000 0163 		break;
; 0000 0164 	case MODE_SET_DATE_DAY:
_0x8D:
	RCALL SUBOPT_0xD
	BRNE _0x8E
; 0000 0165 		digit_out[0] = 8;
	RCALL SUBOPT_0x1F
; 0000 0166 		digit_out[1] = 4;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1D
; 0000 0167 		digit_out[2] = date / 10;
	MOV  R26,R10
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 0168 		digit_out[3] = date % 10;
	MOV  R26,R10
	RJMP _0x9D
; 0000 0169 		break;
; 0000 016A 
; 0000 016B 	case MODE_SET_TIME_HOUR:
_0x8E:
	RCALL SUBOPT_0xA
	BRNE _0x8F
; 0000 016C 		digit_out[0] = 9;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1C
; 0000 016D 		digit_out[1] = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
; 0000 016E 		digit_out[2] = hours / 10;
	MOV  R26,R8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 016F 		digit_out[3] = hours % 10;
	MOV  R26,R8
	RJMP _0x9D
; 0000 0170 		break;
; 0000 0171 	case MODE_SET_TIME_MINUTE:
_0x8F:
	RCALL SUBOPT_0xE
	BRNE _0x90
; 0000 0172 		digit_out[0] = 9;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1C
; 0000 0173 		digit_out[1] = 2;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1D
; 0000 0174 		digit_out[2] = minutes / 10;
	MOV  R26,R9
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 0175 		digit_out[3] = minutes % 10;
	MOV  R26,R9
	RJMP _0x9D
; 0000 0176 		break;
; 0000 0177 	case MODE_SET_TIME_SECONDS:
_0x90:
	RCALL SUBOPT_0xB
	BRNE _0x91
; 0000 0178 		digit_out[0] = 9;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1C
; 0000 0179 		digit_out[1] = 3;
	LDI  R30,LOW(3)
	RJMP _0x9E
; 0000 017A 		digit_out[2] = seconds / 10;
; 0000 017B 		digit_out[3] = seconds % 10;
; 0000 017C 		break;
; 0000 017D 	case MODE_SHOW_SECONDS:
_0x91:
	RCALL SUBOPT_0xC
	BRNE _0x89
; 0000 017E 		digit_out[0] = BLANK_DIGIT;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x1C
; 0000 017F 		digit_out[1] = BLANK_DIGIT;
	LDI  R30,LOW(10)
_0x9E:
	__PUTB1MN _digit_out,1
; 0000 0180 		digit_out[2] = seconds / 10;
	MOV  R26,R6
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x1E
; 0000 0181 		digit_out[3] = seconds % 10;
	MOV  R26,R6
_0x9D:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTB1MN _digit_out,3
; 0000 0182 		break;
; 0000 0183 
; 0000 0184 
; 0000 0185 	}
_0x89:
; 0000 0186 }
	RET
;
;void main(void)
; 0000 0189 {
_main:
; 0000 018A // Declare your local variables here
; 0000 018B 	unsigned char i = 0;
; 0000 018C     unsigned char tmp_counter;
; 0000 018D 
; 0000 018E 	PORTB = 0xFF;
;	i -> R17
;	tmp_counter -> R16
	LDI  R17,0
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 018F 	DDRB = 0xFF;
	OUT  0x17,R30
; 0000 0190 
; 0000 0191 	PORTC = 0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
; 0000 0192 	DDRC = 0xF8;
	LDI  R30,LOW(248)
	OUT  0x14,R30
; 0000 0193 
; 0000 0194 	PORTD = 0xFF;;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0195 	DDRD = 0xFF;
	OUT  0x11,R30
; 0000 0196 
; 0000 0197 
; 0000 0198 // Timer/Counter 0 initialization
; 0000 0199 // Clock source: System Clock
; 0000 019A // Clock value: Timer 0 Stopped
; 0000 019B 	TCCR0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 019C 	TCNT0 = 0x00;
	OUT  0x32,R30
; 0000 019D 
; 0000 019E 	// Timer/Counter 1 initialization
; 0000 019F 	// Clock source: System Clock
; 0000 01A0 	// Clock value: 7,813 kHz
; 0000 01A1 	// Mode: Normal top=0xFFFF
; 0000 01A2 	// OC1A output: Discon.
; 0000 01A3 	// OC1B output: Discon.
; 0000 01A4 	// Noise Canceler: Off
; 0000 01A5 	// Input Capture on Falling Edge
; 0000 01A6 	// Timer1 Overflow Interrupt: On
; 0000 01A7 	// Input Capture Interrupt: Off
; 0000 01A8 	// Compare A Match Interrupt: Off
; 0000 01A9 	// Compare B Match Interrupt: Off
; 0000 01AA 	TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01AB 	TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 01AC 	TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01AD 	TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01AE 	ICR1H=0x00;
	OUT  0x27,R30
; 0000 01AF 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 01B0 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01B1 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01B2 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01B3 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01B4 
; 0000 01B5 
; 0000 01B6 // Timer/Counter 2 initialization
; 0000 01B7 // Clock source: System Clock
; 0000 01B8 // Clock value: 62,500 kHz
; 0000 01B9 // Mode: Normal top=0xFF
; 0000 01BA // OC2 output: Disconnected
; 0000 01BB ASSR = 0x00;
	OUT  0x22,R30
; 0000 01BC TCCR2 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 01BD TCNT2 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01BE OCR2 = 0x00;
	OUT  0x23,R30
; 0000 01BF 
; 0000 01C0 // External Interrupt(s) initialization
; 0000 01C1 // INT0: Off
; 0000 01C2 // INT1: Off
; 0000 01C3 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01C4 
; 0000 01C5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01C6 TIMSK = 0x44;
	LDI  R30,LOW(68)
	OUT  0x39,R30
; 0000 01C7 
; 0000 01C8 
; 0000 01C9 // USART initialization
; 0000 01CA // USART disabled
; 0000 01CB UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 01CC 
; 0000 01CD // Analog Comparator initialization
; 0000 01CE // Analog Comparator: Off
; 0000 01CF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01D0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01D1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01D2 
; 0000 01D3 // ADC initialization
; 0000 01D4 // ADC disabled
; 0000 01D5 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01D6 
; 0000 01D7 // SPI initialization
; 0000 01D8 // SPI disabled
; 0000 01D9 SPCR=0x00;
	OUT  0xD,R30
; 0000 01DA 
; 0000 01DB // TWI initialization
; 0000 01DC // TWI disabled
; 0000 01DD TWBR = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x0,R30
; 0000 01DE TWAR = 0xD0;
	LDI  R30,LOW(208)
	OUT  0x2,R30
; 0000 01DF TWCR = 0x44;
	LDI  R30,LOW(68)
	OUT  0x36,R30
; 0000 01E0 
; 0000 01E1 // Global enable interrupts
; 0000 01E2 #asm("sei")
	sei
; 0000 01E3 //digit_out[0] = 7;
; 0000 01E4 //digit_out[1] = 8;
; 0000 01E5 //digit_out[2] = 9;
; 0000 01E6 //digit_out[3] = 6;
; 0000 01E7 //PORTD.0=1;
; 0000 01E8 //PORTD.1=0;
; 0000 01E9 //PORTD.2=0;
; 0000 01EA //PORTD.3=1;
; 0000 01EB //PORTD.4=1;
; 0000 01EC //PORTD.5=1;
; 0000 01ED //PORTD.6=1;
; 0000 01EE //PORTD.7=1;
; 0000 01EF 
; 0000 01F0 ds3231_init();
	RCALL _ds3231_init
; 0000 01F1 	rtc_get_time(&seconds, &minutes, &hours, &day, &date, &month, &year);
	RCALL SUBOPT_0x20
; 0000 01F2 
; 0000 01F3 
; 0000 01F4 	tmp_counter = 0;
	LDI  R16,LOW(0)
; 0000 01F5 		while (1) {
_0x93:
; 0000 01F6 			rtc_get_time(&seconds, &minutes, &hours, &day, &date, &month, &year);
	RCALL SUBOPT_0x20
; 0000 01F7 			tmp_counter++;
	SUBI R16,-1
; 0000 01F8 			if(tmp_counter == 5) {
	CPI  R16,5
	BRNE _0x96
; 0000 01F9 				show_point = ~show_point;
	LDI  R30,LOW(2)
	EOR  R3,R30
; 0000 01FA 				tmp_counter = 0;
	LDI  R16,LOW(0)
; 0000 01FB 			}
; 0000 01FC 
; 0000 01FD 			displayInfo();
_0x96:
	RCALL _displayInfo
; 0000 01FE 			delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01FF 		}
	RJMP _0x93
; 0000 0200 
; 0000 0201 }
_0x97:
	RJMP _0x97

	.DSEG
_digit_out:
	.BYTE 0x4
_mode:
	.BYTE 0x1
_prevLastDigit:
	.BYTE 0x1
_lastDigit:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x1:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL _twi_start
	LDI  R26,LOW(208)
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(1)
	RCALL _twi_read
	MOV  R26,R30
	RJMP _bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	ST   X,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	RCALL _decToBcd
	MOV  R26,R30
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDS  R30,_mode
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x0
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	MOV  R12,R30
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	MOV  R13,R30
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	MOV  R11,R30
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	MOV  R10,R30
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	MOV  R8,R30
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	MOV  R9,R30
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	CLR  R6
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R13
	MOV  R26,R12
	RJMP _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	BLD  R2,0
	CLT
	BLD  R2,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	BLD  R2,1
	CLT
	BLD  R2,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	BLD  R2,2
	CLT
	BLD  R2,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	STS  _digit_out,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__PUTB1MN _digit_out,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	__PUTB1MN _digit_out,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(8)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	RJMP _rtc_get_time


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
