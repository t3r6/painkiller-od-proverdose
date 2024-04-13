function o:Poisonhim()
	if not self._gibbed then
			local dist = Dist3D(self._groundx, self._groundy, self._groundz, Player._groundx,Player._groundy, Player._groundz)
			if dist < self.Poison.Range then
				Game:Print("!!")
				if Player._slowdownSound then
					if not SOUND2D.IsPlaying(Player._slowdownSound) then
						Player._slowdownSound = nil
					end
				end
				if not Player._slowdownSound then
					Player._slowdownSound = PlaySound2D("actor/devilmonk/klatwa-slowdown")
				end
				Player._poisoned = self.Poison.TimeOut
				Player._poisonedTime = 0
				Player._poison = self.Poison
				Player._DrawColorQuad = true
				Player._ColorOfQuad = Color:New(10, 230, 10)
				Player._QuadAlphaMax = 50
			end
			self._fx_lastx = x
			self._fx_lasty = y
			self._fx_lastz = z
	end
end

