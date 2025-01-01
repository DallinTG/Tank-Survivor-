package game_engin

import rl "vendor:raylib"
import as "../assets"
import "core:fmt"
import "core:math"
import "core:math/rand"
// import "core:math/rand"
import b2 "vendor:box2d"
import "base:runtime"


max_entity_c::4000
stats :: struct{
    speed:f32,
    turning_speed:f32,
    hp:f32,
    hp_regen:f32,
    hp_regen_cold:f32,
    max_hp:f32,
    xp_value:i32,
    proj_damage:f32,
    fis_damage:f32,
    imunity_frames:f32,
    imunity_time:f32,
    

}
shape::enum{
    box,
    circle,
}
entity :: struct{
    shape:shape,
    part_cool_down:f32,
    entity_index:entity_index,
    pos:[2]f32,
    entity_type:entity_type,
    body_id:b2.BodyId,
    shape_id:b2.ShapeId,
    light_id:light_index,
    sprite_id:sprite_index,
}
entity_bucket::struct{
    data:[max_entity_c]entity_data,
    next_open_slot:int,
    last_entity:int,
    count:int,
}
entity_data::struct{
    entity:entity,
    is_occupied:bool,
    gen:int,
}

// all_entity_s:[dynamic]entity
all_entitys:entity_bucket
defalt_entitys:[entity_id]defalt_entity

entity_index::struct{
    id:int,
    gen:int,
}
entity_id::enum{
    none,
    test,
    player,
    mob,
    mob_e,
    small_mob,
    big_mob,
    boss_mob,
    bulet,
}
entity_type::union{
    et_bace,
    et_player,
    et_ai_mob,
    et_proj,
}
et_bace::struct{
    stats_b:stats,
}
et_player::struct{
    stats_b:stats,
}
et_ai_mob::struct{
    stats_b:stats,
    ai_cold:f32,
    target:entity_index,
}
et_proj::struct{
    time_left:f32,
    dir:[2]f32,
    stats_b:stats,
    target:entity_index,
}
box_2d_body::struct{
    extent:[2]f32,
    density:f32,
    friction:f32,
    restitution:f32,
    body_type:b2.BodyType,
}
defalt_entity::struct{
    entity:entity,
    body:box_2d_body,
}

init_defalt_entity_data::proc(){

    defalt_entitys[entity_id.none]={
        entity = {
            entity_type = et_bace{},
        },
        
    }
    defalt_entitys[entity_id.test]={
        entity = {
            entity_type = et_bace{},
        },
        body = {
            extent= {16/2,16/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.player]={
        entity = {
            entity_type = et_player{
                stats_b = {
                    speed = 160,
                    turning_speed = 3,
                    hp = 100,
                    hp_regen =1,
                    max_hp = 100,
                    fis_damage = 10,
                    proj_damage = 10,
                    imunity_time=.2,

                }
            },

        },
        body = {
            extent= {32/2,32/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.mob]={
        entity = {
            shape= shape.circle,
            entity_type = et_ai_mob{
                stats_b = {
                    speed = 300000,
                    turning_speed = 3,
                    hp = 20,
                    max_hp = 20,
                    xp_value = 1,
                    fis_damage =10,
                    imunity_time=.2,
                }
            },
            
        },
        body = {
            extent= {16/2,16/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.mob_e]={
        entity = {
            shape= shape.circle,
            entity_type = et_ai_mob{
                stats_b = {
                    speed = 300000,
                    turning_speed = 3,
                    hp = 60,
                    max_hp = 60,
                    xp_value = 1,
                    fis_damage =10,
                    imunity_time=.2,
                }
            },
            
        },
        body = {
            extent= {16/2,16/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.small_mob]={
        entity = {
            shape= shape.circle,
            entity_type = et_ai_mob{
                stats_b = {
                    speed = 450_000,
                    turning_speed = 3,
                    hp = 10,
                    max_hp = 10,
                    xp_value = 2,
                    fis_damage =5,
                    imunity_time=.2,
                }
            },
            
        },
        body = {
            extent= {8/2,8/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.big_mob]={
        entity = {
            shape= shape.circle,
            entity_type = et_ai_mob{
                stats_b = {
                    speed = 2_000_000,
                    turning_speed = 3,
                    hp = 300,
                    max_hp = 300,
                    xp_value = 50,
                    fis_damage =100,
                    imunity_time=.2,
                }
            },
            
        },
        body = {
            extent= {64/2,64/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.boss_mob]={
        entity = {
            shape= shape.circle,
            entity_type = et_ai_mob{
                stats_b = {
                    speed = 3000000,
                    turning_speed = 3,
                    hp = 100,
                    max_hp = 100,
                    xp_value = 5,
                    fis_damage =50,
                    imunity_time=.2,
                }
            },
            
        },
        body = {
            extent= {128/2,128/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
    defalt_entitys[entity_id.bulet]={
        entity = {
            entity_type = et_proj{
                time_left=3,
                stats_b = {
                    speed = 250,
                    turning_speed = 3,
                    hp = 10,
                    max_hp = 100,
                }
            },

        },
        body = {
            extent= {16/2,16/2},
            density =4,
            friction =.4,
            restitution=.3,
            body_type=b2.BodyType.dynamicBody,
        }
    }
}

// do_entitys::proc(){
//     do_entitys_d()
// }
// loops all entitys then will do logic
do_entitys::proc(){
if all_entitys.count > 0 {
    for &entity_data,i in all_entitys.data[:all_entitys.last_entity+1]{
        if entity_data.is_occupied {
        pos :b2.Vec2= b2.Body_GetWorldPoint(entity_data.entity.body_id,{all_sprites.data[entity_data.entity.sprite_id.id].sprite.rec.x,all_sprites.data[entity_data.entity.sprite_id.id].sprite.rec.y})
        pos_center := b2.Body_GetPosition(entity_data.entity.body_id)
        radians :f32= b2.Rot_GetAngle(b2.Body_GetRotation(entity_data.entity.body_id))

        
        all_lights.data[entity_data.entity.light_id.id].light.rect.x = pos_center.x 
        all_lights.data[entity_data.entity.light_id.id].light.rect.y = pos_center.y 

        entity_data.entity.pos = pos_center

        switch &type in all_entitys.data[i].entity.entity_type {
            case et_ai_mob: 

                dir:[2]f32 = (b2.Body_GetPosition(all_entitys.data[type.target.id].entity.body_id)-b2.Body_GetPosition(entity_data.entity.body_id))  
                dir_abs:=dir
                dir_abs.x=math.abs(dir.x)     
                dir_abs.y=math.abs(dir.y)
                length:f32=math.sqrt(dir_abs.x*dir_abs.x+dir_abs.y*dir_abs.y)
                b2.Body_ApplyForceToCenter(entity_data.entity.body_id,({dir.x/length,dir.y/length})*type.stats_b.speed,true)
                // b2.World_OverlapPolygon(box_2d_world_id,b2.Shape_GetPolygon(all_entitys.data[i].entity.shape_id),b2.Body_GetTransform(all_entitys.data[i].entity.body_id),b2.DefaultQueryFilter(),colide_test,&all_entitys.data[i].entity.shape_id)
                type.stats_b.imunity_frames -=rl.GetFrameTime()
                if type.stats_b.hp <= 0 {
                    play_sound_at_pos(as.sound_names.s_pop,pos,.1)
                    player_xp += type.stats_b.xp_value
                    score += type.stats_b.xp_value
                    delete_entity(all_entitys.data[i].entity.entity_index)
                }

            case et_bace:
            case et_player:
                all_entitys.data[i].entity.part_cool_down-=rl.GetFrameTime()
                circle:b2.Circle={{0,0},20}
                // b2.World_OverlapCircle(box_2d_world_id,circle,b2.Body_GetTransform(all_entitys.data[i].entity.body_id),b2.DefaultQueryFilter(),player_colide_test,&all_entitys.data[i].entity.shape_id)
                b2.World_OverlapPolygon(box_2d_world_id,b2.Shape_GetPolygon(all_entitys.data[i].entity.shape_id),b2.Body_GetTransform(all_entitys.data[i].entity.body_id),b2.DefaultQueryFilter(),player_colide_test,&all_entitys.data[i].entity.shape_id)
                type.stats_b.imunity_frames -=rl.GetFrameTime()
                type.stats_b.hp_regen_cold -=rl.GetFrameTime()
                if !game_over{
                    if type.stats_b.hp_regen_cold<0{
                        type.stats_b.hp_regen_cold = 1
                        type.stats_b.hp+=type.stats_b.hp_regen
                        if type.stats_b.hp>type.stats_b.max_hp{
                            type.stats_b.hp=type.stats_b.max_hp
                        }
                    }
                }

            case et_proj:

                // b2.World_OverlapPolygon(box_2d_world_id,b2.Shape_GetPolygon(all_entitys.data[i].entity.shape_id),b2.Body_GetTransform(all_entitys.data[i].entity.body_id),b2.DefaultQueryFilter(),proj_colide_test,&all_entitys.data[i].entity.shape_id)
                circle:b2.Circle={{0,0},15}
                b2.World_OverlapCircle(box_2d_world_id,circle,b2.Body_GetTransform(all_entitys.data[i].entity.body_id),b2.DefaultQueryFilter(),proj_colide_test,&all_entitys.data[i].entity.shape_id)
                type.time_left-=rl.GetFrameTime()
                all_entitys.data[i].entity.part_cool_down-=rl.GetFrameTime()
                if all_entitys.data[i].entity.part_cool_down<0{
                    particle:particle
                    particle.id = .fiyer
                    particle.life=.7
                    particle.max_life=.7
                    particle.velocity = {(rand.float32()*2-1)*50,(rand.float32()*2-1)*50}
                    particle.xy=all_entitys.data[i].entity.pos
                    spawn_particle(particle)
                    all_entitys.data[i].entity.part_cool_down=.01
                }
                b2.Body_ApplyForceToCenter(entity_data.entity.body_id,type.dir,true)

                if type.stats_b.hp <= 0 {
                    for wi in 0..=50{
                        particle:particle
                        particle.id = .fiyer_2
                        particle.life=.7
                        particle.max_life=.7
                        particle.velocity = {(rand.float32()*2-1)*75,(rand.float32()*2-1)*75}
                        particle.xy=all_entitys.data[i].entity.pos
                        spawn_particle(particle)
                    }
                    delete_entity(all_entitys.data[i].entity.entity_index)
                }
                if type.time_left<0{
                    delete_entity(entity_data.entity.entity_index)
                }

        }

        if all_sprites.data[entity_data.entity.sprite_id.id].gen == entity_data.entity.sprite_id.gen{

            all_sprites.data[entity_data.entity.sprite_id.id].sprite.pos.x = pos.x
            all_sprites.data[entity_data.entity.sprite_id.id].sprite.pos.y = pos.y
            all_sprites.data[entity_data.entity.sprite_id.id].sprite.rotation = rl.RAD2DEG *radians


            all_sprites.data[entity_data.entity.sprite_id.id].sprite.frame_timer += rl.GetFrameTime()
            if as.textures[all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frames !=0 {
                for all_sprites.data[entity_data.entity.sprite_id.id].sprite.frame_timer > cast(f32)as.textures[ all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frame_rate {
                    all_sprites.data[entity_data.entity.sprite_id.id].sprite.frame_timer -= cast(f32)as.textures[ all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frame_rate
                    all_sprites.data[entity_data.entity.sprite_id.id].sprite.curent_frame +=1
                }
                if all_sprites.data[entity_data.entity.sprite_id.id].sprite.curent_frame+1 > as.textures[all_sprites.data[entity_data.entity.sprite_id.id].sprite.texture_name].frames{
                    all_sprites.data[entity_data.entity.sprite_id.id].sprite.curent_frame = 0
                }
            }
        }
        }
        // append(&sprite_rendering_q, &entity.data.sprite)       
    }
}
}
// }
proj_colide_test::proc "cdecl" (ShapeId:b2.ShapeId,data:rawptr)->bool{
    context = runtime.default_context()
    ptr:=cast(^b2.ShapeId)(data)
    if ptr.index1 != ShapeId.index1{
        if ShapeId.index1 !=all_entitys.data[player_e_index.id].entity.shape_id.index1 {
            // fmt.print("fsdfsdfsdfsdsdf")
            ud_rptr:=b2.Body_GetUserData(b2.Shape_GetBody(ShapeId))
            ud_ptr:=cast(^entity)(ud_rptr)
            proj_hp:f32
            mob_hp:f32
            new_proj_hp:f32
            new_mob_hp:f32


            #partial switch &type in ud_ptr.entity_type {
                case et_ai_mob: 
                mob_hp = type.stats_b.hp
            }
            d_rptr:=b2.Body_GetUserData(b2.Shape_GetBody(ptr^))
            d_ptr:=cast(^entity)(d_rptr)
            #partial switch &type in d_ptr.entity_type {
                case et_proj: 
                proj_hp = type.stats_b.hp
            }
            new_proj_hp = proj_hp - mob_hp
            if new_proj_hp < 0 {new_proj_hp = 0}
            new_mob_hp= mob_hp - proj_hp
            if new_mob_hp < 0 {new_mob_hp = 0}
            // fmt.print(mob_hp,"mob ")
            // fmt.print(proj_hp,"proj"," ")
            // fmt.print(new_mob_hp,"new_mob ")
            // fmt.print(new_proj_hp,"new_proj","\n")
            // delete_entity(ud_ptr.entity_index)
            #partial switch &type in d_ptr.entity_type {
                case et_proj: 
                type.stats_b.hp = new_proj_hp
            }
            #partial switch &type in ud_ptr.entity_type {
                case et_ai_mob: 
                type.stats_b.hp = new_mob_hp
            }
        }
    }
return true
}
player_colide_test::proc "cdecl" (ShapeId:b2.ShapeId,data:rawptr)->bool{
    context = runtime.default_context()
    ptr:=cast(^b2.ShapeId)(data)
    if ptr.index1 != ShapeId.index1{
        
        if ShapeId.index1 !=all_entitys.data[player_e_index.id].entity.shape_id.index1 {
            // fmt.print("fsdfsdfsdfsdsdf")
            ud_rptr:=b2.Body_GetUserData(b2.Shape_GetBody(ShapeId))
            ud_ptr:=cast(^entity)(ud_rptr)
            player_hp:f32
            mob_hp:f32
            player_fis_damage:f32
            mob_fis_damage:f32
            new_player_hp:f32
            new_mob_hp:f32
            is_mob_imune:bool
            is_player_imune:bool
            

            #partial switch &type in ud_ptr.entity_type {
                case et_ai_mob: 
                mob_hp = type.stats_b.hp
                mob_fis_damage = type.stats_b.fis_damage
                if type.stats_b.imunity_frames>0{ is_mob_imune = true}
            }
            d_rptr:=b2.Body_GetUserData(b2.Shape_GetBody(ptr^))
            d_ptr:=cast(^entity)(d_rptr)
            #partial switch &type in d_ptr.entity_type {
                case et_player: 
                player_hp = type.stats_b.hp
                player_fis_damage = type.stats_b.fis_damage
                if type.stats_b.imunity_frames>0{ is_player_imune = true}
            }
            new_player_hp = player_hp - mob_fis_damage
            if new_player_hp < 0 {new_player_hp = 0}
            new_mob_hp= mob_hp - player_fis_damage
            if new_mob_hp < 0 {new_mob_hp = 0}
            // fmt.print(mob_hp,"mob ")
            // fmt.print(player_hp,"player"," ")
            // fmt.print(new_mob_hp,"new_mob ")
            // fmt.print(new_player_hp,"new_player","\n")
            // delete_entity(ud_ptr.entity_index)
            
            #partial switch &type in d_ptr.entity_type {
                case et_player: 
                if !is_player_imune{
                    if !player_is_dashing{
                        type.stats_b.hp = new_player_hp
                        type.stats_b.imunity_frames = type.stats_b.imunity_time
                    }
                }
            }
            #partial switch &type in ud_ptr.entity_type {
                case et_ai_mob: 
                if !is_mob_imune{
                    if !game_over{
                        type.stats_b.hp = new_mob_hp
                        type.stats_b.imunity_frames = type.stats_b.imunity_time
                    }
                }
            }
        }
    }
return true
}

create_entity_by_id::proc(pos:[2]f32,entity_id:entity_id,sprite_id:sprite_id,light_id:light_id )->(entity_index:entity_index){
    if all_entitys.count < max_entity_c {
        n_entity :entity = defalt_entitys[entity_id].entity
        
        
        body_def : b2.BodyDef = b2.DefaultBodyDef()
        body_def.type = defalt_entitys[entity_id].body.body_type
        body_def.position = {pos.x,pos.y}
        body_def.angularDamping=1
        body_def.linearDamping=2
        // body_def.rotation = b2.MakeRot(rl.RAD2DEG * 180)
        shape_def :b2.ShapeDef = b2.DefaultShapeDef()
        shape_def.density = defalt_entitys[entity_id].body.density
        shape_def.friction = defalt_entitys[entity_id].body.friction
        shape_def.restitution = defalt_entitys[entity_id].body.restitution
        
        
        n_entity.pos = pos
        n_entity.body_id = b2.CreateBody(box_2d_world_id, body_def)
        switch n_entity.shape{
            case .box:
                n_entity.shape_id = b2.CreatePolygonShape(n_entity.body_id, shape_def, b2.MakeBox(defalt_entitys[entity_id].body.extent.x, defalt_entitys[entity_id].body.extent.y))
            case .circle:
                circle_def:b2.Circle
                circle_def.radius = defalt_entitys[entity_id].body.extent.x
                n_entity.shape_id = b2.CreateCircleShape(n_entity.body_id, shape_def,circle_def)
        }
                            
        entity_index := create_entity(n_entity)
            if entity_index.id > -1 {
            all_entitys.data[entity_index.id].entity.sprite_id = create_sprite(sprite = defalt_sprite_data[sprite_id])
            all_entitys.data[entity_index.id].entity.light_id = create_light(defalt_lights[light_id])
            }
        b2.Body_SetUserData(n_entity.body_id,&all_entitys.data[entity_index.id])
        return entity_index
        }
        entity_index = {-1,-1}
        return entity_index
    // append(&all_entitys, n_entity)
}

create_entity::proc(entity:entity)->(entity_id:entity_index){
    if !all_entitys.data[all_entitys.next_open_slot].is_occupied{
        all_entitys.count +=1
        all_entitys.data[all_entitys.next_open_slot].entity = entity
        all_entitys.data[all_entitys.next_open_slot].is_occupied = true
        // all_entitys.data[all_entitys.next_open_slot].gen += 1
        entity_id = {id = all_entitys.next_open_slot,gen = all_entitys.data[all_entitys.next_open_slot].gen}
        all_entitys.data[all_entitys.next_open_slot].entity.entity_index = entity_id
        if all_entitys.next_open_slot != max_entity_c-1{
            all_entitys.next_open_slot += 1
            for all_entitys.data[all_entitys.next_open_slot].is_occupied{
                if all_entitys.next_open_slot != max_entity_c-1{
                    all_entitys.next_open_slot += 1
                }else { break }
            }
        }

        if all_entitys.last_entity != max_entity_c-1 {
            for all_entitys.data[all_entitys.last_entity].is_occupied{
                if all_entitys.last_entity != max_entity_c-1{
                    all_entitys.last_entity += 1
                }else{break}
            }
        }    
        return entity_id
    }
    entity_id = {-1,-1}
    return entity_id
}
delete_entity::proc(entity_id:entity_index){
    
    if all_entitys.data[entity_id.id].gen == entity_id.gen&& all_entitys.data[entity_id.id].is_occupied{
        all_entitys.count -=1
        all_entitys.data[entity_id.id].is_occupied=false
        all_entitys.data[all_entitys.next_open_slot].gen += 1
        delete_sprite(all_entitys.data[entity_id.id].entity.sprite_id)
        delete_light(all_entitys.data[entity_id.id].entity.light_id)
        if b2.Body_IsValid(all_entitys.data[entity_id.id].entity.body_id){
            b2.DestroyBody(all_entitys.data[entity_id.id].entity.body_id)
        }
        if entity_id.id < all_entitys.next_open_slot{
            all_entitys.next_open_slot = entity_id.id 
        }
        if entity_id.id == all_entitys.last_entity {
            if all_entitys.last_entity != 0 {
                all_entitys.last_entity -= 1
                for !all_entitys.data[all_entitys.last_entity].is_occupied{
                    all_entitys.last_entity -= 1
                }
            }
        }
    }
}
dos_entity_exist::proc(entity_id:entity_index)->bool{
    if all_entitys.data[entity_id.id].gen == entity_id.gen&& all_entitys.data[entity_id.id].is_occupied{
        return true
    }
    return false
}


