AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local DESTROYABLE=true -- set to false to prevent damage
local HEALTH=500 -- change to set spawn health of shuttles

local soundx=Sound("ambient/atmosphere/undercity_loop1.wav")

function ENT:SpawnFunction( ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( "jumper" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self.Entity:SetNetworkedInt("health",HEALTH)

	if (!self.Sound) then
 		self.Sound = CreateSound( self.Entity, soundx )
 	end

	self.Entity:SetUseType( SIMPLE_USE )
	
	self.Firee=nil
	self.Inflight=false
	self.Pilot=false
	self.Entity:SetModel("models/puddle/pjd.mdl")	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Target = Vector(0,0,0);
	self.DroneMaxSpeed = StarGate.CFG:Get("drone","maxspeed",6000);
	self.AllowAutoTrack = (true);
	self.AllowEyeTrack = (false);
	self.TrackTime = 1000000;
	self.Drones = {};
	self.DroneCount = 0;
	self.MaxDrones = (4);
	self.Track = false;
	self.Launched = false;
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(10000)
		end
	self.Entity:StartMotionController()
	self.Accel=0
end

function ENT:DoKill()
	--util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 300, 100 )  ARRRR

 	local effectdata = EffectData() 
 		effectdata:SetOrigin( self.Entity:GetPos() ) 
  	util.Effect( "Explosion", effectdata, true, true ) 

	self.Sound:Stop()
	
	self.Pilot:UnSpectate()
	self.Pilot:DrawViewModel(true)
	self.Pilot:DrawWorldModel(true)
	self.Pilot:Spawn()
	self.Pilot:SetNetworkedBool("isDriveShuttle",false)
	self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))
	self.Entity:Remove()
end

function ENT:OnTakeDamage(dmg)
	if self.Inflight and DESTROYABLE and not self.Done then
		local health=self.Entity:GetNetworkedInt("health")
		self.Entity:SetNetworkedInt("health",health-dmg:GetDamage())
		local health=self.Entity:GetNetworkedInt("health")
		if health<1 then
			self.Entity:DoKill()
			self.Done=true
		end
	end
end

function ENT:OnRemove()
 	if (self.Sound) then
 		self.Sound:Stop()
 	end
end

function ENT:Think()
	if self.Inflight and self.Pilot and self.Pilot:IsValid() then
		if self.Sound then
			self.Sound:ChangePitch(math.Clamp(self.Entity:GetVelocity():Length()/5,1,150),0.001)
		end
		self.Pilot:SetPos(self.Entity:GetPos())
		if self.Pilot:KeyDown(IN_USE) then
			self.Sound:Stop()

			self.Pilot:UnSpectate()
			self.Pilot:DrawViewModel(true)
			self.Pilot:DrawWorldModel(true)
			self.Pilot:Spawn()
			self.Pilot:SetNetworkedBool("isDriveShuttle",false)
			self.Pilot:SetPos(self.Entity:GetPos()+Vector(0,0,100))

			self.Accel=0
			self.Inflight=false
			if self.Firee then
				self.Firee:Remove()
			end
			self.Entity:SetLocalVelocity(Vector(0,0,0))
			self.Pilot=nil
		end	
		self.Entity:NextThink(CurTime())
	else
		self.Entity:NextThink(CurTime()+1)
	end

return true
end

function ENT:Use(ply,caller)
	if self.Inflight then 

	else
		self.Sound:Play()

		self.Entity:GetPhysicsObject():Wake()
		self.Entity:GetPhysicsObject():EnableMotion(true)
		self.Inflight=true
		self.Pilot=ply

		ply:Spectate( OBS_MODE_CHASE  )
		ply:SpectateEntity( self.Entity )
		ply:DrawViewModel(false)
		ply:DrawWorldModel(false)
		ply:StripWeapons()
		ply:SetNetworkedBool("isDriveShuttle",true)
		ply:SetNetworkedEntity("Shuttle",self.Entity)
	end
end

function ENT:PhysicsSimulate( phys, deltatime )
	if self.Inflight then
		local num=0
		
		if self.Pilot:KeyDown(IN_FORWARD) then
			num=500
		elseif self.Pilot:KeyDown(IN_BACK) then
			num=-500
			
		elseif self.Pilot:KeyDown(IN_SPEED) then
			num=2000
		else
			
		end
	if self.Inflight and self.Pilot and self.Pilot:IsValid() then
	self.Entity:SetModel("models/Jumper/pj.mdl")
	else
	self.Entity:SetModel("models/Jumper/pjd.mdl")
	end
	if 
	self.Pilot:KeyDown(IN_SPEED) then
		self.Entity:SetModel("models/Jumper/pjw.mdl")
	end
	
	if self.Pilot:KeyDown(IN_RELOAD) then
		self.Entity:SetColor(255,255,255,0)
		
	else
		self.Entity:SetColor(255,255,255,255)
		
	end	
	
		phys:Wake()
			self.Accel=math.Approach(self.Accel,num,10)
			if self.Accel>-200 and self.Accel < 200 then return end
		local pr={}
			pr.secondstoarrive	= 1
			pr.pos				= self.Entity:GetPos()+self.Entity:GetForward()*self.Accel
			pr.maxangular		= 5000
			pr.maxangulardamp	= 10000
			pr.maxspeed			= 1000000
			pr.maxspeeddamp		= 10000
			pr.dampfactor		= 0.8
			pr.teleportdistance	= 5000
			pr.angle		= self.Pilot:GetAimVector():Angle()
			
			pr.deltatime		= deltatime
		phys:ComputeShadowControl(pr)
	end
	
	
	local pos = self.Entity:GetPos();
	if(self.Track) then
		-- Track the owner's eyes
		local p = self.Entity.Owner;
	if(self.Track and self.DroneCount > 0) then
		if(self.EyeTrack and p and p:IsValid() and p:Alive()) then
			if(self.AllowEyeTrack) then
				local trace = util.TraceLine(util.GetPlayerTrace(p));
				if(trace.HitPos ~= Vector(0,0,0)) then
					self.Target = trace.HitPos;
				end
				
			end
		else
			if(self.AllowAutoTrack) then
				-- Track for players
				if(self.Target == Vector(0,0,0) or not self.PositionSet) then
					-- I love bubble-sort (not rly)
					local dist;
					for _,v in pairs(player.GetAll()) do
						if(v ~= self.Entity.Owner and v:Alive()) then
							local p_pos = v:GetPos();
							-- Fix for people in a shuttle
							if(v:GetNWBool("isDriveShuttle",false)) then
								local shuttle = v:GetNWEntity("Shuttle",nil);
								if(shuttle and shuttle:IsValid()) then
									p_pos = shuttle:GetPos();
								end
							end
							local len = (p_pos-pos):Length();
							if(not dist or len < dist) then
								self.Target = p_pos;
								dist = len;
							end
						end
					end
					
					self.PositionSet = nil;
				end
			end
		end
		end
	end	
	if (self.Inflight and self.DroneCount < 4) then

	
			if self.Pilot:KeyDown(IN_ATTACK) then 
				local vel = self.Entity:GetVelocity();
				local up = self.Entity:GetUp();
				-- calculate the drone's position offset. Otherwise it might collide with the launcher
				local offset = StarGate.VelocityOffset({Velocity=vel,Direction=up,BoundingMax=self.Entity:OBBMaxs().z});
				local e = ents.Create("drone");
				e.Parent = self.Entity;
				e:SetPos(pos+offset);
				e:SetAngles(self.Entity:GetForward():Angle()+Angle(math.random(-2,2),math.random(-2,2),math.random(-2,2)));
				e:SetOwner(self.Entity); -- Don't collide with this thing here please
				e.Owner = self.Entity.Owner;
				e:Spawn();
				e:SetVelocity(vel);
				self.DroneCount = self.DroneCount + 1;
				self.Drones[e] = true;
				-- This is necessary to make the drone not collide and explode with the cannon when it's moving
				e.CurrentVelocity = math.Clamp(vel:Length(),0,self.DroneMaxSpeed-500)+500;
				e.CannonVeloctiy = vel;
			end
	end
	
	if self.Inflight then
		self.Track = false
			if self.Pilot:KeyDown(IN_ATTACK2) then
			self.Track = true
			end 
	end
end

function ENT:ShowOutput()

end
