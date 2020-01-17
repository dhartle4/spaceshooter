pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 t = 0
 ship = {
  sp = 1,
  x = 60,
  y = 100,
  health = 3,
  points = 0,
  box = {x1 = 0, y1 = 0, x2 = 7, y2 = 7},
 }
 bullets = {}
 enemies = {}
 for i = 1,7 do
  add(enemies, {
   sp = 4,
   m_x = i * 16,
   m_y = 10,
   x = -32,
   y = -32,
   r = 12,
   box = {x1 = 0, y1 = 0, x2 = 7, y2 = 7},
  })
 end
end

function _update()
 t = t + 1
-- ship thrusters and controls
 if(t % 6 < 3) then
  ship.sp=1
 else
  ship.sp=2
 end
 if btn(0) then ship.x-=1 end
 if btn(1) then ship.x+=1 end
 if btn(2) then ship.y-=1 end
 if btn(3) then ship.y+=1 end
 if btnp(4) then fire() end
 -- enemy thrusters and movement
 for enemy in all(enemies) do
  if(t % 20 < 10) then
   enemy.sp=4
  else
   enemy.sp=5
  end
  enemy.x = enemy.r*sin(t/50) + enemy.m_x
  enemy.y = enemy.r*cos(t/50) + enemy.m_y
 end
--  bullet control
 for b in all(bullets) do
  b.x+=b.dx
  b.y+=b.dy
  if b.x < 0 or b.x > 128 or b.y < 0 or b.y > 128 then
   del(bullets, b)
  end
  for enemy in all(enemies) do
   if collide(enemy, b) then
    del (enemies, enemy)
    ship.points += 1
   end
  end
 end
end

function _draw()
 cls()
-- ship
 print(ship.points, 9)
 spr(ship.sp, ship.x, ship.y)
 for i = 1, 4 do
  if i <= ship.health then
   spr(6,80+6*i,3)
  else
   spr(7,80+6*i,3)
  end
 end
-- bullet
 for b in all(bullets) do
  spr(b.sp, b.x, b.y)
 end
 -- enemies
 for enemy in all(enemies) do
  spr(enemy.sp, enemy.x, enemy.y)
  if collide(enemy, ship) then
   --todo
  end
 end
end

function fire()
 -- creates a bullet and adds it to the current bullets list
 local b = {
 sp = 3,
 x = ship.x,
 y = ship.y,
 dx = 0,
 dy = -3,
 box = {x1=2,y1=0,x2=5,y2=4}
 }
 add(bullets, b)
end

function collide(object_1, object_2)
 hitbox_1 = locate_hitbox(object_1)
 hitbox_2 = locate_hitbox(object_2)
end

function locate_hitbox(object)
 -- finds a hitboxes location on the screen based on the passed in object
 local box = {}
 box.x1 = object.box.x1 + object.x
 box.y1 = object.box.y1 + object.y
 box.x2 = object.box.x2 + object.x
 box.y2 = object.box.y2 + object.y
 return box
end
__gfx__
000000000010010000100100000bb000000000000000a0000e080000060500000000000000000000000000000000000000000000000000000000000000000000
000000000010010000100100000b300050000005500a0005ee888000665550000000000000000000000000000000000000000000000000000000000000000000
000000000010010000100100000300005000a00550009005e8888000655550000000000000000000000000000000000000000000000000000000000000000000
00000000011111100111111000000000550990555509905508880000055500000000000000000000000000000000000000000000000000000000000000000000
00000000001661000016610000000000050880500508805000800000005000000000000000000000000000000000000000000000000000000000000000000000
00000000011881100118811000000000055555500555555000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000900000000900000000000005dd500005dd50000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000090000009000000000000000550000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000
