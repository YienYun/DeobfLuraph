local t,r = ...
spawn(function() while wait() do pcall(function() game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle.Text = t
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = r end) end end)
game:GetService('Players').LocalPlayer:Kick(r)
        