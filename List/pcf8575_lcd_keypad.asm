
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 20,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _baris_lcd=R4
	.DEF _display_control=R3
	.DEF _display_mode=R6

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2A:
	.DB  0x2
_0x0:
	.DB  0x42,0x59,0x20,0x3A,0x0,0x41,0x49,0x2D
	.DB  0x45,0x4C,0x45,0x4B,0x54,0x52,0x4F,0x4E
	.DB  0x49,0x4B,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x19
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x19+5
	.DW  _0x0*2+5

	.DW  0x01
	.DW  0x04
	.DW  _0x2A*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#include <twi2.h>

	.CSEG
_twiinit:
	LDI  R30,LOW(0)
	STS  185,R30
	LDI  R30,LOW(12)
	STS  184,R30
	LDI  R30,LOW(4)
	RJMP _0x20A0005
_twistart:
	LDI  R30,LOW(164)
	STS  188,R30
_0x3:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x3
	RET
_twistop:
	LDI  R30,LOW(148)
_0x20A0005:
	STS  188,R30
	RET
_twiwrite:
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	STS  187,R30
	LDI  R30,LOW(132)
	STS  188,R30
_0x6:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x6
	RJMP _0x20A0004
_twiread:
	ST   -Y,R26
;	ack -> Y+0
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC
	LDI  R30,LOW(196)
	STS  188,R30
_0xD:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0xD
	LDS  R30,187
	RJMP _0x20A0004
_0xC:
	SBIW R30,0
	BRNE _0xB
	LDI  R30,LOW(132)
	STS  188,R30
_0x11:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x11
	LDS  R30,187
	RJMP _0x20A0004
_0xB:
	RJMP _0x20A0004
;#include <i2c_lcd.c>
;#define lcdw 0b01001110
;#define lcdr 0b01001111
;
;#define en   0b00000100
;#define rw   0b00000010
;#define rs   0b00000001
;#define backon 0x08
;#define backoff 0x00
;
;//unsigned char kolom_lcd=16;
;unsigned char baris_lcd=2;
;//unsigned char charsize=0;
;unsigned char display_control;
;unsigned char display_mode;
;
;void expander_write(unsigned char data){
; 0000 0006 void expander_write(unsigned char data){
_expander_write:
;twistart();
	ST   -Y,R26
;	data -> Y+0
	RCALL _twistart
;twiwrite(lcdw);
	LDI  R26,LOW(78)
	RCALL _twiwrite
;twiwrite(data | backon);
	LD   R30,Y
	ORI  R30,8
	MOV  R26,R30
	RCALL _twiwrite
;twiwrite(0xff);
	LDI  R26,LOW(255)
	RCALL _twiwrite
;twistop();
	RCALL _twistop
;}
	RJMP _0x20A0004
;
;void pulse_enable(unsigned char data){
_pulse_enable:
;expander_write(data | en);
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ORI  R30,4
	MOV  R26,R30
	RCALL _expander_write
;delay_us(1);
	__DELAY_USB 7
;expander_write(data & ~en);
	LD   R30,Y
	ANDI R30,0xFB
	MOV  R26,R30
	RCALL _expander_write
;delay_us(50);
	__DELAY_USW 250
;}
	RJMP _0x20A0004
;
;void write4bits(unsigned char data){
_write4bits:
;expander_write(data);
	ST   -Y,R26
;	data -> Y+0
	LD   R26,Y
	RCALL _expander_write
;pulse_enable(data);
	LD   R26,Y
	RCALL _pulse_enable
;}
	RJMP _0x20A0004
;
;void send(unsigned char data,unsigned char mode){
_send:
;unsigned char high=data&0xf0;
;unsigned char low=(data<<4)&0xf0;
;write4bits((high)|mode);
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+3
;	mode -> Y+2
;	high -> R17
;	low -> R16
	LDD  R30,Y+3
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	LDD  R30,Y+3
	SWAP R30
	ANDI R30,LOW(0xF0)
	MOV  R16,R30
	LDD  R26,Y+2
	OR   R26,R17
	RCALL _write4bits
;write4bits((low)|mode);
	LDD  R26,Y+2
	OR   R26,R16
	RCALL _write4bits
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;void command(unsigned char data){
_command:
;send(data,0);
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x20A0003
;}
;
;void write(char data){
_write:
;send(data,rs);
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x20A0003:
	RCALL _send
;}
_0x20A0004:
	ADIW R28,1
	RET
;
;void clear(){
_clear:
;command(0x01); //lcd clear display command
	LDI  R26,LOW(1)
	RJMP _0x20A0002
;delay_ms(2);
;}
;
;void display(){
_display:
;    display_control|=0x04;//lcd display on
	LDI  R30,LOW(4)
	OR   R3,R30
;    command(0x08 | display_control); //0x08=lcd display control
	MOV  R30,R3
	ORI  R30,8
	MOV  R26,R30
	RCALL _command
;}
	RET
;
;void home(){
_home:
;    command(0x02); // lcd kembali ke posisi 0,0
	LDI  R26,LOW(2)
_0x20A0002:
	RCALL _command
;    delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
;}
	RET
;
;void gotoxy(unsigned char x,unsigned char y){
_gotoxy:
;    int row_offsets[]={0x00,0x40,0x14,0x54};
;    if(y>baris_lcd)y=baris_lcd-1;
	ST   -Y,R26
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(64)
	STD  Y+2,R30
	LDI  R30,LOW(0)
	STD  Y+3,R30
	LDI  R30,LOW(20)
	STD  Y+4,R30
	LDI  R30,LOW(0)
	STD  Y+5,R30
	LDI  R30,LOW(84)
	STD  Y+6,R30
	LDI  R30,LOW(0)
	STD  Y+7,R30
;	x -> Y+9
;	y -> Y+8
;	row_offsets -> Y+0
	LDD  R26,Y+8
	CP   R4,R26
	BRSH _0x14
	MOV  R30,R4
	SUBI R30,LOW(1)
	STD  Y+8,R30
;    command(0x80|(x+row_offsets[y])); //0x80 = alamat ddram lcd
_0x14:
	LDD  R30,Y+8
	LDI  R31,0
	MOVW R26,R28
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDD  R26,Y+9
	ADD  R30,R26
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _command
;}
	ADIW R28,10
	RET
;
;void lcd_begin(){
_lcd_begin:
;//4 bit mode ,  lcd 1 line , lcd 5x8 per karakter
;unsigned char displayfunction = 0x00 | 0x00 | 0x00;
;if(baris_lcd>1)displayfunction |= 0x08; //2 line lcd
	ST   -Y,R17
;	displayfunction -> R17
	LDI  R17,0
	LDI  R30,LOW(1)
	CP   R30,R4
	BRSH _0x15
	ORI  R17,LOW(8)
;
;delay_ms(50);
_0x15:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
;
;expander_write(backon);
	LDI  R26,LOW(8)
	RCALL _expander_write
;delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
;
;write4bits(0x03<<4);
	LDI  R26,LOW(48)
	RCALL _write4bits
;delay_us(4500);
	__DELAY_USW 22500
;write4bits(0x03<<4);
	LDI  R26,LOW(48)
	RCALL _write4bits
;delay_us(4500);
	__DELAY_USW 22500
;write4bits(0x03<<4);
	LDI  R26,LOW(48)
	RCALL _write4bits
;delay_us(150);
	__DELAY_USW 750
;write4bits(0x02 << 4);
	LDI  R26,LOW(32)
	RCALL _write4bits
;command(0x20|displayfunction); //0x20 lcd function set
	MOV  R30,R17
	ORI  R30,0x20
	MOV  R26,R30
	RCALL _command
;
;// lcd display on, lcd cursor off, lcd blink off
;display_control= 0x04 | 0x00 | 0x00;
	LDI  R30,LOW(4)
	MOV  R3,R30
;display();
	RCALL _display
;
;clear();
	RCALL _clear
;
;//lcd entryleft , lcd entry decrement
;display_mode=0x02|0x00;
	LDI  R30,LOW(2)
	MOV  R6,R30
;command(0x04|display_mode); //0x04 = lcd entry modeset
	MOV  R30,R6
	ORI  R30,4
	MOV  R26,R30
	RCALL _command
;
;home();
	RCALL _home
;}
	RJMP _0x20A0001
;
;void put(char *teks){
_put:
;char k;
;while (k=*teks++)write(k);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*teks -> Y+1
;	k -> R17
_0x16:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x18
	MOV  R26,R17
	RCALL _write
	RJMP _0x16
_0x18:
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;
;unsigned char baca_keypad();
;
;void main(void){
; 0000 000A void main(void){
_main:
; 0000 000B unsigned char buf[16];
; 0000 000C #pragma optsize-
; 0000 000D CLKPR=0x80;
	SBIW R28,16
;	buf -> Y+0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 000E CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 000F #ifdef _OPTIMIZE_SIZE_
; 0000 0010 #pragma optsize+
; 0000 0011 #endif
; 0000 0012 
; 0000 0013 twiinit();
	RCALL _twiinit
; 0000 0014 lcd_begin();
	RCALL _lcd_begin
; 0000 0015 gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _gotoxy
; 0000 0016 put("BY :");
	__POINTW2MN _0x19,0
	RCALL _put
; 0000 0017 gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _gotoxy
; 0000 0018 put("AI-ELEKTRONIK");
	__POINTW2MN _0x19,5
	RCALL _put
; 0000 0019 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 001A clear();
	RCALL _clear
; 0000 001B while (1){
_0x1A:
; 0000 001C 
; 0000 001D buf[0]=baca_keypad();buf[1]='\0';
	RCALL _baca_keypad
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
; 0000 001E gotoxy(0,0);put(buf);
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _gotoxy
	MOVW R26,R28
	RCALL _put
; 0000 001F }
	RJMP _0x1A
; 0000 0020 }
_0x1D:
	RJMP _0x1D

	.DSEG
_0x19:
	.BYTE 0x13
;
;unsigned char baca_keypad(){
; 0000 0022 unsigned char baca_keypad(){

	.CSEG
_baca_keypad:
; 0000 0023 unsigned char key;
; 0000 0024 twistart();
	ST   -Y,R17
;	key -> R17
	RCALL _twistart
; 0000 0025 twiwrite(0b01001110);
	LDI  R26,LOW(78)
	RCALL _twiwrite
; 0000 0026 twiwrite(0x00);
	LDI  R26,LOW(0)
	RCALL _twiwrite
; 0000 0027 twiwrite(0xf6);
	LDI  R26,LOW(246)
	RCALL _twiwrite
; 0000 0028 twistop();
	RCALL _twistop
; 0000 0029 
; 0000 002A twistart();
	RCALL _twistart
; 0000 002B twiwrite(0b01001111);
	LDI  R26,LOW(79)
	RCALL _twiwrite
; 0000 002C twiread(1);
	LDI  R26,LOW(1)
	RCALL _twiread
; 0000 002D key=twiread(0);
	LDI  R26,LOW(0)
	RCALL _twiread
	MOV  R17,R30
; 0000 002E twistop();
	RCALL _twistop
; 0000 002F 
; 0000 0030 if( ((key>>4)&1)==0)return '1';
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x1E
	LDI  R30,LOW(49)
	RJMP _0x20A0001
; 0000 0031 if( ((key>>5)&1)==0)return '4';
_0x1E:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(5)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x1F
	LDI  R30,LOW(52)
	RJMP _0x20A0001
; 0000 0032 if( ((key>>6)&1)==0)return '7';
_0x1F:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(6)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x20
	LDI  R30,LOW(55)
	RJMP _0x20A0001
; 0000 0033 if( ((key>>7)&1)==0)return '*';
_0x20:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(7)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x21
	LDI  R30,LOW(42)
	RJMP _0x20A0001
; 0000 0034 
; 0000 0035 twistart();
_0x21:
	RCALL _twistart
; 0000 0036 twiwrite(0b01001110);
	LDI  R26,LOW(78)
	RCALL _twiwrite
; 0000 0037 twiwrite(0x00);
	LDI  R26,LOW(0)
	RCALL _twiwrite
; 0000 0038 twiwrite(0xf5);
	LDI  R26,LOW(245)
	RCALL _twiwrite
; 0000 0039 twistop();
	RCALL _twistop
; 0000 003A 
; 0000 003B twistart();
	RCALL _twistart
; 0000 003C twiwrite(0b01001111);
	LDI  R26,LOW(79)
	RCALL _twiwrite
; 0000 003D twiread(1);
	LDI  R26,LOW(1)
	RCALL _twiread
; 0000 003E key=twiread(0);
	LDI  R26,LOW(0)
	RCALL _twiread
	MOV  R17,R30
; 0000 003F twistop();
	RCALL _twistop
; 0000 0040 
; 0000 0041 if( ((key>>4)&1)==0)return '2';
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x22
	LDI  R30,LOW(50)
	RJMP _0x20A0001
; 0000 0042 if( ((key>>5)&1)==0)return '5';
_0x22:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(5)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x23
	LDI  R30,LOW(53)
	RJMP _0x20A0001
; 0000 0043 if( ((key>>6)&1)==0)return '8';
_0x23:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(6)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x24
	LDI  R30,LOW(56)
	RJMP _0x20A0001
; 0000 0044 if( ((key>>7)&1)==0)return '0';
_0x24:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(7)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x25
	LDI  R30,LOW(48)
	RJMP _0x20A0001
; 0000 0045 
; 0000 0046 twistart();
_0x25:
	RCALL _twistart
; 0000 0047 twiwrite(0b01001110);
	LDI  R26,LOW(78)
	RCALL _twiwrite
; 0000 0048 twiwrite(0x00);
	LDI  R26,LOW(0)
	RCALL _twiwrite
; 0000 0049 twiwrite(0xf3);
	LDI  R26,LOW(243)
	RCALL _twiwrite
; 0000 004A twistop();
	RCALL _twistop
; 0000 004B 
; 0000 004C twistart();
	RCALL _twistart
; 0000 004D twiwrite(0b01001111);
	LDI  R26,LOW(79)
	RCALL _twiwrite
; 0000 004E twiread(1);
	LDI  R26,LOW(1)
	RCALL _twiread
; 0000 004F key=twiread(0);
	LDI  R26,LOW(0)
	RCALL _twiread
	MOV  R17,R30
; 0000 0050 twistop();
	RCALL _twistop
; 0000 0051 
; 0000 0052 if( ((key>>4)&1)==0)return '3';
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	ANDI R30,LOW(0x1)
	BRNE _0x26
	LDI  R30,LOW(51)
	RJMP _0x20A0001
; 0000 0053 if( ((key>>5)&1)==0)return '6';
_0x26:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(5)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x27
	LDI  R30,LOW(54)
	RJMP _0x20A0001
; 0000 0054 if( ((key>>6)&1)==0)return '9';
_0x27:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(6)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x28
	LDI  R30,LOW(57)
	RJMP _0x20A0001
; 0000 0055 if( ((key>>7)&1)==0)return '#';
_0x28:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(7)
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	BRNE _0x29
	LDI  R30,LOW(35)
	RJMP _0x20A0001
; 0000 0056 
; 0000 0057 return 'x';
_0x29:
	LDI  R30,LOW(120)
_0x20A0001:
	LD   R17,Y+
	RET
; 0000 0058 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G101:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1388
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
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

;END OF CODE MARKER
__END_OF_CODE:
