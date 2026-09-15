pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
--player
		a1x,a1y = 40,20
		a2x,a2y = 45,25
--apple
		b1x,b1y = -5,-5
		b2x,b2y	= -2,-2
--collition check		
		check = 1
--random number
		i = 0
--bewegungs richtung		
		rich = 3
--score
		s = 0
end

function _update60()

--new player movement
		if btn(0) then
				rich = 0
		elseif btn(1) then
				rich = 1
		elseif btn(2) then
				rich = 2	
		elseif btn(3) then
				rich = 3
		end
		
		if rich == 0 then
				a1x -= 1
				a2x -= 1
		elseif rich == 1 then
				a1x += 1
				a2x += 1
		elseif rich == 2 then
				a1y -= 1
				a2y -= 1
		elseif rich == 3 then
				a1y += 1
				a2y += 1
		end
		
		
		--collition check
		if 				a1x > b2x then
		elseif a1y > b2y then
		elseif a2x < b1x then
		elseif a2y < b1y then
		else 
				check = 1
				sfx(0)
				s += 1	
				b1x,b1y,b2x,b2y=-5,-5,-2,-2
		end
--teleport to the other wall
		if a1x < 0 then
				a1x = 123
				a2x	= 128
		end
		if a2x > 128 then
				a1x = 0
				a2x	= 5
		end
		if a1y < 0 then
				a1y = 123
				a2y = 128
		end
		if a2y > 128 then
				a1y = 0
				a2y = 5
		end
end

function _draw()
		cls(1)
		print(i,50,30,11)
		print("score:",40,40,11)
		print(s,65,40,11)
		--player
		rectfill(a1x,a1y,a2x,a2y,14)
		
		--randomized apple
		if check < 1 then		
				rectfill(b1x,b1y,b2x,b2y,8)
		else
				--randomiz position
				i = flr(rnd(126))			
				if i < 15 then
				 	i = flr(rnd(126))
				end
				--min abstand zum player
				while 
						i < a1x+35 and
						i > a1x-35 or
						i < a1y+35 and
				 	i > a1y-35 do
				 			i = flr(rnd(126))
				 					if i < 15 then
				 							i = flr(rnd(126))
				 					end
				end
				b1x += i			
				b2x += i			
				b1y += i			
				b2y += i
									
				check -= 1	
		end
		
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400001b000200002401027010280102a0102b0202b0402b0302b0402b040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
