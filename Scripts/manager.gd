extends Node

var random = RandomNumberGenerator.new()

var money: int = 500000
#var hand: Array = []
var upgrade_status: Dictionary = {'BurnerUpgrade' : 0, 'ExtractUpgrade' : 0, 'AcidUpgrade': 0}
var upgrades_reset: bool = false

var first_play: bool = true
var can_use_machines: bool = true
var first_salt_done: bool = false

var current_burner_click_progress: int = 0
var current_extractor_click_progress: int = 0
var current_acid_desk_click_progress: int = 0

var reagent_chosen: String = ''

var salt_list: Array = ['copper sulphate',
						'nickel sulphate',
						'ferric chloride',
						'ammonium chloride',
						'aluminium nitrate',
						'lead nitrate']

var salt_heating_effect: Dictionary = {'copper sulphate' : 'The blue colored salt turned white!\nThis may be a salt of copper!\nNo other effects were seen...',
									'nickel sulphate' : 'The green colored salt turned white!\nThis may be a salt of nickel!\nNo other effects were seen...',
									'ferric chloride' : 'The brown colored salt turned white!\nThis may be a salt of iron!\nNo other effects were seen...',
									'ammonium chloride' : 'A colorless gas that smells bad evolved on heating!\nThis may be a salt of ammonia!\nNo other effects were seen...',
									'aluminium nitrate' : 'Brown-colored fumes were evolved!\nThis may be a nitrate salt!\nThe salt also left a blue ash on burning!\nThis may be an aluminium salt!',
									'lead nitrate' : 'The salt made a crackling noise on heating!\nThis may be a salt of lead!\nBrown-colored fumes were evolved!\nThis may be a nitrate salt!'}

var heating_observations: Dictionary = {'copper sulphate' : '\n\n- Salt loses color, cation may be copper',
									'nickel sulphate' : '\n\n- Salt loses color, cation may be nickel',
									'ferric chloride' : '\n\n- Salt loses color, cation may be ferric',
									'ammonium chloride' : '\n\n- Salt sublimes on heating, cation may be ammonia',
									'lead nitrate' : '\n\n- Salt crackles on heating, cation may be lead',
									'aluminium nitrate' : '\n\n- Heating salt evolves brown fumes, anion may be nitrate'}

var salt_guides: Dictionary = {'Copper' : 'Copper Ion\n\nCharge: +2\n\nSome copper salts are blue colored \nAdd some NH4OH - ammonium hydroxide - to solution drop by drop.\nIf a deep blue color is observed, then the cation is copper.',
							'Nickel' : 'Nickel Ion\n\nCharge: +2\n\nSome nickel salts are green colored. \nAdd some DMG - DiMethylGlyoxime - to solution. \nIf a  cherry-red precipitate is formed, then the cation is nickel.',
							'Ferric' : 'Ferric Ion\n\nCharge: +3\n\nSome ferric salts are brown colored. \nAdd some NH4CNS - ammonium thiocynate - to solution. \nIf a blood-red color is observed, then the cation is ferric.',
							'Ammonium' : "Ammonium Ion\n\nCharge: +1\n\nSome salts of ammonium sublime on heating. \nAdd some Nessler's Reagant to solution. \nIf a reddish-brown precipitate is observed, then the cation is ammonium.",
							'Lead' : 'Lead Ion\n\nCharge: +2\n\nSome salts of lead crackle on heating. \nAdd some KI - potassium iodide - to solution. \nIf a thick yellow precipitate is observed, then the cation is lead.',
							'Aluminium' : 'Aluminium Ion\n\nCharge: +3\n\nAluminium salts leave blue ash when burned. \nAdd some  Aluminon Reagant to solution. \nIf a red color is observed, then the cation is aluminium.',
							'Chloride' : 'Chloride Ion\n\nCharge: -1\n\nMost chloride salts do not respond to heating. \nAdd some AgNO3 - silver nitrate - to extract. \nIf a thick white precipitate is observed, then the anion is chloride.',
							'Sulphate' : 'Sulphate Ion\n\nCharge: -2\n\nSulphate salts do not respond to heating. \nAdd some BaCl2 - barium chloride - to extract. \nIf a thick white precipitate is observed, then the anion is sulphate.',
							'Nitrate' : 'Nitrate Ion\n\nCharge: -1\n\nNitrate salts form brown fumes on heating. \nAdd some FeSO4-H2SO4 mixture to extract. \nIf a brown ring is formed, then the anion is nitrate.'}

var reagents: Dictionary = {'Copper' : 'NH4OH',
							'Nickel' : 'DMG',
							'Ferric' : 'NH4CNS',
							'Ammonium' : "Nessler's Reagent",
							'Lead' : 'KI',
							'Aluminium' : 'Aluminon Reagent',
							'Chloride' : 'AgNO3',
							'Sulphate' : 'BaCl2',
							'Nitrate' : 'FeSO4-H2SO4 Mix'}

var cation_dialogues: Dictionary = {'Copper' : 'A deep blue solution is formed!\nThe cation MUST be copper! Report your findings at the desk.',
									'Nickel' : 'A cherry-red precipitate is formed!\nThe cation MUST be nickel! Report your findings at the desk.',
									'Ferric' : 'A blood-red color is observed!\nThe cation MUST be ferric! Report your findings at the desk.',
									'Ammonium' : 'A reddish-brown precipitate is formed!\nThe cation MUST be ammonium! Report your findings at the desk.',
									'Lead' : 'A thick yellow precipitate is formed!\nThe cation MUST be lead! Report your findings at the desk.',
									'Aluminium' : 'A red color is observed!\nThe cation MUST be aluminium! Report your findings at the desk.'}

var anion_dialogues: Dictionary = {'Chloride' : 'A thick white precipitate is observed!\nThe anion MUST be chloride! Report your findings at the desk.',
								'Sulphate' : 'A thick white precipitate is observed!\nThe anion MUST be sulphate! Report your findings at the desk.',
								'Nitrate' : 'A brown ring is observed!\nThe anion MUST be nitrate! Report your findings at the desk.'}

var possible_disasters: Array = ['nothing', 'labels', 'labcoat', 'extractor', 'burner', 'cookie', 'boom']

var disaster_dialogues: Dictionary = {'labels' : 'The labels of all the reagents in the acid desk are missing until you finish this salt!',
									'labcoat' : 'You left your labcoat at home! You need to pay a $200 fine.',
									'extractor' : 'The extractor is malfunctioning! Finish one salt to fix it.',
									'burner' : 'The burner is malfunctioning! Finish one salt to fix it.',
									'cookie' : 'Professor Eddy really wants a cookie. You need to buy him one for $10.',
									'boom' : 'OH NO! Something exploded in the lab! All upgrades were reset :(' }

var current_disaster: String = ''

var current_salt: String = ''
var current_salt_cation: String = ''
var current_salt_anion: String = ''

var extract_prepared: bool = false
var burner_used: bool = false

var confirmed_cation = ''
var confirmed_anion = ''

func _ready() -> void:
	can_use_machines = true
		
func _process(_delta: float) -> void:
	pass

func get_random_salt():
	var x = randi_range(0, 5)
	
	if salt_list[x] == 'copper sulphate':
		current_salt_cation = 'Copper'
		current_salt_anion = 'Sulphate'
		
	elif salt_list[x] == 'nickel sulphate':
		current_salt_cation = 'Nickel'
		current_salt_anion = 'Sulphate'
		
	elif salt_list[x] == 'ferric chloride':
		current_salt_cation = 'Ferric'
		current_salt_anion = 'Chloride'
		
	elif salt_list[x] == 'ammonium chloride':
		current_salt_cation = 'Ammonium'
		current_salt_anion = 'Chloride'
		
	elif salt_list[x] == 'aluminium nitrate':
		current_salt_cation = 'Aluminium'
		current_salt_anion = 'Nitrate'
		
	else:
		current_salt_cation = 'Lead'
		current_salt_anion = 'Nitrate'

	return salt_list[x]

func check_reagent_test_result():
	
	if reagent_chosen == reagents[current_salt_cation]:
		confirmed_cation = current_salt_cation
		return cation_dialogues[current_salt_cation]
		
	elif reagent_chosen == reagents[current_salt_anion]:
		confirmed_anion = current_salt_anion
		return anion_dialogues[current_salt_anion]
		
	else:
		return 'Hmm, nothing of note happened.\nTry a different reagent!'
