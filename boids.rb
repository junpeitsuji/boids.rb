#!/usr/local/rvm/rubies/default/bin/ruby --
# -*- coding: utf-8 -*-

######################################################
# Ruby で boids シミュレーション                     #
# @auther Junpei Tsuji <junpei.tsuji.0509@gmail.com> #
######################################################


# Simulation parameters
NUM_OF_BOIDS    = 100
FLAME_INTERVALS = 20
NUM_OF_SIMULATION_STEPS = 100

# Boids parameters
MAXSPEED = 5
DISTANCE = 15


# Boid class definition
class Boid 
	# initializer
	def initialize id,x,y,vx,vy,alive
		@id = id
		@x = x
		@y = y
		@vx = vx
		@vy = vy
		@alive = alive
	end

	attr_reader :id, :x, :y, :vx, :vy, :alive

	# 出力用
	def to_s
		"#{@id},#{@x},#{@y},#{@vx},#{@vy},#{@alive}"
	end


	# ルール1: すべての boid は群れの中心に向かおうとする
	def rule1
		# 中心座標
		cx = 0
		cy = 0

		# 生きている boid の数を数える
		aliveCount = 0 

		$boids.each do |other|
			if @id != other.id then
				if other.alive then
					cx += other.x
					cy += other.y

					aliveCount += 1
				end
			end
		end

		# 残りの boid の数が 2 以上のとき
		if aliveCount > 1 then
			cx /= (aliveCount - 1)
			cy /= (aliveCount - 1)

			@vx += (cx - @x) / 1000
			@vy += (cy - @y) / 1000

		end
	end

	# ルール2: 他の個体と距離をとろうとする
	def rule2
		dvx = 0
		dvy = 0

		$boids.drop(@id).each do |other|
			if other.alive then
				dx = other.x - @x
				dy = other.y - @y

				distance = Math::sqrt(dx*dx + dy*dy)
				if distance < DISTANCE then
					distance += 0.001

					dvx -= (dx / distance)
					dvy -= (dy / distance)
				end
			end
		end 

		@vx += dvx
		@vy += dvy
	end

	# ルール3: 他の個体と向きと速度を合わせようとする
	def rule3
		pvx = 0
		pvy = 0

		aliveCount = 0

		$boids.each do |other|
			if @id != other.id then
				if other.alive then
					pvx += other.vx
					pvy += other.vy

					aliveCount += 1
				end
			end
		end
		
		# 残りの boid の数が 2 以上のとき
		if aliveCount > 1 then
			pvx /= (aliveCount - 1)
			pvy /= (aliveCount - 1)

			@vx += (pvx - @vx) / 10
			@vy += (pvy - @vy) / 10

		end
	end 

	# ルール4: 移動領域を限定する
	def rule4
		# 今回は特に何もしない
	end

	# ルール5: ターゲットに向かう
	def rule5
		dx = $target.x - @x
		dy = $target.y - @y

		distance = Math::sqrt(dx*dx + dy*dy)

		@vx += dx / 500
		if @vx * dx < 0 then
			@vx += dx / 500
		end
		@vy += dy / 500
		if @vy * dy < 0 then 
			@vy += dy / 500
		end

	end


	# 更新処理
	def update
		if @alive then
			self.rule1
			self.rule2
			self.rule3
			self.rule4
			self.rule5

			velocity = Math::sqrt(@vx*@vx + @vy*@vy)
			if velocity > MAXSPEED then
				@vx *= MAXSPEED / velocity
				@vy *= MAXSPEED / velocity
			end
			
			@x += @vx
			@y += @vy
		end
	end

end


# ターゲット
class Target 
	# 初期化
	def initialize x,y
		@x = x
		@y = y
	end

	attr_accessor :x, :y
end


# ターゲットの位置
$target = Target.new 100,0

# 個体の初期位置
$startX = 133.0
$startY = 32.0

# boid の配列
$boids = Array.new

# 個体の初期化
NUM_OF_BOIDS.times do |id|
	$boids.push Boid.new id,$startX,$startY,0,0,true
end


# シミュレーションループ
NUM_OF_SIMULATION_STEPS.times do |step|
	
	puts "#{step},#{$boids.join(',')}"

	$boids.each do |boid|
		#puts boid.to_s

		boid.update
	end
	
end


