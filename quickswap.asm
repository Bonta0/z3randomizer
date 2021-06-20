; Thanks to Kazuto for developing the original QS code that inspired this one

QuickSwap:
	; We perform all other checks only if we are pushing L or R in order to have minimal
	; perf impact, since this runs every frame

	LDA.b $F6 : BIT #$30 : BEQ .done

	LDA.l QuickSwapFlag : BEQ .done
	LDA.w $0202 : BEQ .done ; Skip everything if we don't have any items

	PHX
    LDA.b $F2
	CMP.b #$30 : BNE +
		; If holding both L and R, then go directly to the special swap code
		LDX.w $0202 : BRA .special_swap
	+
	BIT #$10 : BEQ + ; Only pressed R
		LDX.w $0202
		-
			CPX.b #$14 : BNE ++ : LDX.b #$00 ;will wrap around to 1
			++ INX
		JSL.l IsItemAvailable : BEQ -
		BRA .store
	+
	; Only pressed L
	LDX.w $0202
	-
		CPX.b #$01 : BNE ++ : LDX.b #$15 ; will wrap around to $14
		++ DEX
	JSL.l IsItemAvailable : BEQ -
	BRA .store

	.special_swap
	CPX.b #$02 : BEQ + ; boomerang
	CPX.b #$01 : BEQ + ; bow
	CPX.b #$05 : BEQ + ; powder
	CPX.b #$0D : BEQ + ; flute
	CPX.b #$10 : BEQ + ; bottle
	BRA .store
	+ STX $0202 : JSL ProcessMenuButtons_y_pressed

	.store
	LDA.b #$20 : STA.w $012F
	STX $0202

	JSL HUD_RefreshIconLong
	PLX

	.done
	LDA.b $F6 : AND.b #$40 ;what we wrote over
RTL
