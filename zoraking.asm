;================================================================================
; Randomize Zora King
;--------------------------------------------------------------------------------
LoadZoraKingItemGFX:
	LDA.l ZoraItem_Player : STA !MULTIWORLD_SPRITEITEM_PLAYER_ID
    LDA.l $1DE1C3 ; location randomizer writes zora item to
	JSL.l PrepDynamicTile
RTL
;--------------------------------------------------------------------------------
JumpToSplashItemTarget:
	LDA $0D90, X
	CMP.b #$FF : BNE + : JML.l SplashItem_SpawnSplash : +
	CMP.b #$00 : JML.l SplashItem_SpawnOther
;--------------------------------------------------------------------------------