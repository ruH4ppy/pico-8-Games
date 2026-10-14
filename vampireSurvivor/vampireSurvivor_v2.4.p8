pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	ipl()
	ipr()
	iene()
	playarea=200
	avoid=35
	
	act=1
end

function _update()
	if btnp(4) and act==1 then
		act=0
	elseif btnp(4) and act==0 then
		act=1
	end
	
	if act==1 then
		upl()
		upr()
		uene()
		enec()
	end
	
	inbound(pl,playarea)
end

function _draw()
		cls()
		
	if act==1 then
		rect(0,0,playarea,playarea)
		camera(pl.x-64,pl.y-64)
		print("hp:",pl.x-63,pl.y+58)
		print(pl.hp,pl.x-50,pl.y+58)
		
		dpl()
		dpr()
		dene()
		
		--debug
		print(pl.dirc,3,2)
		print(enetick,3,8)
		print(#pr,3,14)
		print(wave,3,20)
	end
	
	--inventory
	if act==0 then
		camera(1,1)
		rect(35,35,50,50)
	end
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
--init enemies
function iene()
	ene={}
	estat={
		hp=10,
		dmg=2,
		sp=8,
		speed=1,
		act=1
	}
	--1
	tank={}
	tankstat={
		hp=25,
		dmg=2,
		sp=40,
		speed=1,
		act=1
	}
	--2
	bomb={}
	bombstat={
		hp=10,
		dmg=15,
		sp=11,
		speed=1,
		act=1
	}
	
	enetick=0
	enemaxtick=120
	wave=0
	wavesize=3
	incwave=0
	spc_spsize=1
	spc_wavec=0
end

--update enemies
function uene()
	--pathing for each enemy
	path(ene,pl)
	path(tank,pl)
	
	--del each enemy if hp=0
	delene(ene)
	delene(tank)
	delene(bomb)
	
	--check projectle with each
	--enemy hit box (number is size)
	cpr(ene,pr,5)
	cpr(tank,pr,6)
	cpr(bomb,pr,5)
	
	--spawn first wave
	if wave==0 then
		wavespawn()
	end
	
	--increase wave size every 5 waves
	if wave-incwave==5 then
		wavesize+=1
		incwave+=5
	end
	
	--spawn tick + wave spawn
	if enetick<enemaxtick then
		enetick+=1
	else
		wavespawn()
		enetick=0		
	end
end

--draw enemies
function dene()
	for e in all(ene) do
		spr(e.sp,e.x,e.y)
	end
	for t in all(tank) do
		spr(t.sp,t.x,t.y)
	end
	for b in all(bomb) do
		spr(b.sp,b.x,b.y)
	end
end

---pathing for enemies
function path(e,p)
	local dx=0
	local dy=0
	
	for en in all(e) do
		dx=p.x-en.x
		dy=p.y-en.y
		if en.act==1 then
			if dx<0 then
				en.x-=en.speed
			end
			if dx>0 then
				en.x+=en.speed
			end
		
			if dy<0 then
				en.y-=en.speed
			end
			if dy>0 then
				en.y+=en.speed
			end
		end
	end
end

--spawn enemies as wavesize
function wavespawn()
	for i=1, wavesize do
		spawn(ene,estat,playarea,avoid)						
		spc_spawn()
	end
	wave+=1
end

--add enemy to array
function spawn(o,s,range,avoid)
	add(o,{
		x=rng(range,avoid),
		y=rng(range,avoid),
		sp=s.sp,
		hp=s.hp,
		dmg=s.dmg,
		speed=s.speed,
		act=s.act
		})
end

--special enemy spawn
function spc_spawn()
	if wave-spc_wavec==3 then						
		for j=1, spc_spsize do
			spc_e=rng(2,0)
				
			if spc_e==0 do
				spawn(tank,tankstat,playarea,
										avoid)
			elseif spc_e==1 do
				spawn(bomb,bombstat,playarea,
										avoid)
			end
		end
		spc_wavec+=3
	end
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
function delene(o)
	for e in all(o) do
		if e.hp<=0 then
			del(o,e)
		end
	end
end


-->8
--collisions
--projectile collision
function cpr(o,v,size)
	for e in all(o) do
		for p in all(v) do
			if abs(p.x-e.x)<size and
						abs(p.y-e.y)<size then
				e.hp=e.hp-p.dmg
			end
		end
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

--collision so enemies don't
--clump on one spott
function enec()
	local c=count(ene)
	
	for i=1,c do
		e1=ene[i]
		for j=i+1,c do
			e2=ene[j]
			
			if abs(e1.x-e2.x)<4 and 
						abs(e1.y-e2.y)<4 then
				
				--vergleich x
				if abs(min(e1.x)-pl.x)<abs(min(e2.x)-pl.x) then
					e1.x-=1
				else
					e2.x-=1
				end
				if abs(max(e1.x)-pl.x)<abs(max(e2.x)-pl.x) then
					e1.x+=1
				else
					e2.x+=1
				end
				--vergleich y
				if abs(min(e1.y)-pl.y)<abs(min(e2.y)-pl.y) then
					e1.y-=1
				else
					e2.y-=1
				end
				if abs(max(e1.y)-pl.y)<abs(max(e2.y)-pl.y) then
					e1.y+=1
				else
					e2.y+=1
				end
				
			end
		end
	end
end

--still need pickup collision

__gfx__
00000000000ff000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000007000000000000
00000000000ff000000000000000000000000000007a900000000000000000000777777000000000000000000eeeeee000000000000000000000700000000000
0070070000888800000000000000000000000000007a9000007a9000000000000777777000000000000000000eeeeee000000000000000000005550000000000
0007700000888800000000000777770000777770007a9000007a9000000000000777777000000000000000000eeeeee000000000000000000055555000000000
0007700000f88f0000000000aaaaaa0000aaaaaa007a9000007a9000000000000777777000000000000000000eeeeee000000000000000000055555000000000
00700700000cc000000000000999990000999990007a9000007a9000000000000777777000000000000000000eeeeee000000000000000000055555000000000
00000000000cc00000000000000000000000000000000000007a9000000000000777777000000000000000000eeeeee000000000000000000005550000000000
00000000000ff00000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005555555500000000000000000000000000000000000000000000000000000000
