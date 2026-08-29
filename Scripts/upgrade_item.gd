extends VBoxContainer

@onready var item_name: Label = $ItemName
@onready var progressbar: TextureProgressBar = $VBoxContainer/UpgradeProgress
@onready var price_tag: Label = $VBoxContainer/HBoxContainer/PriceTag
@onready var buy_button: TextureButton = $VBoxContainer/HBoxContainer/BuyButton

var upgrade_state = 0
var price: int = 1000

func _ready() -> void:
	
	progressbar.value = Manager.upgrade_status[name] * 25
	
	if name == 'BurnerUpgrade':
		item_name.text = 'Burner'
		
	elif name == 'ExtractUpgrade':
		item_name.text = 'Extractor'
	
	elif name == 'AcidUpgrade':
		item_name.text = 'Workbench'

func _process(_delta: float) -> void:
	price_tag.text = '$' + str(price)
	progressbar.value = Manager.upgrade_status[name] * 25

	if Manager.upgrade_status[name] == 0:
		price = 1000

	if Manager.money >= price:
		buy_button.disabled = false #can you afford?
	else:
		buy_button.disabled = true
		
	if Manager.upgrade_status[name] == 4:
		price_tag.text = 'MAX'
		buy_button.disabled = true

func _on_buy_button_pressed() -> void:
	progressbar.value += 25
	Manager.money -= price
	Manager.upgrade_status[name] += 1
	price += randi_range(5, 10) * 400 * Manager.upgrade_status[name] * 2 ** (Manager.upgrade_status[name]-1)
	
