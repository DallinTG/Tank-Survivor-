package game_engin

import "core:fmt"
import as "../assets"
import rl "vendor:raylib"
import "core:slice"
import b2 "vendor:box2d"
import "core:math"
import "core:math/rand"
import "core:strings"

window_should_close:bool
game_paused:bool
game_over:bool
player_e_index:entity_index
tank_amb_cold:f32
player_xp:i32
player_level:i32
xp_to_next_level:i32=10
player_has_dash:bool
player_dash_deraton:f32=0.2
player_max_dash_deraton:f32=0.2
player_dash_speed:f32=4
player_is_dashing:bool
player_dash_cold:f32
player_dash_cold_v:f32=8
player_relode_time:f32
player_relode_time_v:f32=1
player_rounds:i32=1
player_max_rounds:i32=1
player_fier_intervul:f32=.1
score:i32=0
time:f32=0
dificulty:f32=1
spawn_intv:f32=2
spawn_time:f32=0
spawn_count:i32=1
spawn_chance:f32=.5


upgrades_id::enum{
    max_hp_up,
    max_hp_up_x,
    speed_up,
    speed_up_x,
    dash,
    dash_deraton_up,
    dash_deraton_up_x,
    dash_speed_up,
    dash_speed_up_x,
    regen_up,
    regen_up_5,
    regen_up_x,
    fis_damage_up,
    fis_damage_up_x,
    prje_damage_up,
    prje_damage_up_x,
    max_rounds_up,
    relode_speed_up,
}
upgrade_info::struct{
    id:upgrades_id,
    description:string,
    one_time_thing:bool,
    can_be_puled:bool,
    weight:int,
    icon:as.texture_names,
}
possible_upgrades:[upgrades_id]upgrade_info
weighted_upgrades:[dynamic]upgrades_id
init_upgrades::proc(){
    possible_upgrades[.max_hp_up]={
        id =.max_hp_up,
        description ="HP UP: Increase HP by 20",
        one_time_thing = false,
        can_be_puled = true,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.max_hp_up_x]={
        id =.max_hp_up_x,
        description ="HP UP: Increase HP by 10%",
        one_time_thing = false,
        can_be_puled = true,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.speed_up]={
        id =.speed_up,
        description ="SPEED UP: Increase speed by 10%",
        one_time_thing = false,
        can_be_puled = true,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.speed_up_x]={
        id =.speed_up_x,
        description ="SPEED UP: Increase speed by 20%",
        one_time_thing = false,
        can_be_puled = true,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.dash]={
        id =.dash,
        description ="Unlocks A Dash SHIFT to use",
        one_time_thing = true,
        can_be_puled =  true,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.dash_deraton_up]={
        id =.dash_deraton_up,
        description ="Increase the Duration of the Dash by 10%",
        one_time_thing = true,
        can_be_puled = false,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.dash_deraton_up_x]={
        id =.dash_deraton_up_x,
        description ="Increase the Duration of the Dash By 20%",
        one_time_thing = true,
        can_be_puled = false,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.dash_speed_up]={
        id =.dash_speed_up,
        description ="Increase the Speed of the Dash",
        one_time_thing = true,
        can_be_puled = false,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.dash_speed_up_x]={
        id =.dash_speed_up,
        description ="Increase the Speed of the Dash By 10%",
        one_time_thing = true,
        can_be_puled = false,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.regen_up]={
        id =.regen_up,
        description ="REGEN UP: Increase HP Regen by 2",
        one_time_thing = false,
        can_be_puled = true,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.regen_up_5]={
        id =.regen_up_5,
        description ="REGEN UP: Increase HP Regen by 5",
        one_time_thing = false,
        can_be_puled = true,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.regen_up_x]={
        id =.regen_up_x,
        description ="REGEN UP: Increase HP Regen by 10%",
        one_time_thing = false,
        can_be_puled = false,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.fis_damage_up]={
        id =.fis_damage_up,
        description ="Increase Physical Damage by 10",
        one_time_thing = false,
        can_be_puled = true,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.fis_damage_up_x]={
        id =.fis_damage_up_x,
        description ="Increase Physical Damage by 10%",
        one_time_thing = false,
        can_be_puled = false,
        weight=5,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.prje_damage_up]={
        id =.prje_damage_up,
        description ="Increase Projectile Damage by 10",
        one_time_thing = false,
        can_be_puled = true,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.prje_damage_up_x]={
        id =.prje_damage_up_x,
        description ="Increase Projectile Damage by 10%",
        one_time_thing = false,
        can_be_puled = false,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.relode_speed_up]={
        id =.relode_speed_up,
        description ="Increase Reloade Speed by 10%",
        one_time_thing = false,
        can_be_puled = true,
        weight=10,
        icon = as.texture_names.bace_light
    }
    possible_upgrades[.max_rounds_up]={
        id =.max_rounds_up,
        description ="Increase Max rounds by 1",
        one_time_thing = false,
        can_be_puled = true,
        weight=5,
        icon = as.texture_names.bace_light
    }
}

init_player::proc(){
    game_over = false
    init_upgrades()
    player_e_index = create_entity_by_id({320,320},entity_id.player,sprite_id.player,light_id.player)
    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
 


    
    game_paused=false
    tank_amb_cold=0
    player_xp=0
    player_level=0
    xp_to_next_level=10
    player_has_dash=false
    player_dash_deraton=0.2
    player_max_dash_deraton=0.2
    player_dash_speed=4
    player_is_dashing=false
    player_dash_cold=0
    player_dash_cold_v=8
    player_relode_time=0
    player_relode_time_v=1
    player_rounds=1
    player_max_rounds=1
    player_fier_intervul=.1
    score=0
    time=0
    dificulty=1
    spawn_intv=1
    spawn_time=0
    spawn_count=1
    spawn_chance=.5

}
do_player::proc(){
    player:=all_entitys.data[player_e_index.id]
    if !game_over{
        do_player_movement()
        player_sounds()
        check_for_level_up()
        do_spawner()
    }
    if player.entity.entity_type.(et_player).stats_b.hp<=0{
        if game_over == false{
            play_sound_at_pos(as.sound_names.wa_wa, player.entity.pos,1)
        }
        game_over = true
    }
    if game_over{
        if rl.IsKeyDown(.ENTER){
            //ge.unlode_t_map(&ge.Curent_world_map.t_maps[{0,0}])
            for &entity_data,i in all_entitys.data[:all_entitys.last_entity]{
               delete_entity(entity_data.entity.entity_index)
           }
           init_player()
        }
    }
}
do_spawner::proc(){
    spawn_time -= rl.GetFrameTime()
    time += rl.GetFrameTime()
    if spawn_time<0{
        switch time {
            case 0..<120:
                dificulty = 1
            case 120..<240:
                dificulty = 2
            case 240..<380:
                dificulty = 3
            case 380..<540:
                dificulty = 4
            case 540..<680:
                dificulty = 5
            case 680..<600080:
                dificulty = 6
            }
            if rand.float32()>.75{
                spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
            }
            if rand.float32()>.75{
                spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
            }
            if rand.float32()>.75{
                spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
            }
            if rand.float32()>.75{
                spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
            }
            if rand.float32()>.99{
                spawn_enemy_on_entity(player_e_index,820,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
            }
            if dificulty > 1{
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
                }
                if rand.float32()>.90{
                    spawn_enemy_on_entity(player_e_index,820,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
            }
            if dificulty > 2{
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.mob,sprite_id.mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.95{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.90{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.big_mob,sprite_id.big_mob,light_id.mob)
                }
            }
            if dificulty > 3{
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.mob,sprite_id.mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.95{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.big_mob,sprite_id.big_mob,light_id.mob)
                }
            }
            if dificulty > 4{
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.mob,sprite_id.mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.55{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.55{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.big_mob,sprite_id.big_mob,light_id.mob)
                }
                if rand.float32()>.95{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
            }
            if dificulty > 5{
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.big_mob,sprite_id.big_mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
                }
                if rand.float32()>.55{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
                if rand.float32()>.55{
                    spawn_enemy_on_entity(player_e_index,1000,entity_id.big_mob,sprite_id.big_mob,light_id.mob)
                }
                if rand.float32()>.70{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
            }
            if dificulty > 6{
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
                if rand.float32()>.75{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
                if rand.float32()>.55{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
                if rand.float32()>.55{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
                if rand.float32()>.70{
                    spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
                }
            }
    
        spawn_time = spawn_intv
        // spawn_enemy_on_entity(player_e_index,820,entity_id.mob,sprite_id.mob,light_id.mob)
        // spawn_enemy_on_entity(player_e_index,820,entity_id.small_mob,sprite_id.small_mob,light_id.mob)
        // spawn_enemy_on_entity(player_e_index,820,entity_id.big_mob,sprite_id.big_mob,light_id.mob)
        // spawn_enemy_on_entity(player_e_index,2000,entity_id.boss_mob,sprite_id.boss_mob,light_id.mob)
        if spawn_intv>0.1{
            spawn_intv = spawn_intv-.001
            // fmt.print(spawn_intv)
        }
    }

}
do_player_movement::proc(){
    pos:=b2.Body_GetPosition(all_entitys.data[player_e_index.id].entity.body_id)
    player:=all_entitys.data[player_e_index.id]
    player_body_id:=all_entitys.data[player_e_index.id].entity.body_id
    turning_speed:f32=0
    speed:[2]f32=0
    if rl.IsKeyDown(.A){
        turning_speed+=player.entity.entity_type.(et_player).stats_b.turning_speed*-1
    }
    if rl.IsKeyDown(.D){
        turning_speed+=player.entity.entity_type.(et_player).stats_b.turning_speed
    }
    if rl.IsKeyDown(.W){
        speed+={player.entity.entity_type.(et_player).stats_b.speed*b2.Body_GetRotation(player_body_id).c,player.entity.entity_type.(et_player).stats_b.speed*b2.Body_GetRotation(player_body_id).s}
    }
    if rl.IsKeyDown(.S){
        speed+={player.entity.entity_type.(et_player).stats_b.speed*-1*b2.Body_GetRotation(player_body_id).c,player.entity.entity_type.(et_player).stats_b.speed*-1*b2.Body_GetRotation(player_body_id).s}
    }
    if rl.IsKeyDown(.SPACE){
        if player_rounds>0{
            if player_fier_intervul < 0{
            lonch_projectile(player_e_index,1000000,entity_id.bulet,sprite_id.bulet,light_id.bulet)
            player_rounds-=1
            player_relode_time = player_relode_time_v
            player_fier_intervul = 0.15
            }

            player_fier_intervul -=rl.GetFrameTime()
        }
    }

    if rl.IsKeyPressed(.LEFT_SHIFT){
        if player_has_dash{
            if player_dash_cold <= 0 {
                player_is_dashing = true
                player_dash_deraton = player_max_dash_deraton
                player_dash_cold = player_dash_cold_v
                play_sound_at_pos(as.sound_names.zuwp,pos,1)
            }
        }
    }
    if player_is_dashing{
        speed=speed*player_dash_speed
        if all_entitys.data[player_e_index.id].entity.part_cool_down<0{
            particle:particle
            particle.id = .fiyer
            particle.life=.7
            particle.max_life=.7
            particle.velocity = {(rand.float32()*2-1)*50,(rand.float32()*2-1)*50}
            particle.xy=all_entitys.data[player_e_index.id].entity.pos
            spawn_particle(particle)
            all_entitys.data[player_e_index.id].entity.part_cool_down=.01
        }
    }
    player_dash_cold -= rl.GetFrameTime()
    player_dash_deraton-= rl.GetFrameTime()
    player_relode_time-= rl.GetFrameTime()
    if player_relode_time<0{
        if player_rounds<player_max_rounds{
            player_rounds = player_max_rounds
            player_relode_time = player_relode_time_v
        }

    }
    if player_dash_deraton<0{
        player_is_dashing = false
    }
    b2.Body_SetAngularVelocity(player_body_id,turning_speed)
    b2.Body_SetLinearVelocity(player_body_id,(speed))
    // camera.target = pos-{cast(f32)rl.GetScreenWidth()/2,cast(f32)rl.GetScreenHeight()/2}
}
spawn_enemy_on_entity::proc(target:entity_index,dis:f32,entity_id:entity_id,sprite_id:sprite_id,light_id:light_id){
    pos:=b2.Body_GetPosition(all_entitys.data[target.id].entity.body_id)
    cos_sin:[2]f32={rand.float32()*2-1 ,rand.float32()*2-1}
    pos+=dis*cos_sin


    e_index: = create_entity_by_id(pos,entity_id,sprite_id,light_id)
    #partial switch &type in all_entitys.data[e_index.id].entity.entity_type {
        case et_ai_mob: type.target = target
    }
}
player_sounds::proc(){
    if tank_amb_cold<0{
        play_sound_at_pos(as.sound_names.tank_engen,all_entitys.data[player_e_index.id].entity.pos,.5,true,player_e_index)
        tank_amb_cold = 3.22
    }
    tank_amb_cold -= rl.GetFrameTime()
}
lonch_projectile::proc(loncher:entity_index,speed:f32,entity_id:entity_id,sprite_id:sprite_id,light_id:light_id){
    
    pos:=b2.Body_GetPosition(all_entitys.data[loncher.id].entity.body_id)
    rot:=b2.Body_GetRotation(all_entitys.data[loncher.id].entity.body_id)
    e_index: = create_entity_by_id(pos,entity_id,sprite_id,light_id)
    // all_entitys.data[e_index.id].entity.body_id
    // b2.Body_SetFixedRotation(all_entitys.data[e_index.id].entity.body_id)
    // all_entitys.data[loncher.id].entity.entity_type.(et_proj).dir = {rot.c*speed,rot.s*speed}
    #partial switch &type in all_entitys.data[e_index.id].entity.entity_type {
        case et_proj:
            type.dir={rot.c*speed,rot.s*speed}
            type.stats_b.hp+=all_entitys.data[loncher.id].entity.entity_type.(et_player).stats_b.proj_damage
    }
    b2.Body_SetBullet(all_entitys.data[e_index.id].entity.body_id,true)
    b2.Body_SetTransform(all_entitys.data[e_index.id].entity.body_id,pos+{rot.c*10,rot.s*10},rot)
    b2.Body_SetFixedRotation(all_entitys.data[e_index.id].entity.body_id,true)
    b2.Body_ApplyLinearImpulseToCenter(all_entitys.data[e_index.id].entity.body_id,{rot.c*speed,rot.s*speed},true)
    b2.Body_SetLinearDamping(all_entitys.data[e_index.id].entity.body_id,0)
    play_sound_at_pos(as.sound_names.gun_shot,pos,.7)
    play_sound_at_pos(as.sound_names.small_thud,pos,2)
    play_sound_at_pos(as.sound_names.shhhhhhhhhh_2,pos,1,true,e_index)
}
check_for_level_up::proc(){
    pos:=all_entitys.data[player_e_index.id].entity.pos
    if player_xp >= xp_to_next_level{
        player_xp-=xp_to_next_level
        xp_to_next_level+=5
        player_level +=1
        start_level_up()
        play_sound_at_pos(as.sound_names.trumpets,pos,1)
    }
}
start_level_up::proc(){
    clear(&weighted_upgrades)
    for upgrade in possible_upgrades {
        if upgrade.can_be_puled{
            for i in 0..=upgrade.weight {
                append(&weighted_upgrades, upgrade.id)
            }
        }
    }
    
    lev_up_slot_1 = rand.choice(weighted_upgrades[:])
    lev_up_slot_2 = rand.choice(weighted_upgrades[:])
    lev_up_slot_3 = rand.choice(weighted_upgrades[:])
    lev_up_slot_4 = rand.choice(weighted_upgrades[:])
    
    lev_up_slot_1_text = possible_upgrades[lev_up_slot_1].description
    lev_up_slot_2_text = possible_upgrades[lev_up_slot_2].description
    lev_up_slot_3_text = possible_upgrades[lev_up_slot_3].description
    lev_up_slot_4_text = possible_upgrades[lev_up_slot_4].description

    lev_up_menu_lev_op_1_button.name = strings.clone_to_cstring(lev_up_slot_1_text)
    lev_up_menu_lev_op_2_button.name = strings.clone_to_cstring(lev_up_slot_2_text)
    lev_up_menu_lev_op_3_button.name = strings.clone_to_cstring(lev_up_slot_3_text)
    lev_up_menu_lev_op_4_button.name = strings.clone_to_cstring(lev_up_slot_4_text)

    game_paused = true
    check_lev_up_menu()
}
do_level_up::proc(upgrades:upgrades_id){
    pos:=all_entitys.data[player_e_index.id].entity.pos
    switch upgrades {
    case .max_hp_up:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.max_hp +=20
        data.stats_b.hp +=20
    case .max_hp_up_x:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.max_hp =data.stats_b.max_hp*1.10
        data.stats_b.hp = data.stats_b.hp*1.10
    case .speed_up:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.speed =data.stats_b.speed*1.10
    case .speed_up_x:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.speed =data.stats_b.speed*1.20
    case .dash:
        player_has_dash = true
        possible_upgrades[.dash].can_be_puled = false
        possible_upgrades[.dash_deraton_up].can_be_puled = true
        possible_upgrades[.dash_speed_up].can_be_puled = true
    case .dash_deraton_up:
        player_dash_deraton=player_dash_deraton*1.1
    case .dash_deraton_up_x:
        player_dash_deraton=player_dash_deraton*1.2
    case .dash_speed_up:
        player_dash_speed += .5
    case .dash_speed_up_x:
        player_dash_speed = player_dash_speed*1.2
    case .regen_up:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.hp_regen +=2
    case .regen_up_5:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.hp_regen +=5
    case .regen_up_x:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.hp_regen =data.stats_b.hp_regen*1.1
    case .fis_damage_up:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.fis_damage +=10
    case.fis_damage_up_x:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.fis_damage =data.stats_b.fis_damage*1.1
    case .prje_damage_up:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.proj_damage +=10
    case .prje_damage_up_x:
        data:=&all_entitys.data[player_e_index.id].entity.entity_type.(et_player)
        data.stats_b.proj_damage =data.stats_b.proj_damage*1.1
    case .max_rounds_up:
        player_max_rounds+=1
    case .relode_speed_up:
        player_relode_time_v=player_relode_time_v*.90
    }
    play_sound_at_pos(as.sound_names.mony,pos,1)
}