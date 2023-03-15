pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--fishy
--by nerdy teachers

--init
function _init()
    --player table
    player={
        x = 60,
        y = 60,
		w = 0,
		h = 0,
        size = 2,
		sx = 0,
		sy = 0,
        dx = 0,
        dy = 0,
        speed = 0.08,
		flp = false
    }
    --player
	set_sprite(player)
		
    --game settings
    enemies = {}
    max_enemies = 10
    max_enemy_size = 10
    max_enemy_speed = 1
    win_size = 10
	
    
end

-->8
--update
function _update()
    --player controls
    if btn(⬅️) then player.dx -= player.speed player.flp=true end
    if btn(➡️) then player.dx += player.speed player.flp=false end
    if btn(⬆️) then player.dy -= player.speed end
    if btn(⬇️) then player.dy += player.speed end

    --player movement
    player.x += player.dx
    player.y += player.dy

    --screen edges
    if player.x > 127 then player.x = 127 end
    if player.x < 0 then player.x = 0 end
    if player.y+player.h > 120 then player.y = 120-player.h player.dy = 0 end
    if player.y < 0 then player.y = 0 player.dy = 0 end
	
    --enemy update
    create_enemies()

    for enemy in all(enemies) do
        --movement
        enemy.x += enemy.dx

        --delete enemies
        if enemy.x > 200
        or enemy.x < -70 then
            del(enemies,enemy)
        end
	
        --collide with player
        if collide_obj(player,enemy) then
            --compare size
            if flr(player.size) > enemy.size then
                --add to player based on size
                player.size += flr((enemy.size/2)+.5) / (player.size*2)
                
				--set sprite based on size
				player = set_sprite(player)
				
                sfx(0)
                del(enemies,enemy)
            else
                sfx(1)
                _init()
            end
        end
    end
    
    --win
    if player.size > win_size then
        if btn(4) or btn(5) then _init() end
    end
end

-->8
--draw
function _draw()
    cls(0)
    draw_stars()
	--sand
	rectfill(0,120,127,127,7)
	
	--rocks
	circfill(8,120,5,6)
	circfill(5,123,3,5)
	circfill(100,122,4,6)
	circfill(122,118,6,6)
	circfill(116,120,3,5)
	
    sspr(player.sx,player.sy,player.w,player.h,player.x,player.y,player.w,player.h,player.flp)
	
    --enemies
    for enemy in all(enemies) do
		pal(9,enemy.c)
		sspr(enemy.sx,enemy.sy,enemy.w,enemy.h,enemy.x,enemy.y,enemy.w,enemy.h,enemy.flp)
    end
	pal()
	
    --score
    rectfill(2,3,22,10,0)
    rectfill(2,4,2+(player.size-flr(player.size))*20,9,8)
	
    --win
    if player.size > win_size then
        rectfill(0,55,127,75,10)
        print("congratulations!!!",28,56,1)
        print("you became",43,63,1)
        print("the biggest fish!",20,70,1)
    end

end

-->8
--collision

function collide_obj(obj, other)
	if  other.x+other.w > obj.x
	and other.y+other.h > obj.y
	and other.x < obj.x+obj.w
	and other.y < obj.y+obj.h
	then
		return true
	end
end

-->8
--enemies

function create_enemies()
    if #enemies < max_enemies then
        --local variables
        local x = 0	 local y = 0
        local dx = 0
        local size = flr(rnd((max_enemy_size+player.size)/2))+1
		local flp = false
		local c = flr(rnd(7))+1
		
        --random start position
        place = flr(rnd(2))
        if place == 0 then
            --left
            x = flr(rnd(16)-64)
            y = flr(rnd(115))
            dx = rnd(max_enemy_speed)+.25
			flp = false
        elseif place == 1 then
            --right
            x = flr(rnd(48)+128)
            y = flr(rnd(115))
            dx = -rnd(max_enemy_speed)-.25
			flp = true
        end
		
        --make enemy table
        local enemy = {
			sx = 0,
			sy = 0,
            x = x,
            y = y,
			w = 0,
			h = 0,
			c = c,
            dx = dx,
            size = size,
			flp = flp
        }
		
		--set sprite based on size
		enemy = set_sprite(enemy)
		
        --add it to enemies table
        add(enemies,enemy)
    end
end


-->8
--sprites

function set_sprite(obj)	
	if flr(obj.size) <= 1 then 
		obj.sx = 0 obj.sy = 0
		obj.w = 4  obj.h = 3
	elseif flr(obj.size) == 2 then
		obj.sx = 5 obj.sy = 0
		obj.w = 4  obj.h = 4
	elseif flr(obj.size) == 3 then
		obj.sx = 9 obj.sy = 0
		obj.w = 6  obj.h = 5
	elseif flr(obj.size) == 4 then
		obj.sx = 15 obj.sy = 0
		obj.w = 9   obj.h = 7
	elseif flr(obj.size) == 5 then
		obj.sx = 24 obj.sy = 0
		obj.w = 14  obj.h = 9
	elseif flr(obj.size) == 6 then
		obj.sx = 38 obj.sy = 0
		obj.w = 14  obj.h = 10
	elseif flr(obj.size) == 7 then
		obj.sx = 52 obj.sy = 0
		obj.w = 16  obj.h = 12
	elseif flr(obj.size) == 8 then
		obj.sx = 68 obj.sy = 0
		obj.w = 15  obj.h = 15
	elseif flr(obj.size) == 9 then
		obj.sx = 83 obj.sy = 0
		obj.w = 19  obj.h = 16
	elseif flr(obj.size) == 10 then
		obj.sx = 102 obj.sy = 0
		obj.w = 26  obj.h = 17
	else
		obj.sx = 102 obj.sy = 0
		obj.w = 26  obj.h = 17
	end
	
	return obj
end
function rndb(low,high)
    return flr(rnd(high-low+1)+low)
    end
    
    function draw_stars() -- define draw_stars function
    srand(1) --P8 to ensure same random number each redraw
    
    for i=1,50 do
        pset(rndb(0,127),rndb(0,127),rndb(5,7))
    end
    
    srand(time())
end

__gfx__
0bb00b7b00bbbb000bbbbb0000bbbbbbbbbb0000bbbbbbbbbb00000bbbbbbbbbb000000bbbbbbbbb00000000bbbbbbbbb000000000000bbbbbbbbbbbb0000000
b70bb707bbb77bb0bb770bb00bbbbbb777bbbb0bbbbbb7777bb000bbbbbbbbbbbb0000bbbbbbbbbbb00000bbbbbbbbbbbbb00000000bbbbbbbbbbbbbbbb00000
bbbbbbbbbbb70bbbbb700bbbbbbbbbb700bbbbbbbbbbb7700bbb0bbbbbbbbb77bbb00bbbbbbbbbbbbb000bbbbbbbbbbbbbbb00000bbbbbbbbb777bbbbbbbb000
0000b0b0bbbbbb0bbbbbbbbbbbbbbbb700bbbbbbbbbbb7700bbbbbbbbbbbb7777bbbbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbbbb000bbbbbbbbb77007bbbbbbbb00
000000000b0b0b0b0b0b0b0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7700bbbbbbbbbbbb77bbbbbbbbbbbbb777bbbbbbb00bbbbbbbb7700007bbbbbbb00
000000000000000b0b0b0b0bb0bbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbb7700bbbbbbbbbbb7700bbbbbbbbbbb77000bbbbbb0bbbbbbbbb7700007bbbbbbbb0
00000000000000000b0b0b00b0b0bbbbbbb0b0b0bbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbb7700bbbbbbbbbbb77000bbbbbb0bbbbbbbbbb77007bbbbbbbbb0
00000000000000000000000000b0b0b0b0b0b0b0b0bbbbbbb0b0bbbbbbbbbbbbbbbbbbbbbbbb7000bbbbbbbbbbb77000bbbbbbbbbbbbbbbbbb777bbbbbbbbbb0
0000000000000000000000000000b0b0b0b000b0b0b0b0b0b0b0b0bbbbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbb777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0
0000000000000000000000000000000000000000b0b0b0b0b0b0b0b0bbbbbbbbb0b0bbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbb0bb0bbbbbbbbbbbbbbbbbbbbb0b0
000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0b0bbbbbbbbbbb0bb0bbbbbbbbbbbbbbb0bb0bbbbbbbbbbbbbbbbbbbbb0b0
00000000000000000000000000000000000000000000000000000000b0b0b0b0b000b0b0bbbbbbb0b0bb0b0bbbbbbbbbbb0b0bb0b0bbbbbbbbbbbbbbbbb0b0b0
00000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0bb0b0b0bbbbbbb0b0b0bb0b0b0b0bbbbbbbbb0b0b0b0b0
0000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0000b0b0b0b0b0b0b0b00b0b0b0b0b0b0b0b0b0b0b0b0b0
000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b00000000b0b0b0b0b0b000000b0b0b0b0b0b0b0b0b0b0b000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0000000000b0b0b0b0b0b0b0b0b00000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0b0b0b0b0b0b0000000
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc888888880000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc888888880000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc888888880000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc888888880000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc888888880000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc888888880000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc000000000000000000000ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccc88cccccc8cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc888ccccc81cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccc11118888cccc811cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccc1117111111cc8111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccc1111111a11a8111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccc111111a111a811accccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccc11111111a1a811acccccccccccccc4ca4ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccc11111a11a8111cccccccccccc44444cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccc11aaaaaaaacc8111ccccccccccc4144ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccc88ccc888ccc811cccccccccccaaaa4cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccc8cccc88cccc81ccccccccccccccca4ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccc8ccccc8cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccc111cccccecccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc1e1cccceeccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccc1e1cc111111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccc11e1c1117111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccc11e11a11111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccc11e11111111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccc11e1a11111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccc1e1ccaaaa111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc1e1ccceeccaaaccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccc111cccceccceccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccccfcccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5cc5555cccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf5555155ccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf5a555cccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf5555555ccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5cffcfccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5ccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccc9ac9cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccc99999cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccc9919cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccc9aaaaccccccccccccccccccccccccccccccccccccc7ca7ccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccc9accccccccccccccccccccccccccccccccccccccc77777cccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7177ccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccaaaa7cccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccca7ccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7ccccfccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7cc7777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf7777177cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf7a777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf7777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7cffcfcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccc1ca1ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccc11111cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccc1111ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccaaaa1cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc3cccccccccccccccccccccccccccccccccca1ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cc3bccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3ccccccccccccccc3cc
cc3bcccc3ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1ccccfccccc3bcccccccccccccc3bc
cc3bcccc3bccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1cc1111ccc3bccccccccc3cccc3bc
cc3bcccc3bcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf1111111cc3bccccccccc3bccc3bc
cccbcccc3bccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf1a111ccc3bccccccccc3bccc3bc
ccc3bccc3bcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccf1111111cc3bccccccccc3bccc3bc
ccc3bccc3bccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1cffcfcccc3bccccccccc3bcc3cbc
ccc3bcc3cbcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1cccccccccc3bccccccccc3bcc3bcc
ccc3bcc3bcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bccccccccc3bcc3bcc
ccc3bcc3bcccccccc6ccccfcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bccccccccc3bcc3bcc
ccc3bcc3bccccccccc6cc6666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bccccccccc66666bcc
ccc3bcc3bcccccccccf6666166ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bcccccccc6666666cc
ccc3bcc3bccccccccccf6a666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccbccccccc666666666c
ccc3bcdddddcccccccf6666666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bccccc66666666666
ccccbdddddddcccccc6cffcfcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bcccc666666666666
ccccdddddddddcccc6cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3bccc5556666666666
cccdddddddddddcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddcccccccc3bcc55555666666666
cccdddddddddddcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddcccccc3bc555555566666666
fffd555dddddddfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddddffffff3bf555555566666666
fff55555ddddddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddddddfffff3bf555555566666666
ff5555555dddddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddddddfffff3bff5555566666666f
ff5555555ddddfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddddddfffff3bfff555f6666666ff
ff5555555dddfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddddffffff3bffffffff66666fff
fff55555dddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddddffffff3bffffffffffffffff
ffff555ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddfffffffffbffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

__sfx__
010300000050216534005040e544025040d5540d0000f544005041c55400502005020050200502005020050200502005020050200402004020040200502005020050200502005020050200502005020050200502
00040000005071b5571b5571b55701507015070050712557125571255701507005070d5570d5570d5570450705507005070b5270b5370b5470a55707557065570555704557045570455703557035070350700507
011000000c5570c5470c53700000000000000000000000000c5570c5470c53700000000000000000000000000c5570c5470c53700000000000000000000000000c5570c5470c5370000000000000000000000000
011000001055710547105370000700007000070000700007105571054710537000070000700007000070000710557105471053700007000070000700007000071055710547105370000700007000070000700007
011000001355713547135370000000000000000000000000135571354713537000000000000000000000000013557135471353700000000000000000000000001355713547135370000000000000000000000000
011000000c5570c5470c53700000105500000013550000000c5570c5470c53700000105500000013550000000c5570c5470c53700000105500000013550000000c5570c5470c5370000010550000001355000000
__music__
00 02424344
00 03424344
00 04424344
00 05424344

