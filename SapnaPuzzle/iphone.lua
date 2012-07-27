module(..., package.seeall)





function splash()

	local splashGroup = display.newGroup()
	local splashImage = display.newImage( "images/Splash-iPhone@2x.png" )
	splashImage.x = display.contentWidth/2
	splashImage.y = display.contentHeight/2
	splashGroup:insert(splashImage)
 
 	local function removeSplashScreen()
 		
 		
 		splashGroup:removeSelf()
 		
		-- audio.play(gameBackGroundSound_)
		setFirstView()
 	end

 	transition.to(splashImage,{time = 4000, alpha = 0.05, delay = 3000})
 	timer.performWithDelay(4000,removeSplashScreen)

  	
end



function loadMod()

print("Hello Sapna Puzzle iPhone & MyTouch Mode "..display.contentWidth, display.contentHeight)
local BG = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
BG:setFillColor(  211, 244, 193, 255) -- object:setFillColor( r, g, b [, a] )
local backGroundImage = display.newImage( "images/gameBG.png" )
	backGroundImage.x = display.contentWidth/2
	backGroundImage.y = display.contentHeight/2
 	backGroundImage:toBack()

 	splash()

return 20
end

