local v8=game:GetService("Players");
local v9=game:GetService("ReplicatedStorage");
local v10=game:GetService("RunService");
local v11=game:GetService("UserInputService");
local v12=game:GetService("HttpService");
local v13=v8.LocalPlayer;
local v14="nebula_sentinel_v2.json";
local v15=8472910452;
if((game.PlaceId~=0)and(game.PlaceId~=v15))then
  warn(string.format("[Nebula] Unsupported PlaceId: %d (expected %d)", game.PlaceId, v15));
end
local function v16(v55, v56)local v57=v56 or 2166136261;
  local v58=#v55;
  for v155=1, v58 do
    local v156=0;
    local v157;
    while true do
      if(v156==0)then
        v157=string.byte(v55, v155);
        v57=((v57*16777619)+(v157*(v155+7)))%4294967296;
        break;
      end
    end
  end
  local v59=string.format("%08X", v57);
  return v57, v59, v58;
end
local function v17(v60, v61, v62)if(v60<v61)then
  return v61, "clamped_low";
elseif(v60>v62)then
  return v62, "clamped_high";
end
return v60, "exact";
end
local function v18(...)local v63=0;
  local v64;
  local v65;
  while true do
    local v158=0;
    while true do
      if(v158==0)then
        if(v63==1)then
          for v231=1, v64 do
            v65[v231]=select(v231, ...);
          end
          return v65, v64;
        end
        if(v63==0)then
          v64=select("#", ...);
          v65={n=v64};
          v63=1;
        end
        break;
      end
    end
  end
end
local function v19(v66)local v67=0;
  local v68;
  local v69;
  local v70;
  local v71;
  local v72;
  local v73;
  local v74;
  while true do
    if(v67==2)then
      local v167=0;
      while true do
        if(v167==1)then
          v73=nil;
          v67=3;
          break;
        end
        if(v167==0)then
          v72=nil;
          function v72(v233)local v234=0;
            local v235;
            local v236;
            local v237;
            local v238;
            while true do
              local v247=0;
              while true do
                if(v247==1)then
                  if(v234==1)then
                    if not v235 then
                      warn("[Nebula] Encode failed: " .. tostring(v236));
                      return false;
                    end
                    v237, v238=pcall(writefile, v14, v236);
                    v234=2;
                  end
                  if(v234==2)then
                    if v237 then
                      local v279=0;
                      local v280;
                      local v281;
                      local v282;
                      while true do
                        local v283=0;
                        local v284;
                        while true do
                          if(v283==0)then
                            v284=0;
                            while true do
                              if(0==v284)then
                                if(v279==1)then
                                  v69=0;
                                  return true;
                                end
                                if(v279==0)then
                                  v280, v281, v282=v16(v236, v69+17);
                                  v70[#v70+1]={["tag"]=v281,["bytes"]=v282,["reason"]=v233 or "manual"};
                                  v279=1;
                                end
                                break;
                              end
                            end
                            break;
                          end
                        end
                      end
                    end
                    warn("[Nebula] Save failed: " .. tostring(v238));
                    v234=3;
                  end
                  break;
                end
                if(v247==0)then
                  if(v234==3)then
                    return false;
                  end
                  if(v234==0)then
                    if not writefile then
                      warn("[Nebula] Executor missing writefile; skipped save (" .. tostring(v233).. ")");
                      return false;
                    end
                    v235, v236=pcall(function()return v12:JSONEncode(v68);
                    end
                    );
                    v234=1;
                  end
                  v247=1;
                end
              end
            end
          end
          v167=1;
        end
      end
    end
    if(v67==3)then
      function v73(v181, v182, v183)local v184=0;
        while true do
          if(v184==2)then
            return true, v182;
          end
          if(v184==0)then
            if(v68[v181]==v182)then
              return false, v68[v181];
            end
            v68[v181]=v182;
            v184=1;
          end
          if(v184==1)then
            v69=v69+1;
            if v183 then
              v72("set:" .. tostring(v181));
            end
            v184=2;
          end
        end
      end
      v74=nil;
      function v74(v185)return v68[v185], v69;
      end
      v67=4;
    end
    if(v67==1)then
      for v186, v187 in pairs(v66)do
        if(type(v187)=="table")then
          local v220=0;
          local v221;
          while true do
            if(v220==1)then
              v68[v186]=v221;
              break;
            end
            if(0==v220)then
              v221={};
              for v261, v262 in pairs(v187)do
                v221[v261]=v262;
              end
              v220=1;
            end
          end
        else
          v68[v186]=v187;
        end
      end
      v71=nil;
      function v71()local v188=0;
        local v189;
        local v190;
        while true do
          if(v188==0)then
            if not(isfile and readfile and isfile(v14))then
              return false, "no_file";
            end
            v189, v190=pcall(function()return v12:JSONDecode(readfile(v14));
            end
            );
            v188=1;
          end
          if(2==v188)then
            return true, "loaded";
          end
          if(v188==1)then
            if(not v189 or(type(v190)~="table"))then
              return false, "corrupt_json";
            end
            for v248, v249 in pairs(v190)do
              if((v68[v248]~=nil)and(type(v68[v248])==type(v249)))then
                v68[v248]=v249;
              end
            end
            v188=2;
          end
        end
      end
      v67=2;
    end
    if(v67==0)then
      v68={};
      v69=0;
      v70={};
      v67=1;
    end
    if(v67==4)then
      return{["load"]=v71,["save"]=v72,["set"]=v73,["get"]=v74,["raw"]=v68,["history"]=v70};
    end
  end
end
local v20={};
v20.__index=v20;
v20.new=function(v75, v76)local v77=0;
  local v78;
  while true do
    if(v77==0)then
      v78=setmetatable({}, v20);
      v78.label=v75 or "MainScheduler";
      v77=1;
    end
    if(v77==2)then
      v78.totalTicks=0;
      v78.running=false;
      v77=3;
    end
    if(v77==3)then
      local v171=0;
      while true do
        if(v171==0)then
          v78.connection=nil;
          return v78;
        end
      end
    end
    if(v77==1)then
      v78.maxBudgetMs=v76 or 8.5;
      v78.jobs={};
      v77=2;
    end
  end
end
v20.register=function(v79, v80, v81, v82)local v83={["name"]=v80,["interval"]=math.max(v81 or 0.1, 0.01),["elapsed"]=0,["runs"]=0,["active"]=true,["fn"]=v82};
  v79.jobs[#v79.jobs+1]=v83;
  return v83;
end
v20.pruneInactive=function(v85)local v86=0;
  for v159=#v85.jobs, 1,-1 do
    local v160=0;
    local v161;
    while true do
      if(v160==0)then
        v161=v85.jobs[v159];
        if not v161.active then
          local v224=0;
          while true do
            if(v224==0)then
              table.remove(v85.jobs, v159);
              v86=v86+1;
              break;
            end
          end
        end
        break;
      end
    end
  end
  return v86;
end
v20.step=function(v87, v88)v87.totalTicks=v87.totalTicks+1;
  local v90=0;
  for v162, v163 in ipairs(v87.jobs)do
    if v163.active then
      v163.elapsed=v163.elapsed+v88;
      if(v163.elapsed>=v163.interval)then
        local v212=0;
        local v213;
        local v214;
        while true do
          if(v212==0)then
            v163.elapsed=0;
            v163.runs=v163.runs+1;
            v212=1;
          end
          if(v212==1)then
            v213, v214=pcall(v163.fn, v163.runs, v88, v87.totalTicks);
            v90=v90+1;
            v212=2;
          end
          if(v212==2)then
            if not v213 then
              local v265=0;
              while true do
                if(v265==0)then
                  warn(string.format("[Nebula:%s] Job '%s' error: %s", v87.label, v163.name, tostring(v214)));
                  v163.active=false;
                  break;
                end
              end
            elseif(v214==false)then
              v163.active=false;
            end
            break;
          end
        end
      end
    end
  end
  if((v87.totalTicks%30)==0)then
    v87:pruneInactive();
  end
  return v90;
end
v20.start=function(v91)local v92=0;
  while true do
    if(v92==1)then
      v91.connection=v10.Heartbeat:Connect(function(v192)local v193=0;
        local v194;
        while true do
          if(v193==0)then
            v194=0;
            while true do
              if(v194==0)then
                if not v91.running then
                  return;
                end
                v91:step(v192);
                break;
              end
            end
            break;
          end
        end
      end
      );
      break;
    end
    if(v92==0)then
      if v91.running then
        return;
      end
      v91.running=true;
      v92=1;
    end
  end
end
v20.stop=function(v93)local v94=0;
  while true do
    if(v94==0)then
      v93.running=false;
      if v93.connection then
        local v215=0;
        local v216;
        while true do
          if(v215==0)then
            v216=0;
            while true do
              if(v216==0)then
                v93.connection:Disconnect();
                v93.connection=nil;
                break;
              end
            end
            break;
          end
        end
      end
      break;
    end
  end
end
local v28={["Rifle"]={["skipLocked"]=true,["overrides"]={["Spread"]=0,["RecoilPitch"]=0.02,["FireCooldown"]=0.045,["Range"]=450}},["Melee"]={["skipLocked"]=false,["overrides"]={["SwingCooldown"]=0.08,["HitboxScale"]=1.35,["Recovery"]=0.05}}};
local v29={};
local function v30(v95, v96, v97)local v98=0;
  local v99;
  local v100;
  while true do
    local v164=0;
    while true do
      if(v164==1)then
        if(v98==2)then
          return v100;
        end
        break;
      end
      if(v164==0)then
        if(v98==1)then
          v100=0;
          for v240, v241 in pairs(v97)do
            local v242=v99.skipLocked and(type(v241)=="table")and(v241.Locked==true);
            if((type(v241)=="table")and not v242)then
              for v266, v267 in pairs(v99.overrides)do
                if v96 then
                  if(v241[v266]~=nil)then
                    v29[v240]=v29[v240]or{};
                    if(v29[v240][v266]==nil)then
                      v29[v240][v266]=v241[v266];
                    end
                    v241[v266]=v267;
                    v100=v100+1;
                  end
                else
                  local v270=v29[v240]and v29[v240][v266];
                  if(v270~=nil)then
                    local v278=0;
                    while true do
                      if(v278==0)then
                        v241[v266]=v270;
                        v100=v100+1;
                        break;
                      end
                    end
                  end
                end
              end
            end
          end
          v98=2;
        end
        if(0==v98)then
          v99=v28[v95];
          if(not v99 or(type(v97)~="table"))then
            return 0;
          end
          v98=1;
        end
        v164=1;
      end
    end
  end
end
local function v31(v101, v102)local v103=0;
  local v104;
  local v105;
  local v106;
  local v107;
  while true do
    if(v103==2)then
      local v178=0;
      while true do
        if(0==v178)then
          v105=v104:FindFirstChildOfClass("Humanoid");
          v106=v104:FindFirstChild("HumanoidRootPart");
          v178=1;
        end
        if(v178==1)then
          v103=3;
          break;
        end
      end
    end
    if(3==v103)then
      v107=v104:FindFirstChild("Head");
      if not(v105 and v106 and v107 and(v105.Health>0))then
        return false, "dead_or_incomplete";
      end
      v103=4;
    end
    if(v103==1)then
      v104=v101.Character;
      if not v104 then
        return false, "no_char";
      end
      v103=2;
    end
    if(v103==4)then
      return true, v106;
    end
    if(0==v103)then
      if(not v101 or(v101==v13))then
        return false, "self_or_nil";
      end
      if(not v102 and v13.Team and(v101.Team==v13.Team))then
        return false, "teammate";
      end
      v103=1;
    end
  end
end
local function v32(v108, v109)local v110=0;
  local v111;
  local v112;
  local v113;
  local v114;
  while true do
    if(3==v110)then
      return v113, v114;
    end
    if(v110==2)then
      v114=v108 or 250;
      for v195, v196 in ipairs(v8:GetPlayers())do
        local v197=0;
        local v198;
        local v199;
        local v200;
        while true do
          if(v197==0)then
            local v243=0;
            while true do
              if(v243==0)then
                v198=0;
                v199=nil;
                v243=1;
              end
              if(v243==1)then
                v197=1;
                break;
              end
            end
          end
          if(v197==1)then
            v200=nil;
            while true do
              if(0==v198)then
                v199, v200=v31(v196, v109);
                if v199 then
                  local v271=0;
                  local v272;
                  local v273;
                  local v274;
                  while true do
                    if(v271==1)then
                      v274=nil;
                      while true do
                        if(v272==1)then
                          if(v274<v114)then
                            local v289=0;
                            while true do
                              if(0==v289)then
                                v114=v274;
                                v113=v196;
                                break;
                              end
                            end
                          end
                          break;
                        end
                        if(v272==0)then
                          local v288=0;
                          while true do
                            if(1==v288)then
                              v272=1;
                              break;
                            end
                            if(v288==0)then
                              v273=v200.Position-v112.Position;
                              v274=v273.Magnitude;
                              v288=1;
                            end
                          end
                        end
                      end
                      break;
                    end
                    if(v271==0)then
                      v272=0;
                      v273=nil;
                      v271=1;
                    end
                  end
                end
                break;
              end
            end
            break;
          end
        end
      end
      v110=3;
    end
    if(v110==1)then
      if not v112 then
        return nil, math.huge;
      end
      v113=nil;
      v110=2;
    end
    if(v110==0)then
      v111=v13 and v13.Character;
      v112=v111 and v111:FindFirstChild("HumanoidRootPart");
      v110=1;
    end
  end
end
local function v33(v115, v116, v117, ...)local v118=0;
  local v119;
  local v120;
  local v121;
  local v122;
  local v123;
  while true do
    if(v118==0)then
      v119, v120=v18(...);
      v121=0;
      v118=1;
    end
    if(v118==2)then
      repeat
        local v201=0;
        local v202;
        local v203;
        while true do
          if(v201==2)then
            v122=v17(v122*1.5, 0.05, 0.5);
            if(task and task.wait)then
              task.wait(v122);
            end
            break;
          end
          if(0==v201)then
            v121=v121+1;
            v202, v203=pcall(function()if(v120==0)then
              return v117();
            elseif(v120==1)then
              return v117(v119[1]);
            elseif(v120==2)then
              return v117(v119[1], v119[2]);
            end
            return v117(unpack(v119, 1, v120));
          end
          );
          v201=1;
        end
        if(v201==1)then
          if v202 then
            return true, v203, v121;
          end
          v123=v203;
          v201=2;
        end
      end
    until v121>=v116 warn(string.format("[Nebula] '%s' failed after %d attempts: %s", v115, v121, tostring(v123)));
    v118=3;
  end
  if(1==v118)then
    v122=0.05;
    v123=nil;
    v118=2;
  end
  if(v118==3)then
    return false, v123, v121;
  end
end
end
local function v34(v124, v125, v126)local v127=0;
  local v128;
  while true do
    local v165=0;
    while true do
      if(v165==0)then
        if(v127==0)then
          v128=Instance.new(v124);
          for v244, v245 in pairs(v125 or{})do
            v128[v244]=v245;
          end
          v127=1;
        end
        if(v127==1)then
          if v126 then
            for v257, v258 in next, v126 do
              -- This Source Was Generated by discord.gg/c3xVMnUUBv
              v258.Parent=v128;
            end
          end
          return v128;
        end
        break;
      end
    end
  end
end
local v35=v19({["rifleBypass"]=false,["meleeBypass"]=false,["autoOrbit"]=false,["scanRadius"]=180,["allowTeam"]=false});
v35.load();
local v36=v20.new("NebulaCore", 6);
local v37=0;
local v38=nil;
v36:register("TargetOrbit", 0.016, function(v129, v130)local v131=0;
  local v132;
  local v133;
  local v134;
  local v135;
  local v136;
  while true do
    if(v131==4)then
      if((v129%600)==0)then
        print(string.format("[Nebula] Orbit heartbeat #%d active", v129));
      end
      return true;
    end
    if(v131==0)then
      local v180=0;
      while true do
        if(v180==0)then
          v132=v35.get("autoOrbit");
          if not v132 then
            local v252=0;
            while true do
              if(v252==0)then
                v38=nil;
                return true;
              end
            end
          end
          v180=1;
        end
        if(v180==1)then
          v131=1;
          break;
        end
      end
    end
    if(v131==3)then
      if not v135 then
        local v217=0;
        local v218;
        while true do
          if(v217==0)then
            v218=v17(v35.get("scanRadius"), 25, 500);
            v38=v32(v218, v35.get("allowTeam"));
            v217=1;
          end
          if(v217==1)then
            v135, v136=v31(v38, v35.get("allowTeam"));
            break;
          end
        end
      end
      if(v135 and v136)then
        local v219=0;
        while true do
          if(v219==0)then
            v37=(v37+(v130*4.5))%(math.pi*2);
            v134.CFrame=CFrame.new(v136.Position)*CFrame.Angles(0, v37, 0)*CFrame.new(0, 2.5, 6);
            v219=1;
          end
          if(v219==1)then
            v134.AssemblyLinearVelocity=Vector3.zero;
            break;
          end
        end
      end
      v131=4;
    end
    if(v131==1)then
      v133=v13 and v13.Character;
      v134=v133 and v133:FindFirstChild("HumanoidRootPart");
      v131=2;
    end
    if(v131==2)then
      if not v134 then
        return true;
      end
      v135, v136=v31(v38, v35.get("allowTeam"));
      v131=3;
    end
  end
end
);
local v39=(gethui and gethui())or v13:WaitForChild("PlayerGui");
local v40=v39:FindFirstChild("NebulaSentinelUI");
if v40 then
  v40:Destroy();
end
local v41=v34("ScreenGui",{["Name"]="NebulaSentinelUI",["ResetOnSpawn"]=false,["ZIndexBehavior"]=Enum.ZIndexBehavior.Sibling,["Parent"]=v39});
local v42=v34("Frame",{["Size"]=UDim2.new(0, 240, 0, 280),["Position"]=UDim2.new(0, 48, 0, 140),["BackgroundColor3"]=Color3.fromRGB(20, 22, 28),["BorderSizePixel"]=0,["Parent"]=v41},{v34("UICorner",{["CornerRadius"]=UDim.new(0, 12)}), v34("UIStroke",{["Color"]=Color3.fromRGB(62, 68, 82),["Thickness"]=1})});
local v43=v34("TextLabel",{["Size"]=UDim2.new(1,-20, 0, 32),["Position"]=UDim2.new(0, 10, 0, 0),["BackgroundTransparency"]=1,["Text"]="Nebula Sentinel v2.4",["TextColor3"]=Color3.fromRGB(235, 238, 245),["Font"]=Enum.Font.Code,["TextSize"]=13,["TextXAlignment"]=Enum.TextXAlignment.Left,["Parent"]=v42});
local v44=v34("Frame",{["Size"]=UDim2.new(1,-16, 1,-44),["Position"]=UDim2.new(0, 8, 0, 36),["BackgroundTransparency"]=1,["Parent"]=v42},{v34("UIListLayout",{["Padding"]=UDim.new(0, 6),["SortOrder"]=Enum.SortOrder.LayoutOrder})});
local v45={};
local v46, v47=v33("LoadItemRegistry", 2, function()local v137=0;
  local v138;
  while true do
    if(v137==0)then
      v138=v9:FindFirstChild("Modules")and v9.Modules:FindFirstChild("WeaponRegistry");
      return(v138 and require(v138))or{};
    end
  end
end
);
if(v46 and(type(v47)=="table"))then
  v45=v47.Items or v47;
end
local v48={{"Rifle Fast-Fire", "rifleBypass", function(v139)v30("Rifle", v139, v45);
end
},{"Melee Cooldown", "meleeBypass", function(v140)v30("Melee", v140, v45);
end
},{"Auto Orbit Nearest", "autoOrbit", function(v141)if v141 then
  v36:start();
end
end
},{"Include Teammates", "allowTeam", function(v142)end
  }};
  for v143, v144 in ipairs(v48)do
    local v145, v146, v147=v144[1], v144[2], v144[3];
    local v148=v35.get(v146)==true;
    local v149=v34("TextButton",{["Size"]=UDim2.new(1, 0, 0, 32),["BackgroundColor3"]=(v148 and Color3.fromRGB(42, 62, 54))or Color3.fromRGB(30, 33, 42),["BorderSizePixel"]=0,["AutoButtonColor"]=false,["Text"]=v145 ..((v148 and " [ON]")or " [OFF]"),["TextColor3"]=(v148 and Color3.fromRGB(160, 240, 190))or Color3.fromRGB(175, 180, 192),["Font"]=Enum.Font.Code,["TextSize"]=12,["LayoutOrder"]=v143,["Parent"]=v44},{v34("UICorner",{["CornerRadius"]=UDim.new(0, 8)})});
    v149.MouseButton1Click:Connect(function()local v166=0;
      while true do
        if(v166==1)then
          v149.TextColor3=(v148 and Color3.fromRGB(160, 240, 190))or Color3.fromRGB(175, 180, 192);
          v149.Text=v145 ..((v148 and " [ON]")or " [OFF]");
          v166=2;
        end
        if(v166==0)then
          v148=not v148;
          v149.BackgroundColor3=(v148 and Color3.fromRGB(42, 62, 54))or Color3.fromRGB(30, 33, 42);
          v166=1;
        end
        if(v166==2)then
          v35.set(v146, v148, true);
          v147(v148);
          break;
        end
      end
    end
    );
    if v148 then
      v147(true);
    end
  end
  do
    local v150=0;
    local v151;
    local v152;
    local v153;
    while true do
      if(v150==1)then
        v153=nil;
        v43.InputBegan:Connect(function(v207)if((v207.UserInputType==Enum.UserInputType.MouseButton1)or(v207.UserInputType==Enum.UserInputType.Touch))then
          v151=true;
          v152=v207.Position;
          v153=v42.Position;
        end
      end
      );
      v150=2;
    end
    if(v150==2)then
      v11.InputEnded:Connect(function(v208)if((v208.UserInputType==Enum.UserInputType.MouseButton1)or(v208.UserInputType==Enum.UserInputType.Touch))then
        v151=false;
      end
    end
    );
    v11.InputChanged:Connect(function(v209)if(v151 and((v209.UserInputType==Enum.UserInputType.MouseMovement)or(v209.UserInputType==Enum.UserInputType.Touch)))then
      local v228=0;
      local v229;
      while true do
        if(v228==0)then
          v229=v209.Position-v152;
          v42.Position=UDim2.new(v153.X.Scale, v153.X.Offset+v229.X, v153.Y.Scale, v153.Y.Offset+v229.Y);
          break;
        end
      end
    end
  end
  );
  v150=3;
end
if(v150==3)then
  v11.InputBegan:Connect(function(v210, v211)if(not v211 and(v210.KeyCode==Enum.KeyCode.RightShift))then
    v41.Enabled=not v41.Enabled;
  end
end
);
break;
end
if(0==v150)then
  v151=false;
  v152=nil;
  v150=1;
end
end
end
v36:start();
local v49, v50, v51=v16("NebulaSentinelReady", 42);
print(string.format("[Nebula] Loaded OK | sig=%s (%d, len=%d)", v50, v49, v51));
print("Deobf By Zed")
