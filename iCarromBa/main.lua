 local physics = require("physics")
 local gameUI = require("gameUI")
 local ui = require("ui")
 require "slider"
 --require( "ice" )
 physics.start()
 display.setStatusBar( display.HiddenStatusBar )
 -- physics.setDrawMode("hybrid") --Set physics Draw mode
 -- physics.setDrawMode("debug") --Set physics Draw mode
 physics.setScale( 70 ) -- a value that seems good for small objects (based on playtesting)
 physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector

local volume

local themeNo = 1
local spriteInstance = {}
local centerX = display.contentWidth/2
local centerY = 499
local coinRadius = 20
local strickerRadius = 23
local angle = 0
local deg2rad = math.pi / 180
local check = 0
local object
local newEvent

--Player Score Variables
local player1Score = 0
local player2Score = 0

--Player Variables
local queenLevel = 0
local playerTurn = 0
local playerTurnArray = {"white","black"}	



--Array For stack of scored coins
 local stackOfBlacks = {}
 local stackOfWhites = {}
 local queenStack = {}
 
--Array of Co-ordinates
local scoredCordinatesX = {display.contentWidth-coinRadius, display.contentWidth-3*coinRadius, display.contentWidth-5*coinRadius, display.contentWidth-7*coinRadius, display.contentWidth-9*coinRadius, display.contentWidth-11*coinRadius, display.contentWidth-13*coinRadius, display.contentWidth-115*coinRadius }


-- Stricker area to detect coins while replacing strickers
local strickerArea1
local strickerArea2
local strickerAreaCoins = {}
local strickerSafeAreaArray = {173,277,380,491,595}


--Function to add Menu screen  
function splash()
	
	
	print("----Begin Game----")
	splashGroup = display.newGroup()
	
	
	function loadMainScreen()
		splashGroup.alpha = 0.2
		transition.to( splashGroup, { time=1000, alpha=1 } )
		
		local mainScreen = display.newImage("splash.jpg", true, 20, 1, true)
		splashGroup:insert(mainScreen)
		
	 -- Show alert with five buttons


	      buttonPlay = display.newImage("button1.png", true, 20, 1, true)
	      buttonPlay.x = centerX
	      buttonPlay.y = centerY+130
	      buttonPlay.alpha = 0.9
	      splashGroup:insert(buttonPlay)		        
	    
	  
		  local buttonText = display.newText("Play", centerX-25, centerY+105, null, 35)
		  buttonText:setTextColor(255,255,255)
	      splashGroup:insert(buttonText) 
	     
		  buttonPlay:addEventListener("touch", init )
	     
	      buttonSettings = display.newImage("button2.png", true, 20, 1, true)
	      buttonSettings.x = centerX
	      buttonSettings.y = centerY+250
	      buttonSettings.alpha = 0.9
	      splashGroup:insert(buttonSettings)
	  
		  local buttonSettingsText = display.newText("Settings", centerX-50, centerY+225, null, 35)
		  buttonSettingsText:setTextColor(255,255,255)
		  splashGroup:insert(buttonSettingsText)
	    
	      buttonSettings:addEventListener("touch", loadSettingScreen,1 )


		  buttonAbout = display.newImage("button4.png", true, 20, 1, true)
	      buttonAbout.x = centerX
	      buttonAbout.y = centerY+360
	      buttonAbout.alpha = 0.9  
	      splashGroup:insert(buttonAbout)
	  
		  local buttonAboutText = display.newText("About", centerX-45, centerY+335, null, 35)
		  buttonAboutText:setTextColor(255,255,255)
		  splashGroup:insert(buttonAboutText)
	    
	      buttonAbout:addEventListener("touch", buttonAboutScreen,1 )


	end

      local splashBG = display.newImage("splash.jpg", true, 20, 1, true)
	  splashGroup:insert(splashBG)
	  transition.to( splashBG, { time=1000, alpha=0.9, onComplete= loadMainScreen } )
   

end

function buttonAboutScreen()
	
	aboutGroup = display.newGroup()
	
	
	buttonPlay:removeEventListener("touch", init )
	buttonSettings:removeEventListener("touch", loadSettingScreen,1 )	
	buttonAbout:removeEventListener("touch", buttonAboutScreen,1 )
	
	local aboutScreen = display.newImage("about.jpg", true, 20, 10, true)
    aboutGroup:insert(aboutScreen)


	local function goBack(event)
	    aboutGroup:removeSelf()
	    buttonPlay:addEventListener("touch", init )
	    buttonSettings:addEventListener("touch", loadSettingScreen,1 )	
		buttonAbout:addEventListener("touch", buttonAboutScreen,1 )
    end

    buttonBack = display.newImage("button3.png", true, 20, 1, true)
    buttonBack.x = 105
    buttonBack.y = 55
    aboutGroup:insert(buttonBack)

	local buttonBackText = display.newText("Back", 80, 40, null, 26)
	buttonBackText:setTextColor(255,255,255)
	aboutGroup:insert(buttonBackText)
	buttonBack:addEventListener("touch", goBack,1 )


end

function loadSettingScreen()
    
    buttonPlay:removeEventListener("touch", init )
	buttonSettings:removeEventListener("touch", loadSettingScreen,1 )	
	buttonAbout:removeEventListener("touch", buttonAboutScreen,1 )
    
    settingGroup = display.newGroup()
    
    local settingScreenBG = display.newImage("MainScreen.jpg", true, 20, 10, true)
    settingGroup:insert(settingScreenBG)
    

	local function goBack(event)
	    settingGroup:removeSelf()
	    buttonPlay:addEventListener("touch", init )
	    buttonSettings:addEventListener("touch", loadSettingScreen,1 )	
		buttonAbout:addEventListener("touch", buttonAboutScreen,1 )
    end
	buttonBack = display.newImage("button3.png", true, 20, 1, true)
    buttonBack.x = 105
    buttonBack.y = 55
    settingGroup:insert(buttonBack)
    
	local buttonBackText = display.newText("Back", 80, 40, null, 26)
	buttonBackText:setTextColor(255,255,255)
	settingGroup:insert(buttonBackText)

	buttonBack:addEventListener("touch", goBack,1 )

      
 --Code to Select Themes For the Game


    local settingsLogo = display.newImage("settings.png", true, 20, 1, true)
    settingsLogo.x = centerX
    settingsLogo.y = 240
	settingGroup:insert(settingsLogo)
	
	local selectedHighlighter1
	local selectedHighlighter2

    local function selectTheme(event)
	    themeNo = event.target.id
	    print("selected-theme->"..themeNo)
	    if themeNo == 2 then
			selectedHighlighter2.alpha =1
			selectedHighlighter1.alpha =0
	    elseif themeNo == 1 then
			selectedHighlighter1.alpha =1
			selectedHighlighter2.alpha =0
		end

	   
    end


	--VOLUME CONTROL SECTION
	
    local volumeLogo = display.newImage("volume.png", true, 20, 1, true)
    volumeLogo.x = centerX - 250
    volumeLogo.y = centerY - 70
	settingGroup:insert(volumeLogo)

     
    --media.setSoundVolume( 0.5 )
    print( "volume = " .. media.getSoundVolume() )
    volume =  media.getSoundVolume()
    local buttonVolText = display.newText(string.format("%0.0f%%", volume*100 ), display.contentWidth-110, centerY -20, null, 30)
          buttonVolText:setTextColor(255,255,255)
    settingGroup:insert(buttonVolText)

	local eventHandler = function( event )
		print( "id = " .. event.id .. ", phase = " .. event.phase .. " value=" .. event.value )
		buttonVolText.text= string.format("%0.0f%%", event.value )
		--media.setSoundVolume(event.value/100)--UNCOMMENT IT TO SET DEVICE VOLUME  
	end

	local mySlider = slider.newSlider( 
		{ 
			track = "track.png",
			thumbDefault = "thumb.png",
			thumbOver = "thumbDrag.png",
			onPress = press,
			onRelease = release,
			onEvent	= eventHandler,
			value = 0.10,
		} 
		)
	
	mySlider.x = display.contentWidth / 2.15
	mySlider.y = centerY

	settingGroup:insert(mySlider)    
    
 
 
 
	--THEME SECTION

    local themeLogo = display.newImage("theme.png", true, 20, 1, true)
    themeLogo.x = centerX-250
    themeLogo.y = centerY+120
	settingGroup:insert(themeLogo)

    local theme1 = display.newImage("caromboard-classic.png", true, 20, 1, true)
     theme1.x = centerX-160
     theme1.y = centerY+320
     settingGroup:insert(theme1)
     theme1.id=1
     theme1:addEventListener("touch", selectTheme,1 )
     selectedHighlighter1 = display.newRoundedRect( theme1.x-theme1.width/2-2, theme1.y-theme1.height/2-2, theme1.width+4, theme1.height+4,1 )
     settingGroup:insert(selectedHighlighter1)
     selectedHighlighter1.alpha =0
     theme1:toFront()
     
     local theme2 = display.newImage("caromboard-neon.png", true, 20, 1, true)
     theme2.x = centerX+160
     theme2.y = centerY+320
     settingGroup:insert(theme2)
     theme2.id=2
     theme2:addEventListener("touch", selectTheme,1 )
     selectedHighlighter2 = display.newRoundedRect( theme2.x-theme2.width/2-2, theme2.y-theme2.height/2-2, theme2.width+4, theme2.height+4,1 )
     settingGroup:insert(selectedHighlighter2)
     selectedHighlighter2.alpha =0
     theme2:toFront()
     


end
 



--USE THIS FOR SWIPE GESTURE ON STRICKER	
local function dragBody( event ) 
	return 
	gameUI.dragBody( event )
--	gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
--	gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
end
	
	


-- Shoot the cue coin, using a visible force vector
function cueShot( event )
    
  	local t = event.target
	local phase = event.phase
	
	if event.x < 20  then
	event.x = 20
    elseif event.x > 730  then
	event.x = 730
	end
	
	if event.y < 150 then
	event.y = 150
	elseif event.y > 850 then
	event.y = 850
	end
	
		
	if "began" == phase then
	check = 1
	
	
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		
		-- Stop current Stricker motion, if any
		t:setLinearVelocity( 0, 0 )
		t.angularVelocity = 0

		target.x = t.x
		target.y = t.y

		startRotation = function()
			target.rotation = target.rotation + 4
		end
		
		Runtime:addEventListener( "enterFrame", startRotation )
		
		local showTarget = transition.to( target, { alpha=1, xScale=0.4, yScale=0.4, time=200 } )
		myLine = nil

	elseif t.isFocus then
		
		if "moved" == phase then
			
			
			if ( myLine ) then
				myLine.parent:remove( myLine ) -- erase previous line, if any
			end
			--myLine = display.newLine( t.x,t.y, event.x,event.y )
			myLine = display.newLine(  t.x, t.y,t.x-(-t.x+event.x)*3,t.y-(-t.y+event.y)*3 )
			myLine:setColor( 255, 255, 255, 100 )
			myLine.width = 20

		elseif "ended" == phase or "cancelled" == phase then
		
			     
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
                local stopRotation = function()
                    Runtime:removeEventListener( "enterFrame", startRotation )
                end
			
			local hideTarget = transition.to( target, { alpha=0, xScale=1.0, yScale=1.0, time=200, onComplete=stopRotation } )
			
                if ( myLine ) then
                    myLine.parent:remove( myLine )
                end
                
		    --t:applyForce( (t.x - event.x)*105, (t.y - event.y)*105, t.x, t.y )
            t:applyLinearImpulse(((t.x - event.x)*100), ((t.y - event.y)*100), ((t.x)), ((t.y)) )
  

            	--  code to put a timer to relocate stricker
        	resetButtonImg:removeEventListener("touch", resetGame )
            timer.performWithDelay(3000, relocateStricker, 1 )
            stricker:removeEventListener( "touch", cueShot )
		end
	end

    
	return true	-- Stop further propagation of touch event
	
	
end



--CHECKS THE STRICKER LOCATION BEFORE CUE_SHOT FOR RED CIRCLE AREA 
function checkRedArea(event)

    if event.x < 220 then
        stricker.x = 173
        local placeStricker = transition.to( stricker, { alpha=1.0, xScale=1.0, yScale=1.0, time=100 } )
      end
    
    if event.x > 555 then
        stricker.x = 595
        local placeStricker = transition.to( stricker, { alpha=1.0, xScale=1.0, yScale=1.0, time=100 } )
     end


end



--Draging Stricker Method
function startDrag( event )
--print("startDrag called")
	local t = event.target
  	
	local phase = event.phase
	if "began" == phase then

		event.target.xScale = 2
		event.target.yScale = 2
		-- event.target.isSensor = true

		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

		-- Stop current motion, if any
		event.target:setLinearVelocity( 0, 0 )
		event.target.angularVelocity = 0

	elseif t.isFocus then
		if "moved" == phase then
		if event.x<170 then
		  t.x = 170
		  elseif event.x>595 then
		  t.x = 595
		  else
			t.x = event.x - t.x0
			--t.y = event.y - t.y0
		 end	

		elseif "ended" == phase or "cancelled" == phase then
        
        event.target.xScale = 1
		event.target.yScale = 1
		event.target.isSensor = false
		getSafeAreaLocationForStricker(event)
        checkRedArea(event)
		
		stricker:removeEventListener( "touch", startDrag )
		stricker:addEventListener( "touch", cueShot ) -- Sets event listener to Stricker

			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			-- Switch body type back to "dynamic", unless we've marked this sprite as a platform
			if ( not event.target.isPlatform ) then
				event.target.bodyType = "dynamic"
			end

		end
	end

	-- Stop further propagation of touch event!
	return true
end


function replaceBlackCoin()

   print("penaltyScoredWhite!!")
    stackOfBlacks[#stackOfBlacks].alpha = 0
    stackOfBlacks[#stackOfBlacks].x = 380.0
    stackOfBlacks[#stackOfBlacks].y = 512.0
    local dropCoin = transition.to( stackOfBlacks[#stackOfBlacks], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
    stackOfBlacks[#stackOfBlacks] = nil
    print(#stackOfBlacks)

	--REDUCE PLAYER2 SCORE
	player2Score = player2Score - 1
	PlayerTwoScore.text = "Player2 Score : "..player2Score
end



function replaceWhiteCoin()

	print("penaltyScoredWhite!!")
    stackOfWhites[#stackOfWhites].alpha = 0
    stackOfWhites[#stackOfWhites].x = 380.0
    stackOfWhites[#stackOfWhites].y = 512.0
    local dropCoin = transition.to( stackOfWhites[#stackOfWhites], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
    stackOfWhites[#stackOfWhites] = nil
    print(#stackOfWhites)

		--REDUCE PLAYER1 SCORE
		player1Score = player1Score - 1
		PlayerOneScore.text = "Player1 Score : "..player1Score

end


function penaltyScore()
--check turn return a coin from player and queen if at level 1
	
	if queenLevel == 1 or queenLevel == 2 then
	replaceQueen()
	end
	
	if playerTurn == 1 then
	--replace white coin
		if #stackOfWhites > 0 then
		--replace white coin from stack
		replaceWhiteCoin()
		end
	
	else
	--replace black coin
		if #stackOfBlacks > 0 then
		--replace white coin from stack
		replaceBlackCoin()
		end
	end

end




function coinScored()
	--check queen counter
	--remove coin and update respective score and turn
	print("--check queen counter--remove coin and update respective score and turn\n")

	if queenLevel == 3 then
		queenLevel = 0
		queenEarned()
	end

	print("scoredCoin "..object.type)
	coinEarned()
end





function coinEarned()
	--check pocketed coin type and place queen with that player
	print("coin EARNED BY - - - "..object.type)
	if object.type == "white" then

		stackOfWhites[#stackOfWhites+1] = object
		stackOfWhites[#stackOfWhites].active = true
		stackOfWhites[#stackOfWhites].alpha = 0
		stackOfWhites[#stackOfWhites].x = scoredCordinatesX[#stackOfWhites]
		stackOfWhites[#stackOfWhites].y = 1000
		local dropCoin = transition.to( stackOfWhites[#stackOfWhites], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
		--INCREASE PLAYER 1 SCORE
		player1Score = player1Score + 1
		PlayerOneScore.text = "Player1 Score : "..player1Score
	    checkGameOver()

		        
	else
		stackOfBlacks[#stackOfBlacks+1] = object
		stackOfBlacks[#stackOfBlacks].active = true
		stackOfBlacks[#stackOfBlacks].alpha = 0
		stackOfBlacks[#stackOfBlacks].x = scoredCordinatesX[#stackOfBlacks]
		stackOfBlacks[#stackOfBlacks].y = 20
		local dropCoin = transition.to( stackOfBlacks[#stackOfBlacks], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
		--INCREASE PLAYER 2 SCORE
		player2Score = player2Score + 1
		PlayerTwoScore.text = "Player2 Score : "..player2Score	
		checkGameOver()
	          
	end

end



function queenEarned()
	--check pocketed coin type and place queen with that player
	print("QUEEN EARNED BY - - - "..object.type)
	      
	if object.type == "white" then
			queenStack[#queenStack].alpha = 0
	        queenStack[#queenStack].x = 380.0
	        queenStack[#queenStack].y = 1000.0
	        --INCREASE PLAYER 1 SCORE BY 5
	        player1Score = player1Score + 5
			PlayerOneScore.text = "Player1 Score : "..player1Score
	        checkGameOver()

	        
	else
			queenStack[#queenStack].alpha = 0
			queenStack[#queenStack].x = 380.0
	        queenStack[#queenStack].y = 20.0
	        --INCREASE PLAYER 2 SCORE BY 5
	        player2Score = player2Score + 5
			PlayerTwoScore.text = "Player2 Score : "..player2Score
	        checkGameOver()
	          
	end

			local dropCoin = transition.to( queenStack[#queenStack], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
	        queenStack[#queenStack] = nil
	 		queenLevel = 0

end

	--check turn and place queen with respective player
function queenScored()
	--check turn and place queen with respective player
	
	if playerTurn == 0 then
			queenStack[#queenStack].alpha = 0
	        queenStack[#queenStack].x = 380.0
	        queenStack[#queenStack].y = 912.0
	        local dropCoin = transition.to( queenStack[#queenStack], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )

	else
			queenStack[#queenStack].alpha = 0
	        queenStack[#queenStack].x = 380.0
	        queenStack[#queenStack].y = 112.0
	        local dropCoin = transition.to( queenStack[#queenStack], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )

	end

end

	--if queen at level 1 and No score/penalty then place queen at center
function replaceQueen()

    queenStack[#queenStack].alpha = 0
    queenStack[#queenStack].x = 380.0
    queenStack[#queenStack].y = 512.0
    local dropCoin = transition.to( queenStack[#queenStack], { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
    queenStack[#queenStack] = nil
    print(#queenStack)
	queenLevel = 0

end



--Function for removing coin after it goes into pocket
function removeCoin(self, event )
	object = event.other
    event.other:setLinearVelocity(0,0)
    event.other.active = false
    event.other.alpha = 0
    
   if check == 1  then  
   
      
        print("remove coin  "..event.other.type)
        
		if event.other.type == "white" or event.other.type == "black" then
			if queenLevel == 2 then
				queenLevel = 3
			end
			--checks if player scored for self or opponent and updates turn
			if object.type == playerTurnArray[playerTurn+1] then
				playerTurn = (playerTurn + 1)%2
			end

			timer.performWithDelay(3000, coinScored, 1)
		end 

		if event.other.type == "queen" then
			queenLevel = 1
			queenStack[#queenStack] = event.other
			playerTurn = (playerTurn + 1)%2
			timer.performWithDelay(3000, queenScored, 1)
		end

		
		if event.other.type == "stricker" then
			timer.performWithDelay(3000, penaltyScore, 1)
		end
		
		
	end	-- to remove double calls for same event
        
end



--EVENT TO RELOCATE THE STRICKER
       
function relocateStricker(event)

	stricker.isSensor = true
	 check = 0
     print("relocateStricker")
     playerTurn = (playerTurn + 1)%2
     print("playerTurn"..playerTurn)
     print("turn of player changed to"..playerTurnArray[playerTurn + 1])
     
     
     if queenLevel == 2 then
	     print("queenLevel == 2  and replaceQueen")
	     replaceQueen()
     elseif queenLevel == 1 then           
	     queenLevel = 2
	     print("queenLevel == 1")
     end

	checkCoinsInStrickerArea(event)
		stricker.alpha = 0

	if playerTurn == 0 then
		stricker.x = getRandomStrickerPosition()
        stricker.y = 740.0
    else
        stricker.x = getRandomStrickerPosition()
        stricker.y = 258.0
       
	end
	
	local dropStricker = transition.to( stricker, { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
	resetButtonImg:addEventListener("touch", resetGame )

    stricker:addEventListener( "touch", startDrag )
    return true	
end	

function getRandomStrickerPosition()
	return strickerSafeAreaArray[math.random(5)]
end

function getSafeAreaLocationForStricker(event)

	print("CurrentLocation for stricker ---->"..stricker.x)

	for i=1,#strickerAreaCoins do
		print("\n Stricker "..stricker.x)
		print("\n strickerAreaCoins Range"..strickerAreaCoins[i].x-coinRadius,strickerAreaCoins[i].x+coinRadius)
		if stricker.x > strickerAreaCoins[i].x-coinRadius and stricker.x < strickerAreaCoins[i].x+coinRadius then
			stricker.x = strickerAreaCoins[i].x+coinRadius+strickerRadius
			print("\n Stricker "..stricker.x)
		end
	end

end

function gameOver()
    gameGroup.alpha = 0.5
    gamecoinGroup.alpha = 0.5
  
    gameOverImg = display.newImage( "game-over1.jpg", 135, 248, true )
    gameOverImg.alpha = 0.7
   
    timer.performWithDelay(8000, resetGame, 1)

end

function checkGameOver() 
    if player1Score == 14 then
	    print("PLAYER 1 WINS!!")
	    PlayerOneScore.text = "WINNER!"
	    gameOver()
    elseif player2Score == 14 then
	    print("PLAYER 2 WINS!!")
	    PlayerTwoScore.text = "WINNER!"
	    gameOver()
    end

end
 


 function saveGame()
	print("savegame")
end 
 
         
function resetGame()
    player1Score = 0
    player2Score = 0
    gameGroup:removeSelf()
    gamecoinGroup:removeSelf()
    splash()
end     


function getSpritesInTheArea(event)
	print("Get Sprites Array "..event.object.type)
end


--To Check If The Stricker Area is Occupied by Any Coins - *test for the Stricker Area Co-ordinates is Required to be done properly*
function checkCoinsInStrickerArea(event)

	print("checkCoinsInStrickerArea "..#strickerAreaCoins)
	strickerAreaCoins = {}

	for i = 0, #spriteInstance do

		--print(playerTurn.."\n"..spriteInstance[i].x)

		if playerTurn == 1 then
			if (spriteInstance[i].x > 160 and spriteInstance[i].x < 620) and (spriteInstance[i].y > 220 and spriteInstance[i].y <290)  then
				print(playerTurn.."--\n------"..spriteInstance[i].x)	
				strickerAreaCoins[#strickerAreaCoins+1] = spriteInstance[i]
			end	
		end	

		if playerTurn == 0 then
			if (spriteInstance[i].x > 160 and spriteInstance[i].x < 600) and (spriteInstance[i].y > 710 and spriteInstance[i].y <780)  then
				print(playerTurn.."--\n------"..spriteInstance[i].x)	
				strickerAreaCoins[#strickerAreaCoins+1] = spriteInstance[i]
			end	
		end	
	end

	print("checkCoinsInStrickerArea again "..#strickerAreaCoins)

end


function setGame()  

    gameGroup = display.newGroup()
   
	--Reset Button

    resetButtonImg = display.newImage( "button3.png", 50, 915, true )
    resetButtonImg.alpha = 0.7
    gameGroup:insert(resetButtonImg)

    local resetButtonText = display.newText("Quit", 90, 925, null, 30)
	resetButtonText:setTextColor(255,255,255)
    gameGroup:insert(resetButtonText)

    resetButtonImg:addEventListener("touch", resetGame )


	--Code for creating Board image   
    myImage = display.newImage( "carrom-board"..themeNo..".jpg", 0, 115, true )
    myImage.alpha = 1 
    gameGroup:insert(myImage)
    
	--Score Card

	 PlayerTwoScore = display.newText("Player2 Score : "..player2Score, 300,40,native.systemfont,30)
     PlayerOneScore = display.newText("Player1 Score : "..player1Score, 300,920,native.systemfont,30)
     PlayerTwoScore.alpha = 1
     PlayerOneScore.alpha = 1
     gameGroup:insert(PlayerTwoScore)
     gameGroup:insert(PlayerOneScore)
  

  
    --Adding Coin and Stricker Physics Behaviour
	coinBody = { density=3.5*100, friction=0.5, bounce=0.95,  radius=coinRadius }
	strickerBody={ density=4.5*100, friction=0.5 , bounce=1.5, radius=strickerRadius }



	-- Code for creating Stricker
      gamecoinGroup = display.newGroup() 
   
      stricker = display.newImage( "Carrom_Striker"..themeNo..".png", 360,720, true )
      stricker.alpha = 1
      stricker.type = "stricker"
      gamecoinGroup:insert(stricker)
      physics.addBody( stricker, strickerBody )	
	  stricker.isBullet = true
	  stricker.active = true
      stricker.linearDamping = 3
      stricker.angularDamping = 3.0
      stricker.bodyType = "kinematic"
      --stricker:addEventListener( "postCollision", stricker )
	
      stricker.isAwake = true
      -- gameGroup:insert(stricker)

     target = display.newImage( "target.png" )
     target.alpha = 1
     target.x = stricker.x; target.y = stricker.y; target.alpha = 0;

	--Calling Stricker Method
 	 stricker:addEventListener( "touch", startDrag )


-- Making coins
          
     spriteInstance[0] = display.newImage("coin_queen"..themeNo..".png")
     spriteInstance[0].x = centerX
     spriteInstance[0].y = centerY
     spriteInstance[0].type = "queen"
    
    -- inner circle of Coins
      for i = 1, 6 do
        
        if math.fmod(i,2) ~= 0 then
            spriteInstance[i] = display.newImage("coin_white"..themeNo..".png")
            spriteInstance[i].type = "white"
        else
            spriteInstance[i] = display.newImage("coin_black"..themeNo..".png") 
            spriteInstance[i] .type = "black"
        end
        
        spriteInstance[i].x = 2 * coinRadius * math.cos(angle * deg2rad) + centerX
        spriteInstance[i].y = 2* coinRadius * math.sin(angle * deg2rad) + centerY
        angle = angle + 60

    end
    
    -- outer circle
    angle = 0
    local equivalentRadius = 0
    for i = 7, 18 do
        if math.fmod(i,2) == 0 then
            -- even
            equivalentRadius = 3 * coinRadius
            spriteInstance[i] = display.newImage("coin_white"..themeNo..".png")
            spriteInstance[i].type = "white"
        else
            -- odd
            equivalentRadius = 2 * coinRadius * math.sqrt(3)   
            spriteInstance[i] = display.newImage("coin_black"..themeNo..".png") 
            spriteInstance[i].type = "black"
        end
        
        spriteInstance[i].x = equivalentRadius * math.cos(angle * deg2rad) + centerX
        spriteInstance[i].y = equivalentRadius * math.sin(angle * deg2rad) + centerY
        angle = angle + 30
    end
    
-- for every coin (Assigning Physics to coins)
    for n = 0, 18 do
        gamecoinGroup:insert(spriteInstance[n])
		physics.addBody(spriteInstance[n], coinBody)
        spriteInstance[n].linearDamping = 3 -- simulates friction of felt
        spriteInstance[n].angularDamping = 5.0 -- stops coins from spinning forever
        spriteInstance[n].bodyType = "dynamic"
        spriteInstance[n].isFixedRotation = false
        --spriteInstance[n].angularVelocity = 0
        spriteInstance[n].active = true -- coin is set to active
        spriteInstance[n].bullet = false -- force continuous collision detection, to stop really fast shots from passing through other coins
        spriteInstance[n].isBullet = true
        
        -- spriteInstance[n].postCollision = coinCollisionAudio
        spriteInstance[n]:addEventListener( "postCollision", spriteInstance[n] )
        
        spriteInstance[n].id = "spritecoin"
        --spriteInstance[n]:addEventListener( "touch", dragBody )
        
    end
    

--the 4 Goal Pockets Code
    	
    local goal1 = display.newCircle( 50, 160, 10 )
    goal1:setFillColor(0,0,0, 100 )
    goal1.isVisible = true  -- optional
    physics.addBody( goal1, { isSensor = true } )
    gameGroup:insert(goal1)
    goal1.collision = removeCoin
    
    goal1:addEventListener("collision", goal1)
    
    
    
    
    local goal2 = display.newCircle( 717, 160, 10 )
    goal2:setFillColor(0,0,0, 100 )
    goal2.isVisible = true  -- optional
    physics.addBody( goal2, { isSensor = true } )
    gameGroup:insert(goal2)
    goal2.collision = removeCoin
    
    goal2:addEventListener("collision", goal2)
    
    
    
    local goal3 = display.newCircle( 50, 830, 10 )
    goal3:setFillColor(0,0,0, 100 )
    goal3.isVisible = false  -- optional
    physics.addBody( goal3, { isSensor = true } )
    gameGroup:insert(goal3)
    goal3.collision = removeCoin
    
    goal3:addEventListener("collision", goal3)
    
    
    
    local goal4 = display.newCircle( 725, 830, 10 )
    goal4:setFillColor(0,0,0, 100 )
    goal4.isVisible = false  -- optional
    physics.addBody( goal4, { isSensor = true } )
    gameGroup:insert(goal4)
    goal4.collision = removeCoin
    
    goal4:addEventListener("collision", goal4)

            
	--Code to add Walls

        borderCollisionFilter = { categoryBits = 2, maskBits =1 }
        borderBody = { friction=0.4, bounce=0.3, bodyType="static", filter = borderCollisionFilter}
        
        local borderTop = display.newRect( 10,140, 748, 5 )
        physics.addBody( borderTop,"static", borderBody )
        borderTop.isVisible = false
        borderTop.collision = playWallCollisionAudio  
        borderTop:addEventListener("collision", borderTop)
        gameGroup:insert(borderTop)
        
        local borderBottom = display.newRect( 10, 850,748, 5 )
        physics.addBody( borderBottom,"static", borderBody )
        borderBottom.isVisible = false
        borderBottom.collision = playWallCollisionAudio  
        borderBottom:addEventListener("collision", borderBottom)
        gameGroup:insert(borderBottom)
         
        local borderLeft = display.newRect(23,150, 5,700 )
        physics.addBody( borderLeft, "static",borderBody )
        borderLeft.isVisible = false
        borderLeft.collision = playWallCollisionAudio  
        borderLeft:addEventListener("collision", borderLeft)
        gameGroup:insert(borderLeft)
        
        local borderRight = display.newRect( 740, 150, 5, 700 )
        physics.addBody( borderRight,"static", borderBody )
        borderRight.isVisible = false
        borderRight.collision = playWallCollisionAudio  
        borderRight:addEventListener("collision", borderRight)
        gameGroup:insert(borderRight)

-- ---------------------------------------------------------------------------------------------------------
-- ------------------------------For CODE OPTIMIZATION------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------
-- 	local boundaryWalls = {}
-- 	local wallThickness =5
-- 	local wallCods = {{wallThickness,wallThickness,wallThickness,display.contentHeight},
-- 	{wallThickness,display.contentHeight-wallThickness,display.contentWidth,wallThickness},
-- 	{display.contentWidth-wallThickness,wallThickness,wallThickness, display.contentHeight},
-- 	{wallThickness,wallThickness,display.contentWidth,wallThickness}}

-- 	for i=1,4 do
-- 		print(wallCods[i][1],wallCods[i][2],wallCods[i][3],wallCods[i][4])
-- 		boundaryWalls[i]  = display.newRect(wallCods[i][1],wallCods[i][2],wallCods[i][3],wallCods[i][4] )
-- 		physics.addBody(boundaryWalls[i], "static",{ friction=3, bounce=0, density=10})
-- 	end

-- ------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------


	--CODE FOR STRICKER AREA SENSORS
				
        -- strickerArea1 = display.newRect( 160, 727, 450, 30 )
        -- physics.addBody( strickerArea1,"static")
        -- strickerArea1.id = 1
        -- borderBottom.isVisible = false
        -- strickerArea1.isSensor = true
        -- strickerArea1.isBodyActive = false
        -- gameGroup:insert(strickerArea1)

        -- strickerArea1.postCollision = getSpritesInTheArea
        -- strickerArea1:addEventListener("touch",strickerArea1 )

        -- strickerArea2 = display.newRect( 160, 240, 450, 30 )
        -- physics.addBody( strickerArea2,"static")
        -- strickerArea2.id = 2
        -- borderBottom.isVisible = false
        -- strickerArea2.isSensor = true
        -- strickerArea2.isBodyActive = false
        -- gameGroup:insert(strickerArea2)

        -- strickerArea2.onCollision = getSpritesInTheArea
        -- strickerArea2:addEventListener("collision",getSpritesInTheArea )
        
end



--First Init Method to get called
function init()
	 
	 splashGroup:removeSelf()
	 
	 local mainScreen = display.newImage("MainScreen.jpg", true, 20, 1, true)
	 mainScreen.alpha = 1
		 
	 --Player Score Variables
        player1Score = 0
        player2Score = 0

    --Player Variables
        queenLevel = 0
        playerTurn = 0

    --Array For stack of scored coins
        stackOfBlacks = {}
        stackOfWhites = {}
        queenStack = {}
 	 strickerAreaCoins ={}
 
	setGame()
	local function handleLowMemory( event ) 
	  	print( "!!!!!!!!!!!!!!!!!!memory warning received!!!!!!!!!!!!!!!!!!" ) 
	end
 
Runtime:addEventListener( "memoryWarning", handleLowMemory )
		
end

-- Set Up Splashh Screen
splash()
