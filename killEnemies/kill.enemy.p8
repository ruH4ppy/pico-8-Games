pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--main functions
function _init()
	ipl()
	iproj()
	iene()
	game=0
	score=0
end

function _update()
	upl()
	uproj()
	uene()
	wave()
	--gameover
	if pl.hp<=0 then
		game=1
	end
	
	if btn(❎) then
		game=1
	end
	
end

function _draw()
	cls(1)
	print("player hp:")
	print(pl.hp)
	print("score:")
	print(score)
	dpl()
	dproj()
	dene()
	
	if game==1 then
		print("gameover",50,40,8)
		print("your endscore was",35,50,6)
		print(score,62,60,6)
	end
	--debug
	print(#projr)
	print(collition())
--	print(#projl)
	print(sr)
end
-->8
--player
function ipl()
	pl={
	x=5,
	y=63,
	hp=100,
	d=1
	}
	tick=0
	maxtick=5
end

function upl()
	--pl movement
	
--	if btn(0) then
--		pl.x-=2
--		pl.d=0
--	end
--	if btn(1) then
--		pl.x+=2
--		pl.d=1
--	end
	--save last position
	local lyu=pl.y+2
	local lyd=pl.y-2
	--if collition true
	--then set pl to last position
	if collition()==1 then
		pl.y=lyu
	elseif collition()==2 then
		pl.y=lyd
	end
	
	if btn(2) then
		pl.y-=2
	end
	if btn(3) then
		pl.y+=2
	end
	--pl shoot
--	if btnp(❎) then
--		shoot()
--	end
	--shoot
	if tick<maxtick and game==0 then
		tick+=1
	elseif tick==maxtick 
	and game==0 then
		shoot()
		tick=0
	end
	
end

function dpl()
	spr(1,pl.x,pl.y)
end

function collition()
	--up and down collition
	--detection
	if pl.y<=0 then
		return 1
	elseif pl.y>=120 then
		return 2
	else
		return 0
	end
end
-->8
--projectile
function iproj()
	projr={}
	projl={}
end

function uproj()
		--move proj left and right
		--delete if off screen
		for p in all(projl) do
			p.x=p.x-2
				if p.x>128 or	p.x<0 then
					del(projl,p)
				end
		end
	
		for p in all(projr) do
			p.x=p.x+2
				if p.x>128 or	p.x<0 then
					del(projr,p)
				end
		end
		
		if game==1 then
			for p in all(projr) do
				del(projr,p)
			end
		end
end

function dproj()
	--draw proj left + right
	for p in all(projl) do
		spr(3,p.x,p.y)
	end
	for p in all(projr) do
		spr(2,p.x,p.y)
	end
end

function shoot()
	--shoot left
	if pl.d==0 then
		add(projl,{
			x=pl.x-4,
			y=pl.y,
			dmg=5
		})
	end
	--shoot right
	if pl.d==1 then
		add(projr,{
			x=pl.x+4,
			y=pl.y,
			dmg=5
		})
	end
end
-->8
--enemy
function iene()
	ene={
	speed=0.333
	}
	maxsr=90
	minsr=40
	sr=maxsr
	isr=2
	
end

function uene()
	for e in all(ene) do
		e.x-=ene.speed
		--collition projr
		for p in all(projr) do
			if abs(e.x-p.x)<5 and
						abs(e.y-p.y)<5 then
				e.hp=e.hp-p.dmg
				del(projr,p)
			end
		end
		--collition projl
		for p in all(projl) do
			if abs(e.x-p.x)<5 and
						abs(e.y-p.y)<5 then
				e.hp=e.hp-p.dmg
				del(projl,p)
			end
		end
		--delete enemy when hp is 0
		if e.hp<=0 then
			del(ene,e)
			score+=1		
		end
		--player takes damage
		if e.x<=0 then
			pl.hp=pl.hp-10
			del(ene,e)
		end
	end
	
end

function dene()
	--draw all enemies
	for e in all(ene) do
		spr(17,e.x,e.y)
	end
	
end
-->8
--spawn waves
function wave()
 local sp=5
	
	if spawrate() then
		sp=sp+flr(rnd(115))
		add(ene,{x=125,y=sp,hp=10})
		sp=5
		
		sp=sp+flr(rnd(115))
		add(ene,{x=125,y=sp,hp=10})
		sp=5
		
		sp=sp+flr(rnd(115))
		add(ene,{x=125,y=sp,hp=10})
		sp=5
	end
end

function spawrate()
	if sr<maxsr then
		sr=sr+1
	else
		sr=0
		if maxsr>minsr then
			maxsr=maxsr-isr
		end
		return true
	end
end
__gfx__
00000000000ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000008888000777770000777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000f88f000aaaaaa00aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000cc0000999990000999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000711771170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
