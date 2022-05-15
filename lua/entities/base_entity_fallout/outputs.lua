function ENT:KeyValue(key,value)
	key = string.lower(key)
	if self.m_tbOutputs && table.HasValue(self.m_tbOutputs,key) then self:StoreOutput(key,value)
	elseif(key == "model") then
		self:SetModel(value)
		return
	end
	if(key == "name") then
		if(string.len(value) > 0) then self:SetNetworkedString("name",value) end
		return
	end
	self:KeyValueHandle(key,value)
end

function ENT:KeyValueHandle(key,value)
end

function ENT:StoreOutput(name, info)
	local rawData = string.Explode(",",info)
	
	local Output = {}
	Output.entities = rawData[1] or ""
	Output.input = rawData[2] or ""
	Output.param = rawData[3] or ""
	Output.delay = tonumber(rawData[4]) or 0
	Output.times = tonumber(rawData[5]) or -1
	
	self.Outputs = self.Outputs or {}
	name = string.lower(name)
	self.Outputs[name] = self.Outputs[name] or {}
	table.insert(self.Outputs[name], Output)
end

local function FireSingleOutput(output, this, activator)
	if output.times == 0 then return false end
	local entitiesToFire = {}
	if output.entities == "!activator" then entitiesToFire = {activator}
	elseif output.entities == "!self" then entitiesToFire = {this}
	elseif output.entities == "!player" then entitiesToFire = player.GetAll()
	else entitiesToFire = ents.FindByName(output.entities) end
	for _,ent in pairs(entitiesToFire) do
		if (ent:IsValid()) then
			if (output.delay == 0) then ent:Input(output.input, activator, this, output.param);
			else
				timer.Simple(output.delay,function()
					if IsValid(ent) then
						ent:Input(output.input, activator, this, output.param)
					end
				end)
			end
		end
	end
	if output.times ~= -1 then
		output.times = output.times - 1
	end
	return output.times > 0 || output.times == -1
end

function ENT:TriggerOutput(name, activator)
	if (!self.Outputs) then return end
	name = string.lower(name)
	if !self.Outputs[name] then return end
	for idx,op in pairs(self.Outputs[name]) do
		if !FireSingleOutput(op, self.Entity, activator) then
			self.Outputs[name][idx] = nil
		end
	end
end