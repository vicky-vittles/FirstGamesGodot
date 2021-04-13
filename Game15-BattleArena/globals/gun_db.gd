extends Node

enum BULLET_TYPES {
	NORMAL_BULLET = 1}
const BULLETS = {
	BULLET_TYPES.NORMAL_BULLET: preload("res://entities/bullet/NormalBullet.tscn")}

enum GUN_TYPES {
	SMG = 0,
	SHOTGUN = 1,
	SNIPER = 2,
	RPG = 3,
	MACHINE_GUN = 4,
	RIFLE = 5}
const GUN_PLACEMENT = {
	GUN_TYPES.SMG: {
		1: Vector2(7,3),
		2: Vector2(6,4),
		3: Vector2(10,5)},
	GUN_TYPES.SHOTGUN: {
		1: Vector2(0,6),
		2: Vector2(2,7),
		3: Vector2(3,7)},
	GUN_TYPES.SNIPER: {
		1: Vector2(-8,4),
		2: Vector2(-1,1),
		3: Vector2(-4,5)},
	GUN_TYPES.RPG: {
		1: Vector2(1,3),
		2: Vector2(-4,6),
		3: Vector2(-4,6)},
	GUN_TYPES.MACHINE_GUN: {
		1: Vector2(-6,2),
		2: Vector2(6,7),
		3: Vector2(-6,1)},
	GUN_TYPES.RIFLE: {
		1: Vector2(-1,6),
		2: Vector2(0,5),
		3: Vector2(1,4)}}
const GUN_BULLETS = {
	GUN_TYPES.SMG: BULLET_TYPES.NORMAL_BULLET,
	GUN_TYPES.SHOTGUN: BULLET_TYPES.NORMAL_BULLET,
	GUN_TYPES.SNIPER: BULLET_TYPES.NORMAL_BULLET,
	GUN_TYPES.RPG: BULLET_TYPES.NORMAL_BULLET,
	GUN_TYPES.MACHINE_GUN: BULLET_TYPES.NORMAL_BULLET,
	GUN_TYPES.RIFLE: BULLET_TYPES.NORMAL_BULLET}
const GUNS = {
	GUN_TYPES.SMG: {
		1: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 5,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.1,
			"max_ammo": 100,
			"shoot_anim_intensity": 3},
		2: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 5,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.1,
			"max_ammo": 100,
			"shoot_anim_intensity": 3},
		3: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 5,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.1,
			"max_ammo": 100,
			"shoot_anim_intensity": 3}},
	GUN_TYPES.SHOTGUN: {
		1: {
			"bullets_emitted": 5,
			"angle_between_bullets": 7.5,
			"bullet_damage": 6,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 1.0,
			"max_ammo": 20,
			"shoot_anim_intensity": 6},
		2: {
			"bullets_emitted": 5,
			"angle_between_bullets": 7.5,
			"bullet_damage": 6,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 1.0,
			"max_ammo": 20,
			"shoot_anim_intensity": 6},
		3: {
			"bullets_emitted": 5,
			"angle_between_bullets": 7.5,
			"bullet_damage": 6,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 1.0,
			"max_ammo": 20,
			"shoot_anim_intensity": 6}},
	GUN_TYPES.SNIPER: {
		1: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 40,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 1.0,
			"max_ammo": 10,
			"shoot_anim_intensity": 6},
		2: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 40,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 1.0,
			"max_ammo": 10,
			"shoot_anim_intensity": 6},
		3: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 40,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 1.0,
			"max_ammo": 10,
			"shoot_anim_intensity": 6}},
	GUN_TYPES.RPG: {
		1: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 50,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 2.0,
			"max_ammo": 5,
			"shoot_anim_intensity": 6},
		2: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 50,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 2.0,
			"max_ammo": 5,
			"shoot_anim_intensity": 6},
		3: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 50,
			"critical_hit_chance": 0.0,
			"needs_reloading": true,
			"fire_rate": 2.0,
			"max_ammo": 5,
			"shoot_anim_intensity": 6}},
	GUN_TYPES.MACHINE_GUN: {
		1: {
			"bullets_emitted": 5,
			"angle_between_bullets": 1.0,
			"bullet_damage": 2,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.05,
			"max_ammo": 200,
			"shoot_anim_intensity": 3},
		2: {
			"bullets_emitted": 5,
			"angle_between_bullets": 1.0,
			"bullet_damage": 2,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.05,
			"max_ammo": 200,
			"shoot_anim_intensity": 3},
		3: {
			"bullets_emitted": 5,
			"angle_between_bullets": 1.0,
			"bullet_damage": 2,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.05,
			"max_ammo": 200,
			"shoot_anim_intensity": 3}},
	GUN_TYPES.RIFLE: {
		1: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 20,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.25,
			"max_ammo": 50,
			"shoot_anim_intensity": 3},
		2: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 20,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.25,
			"max_ammo": 50,
			"shoot_anim_intensity": 3},
		3: {
			"bullets_emitted": 1,
			"angle_between_bullets": 0.0,
			"bullet_damage": 20,
			"critical_hit_chance": 0.0,
			"needs_reloading": false,
			"fire_rate": 0.25,
			"max_ammo": 50,
			"shoot_anim_intensity": 3}}}

func get_sprite(gun_type: int, gun_variation: int) -> int:
	return gun_type + (gun_variation-1)*6

func get_placement(gun_type: int, gun_variation: int) -> Vector2:
	return GUN_PLACEMENT[gun_type][gun_variation]

func get_shoot_intensity(gun_type: int, gun_variation: int) -> int:
	return GUNS[gun_type][gun_variation]["shoot_anim_intensity"]

func get_bullet_type(gun_type: int):
	return BULLETS[GUN_BULLETS[gun_type]]
