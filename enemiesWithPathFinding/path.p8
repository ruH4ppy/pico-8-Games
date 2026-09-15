pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	ipl()
	ipr()
	iene()
end

function _update()
	upl()
	upr()
	uene()
end

function _draw()
	cls()
	dpl()
	dpr()
	dene()
	
	--debug
	print(pl.dirc)
	print(tick)
	print(#pr)
end
-->8
--player
function ipl()
	pl={
		x=50,
		y=50,
		sp=1,
		speed=2,
		dirc=0,
		hp=100
	}
end

function upl()
	if btn(0) then
		pl.x-=pl.speed
		pl.dirc=0
	end
	if btn(1) then
		pl.x+=pl.speed
		pl.dirc=1
	end
	if btn(2) then
		pl.y-=pl.speed
		pl.dirc=2
	end
	if btn(3) then
		pl.y+=pl.speed
		pl.dirc=3
	end
	
	if btnp(❎) then
		shoot()
	end
end

function dpl()
	spr(pl.sp,pl.x,pl.y)
end
-->8
--shoot
function ipr()
	pr={
	}
end

function upr()
	for p in all(pr) do
		--move pr in dirc
		if p.dirc==0 then
			p.x=p.x-p.speed
		end
		if p.dirc==1 then
			p.x=p.x+p.speed
		end
		if p.dirc==2 then
			p.y=p.y-p.speed
		end
		if p.dirc==3 then
			p.y=p.y+p.speed
		end	
		
		--delete pr off screen	
		if p.x>128 or p.x<0 then
			del(pr,p)
		end
		if p.y>128 or p.y<0 then
			del(pr,p)
		end
	end
end

function dpr()
	for p in all(pr) do
		spr(p.sp,p.x,p.y)
	end	
end

function shoot()
		if pl.dirc==0 then
			addpr(3)
		end
		if pl.dirc==1 then
			addpr(4)
		end
		if pl.dirc==2 then
		 addpr(5)
		end
		if pl.dirc==3 then
		 addpr(6)
		end
end

function addpr(o)
	add(pr,{
		x=pl.x,
		y=pl.y,
		speed=2,
		dirc=pl.dirc,
		sp=o,
		dmg=5
	})
end
-->8
--enemy
function iene()
	ene={}
	tick=0
	maxtick=120
end

function uene()
	if tick<maxtick then
		tick+=1
	else
		spawn(ene)
		tick=0
	end
	path(ene,pl)
end

function dene()
	for e in all(ene) do
		spr(e.sp,e.x,e.y)
	end
end

function spawn(o)
	add(o,{
		x=20,
		y=20,
		sp=8,
		})
end

function path(e,p)
	local dx=0
	local dy=0
	
	for en in all(e) do
		dx=p.x-en.x
		dy=p.y-en.y
		
		if dx<0 then
			en.x-=1
		end
		if dx>0 then
			en.x+=1
		end
		
		if dy<0 then
			en.y-=1
		end
		if dy>0 then
			en.y+=1
		end
	end
end
__gfx__
00000000000ff000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff000000000000000000000000000007a900000000000000000000777777000000000000000000000000000000000000000000000000000000000
0070070000cccc00000000000000000000000000007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
0007700000cccc00000000000777770000777770007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
0007700000fccf0000000000aaaaaa0000aaaaaa007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
0070070000088000000000000999990000999990007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
000000000008800000000000000000000000000000000000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
00000000000ff00000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000
