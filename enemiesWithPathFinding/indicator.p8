pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	ipl()
	ipr()
	iene()
	playarea=200
	avoid=35
end

function _update()
	upl()
	upr()
	uene()
	
	inbound(pl,playarea)
end

function _draw()
	cls()
	rect(0,0,playarea,playarea)
	camera(pl.x-64,pl.y-64)

	dpl()
	dpr()
	dene()
	
	--debug
	print(pl.hp)
	print(pl.dirc)
	print(enetick)
	print(#pr)
	print(wave)
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
		sdirc=0,
		hp=100,
		tickpr=0,
		firerate=10,
		lockd=0
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
	
	if btn(0) and btn(2) then
		pl.dirc=4
	end
	if btn(1) and btn(2) then
		pl.dirc=5
	end
	if btn(0) and btn(3) then
		pl.dirc=6
	end
	if btn(1) and btn(3) then
		pl.dirc=7
	end
	
 --lock direction
	if btnp(5) and pl.lockd==0 then
		pl.sdirc=pl.dirc
		pl.lockd=1
	elseif btnp(5) and pl.lockd==1 then
		pl.lockd=0
	end
	
	--fire in locked direction
	if pl.lockd==1 then
		pl.dirc=pl.sdirc
	end
	
	--fire rate
	if pl.tickpr<pl.firerate then
		pl.tickpr+=1
	else
		shoot()
		pl.tickpr=0
	end
	
	--player takes damage
	for e in all(ene) do
		cpr(pl,e)
	end
end

function dpl()
	spr(pl.sp,pl.x,pl.y)
	--lock indicator
	if pl.lockd==1 then
		rectfill(pl.x+4,pl.y-3,pl.x+3,pl.y-2)
	end
end
-->8
--shoot
function ipr()
	pr={
	}
	prstat={
		speed=3,
		sp=19,
		dmg=2
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
		
		if p.dirc==4 then
			p.x=p.x-p.speed
			p.y=p.y-p.speed
		end
		if p.dirc==5 then
			p.x=p.x+p.speed
			p.y=p.y-p.speed
		end
		if p.dirc==6 then
			p.y=p.y+p.speed
			p.x=p.x-p.speed
		end
		if p.dirc==7 then
			p.y=p.y+p.speed
			p.x=p.x+p.speed
		end	
		
		--delete pr off screen	
		if p.x>playarea or p.x<0 then
			del(pr,p)
		end
		if p.y>playarea-6 or p.y<0 then
			del(pr,p)
		end
	end
end

function dpr()
	for p in all(pr) do
		spr(p.sp,p.x,p.y)
	end	
end
--add projectile to array
function shoot()
	add(pr,{
		x=pl.x,
		y=pl.y,
		dirc=pl.dirc,
		speed=prstat.speed,
		sp=prstat.sp,
		dmg=prstat.dmg
	})
end
-->8
--enemy
function iene()
	ene={}
	estat={
		hp=10,
		dmg=2,
		sp=8
	}
	
	enetick=0
	enemaxtick=120
	wave=0
	wavesize=3
	incwave=0
	
end

function uene()
	path(ene,pl)
	
	if wave==0 then
		wavespawn()
	end
	
	if wave-incwave==5 then
		wavesize+=1
		incwave=incwave+5
	end
	
	if enetick<enemaxtick then
		enetick+=1
	else
		wavespawn()
		enetick=0		
	end
	
	for e in all(ene) do
		delene(ene,e)
	
		for p in all(pr) do
			cpr(e,p)
		end
	end 
end

function dene()
	for e in all(ene) do
		spr(e.sp,e.x,e.y)
	end
end
---pathing for enemies
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
--spawn enemies as wavesize
function wavespawn()
	local i=0
	while i<wavesize do
		spawn(ene,estat.sp,playarea,
								avoid)
		i+=1
	end
	wave+=1
	i=0
end
--add enemy to array
function spawn(o,s,range,avoid)
	add(o,{
		x=rng(range,avoid),
		y=rng(range,avoid),
		sp=s,
		hp=estat.hp,
		dmg=estat.dmg
		})
end
--rng for enemy pos spawn
function rng(range,avoid)
	local rn=0
	rn=flr(rnd(range))
	while rn>pl.x-avoid and rn<pl.x+avoid or
							rn>pl.y-avoid and rn<pl.y+avoid do
		
		rn=flr(rnd(range))
	end
	return rn		
end
--delete enemy on 0 hp
function delene(o,e)
	if e.hp<=0 then
		del(o,e)
	end
end
-->8
--collisions
--projectile collision
function cpr(v,o)
	if abs(v.x-o.x)<5 and
				abs(v.y-o.y)<5 then
		v.hp=v.hp-o.dmg
	end
end
-- player inbound collision
function inbound(o,a)
	local lx1=pl.x-2
	local lx2=pl.x+2
	local ly1=pl.y-2
	local ly2=pl.y+2
		
	if o.x>a-5 then
		pl.x=lx1
	end
	if o.x<-2 then
		pl.x=lx2
	end
	if o.y>a-7 then
		pl.y=ly1
	end
	if o.y<0 then
		pl.y=ly2
	end
end

--still need pickup collision
__gfx__
00000000000ff000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff000000000000000000000000000007a900000000000000000000777777000000000000000000000000000000000000000000000000000000000
0070070000888800000000000000000000000000007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
0007700000888800000000000777770000777770007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
0007700000f88f0000000000aaaaaa0000aaaaaa007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
00700700000cc000000000000999990000999990007a9000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
00000000000cc00000000000000000000000000000000000007a9000000000000777777000000000000000000000000000000000000000000000000000000000
00000000000ff00000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
