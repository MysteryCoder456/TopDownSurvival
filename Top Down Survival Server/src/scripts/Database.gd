extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const DB_PATH = "res://data/database"

var db = SQLite.new()


func _ready():
	init_db()
	create_tables()
	
	
func init_db():
	db.path = DB_PATH
	db.open_db()
	
	
func create_tables():
	# Inventory Table
	db.query("""
	CREATE TABLE IF NOT EXISTS inventories (
		player_id	INTEGER NOT NULL,
		inventory_slot	INTEGER NOT NULL,
		item_id	INTEGER NOT NULL,
		quantity	INTEGER NOT NULL DEFAULT 1
	)
	""")
	
	
func get_inventory(player_id: int):
	db.query("SELECT inventory_slot, item_id, quantity FROM inventories WHERE player_id = %s" % player_id)
	return db.query_result
