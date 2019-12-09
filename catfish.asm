;================================================================================
; Randomize Catfish
;--------------------------------------------------------------------------------
!HEART_REDRAW = "$7F5000"
LoadCatfishItemGFX:
    LDA.l $1DE185 ; location randomizer writes catfish item to
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
DrawThrownItem:
	LDA $8A : CMP.b #$81 : BNE .catfish
	
	.zora
	LDA.b #$01 : STA !HEART_REDRAW
    LDA.l $1DE1C3 ; location randomizer writes zora item to
	BRA .draw
	
	.catfish
    LDA.l $1DE185 ; location randomizer writes catfish item to
	
	.draw
	JSL.l DrawDynamicTile
RTL
;--------------------------------------------------------------------------------
MarkThrownItem:
	PHA

	LDA $8A : CMP.b #$81 : BNE .catfish

	.zora
    JSL.l ItemSet_ZoraKing
	LDA ZoraItem_Player : STA !MULTIWORLD_ITEM_PLAYER_ID
	BRA .done

	.catfish
    JSL.l ItemSet_Catfish
	LDA CatfishItem_Player : STA !MULTIWORLD_ITEM_PLAYER_ID

	.done
	PLA
	JSL Link_ReceiveItem ; thing we wrote over
RTL
;--------------------------------------------------------------------------------