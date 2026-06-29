;================================================================
; ПП опроса кнопок
;================================================================

ButOpros:

	cbr		flags,(1<<ButOpros_flag)
	sbis	BUT_PIN,BUT_UP
	rjmp	UpPressed
	sbis	BUT_PIN,BUT_DWN
	rjmp	DwnPressed
	sbis	BUT_PIN,BUT_ENTER
	rjmp	EnterPressed


	sbrs	buttons,long_autorepeat
	rjmp	clr_buttons_regs_tmrs
	sbrc	buttons,but_up_pr
	rcall	UpPressedOnceAction
	sbrc	buttons,but_dwn_pr
	rcall	DwnPressedOnceAction
	sbrc	buttons,but_enter_pr
	rcall	EnterPressedOnceAction
	
clr_buttons_regs_tmrs:
	clr		buttons
	sts		Autorepeat_timer+1,buttons
	sts		Autorepeat_timer,buttons
	ret

UpPressed:
	rcall	lcd_backlight_on

	sbrs	buttons,but_up_pr
	rjmp	UpPressed1StTime

	sbrs	buttons,end_autorepeat
	ret

	cbr		buttons,(1<<end_autorepeat)
	ldi		Zh,high(short_autorepeat_time)
	ldi		Zl,low(short_autorepeat_time)
	rcall	StartAutoRepeat
	sbrc	buttons,long_autorepeat
	rjmp	UpPressedLongAutorepAction
	rjmp	UpPressedShortAutorepAction

UpPressed1StTime:	
	sbr		buttons,(1<<but_up_pr|1<<long_autorepeat)
	ldi		Zh,high(long_autorepeat_time)
	ldi		Zl,low(long_autorepeat_time)
	rcall	StartAutoRepeat

	ret

UpPressedOnceAction:														// Здесь действие на кратковременное нажатие

	sbrs	mode,selection_mode
	rjmp	pc+3
	
	rcall	switch_mode_up
	ret

	sbrc	mode,edit_mode
	rcall	edit_mode_up

	ret



UpPressedLongAutorepAction:
	cbr		buttons,(1<<long_autorepeat)									// Здесь действие на первое долгое нажатие - первый автоповтор
	
	sbrs	mode,selection_mode
	rjmp	pc+3
	
	rcall	switch_mode_up
	ret

	sbrc	mode,edit_mode
	rcall	edit_mode_up

	ret

UpPressedShortAutorepAction:
	
	sbrs	mode,selection_mode
	rjmp	pc+3
	
	rcall	switch_mode_up
	ret

	sbrc	mode,edit_mode
	rcall	edit_mode_up

	ret

DwnPressed:
	rcall	lcd_backlight_on

	sbrs	buttons,but_dwn_pr
	rjmp	DwnPressed1StTime

	sbrs	buttons,end_autorepeat
	ret

	cbr		buttons,(1<<end_autorepeat)
	ldi		Zh,high(short_autorepeat_time)
	ldi		Zl,low(short_autorepeat_time)
	rcall	StartAutoRepeat
	sbrc	buttons,long_autorepeat
	rjmp	DwnPressedLongAutorepAction
	rjmp	DwnPressedShortAutorepAction

DwnPressed1StTime:	
	sbr		buttons,(1<<but_dwn_pr|1<<long_autorepeat)
	ldi		Zh,high(long_autorepeat_time)
	ldi		Zl,low(long_autorepeat_time)
	rcall	StartAutoRepeat

	ret

DwnPressedOnceAction:														// Здесь действие на кратковременное нажатие
	
	sbrs	mode,selection_mode
	rjmp	pc+3
	
	rcall	switch_mode_dwn
	ret

	sbrc	mode,edit_mode
	rcall	edit_mode_dwn

	ret



DwnPressedLongAutorepAction:
	cbr		buttons,(1<<long_autorepeat)									// Здесь действие на первое долгое нажатие - первый автоповтор
	
	sbrs	mode,selection_mode
	rjmp	pc+3
	
	rcall	switch_mode_dwn
	ret

	sbrc	mode,edit_mode
	rcall	edit_mode_dwn

	ret

DwnPressedShortAutorepAction:
	
	sbrs	mode,selection_mode
	rjmp	pc+3
	
	rcall	switch_mode_dwn
	ret

	sbrc	mode,edit_mode
	rcall	edit_mode_dwn

	ret

EnterPressed:
	rcall	lcd_backlight_on

	sbrs	buttons,but_enter_pr
	rjmp	EnterPressed1StTime

	sbrs	buttons,end_autorepeat
	ret

	cbr		buttons,(1<<end_autorepeat)
	ldi		Zh,high(short_autorepeat_time)
	ldi		Zl,low(short_autorepeat_time)
	rcall	StartAutoRepeat
	sbrc	buttons,long_autorepeat
	rjmp	EnterPressedLongAutorepAction
	rjmp	EnterPressedShortAutorepAction

EnterPressed1StTime:	
	sbr		buttons,(1<<but_enter_pr|1<<long_autorepeat)
	ldi		Zh,high(long_autorepeat_time)
	ldi		Zl,low(long_autorepeat_time)
	rcall	StartAutoRepeat

	ret

EnterPressedOnceAction:														// Здесь действие на кратковременное нажатие

	sbrc	mode,selection_mode
	rjmp	goto_modes

	sbrc	mode,read_mode
	rcall	set_read_mode

	sbrc	mode,write_mode
	rcall	set_write_mode

	sbrc	mode,edit_mode
	rcall	edit_mode_enter

	ret

goto_modes:
	
	cbr		mode,(1<<selection_mode)

	ret



EnterPressedLongAutorepAction:
	cbr		buttons,(1<<long_autorepeat)									// Здесь действие на первое долгое нажатие - первый автоповтор
	
	sbrc	mode,selection_mode
	ret	
	
	sbrc	mode,edit_mode
	rcall	set_edit_mode

	ret

EnterPressedShortAutorepAction:
	
	nop

	ret

StartAutoRepeat:
	sts		Autorepeat_timer+1,Zh
	sts		Autorepeat_timer,Zl
	ret


