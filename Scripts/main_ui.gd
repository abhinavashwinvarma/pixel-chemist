extends CanvasLayer

@onready var instr_popup: NinePatchRect = $InstructionsPopUp
@onready var left_arrow: TextureButton = $InstructionsPopUp/LeftArrow
@onready var right_arrow: TextureButton = $InstructionsPopUp/RightArrow
@onready var exit_pop_up: TextureButton = $InstructionsPopUp/ExitPopUp
@onready var instr_text: Label = $InstructionsPopUp/InstructionsText

@onready var upgrades_popup: NinePatchRect = $UpgradesPopUp
@onready var upgrades_openbutton: TextureButton = $UpgradesPopUp/UpgradesOpenTab
var upgrades_open: bool = false

@onready var home_button: TextureButton = $TopMenu/Home
@onready var instr_button: TextureButton = $TopMenu/Instructions
@onready var money_label: Label = $TopMenu/Money/MoneyLabel

@onready var page_num: Label = $InstructionsPopUp/PageNum
var instr_page: int = 1
var instr_open: bool = true
var prompts = ["Hello, Brackeys!", 
"You run the town's best chemistry lab! 

It's your job to analyze different salts and determine their chemical composition!

To start, grab a sample from the salt table. 
The color of the salt MAY give you a hint about what it is.

Use the extractor to prepare salt extracts. 
You need extracts to perform tests on!

The burner is every chemist's best friend. 
You need this to heat things up!

Lastly, use the workbench to add reagents to solutions.", 
"Click on the different machines present in the lab to interact with and use them.

Click on the bookshelf to go through the guides for analyzing different elements. Simply follow the steps shown in the books!

You need to do TWO tests at the acid desk to figure out what your salt is.
After running your tests, you should be able to figure out the cation (positive part) and anion (negative part) that make up your salt.",
"Report your findings to Professor Eddy to finish your analysis! Running a test earns you money. You also get a nice reward if you analyze your salt correctly!

You can spend your hard-earned money on upgrades for your equipment. Upgrades speed up testing time!

Follow all the rules of the lab, and nothing can go wrong!

...right?"]

var game_popup_open: bool = false
@onready var salt_desk_popup: NinePatchRect = $SaltDeskPopUp
@onready var salt_desk_exit: TextureButton = $SaltDeskPopUp/SaltDeskExit
@onready var salt_desk_text_label: Label = $SaltDeskPopUp/SaltText
@onready var salt_color_sprite: AnimatedSprite2D = $SaltDeskPopUp/SaltColor

@onready var extractor_popup: NinePatchRect = $ExtractorPopUp
@onready var extractor_exit: TextureButton = $ExtractorPopUp/ExtractorExit
@onready var extractor_text_label: Label = $ExtractorPopUp/ExtractorText
@onready var extractor_progress_bar: TextureProgressBar = $ExtractorPopUp/ExtractorProgressBar
@onready var extractor_clicker: TextureButton = $ExtractorPopUp/Clicker
var extractor_upgrade_status = Manager.upgrade_status['ExtractUpgrade']

@onready var burner_popup: NinePatchRect = $BurnerPopUp
@onready var burner_exit: TextureButton = $BurnerPopUp/BurnerExit
@onready var burner_text_label: Label = $BurnerPopUp/BurnerText
@onready var burner_progress_bar: TextureProgressBar = $BurnerPopUp/BurnerProgressBar
@onready var burner_clicker: TextureButton = $BurnerPopUp/Clicker
@onready var burner_result_sprite: AnimatedSprite2D = $BurnerPopUp/BurnerResult
var burner_upgrade_status = Manager.upgrade_status['BurnerUpgrade']

@onready var guides_popup: NinePatchRect = $GuidesPopUp
@onready var guides_exit: TextureButton = $GuidesPopUp/GuidesExit
@onready var guides_text: Label = $GuidesPopUp/TextMiniTitle

@onready var report_desk_popup: NinePatchRect = $ReportDeskPopUp
@onready var report_desk_exit: TextureButton = $ReportDeskPopUp/ReportDeskExit
@onready var report_desk_text_label: Label = $ReportDeskPopUp/SaltText
@onready var report_desk_finish_button: TextureButton = $ReportDeskPopUp/FinishButton

@onready var acid_desk_popup: NinePatchRect = $AcidDeskPopUp
@onready var acid_desk_exit: TextureButton = $AcidDeskPopUp/AcidDeskExit
@onready var acid_desk_text: Label = $AcidDeskPopUp/AcidDeskText
@onready var acid_desk_clicker: TextureButton = $AcidDeskPopUp/Clicker
@onready var acid_desk_progress_bar: TextureProgressBar = $AcidDeskPopUp/AcidDeskProgressBar
@onready var reagents_row_1: HBoxContainer = $AcidDeskPopUp/ReagentsRow1
@onready var reagents_row_2: HBoxContainer = $AcidDeskPopUp/ReagentsRow2
var acid_desk_upgrade_status = Manager.upgrade_status['AcidUpgrade']

#reagents
@onready var nh4oh: TextureButton = $AcidDeskPopUp/ReagentsRow1/NH4OH
@onready var dmg: TextureButton = $AcidDeskPopUp/ReagentsRow1/DMG
@onready var nh4cns: TextureButton = $AcidDeskPopUp/ReagentsRow1/NH4CNS
@onready var nesslers_reagent: TextureButton = $"AcidDeskPopUp/ReagentsRow1/Nessler's Reagent"
@onready var ki: TextureButton = $AcidDeskPopUp/ReagentsRow2/KI
@onready var aluminon_reagent: TextureButton = $"AcidDeskPopUp/ReagentsRow2/Aluminon Reagent"
@onready var agno3: TextureButton = $AcidDeskPopUp/ReagentsRow2/AgNO3
@onready var bacl2: TextureButton = $AcidDeskPopUp/ReagentsRow2/BaCl2
@onready var feso4h2so4mix: TextureButton = $"AcidDeskPopUp/ReagentsRow2/FeSO4-H2SO4 Mix"
var can_select_reagents = false

@onready var disaster_popup: NinePatchRect = $DisasterPopUp
@onready var disaster_exit: TextureButton = $DisasterPopUp/DisasterExit
@onready var disaster_text_label: Label = $DisasterPopUp/DisasterText
@onready var disaster_sprite: AnimatedSprite2D = $DisasterPopUp/DisasterSprite

var current_salt: String = ''

func _ready() -> void:

	salt_desk_popup.hide()
	extractor_popup.hide()
	burner_popup.hide()
	guides_popup.hide()
	report_desk_popup.hide()
	acid_desk_popup.hide()
	disaster_popup.hide()
	
	acid_desk_clicker.hide()
	acid_desk_progress_bar.hide()
	
	if Manager.first_play:
		Manager.can_use_machines = false
		instr_popup.show() #show instructions on start
		Manager.first_play = false
		
	else:
		instr_popup.hide()
		instr_open = false
		
	money_label.text = '$' + str(Manager.money)
	instr_text.text = prompts[1]

func _process(_delta: float) -> void:
	money_label.text = '$' + str(Manager.money)
	page_num.text = str(instr_page) + '/3'
	instr_text.text = prompts[instr_page] #appropriate page 
	
	extractor_upgrade_status = Manager.upgrade_status['ExtractUpgrade']
	burner_upgrade_status = Manager.upgrade_status['BurnerUpgrade']
	acid_desk_upgrade_status = Manager.upgrade_status['AcidUpgrade']
	
	acid_desk_progress_bar.value = Manager.current_acid_desk_click_progress
	extractor_progress_bar.value = Manager.current_extractor_click_progress
	burner_progress_bar.value = Manager.current_burner_click_progress
	
	if Manager.current_disaster == 'labels':
		disaster_sprite.frame = 0
	elif Manager.current_disaster == 'labcoat':
		disaster_sprite.frame = 1
	elif Manager.current_disaster == 'extractor':
		disaster_sprite.frame = 2
	elif Manager.current_disaster == 'burner':
		disaster_sprite.frame = 3
	elif Manager.current_disaster == 'cookie':
		disaster_sprite.frame = 4
	else:
		disaster_sprite.frame = 5
		
	if acid_desk_progress_bar.value >= 200:
		acid_desk_text.text = Manager.check_reagent_test_result()
		acid_desk_clicker.disabled = true
		
	if extractor_progress_bar.value >= 200:
		Manager.extract_prepared = true
		extractor_text_label.text = 'You prepared the salt extract!'
		extractor_clicker.disabled = true
		
	if burner_progress_bar.value >= 200:
		Manager.burner_used = true
		burner_text_label.text = Manager.salt_heating_effect[Manager.current_salt]
		burner_clicker.disabled = true
		burner_clicker.hide()
		burner_progress_bar.hide()
		burner_result_sprite.show()
		if Manager.current_salt == 'copper sulphate':
			burner_result_sprite.frame = 0
		elif Manager.current_salt == 'nickel sulphate':
				burner_result_sprite.frame = 1
		elif Manager.current_salt == 'ferric chloride':
				burner_result_sprite.frame = 2
		elif Manager.current_salt == 'ammonium chloride':
				burner_result_sprite.frame = 3
		elif Manager.current_salt == 'aluminium nitrate':
				burner_result_sprite.frame = 4
		else:
				burner_result_sprite.frame = 5
	
	if not can_select_reagents:
		nh4oh.disabled = true
		dmg.disabled = true
		nh4cns.disabled = true
		nesslers_reagent.disabled = true
		ki.disabled = true
		aluminon_reagent.disabled = true
		agno3.disabled = true
		bacl2.disabled = true
		feso4h2so4mix.disabled = true
		
	else:
		nh4oh.disabled = false
		dmg.disabled = false
		nh4cns.disabled = false
		nesslers_reagent.disabled = false
		ki.disabled = false
		aluminon_reagent.disabled = false
		agno3.disabled = false
		bacl2.disabled = false
		feso4h2so4mix.disabled = false
		
	if game_popup_open:
		home_button.disabled = true
		instr_button.disabled = true
		upgrades_openbutton.disabled = true

	elif instr_open:
		home_button.disabled = true
		instr_button.disabled = true
		upgrades_openbutton.disabled = true
		
	elif upgrades_open:
		home_button.disabled = true
		instr_button.disabled = true
	
	else:
		home_button.disabled = false
		instr_button.disabled = false
		upgrades_openbutton.disabled = false
	
	if instr_page == 3: #disabling right/left scroll arrows
		right_arrow.hide()
		exit_pop_up.show()
	else:
		right_arrow.show()
		exit_pop_up.hide()
	
	if instr_page == 1:
		left_arrow.hide()
	else:
		left_arrow.show()
		
func _on_exit_pop_up_pressed() -> void:
	instr_popup.hide()
	instr_page = 1 #go back to first page
	instr_open = false
	Manager.can_use_machines = true

func _on_instructions_pressed() -> void:
	instr_popup.show()
	instr_open = true
	Manager.can_use_machines = false
	
func _on_left_arrow_pressed() -> void:
	instr_page -= 1 #go back a page
		
func _on_right_arrow_pressed() -> void:
	instr_page += 1 #go to next page

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/title_screen.tscn")
	
func _on_upgrades_tab_pressed() -> void:
	
	if not upgrades_open:
		upgrades_popup.z_index = 10
		
		var move_in = get_tree().create_tween()
		move_in.tween_property(upgrades_popup, 'position', Vector2(837, 0), 0.18) #smooth!
		Manager.can_use_machines = false
		upgrades_open = not upgrades_open
		
	else:
		
		var move_out = get_tree().create_tween()
		move_out.tween_property(upgrades_popup, 'position', Vector2(1152, 0), 0.18)
		upgrades_open = not upgrades_open
		upgrades_popup.z_index = 10
		Manager.can_use_machines = true

func _on_laboratory_salt_opened() -> void:
	salt_desk_popup.show()
	game_popup_open = true
	Manager.can_use_machines = false

	if current_salt == '':
		
		current_salt = Manager.get_random_salt()
		salt_desk_text_label.text = current_salt
		
		if current_salt == 'copper sulphate':
			salt_color_sprite.frame = 1
			salt_desk_text_label.text = 'Your salt is blue!\nIt might be a salt of copper!'

		elif current_salt == 'ferric chloride':
			salt_color_sprite.frame = 2
			salt_desk_text_label.text = 'Your salt is brown!\nIt might be a salt of iron!'
			Manager.current_salt_cation = 'Ferric'
			Manager.current_salt_anion = 'Chloride'

		elif current_salt == 'nickel sulphate':
			salt_color_sprite.frame = 3
			salt_desk_text_label.text = 'Your salt is green!\nIt might be a salt of nickel!'

		else:
			salt_color_sprite.frame = 0
			salt_desk_text_label.text = 'Your salt is white!\nIt might be a salt of ammonia, aluminium, or lead!'
			
		Manager.current_salt = current_salt

func _on_salt_desk_exit_pressed() -> void:
	salt_desk_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true
	
	if Manager.first_salt_done and Manager.current_disaster == '':
		get_random_disaster()

func _on_laboratory_extractor_opened() -> void:
	extractor_popup.show()
	game_popup_open = true
	Manager.can_use_machines = false
	
	if current_salt == '':
		extractor_text_label.text = 'Get a salt from the desk first!'
		extractor_clicker.disabled = true
		
	else:
		if not Manager.extract_prepared:
			extractor_text_label.text = 'Click until the extract is prepared!'
			extractor_clicker.disabled = false
		else:
			extractor_text_label.text = 'You prepared the salt extract!'
			extractor_clicker.disabled = true
		
func _on_extractor_exit_pressed() -> void:
	extractor_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true
	
	#if not Manager.extract_prepared:
		#Manager.current_click_progress = 0
	
func _on_extractor_clicker_pressed() -> void:
	
	if Manager.current_disaster == 'extractor':
		Manager.current_extractor_click_progress += 2 + (2*extractor_upgrade_status)
		Manager.current_extractor_click_progress -= randi_range(0, 2 + (3*extractor_upgrade_status))
		Manager.money += (2 + (3*extractor_upgrade_status))*(extractor_upgrade_status+1)/2
	else:
		Manager.current_extractor_click_progress += 2 + (2*extractor_upgrade_status)
		Manager.money += (2 + (3*extractor_upgrade_status))*(extractor_upgrade_status+1)/2
	
func _on_laboratory_burner_opened() -> void:
	burner_popup.show()
	burner_result_sprite.hide()
	game_popup_open = true
	Manager.can_use_machines = false
	
	if current_salt == '':
		burner_text_label.text = 'Get a salt from the desk first!'
		burner_clicker.disabled = true
		burner_clicker.show()
		burner_progress_bar.show()
		
	else:
		if not Manager.burner_used:
			burner_clicker.show()
			burner_progress_bar.show()
			burner_text_label.text = 'Click to show the salt in the flame!'
			burner_clicker.disabled = false
			
		else:
			burner_result_sprite.show()

			burner_text_label.text = Manager.salt_heating_effect[Manager.current_salt]
			burner_clicker.disabled = true

func _on_burner_exit_pressed() -> void:
	
	burner_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true
	
	#if not Manager.burner_used:
		#Manager.current_click_progress = 0

func _on_burner_clicker_pressed() -> void:
	if Manager.current_disaster == 'burner':
		Manager.current_burner_click_progress += 2 + (2*burner_upgrade_status)
		Manager.current_burner_click_progress -= randi_range(0, 2 + (3*burner_upgrade_status))
		Manager.money += (2 + (3*burner_upgrade_status)*(extractor_upgrade_status+1))/2
	else:
		Manager.current_burner_click_progress += 2 + (2*burner_upgrade_status)
		Manager.money += (2 + (3*burner_upgrade_status)*(extractor_upgrade_status+1))/2

func _on_laboratory_guides_opened() -> void:
	guides_popup.show()
	game_popup_open = true
	Manager.can_use_machines = false
	guides_text.text = 'Click on an ion to view its guide.'

func _on_guides_exit_pressed() -> void:
	
	guides_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true
	guides_text.text = 'Click on an ion to view its guide.'

#salt buttons in guides

func _on_ammonium_pressed() -> void:
	guides_text.text = Manager.salt_guides['Ammonium']

func _on_aluminium_pressed() -> void:
	guides_text.text = Manager.salt_guides['Aluminium']

func _on_copper_pressed() -> void:
	guides_text.text = Manager.salt_guides['Copper']

func _on_ferric_pressed() -> void:
	guides_text.text = Manager.salt_guides['Ferric']

func _on_lead_pressed() -> void:
	guides_text.text = Manager.salt_guides['Lead']

func _on_nickel_pressed() -> void:
	guides_text.text = Manager.salt_guides['Nickel']

func _on_chloride_pressed() -> void:
	guides_text.text = Manager.salt_guides['Chloride']

func _on_nitrate_pressed() -> void:
	guides_text.text = Manager.salt_guides['Nitrate']

func _on_sulphate_pressed() -> void:
	guides_text.text = Manager.salt_guides['Sulphate']

func _on_laboratory_report_opened() -> void:
	
	report_desk_popup.show()
	game_popup_open = true
	Manager.can_use_machines = false
	
	if Manager.current_salt == '':
		report_desk_text_label.text = 'Get a salt from the salt desk first!'
		report_desk_finish_button.hide()
		
	else:
		
		report_desk_finish_button.show()
		if Manager.confirmed_cation == '':
			report_desk_text_label.text = 'SALT CATION: ???\n\n'
		else:
			report_desk_text_label.text = 'SALT CATION: ' + Manager.confirmed_cation + '\n\n'

		if Manager.confirmed_anion == '':
			report_desk_text_label.text += 'SALT ANION: ???\n\n'
		else:
			report_desk_text_label.text += 'SALT ANION: ' + Manager.confirmed_anion + '\n\n'

		if (Manager.confirmed_cation != '') and (Manager.confirmed_anion != ''):
			report_desk_text_label.text += 'SALT: ' + Manager.confirmed_cation + ' ' + Manager.confirmed_anion + '\n\n\nGreat job! You can take a new salt now!'
			report_desk_finish_button.disabled = false
			
		else:
			report_desk_text_label.text += "SALT: ???\n\n\nYou didn't finish all the tests!"
			report_desk_finish_button.disabled = true

func _on_report_desk_exit_pressed() -> void:
	report_desk_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true

func _on_laboratory_acid_desk_opened() -> void:
	
	Manager.reagent_chosen = ''
	acid_desk_clicker.hide()
	acid_desk_progress_bar.hide()
	reagents_row_1.show()
	reagents_row_2.show()
	acid_desk_popup.show()
	game_popup_open = true
	Manager.can_use_machines = false
	
	if current_salt == '':
		can_select_reagents = false
		acid_desk_text.text = 'Get a salt from the desk first!'
		acid_desk_clicker.disabled = true
		
	else:
		if not Manager.extract_prepared:
			can_select_reagents = false
			acid_desk_text.text = 'Prepare the salt extract first!'
			acid_desk_clicker.disabled = false
		else:
			can_select_reagents = true
			acid_desk_text.text = 'Choose a reagent!'#Manager.current_salt + Manager.reagents[Manager.current_salt_cation] + Manager.reagents[Manager.current_salt_anion]
			acid_desk_clicker.disabled = true

func _on_acid_desk_exit_pressed() -> void:
	acid_desk_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true
	Manager.current_acid_desk_click_progress = 0

#reagent name text
func _on_nh4oh_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'NH4OH'
	
func _on_nh4oh_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_dmg_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'DMG'

func _on_dmg_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_nh4cns_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'NH4CNS'

func _on_nh4cns_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_nesslers_reagent_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = "Nessler's Reagent"

func _on_nesslers_reagent_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_ki_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'KI'

func _on_ki_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_aluminon_reagent_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'Aluminon Reagent'

func _on_aluminon_reagent_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''	

func _on_agno3_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'AgNO3'

func _on_agno3_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_bacl2_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'BaCl2'

func _on_bacl2_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_feso4h2so4mix_mouse_entered() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		if Manager.current_disaster == 'labels':
			acid_desk_text.text = '???'
		else:
			acid_desk_text.text = 'FeSO4-H2SO4 Mix'

func _on_feso4h2so4mix_mouse_exited() -> void:
	if Manager.extract_prepared and Manager.current_salt != '':
		acid_desk_text.text = ''

func _on_acid_desk_clicker_pressed() -> void:
	Manager.current_acid_desk_click_progress += 2 + (2*acid_desk_upgrade_status)
	Manager.money += (2 + (3*acid_desk_upgrade_status))*(acid_desk_upgrade_status+1)/2
	
#selecting reagent
func _on_nh4oh_pressed() -> void:
	Manager.reagent_chosen = 'NH4OH'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()

	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_dmg_pressed() -> void:
	Manager.reagent_chosen = 'DMG'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_nh4cns_pressed() -> void:
	Manager.reagent_chosen = 'NH4CNS'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_nesslers_reagent_pressed() -> void:
	Manager.reagent_chosen = "Nessler's Reagent"
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_ki_pressed() -> void:
	Manager.reagent_chosen = 'KI'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_aluminon_reagent_pressed() -> void:
	Manager.reagent_chosen = "Aluminon Reagent"
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_agno3_pressed() -> void:
	Manager.reagent_chosen = 'AgNO3'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_bacl2_pressed() -> void:
	Manager.reagent_chosen = 'BaCl2'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

func _on_feso4h2so4mix_pressed() -> void:
	
	Manager.reagent_chosen = 'FeSO4-H2SO4 Mix'
	reagents_row_1.hide()
	reagents_row_2.hide()
	acid_desk_clicker.show()
	acid_desk_clicker.disabled = false
	acid_desk_progress_bar.show()
	if Manager.current_disaster == 'labels':
		acid_desk_text.text = 'Click to add ???'
	else:
		acid_desk_text.text = 'Click to add ' + Manager.reagent_chosen + '!'

#FINISH button
func _on_finish_button_pressed() -> void:
	report_desk_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true

	if not Manager.first_salt_done:
		Manager.first_salt_done = true

	Manager.current_disaster = ''

	Manager.money += 400
	Manager.current_burner_click_progress = 0
	Manager.current_acid_desk_click_progress = 0
	Manager.current_extractor_click_progress = 0
	
	current_salt = ''
	Manager.reagent_chosen = ''
	Manager.current_salt = ''
	Manager.current_salt_anion = ''
	Manager.current_salt_cation = ''
	
	Manager.extract_prepared = false
	Manager.burner_used = false
	
	Manager.confirmed_anion = ''
	Manager.confirmed_cation = ''

func get_random_disaster():

	var x = randi_range(1, 100)
	if x in range(1, 11):
		Manager.current_disaster = 'nothing'
		disaster_text_label.text = ''
		
	elif x in range(11,36):
		Manager.current_disaster = 'labels'
		disaster_text_label.text = Manager.disaster_dialogues['labels']
		
	elif x in range(36, 51):
		Manager.current_disaster = 'labcoat'
		disaster_text_label.text = Manager.disaster_dialogues['labcoat']
		
	elif x in range(51, 71):
		Manager.current_disaster = 'extractor'
		disaster_text_label.text = Manager.disaster_dialogues['extractor']
		
	elif x in range(71, 91):
		Manager.current_disaster = 'burner'
		disaster_text_label.text = Manager.disaster_dialogues['burner']
		
	elif x in range(91, 96):
		Manager.current_disaster = 'cookie'
		disaster_text_label.text = Manager.disaster_dialogues['cookie']
		
	elif x in range(96, 101):
		Manager.current_disaster = 'boom'
		disaster_text_label.text = Manager.disaster_dialogues['boom']
	
	if not Manager.current_disaster == 'nothing':
		disaster_popup.show()
		game_popup_open = true
		Manager.can_use_machines = false
	
	#print(Manager.current_disaster)
	
func _on_disaster_exit_pressed() -> void:
	disaster_popup.hide()
	game_popup_open = false
	Manager.can_use_machines = true
	#print(Manager.current_disaster)
	
	if Manager.current_disaster == 'labcoat':
		Manager.money -= 200

	elif Manager.current_disaster == 'boom':
		Manager.upgrades_reset = true
		Manager.upgrade_status['BurnerUpgrade'] = 0
		Manager.upgrade_status['ExtractUpgrade'] = 0
		Manager.upgrade_status['AcidUpgrade'] = 0
		Manager.upgrades_reset = false

	elif Manager.current_disaster == 'cookie':
		Manager.money -= 10
	
