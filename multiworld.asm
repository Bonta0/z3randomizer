HUD_clearTable:
dw $007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F,$007F

WriteText:
{
	PHP
	LDX #$80 : STX $2100
	REP #$20
	LDA #$6000+$0340 : STA $2116

	LDA.w #!MULTIWORLD_HUD_CHARACTER_DATA : STA $4342
	LDX.b #!MULTIWORLD_HUD_CHARACTER_DATA>>16 : STX $4344
		
	LDA #$0080 : STA $4345
	LDA #$1801 : STA $4340
	LDX #$10 : STX $420B

	LDX #$0F : STX $2100
	PLP
RTL
}

ClearBG:
{
	PHP
	LDX #$80 : STX $2100
	REP #$20
	LDA #$6000+$0340 : STA $2116
		
	LDA.w #HUD_clearTable : STA $4342
	LDX.b #HUD_clearTable>>16 : STX $4344

	LDA #$0080 : STA $4345
	LDA #$1801 : STA $4340
	LDX #$10 : STX $420B

	LDX #$0F : STX $2100
	PLP
RTL
}

GetMultiworldItem:
{
	PHP
	LDA !MULTIWORLD_ITEM : CMP #$00 : BNE +
	LDA !MULTIWORLD_HUD_TIMER : CMP #$00 : BNE +
		BRL .return
	+

	LDA $10
	CMP #$07 : BEQ +
	CMP #$09 : BEQ +
	CMP #$0B : BEQ +
		BRL .return
	+

	LDA !MULTIWORLD_HUD_TIMER
	CMP #$00 : BEQ .textend
		CMP !MULTIWORLD_HUD_DELAY : BNE +
			JSL WriteText
			LDA !MULTIWORLD_HUD_TIMER
		+
		DEC #$01 : STA !MULTIWORLD_HUD_TIMER
		CMP #$00 : BNE .textend
			JSL ClearBG
	.textend

	LDA $5D
	CMP #$00 : BEQ +
	CMP #$04 : BEQ +
	CMP #$17 : BEQ +
	CMP #$1C : BEQ +
		BRL .return
	+

	LDA !MULTIWORLD_ITEM : CMP #$00 : BNE +
		BRL .return
	+

	PHA
	LDA #$22
	LDY #$04
	JSL Ancilla_CheckForAvailableSlot : BPL +
		PLA
		BRL .return
	+
	PLA

	; Check if we have a key for the dungeon we are currently in
	LDX $040C
	; Escape
	CMP #$A0 : BNE + : CPX #$00 : BEQ ++ : CPX #$02 : BEQ ++ : BRL .keyend : ++ : BRL .thisdungeon : +
	; Eastern
	CMP #$A2 : BNE + : CPX #$04 : BEQ .thisdungeon : BRA .keyend : +
	; Desert
	CMP #$A3 : BNE + : CPX #$06 : BEQ .thisdungeon : BRA .keyend : +
	; Hera
	CMP #$AA : BNE + : CPX #$14 : BEQ .thisdungeon : BRA .keyend : +
	; Aga
	CMP #$A4 : BNE + : CPX #$08 : BEQ .thisdungeon : BRA .keyend : +
	; PoD
	CMP #$A6 : BNE + : CPX #$0C : BEQ .thisdungeon : BRA .keyend : +
	; Swamp
	CMP #$A5 : BNE + : CPX #$0A : BEQ .thisdungeon : BRA .keyend : +
	; SW
	CMP #$A8 : BNE + : CPX #$10 : BEQ .thisdungeon : BRA .keyend : +
	; TT
	CMP #$AB : BNE + : CPX #$16 : BEQ .thisdungeon : BRA .keyend : +
	; Ice
	CMP #$A9 : BNE + : CPX #$12 : BEQ .thisdungeon : BRA .keyend : +
	; Mire
	CMP #$A7 : BNE + : CPX #$0E : BEQ .thisdungeon : BRA .keyend : +
	; TR
	CMP #$AC : BNE + : CPX #$18 : BEQ .thisdungeon : BRA .keyend : +
	; GT
	CMP #$AD : BNE + : CPX #$1A : BEQ .thisdungeon : BRA .keyend : +
	; GT BK
	CMP #$92 : BNE .keyend : CPX #$1A : BNE .keyend : LDA #$32 : BRA .keyend
	.thisdungeon
	LDA #$24
	.keyend

	STA $02D8 ;Set Item to receive
	TAY

	LDA #$01 : STA !MULTIWORLD_RECEIVING_ITEM
	LDA #$00 : STA !MULTIWORLD_ITEM_PLAYER_ID

	STZ $02E9
	JSL.l $0791B3 ; Player_HaltDashAttackLong
	JSL Link_ReceiveItem
	LDA #$00 : STA !MULTIWORLD_ITEM : STA !MULTIWORLD_RECEIVING_ITEM

	.return
	PLP
	LDA $5D : ASL A : TAX
RTL
}

Multiworld_OpenKeyedObject:
{
	PHP
	SEP #$20
	LDA ChestData_Player+2, X : STA !MULTIWORLD_ITEM_PLAYER_ID
	PLP

	LDA !Dungeon_ChestData+2, X ; thing we wrote over
RTL
}

Multiworld_BottleVendor_GiveBottle:
{
	PHA : PHP
	SEP #$20
	LDA BottleMerchant_Player : STA !MULTIWORLD_ITEM_PLAYER_ID
	PLP : PLA

	JSL Link_ReceiveItem ; thing we wrote over
RTL
}

Multiworld_MiddleAgedMan_ReactToSecretKeepingResponse:
{
	PHA : PHP
	SEP #$20
	LDA PurpleChest_Item_Player : STA !MULTIWORLD_ITEM_PLAYER_ID
	PLP : PLA

	JSL Link_ReceiveItem ; thing we wrote over
RTL
}

Multiworld_Hobo_GrantBottle:
{
	PHA : PHP
	SEP #$20
	LDA HoboItem_Player : STA !MULTIWORLD_ITEM_PLAYER_ID
	PLP : PLA

	JSL Link_ReceiveItem ; thing we wrote over
RTL
}

Multiworld_MasterSword_GrantToPlayer:
{
	PHA : PHP
	SEP #$20
	LDA PedestalSword_Player : STA !MULTIWORLD_ITEM_PLAYER_ID
	PLP : PLA

	JSL Link_ReceiveItem ; thing we wrote over
RTL
}

Multiworld_AddReceivedItem_notCrystal:
{
	LDA !MULTIWORLD_ITEM_PLAYER_ID : CMP #$00 : BEQ +
		LDA #$33 : STA $012F
		TYA : STA $02E4 : PHX ; things we wrote over
		JML.l AddReceivedItem_gfxHandling
	+
	TYA : STA $02E4 : PHX ; things we wrote over
	JML.l AddReceivedItem_notCrystal+5
}

Multiworld_Ancilla_ReceiveItem_stillInMotion:
{
	CMP.b #$28 : BNE + ; thing we wrote over
	LDA !MULTIWORLD_ITEM_PLAYER_ID : CMP #$00 : BNE +
		JML.l Ancilla_ReceiveItem_stillInMotion_moveon
	+
	JML.l Ancilla_ReceiveItem_dontGiveRupees
}
