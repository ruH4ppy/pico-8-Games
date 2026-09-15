pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	ipl()
	ien()
	iproj()
end

function _update()
	upl()
	uproj()
	killen(pl,en)
	
	if btnp(❎) then
		fire()
	end
end

function _draw()
	cls(1)
	dpl()
	den()
	dproj()
	print(en.hp,45,25,8)
	print(#proj,8)
end
-->8
--player
function ipl()
	pl={
	x0=50,
	y0=80,
	x1=53,
	y1=87,
	hp=100
	}	
end

function upl()
	movepl(pl)
end

function dpl()
	rectfill(pl.x0,pl.y0,pl.x1,
										pl.y1,2)
	spr(1,pl.x0-2,pl.y0)	
end


-->8
--move player
function movepl(o)
	if btn(0) then
		o.x0 -= 1
		o.x1 -= 1
	end
	if btn(1) then
		o.x0 += 1
		o.x1 += 1
	end
	if btn(2) then
		o.y0 -= 1
		o.y1 -= 1
	end
	if btn(3) then
		o.y0 += 1
		o.y1 += 1
	end
end


-->8
--enemy
function ien()
	en={
	x0=10,
	y0=10,
	x1=15,
	y1=15,
	hp=10
	}
end

function uen()
	
end

function den()
	rectfill(en.x0,en.y0,en.x1,
										en.y1,8)
end
-->8
--collition + despawn en
function killen(o,p)
	if collition(o,p) then
		p.hp -= 1
	end
	if p.hp <= 0 then
		p.x0=-10
		p.y0=-10
		p.x1=-5
		p.y1=-5
	end
end

--collition
function collition(o,p)
	if	o.x0 > p.x1 or
				o.y0 > p.y1 or
				o.x1 < p.x0 or
				o.y1 < p.y0 then
	else
		return true
	end 
end
-->8
--bullets
function	iproj()
	proj={}
end

function	uproj(o,p)
	for b in all(proj) do
		b.x=b.x+2
		if b.x>128 or b.x<0 then
			del(proj,b)
		end
	end
end

function	dproj()
	for b in all(proj) do
		rectfill(b.x+1,b.y+2,
											b.x+6,b.y+4,0)
		spr(2,b.x,b.y)
	end
end

function fire()
		add(proj,{
			x=pl.x0,
			y=pl.y0
		})
end
__gfx__
00000000000ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000008888000aaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000008888000777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000fccf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
