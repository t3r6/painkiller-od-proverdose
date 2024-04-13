function o:CustomOnDamage()
	if not self.enraged and math.random(100) < 25 then
		self.hited=true
		self.Health = 170
	end
end

