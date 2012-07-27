---main.lua (splash, main menu, calls to other module)----------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
---A CORONA PROJECT --------------------------------------------------------------------------------------------------------
---CREATED BY : GIRISH VR --------------------------------------------------------------------------------------------------
---FOR : SAPNA SOLUTIONS INFOTECH PVT. LTD.---------------------------------------------------------------------------------
----Date : 10-Jan-2012 -----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------


require ("physics")
local ui = require("ui")-- Load external button/label library (ui.lua should be in the same folder as main.lua)
require("ice")
local widget = require "widget"
display.setStatusBar( display.HiddenStatusBar )--HIDE THE STATUS BAR
require "sprite"--for Animations using Sprites

physics.start()
-- physics.setDrawMode ( "hybrid" ) -- Uncomment in order to show in hybrid mode	
physics.setGravity( 0, 9.8 * 1)
physics.start()
local int margin = 40 --**read different values for different devices**
local gameLevel = 1
local fontType = "Noteworthy-Bold" --"Georgia-BoldItalic"--"MarkerFelt-Wide"--"Chalkboard-Bold"--

----------------------------------------------------------------------------------------------------------------------
---TO READ THE PLATFORM DEVICE MODEL ---------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

local platformName = system.getInfo( "platformName" )

local modelName = system.getInfo( "model" )

local isAndroid = platformName == "Android"

local isAndroidSim = platformName == "Mac OS X" and modelName ~= "iPhone" and modelName ~= "iPhone4" and modelName ~= "iPad" and modelName ~= "iPhone Simulator"

local isiOS = platformName == "iPhone" or platformName == "iOS" or modelName == "iPod touch" or modelName == "iPhone" or modelName == "iPhone4" or modelName == "iPad"
local isiOSsim = platformName == "Mac OS X" and modelName == "iPhone" or modelName == "iPhone4" or modelName == "iPad" or modelName == "iPhone Simulator"


if isiOS or isiOSsim then
	
	-- For iOS, load a different module depending on if user's device is
	-- an iPhone/iPod touch or an iPad.
	
	if modelName == "iPad" then
		if isiOSsim then
			print(" It is an iPad iOSsim ->"..platformName,modelName)
			margin = require( "ipad" ).loadMod()
			print(margin)
		end	
	else
		print(" It is an iPhone iOSsim ->"..platformName,modelName)
		margin = require( "iphone" ).loadMod()
		print(margin)
	end

elseif isAndroid or isAndroidSim then
	
	print(" It is an Android Sim ->"..platformName,modelName)

		if modelName == "myTouch" then 
			margin = require( "iphone" ).loadMod()
			print(margin)
		else	
			margin = require( "android" ).loadMod()
			print(margin)
		end

end

if modelName == "iPod touch" then
	fontType = "MarkerFelt-Wide"--"Noteworthy-Bold" --"Georgia-BoldItalic"--"Chalkboard-Bold"--"AmericanTypewriter-Bold"--
end

----------------------------------------------------------------------------------------------------------------------
---MAIN GAME SETUP ---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

local closedCard = {}
local faceCard = {}

local ContentWidth = display.contentWidth-margin
local ContentHeight = display.contentHeight
local int rows = 4 --SET THIS VALUE ACCORDING TO THE DIFFICULTY
local int columns = 4 --SET THIS VALUE ACCORDING TO THE DIFFICULTY

local int buttonFontSize = display.contentWidth*0.06 --**read different values for different devices**

---MAAIN PAGE

local button1
local button2
local button3
local buttonQuit


---GAME VARIABLES

local count = 0
local int card1 = 0
local int card2 = 0
local scaleX, scaleY --to set image ratio
local numberOfCards
local remainingCards
local buttonQuitGameEnabled = true

local int seconds = 0
local int minutes = 0
local scoreTimer


---SOUND FILES

local clickButtonSound = media.newEventSound("buttonclick.mp3")
local loadNewViewSound = media.newEventSound("loadnewview.mp3")
local flipCardSound = media.newEventSound("flipcard.mp3")
local rotateAndShrinkSound = media.newEventSound("rotateandshrink.mp3")
local flipBackSound = media.newEventSound("flipback.mp3")
-- local gameUpSound = media.newEventSound("")
local gameBackGroundSound = media.newEventSound("bgtone.mp3")

local clickButtonSound_ = audio.loadSound("buttonclick.mp3")
local loadNewViewSound_ = audio.loadSound("loadnewview.mp3")
local flipCardSound_ = audio.loadSound("flipcard.mp3")
local rotateAndShrinkSound_ = audio.loadSound("rotateandshrink.mp3")
local flipBackSound_ = audio.loadSound("flipback.mp3")
-- local gameUpSound_ = audio.loadSound("")
-- local gameBackGroundSound_ = audio.loadSound("bgtone.mp3")



function setFirstView()
	
	-- media.playEventSound(loadNewViewSound )		

	local firstPageGroup = display.newGroup()
	local instance1

	function loadScreen(event)
		print("loadScreen "..event.phase)
			

		if event.phase == "release" then
			-- media.playEventSound(clickButtonSound)
			audio.play(clickButtonSound_)
			firstPageGroup:removeSelf()	
			if event.id == "button1" then
				startGame()
			elseif event.id == "button2" then
				setDifficulty()
			elseif event.id == "button3" then
				getBestScores()
			elseif event.id == "button4" then
			local nothing = require( "information" ).loadInformation()-- call information.lua for score calculation
			print("returned "..nothing)
			end

			
		end
	end


	button1 = ui.newButton{
			default = "images/Play-Unpressed.png",
			over = "images/Play-Pressed.png",
			
			-- onPress = startGame,
			-- onRelease = removeSelfScreen,
			-- text = "PLAY",
			onEvent = loadScreen,
			id = "button1",
			font = "Trebuchet-BoldItalic",
			textColor = { 51, 51, 51, 255 },
			size = buttonFontSize,
			emboss = true
		}

	button1.x = display.contentWidth/5 +display.contentWidth; button1.y = display.contentHeight/4 --display.contentWidth added for animation purpose
	button1:scale(display.contentWidth/1000,display.contentWidth/1000)	
	firstPageGroup:insert(button1)

	button2 = ui.newButton{
		default = "images/Difficulty-Unpressed.png",
		over = "images/Difficulty-Pressed.png",
		-- text = "DIFFICULTY",
		onEvent = loadScreen,
		id = "button2",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize,
		emboss = true
	}
	button2.x = display.contentWidth/5 + display.contentWidth; button2.y = display.contentHeight/2.5
	button2:scale(display.contentWidth/900,display.contentWidth/900)
	firstPageGroup:insert(button2)

	button3 = ui.newButton{
		default = "images/Scores-UnPressed.png",
		over = "images/Scores-Pressed.png",
		-- text = "BEST SCORES",
		onEvent = loadScreen,
		id = "button3",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize,
		emboss = true
	}
	button3.x = display.contentWidth/5 + display.contentWidth; button3.y = display.contentHeight/1.83
	button3:scale(display.contentWidth/900,display.contentWidth/900)
	firstPageGroup:insert(button3)

	local buttonText ={}
	local buttonLabel = {"PLAY","DIFFICULTY","BEST SCORES", button1, button2, button3}

	for i=1,3 do
		
		buttonText[i] = ui.newLabel{
			bounds = {  display.contentWidth/3 - display.contentWidth, buttonLabel[3+i].y-30, display.contentWidth/4, display.contentHeight/9 },
			text = buttonLabel[i],
			font = fontType,--"AmericanTypewriter-Bold",
			textColor = { 85, 205, 91, 255 },
			size = display.contentWidth/15,
			align = "left"
		}
		firstPageGroup:insert(buttonText[i])
	end

	button4 = ui.newButton{
		default = "images/Info-Unpressed.png",
		over = "images/Info-Pressed.png",
		onEvent = loadScreen,
		id = "button4",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize,
		emboss = true
	}
	button4.x = display.contentWidth/1.3 - display.contentWidth; button4.y = display.contentHeight/1.14
	button4:scale(display.contentWidth/1000,display.contentWidth/1000)
	firstPageGroup:insert(button4)
	

	function pageLoadAnimation()
		print("-- body pageLoadAnimation()")
		for i=1,3 do
			buttonText[i]:slideLeft{ slideAlpha=1, distance=-display.contentWidth} 
		end
		button1:slideRight{ slideAlpha=1, distance=-display.contentWidth}
		button2:slideRight{ slideAlpha=1, distance=-display.contentWidth}
		button3:slideRight{ slideAlpha=1, distance=-display.contentWidth}
		button4:slideRight{ slideAlpha=1, distance=display.contentWidth}
	end

	firstPageGroup.alpha =0
	transition.to(firstPageGroup,{time = 100, alpha = 1, delay = 113, onComplete = pageLoadAnimation})

	
	
		
end--setFirstView()
 

function getBestScores()
	
	-- media.playEventSound(loadNewViewSound )		

	local scoreCardGroup =display.newGroup()

	function quitScreen(event)
			
		if event.phase == "release" then
			-- media.playEventSound(clickButtonSound)
			audio.play(clickButtonSound_)
			if event.id == "buttonQuit" then
				print("quitScreen BestScores"..event.phase)
				scoreCardGroup:removeSelf()
				setFirstView()	
			end

		end
	end

	buttonQuit = ui.newButton{
		default = "images/Back-Unpressed.png",
		over = "images/Back-Pressed.png",
		text = "",
		onEvent = quitScreen,
		id = "buttonQuit",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize*0.7,
		emboss = true
	}

	buttonQuit.x = display.contentWidth/7
	buttonQuit.y = display.contentHeight/1.09
	buttonQuit:scale(display.contentWidth/(4.5*buttonQuit.width),display.contentWidth/(4.5*buttonQuit.width))

	scoreCardGroup:insert(buttonQuit)



    local newSegmentedControlrelease = function()
		
		
		myPanel = display.newGroup()

		bestScoreLabel = ui.newLabel{
		bounds = { display.contentWidth/2,display.contentHeight/10, display.contentWidth/4, display.contentHeight/9 },
		text = "BEST TIME",
		font = fontType,
		textColor = { 105, 122, 94, 255 },
		size = display.contentWidth/18,
		align = "left"
		}
		myPanel:insert(bestScoreLabel)
		
		-- create the different "fruit" objects
		local apple, lemon, kiwi
		newSegmentedControl = widget.newSegmentedControl

		local scoreCard = {}
		for i=1,5 do
			scoreCard[i] = display.newText("" ,display.contentWidth*0.5, display.contentWidth*0.25 +i*display.contentHeight/16, fontType, display.contentWidth*0.07 )
			scoreCard[i]:setTextColor(81, 92, 175, 255)
			myPanel:insert(scoreCard[i])
		end
		
		

		local rect1 = display.newRect( display.contentWidth*0.15, display.contentWidth*0.15, display.contentWidth*0.7, display.contentHeight*0.65 )
			rect1:setFillColor( 85, 205, 91, 100 )
			rect1:setReferencePoint( display.CenterReferencePoint )

		local rect2 = display.newRect( display.contentWidth*0.15, display.contentWidth*0.15, display.contentWidth*0.7, display.contentHeight*0.65 )
			rect2:setFillColor( 85, 205, 91, 150 )
			rect2:setReferencePoint( display.CenterReferencePoint )
			rect2.isVisible = false

		local rect3 = display.newRect( display.contentWidth*0.15, display.contentWidth*0.15, display.contentWidth*0.7, display.contentHeight*0.65 )
			rect3:setFillColor( 85, 205, 91, 200 )
			rect3:setReferencePoint( display.CenterReferencePoint )
			rect3.isVisible = false

		
		
		myPanel:insert( rect1 )
		myPanel:insert( rect2 )
		myPanel:insert( rect3 )
		
		rect1:toBack() rect2:toBack() rect3:toBack()


		
		local onBtnPress = function( event )
			print( "You pressed button #" .. event.target.id )
			-- media.playEventSound(clickButtonSound)
			audio.play(clickButtonSound_)
			local id = tonumber(event.target.id)
				
				local retrivedScore1 = ice:loadBox(id, "scores" )	-----------------------------
				retrivedScore1:print()								---Scores For each Level---
				print("savedData from getBestScores"..id)			--------------------------

				local playerArray , scoresArray = {}
				playerArray = retrivedScore1:retrieve("playerArray") or {}
				scoresArray = retrivedScore1:retrieve("scoresArray") or {}

				for i=1,5 do
					scoreCard[i].text = ""
				end
				
				for i=1,#playerArray do
					scoreCard[i].text = playerArray[i].." - "..scoresArray[i]
				end

			if id == 1 then
				
				rect1.isVisible = true
				rect2.isVisible = false
				rect3.isVisible = false
		

			elseif id == 2 then
			
				rect1.isVisible = false
				rect2.isVisible = true
				rect3.isVisible = false
			
			elseif id == 3 then
				
				rect1.isVisible = false
				rect2.isVisible = false
				rect3.isVisible = true
				
			end
			
			return true
		end
		
		
		
		-- set up a table to hold button information
		local myButtons = {
			{ label="    EASY  ", onPress=onBtnPress, isDown=true ,textColor = { 51, 51, 51, 255 }},
			{ label=" MEDIUM ", onPress=onBtnPress },
			{ label="EXTREME", onPress=onBtnPress }
		}
		
		-- set up the segmented control
		rowOfButtons = newSegmentedControl( myButtons )
		rowOfButtons:setReferencePoint( display.CenterReferencePoint )
		rowOfButtons.x = display.contentWidth * 0.5
		rowOfButtons.y = display.contentHeight * 0.8
		myPanel:insert( rowOfButtons.view )
	
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }

		scoreCardGroup : insert(myPanel)

	function loadScoreCard()
		local retrivedScore1 = ice:loadBox(1, "scores" )	-----------------------------
		retrivedScore1:print()								---Scores For each Level---
		-- print("savedData from getBestScores"..id)		--------------------------

		local playerArray , scoresArray = {}
		playerArray = retrivedScore1:retrieve("playerArray") or {}
		scoresArray = retrivedScore1:retrieve("scoresArray") or {}

		for i=1,5 do
			scoreCard[i].text = " "
		end
		
		for i=1,#playerArray do
			scoreCard[i].text = playerArray[i].." - "..scoresArray[i]
		end
	end

	loadScoreCard()

	end


    newSegmentedControlrelease()

end



function setDifficulty()--button2
	   
	-- media.playEventSound(loadNewViewSound )		

	local difficultyPageGroup = display.newGroup()

	function setLevel(event)

		print("id = "..event.id)

		if event.phase == "release" then
			-- media.playEventSound(clickButtonSound)
			audio.play(clickButtonSound_)		
		-- event listener for all the buttons
			if event.id == "level1" then
				highLighter.y = display.contentHeight/3
				gameLevel = 1			
			elseif event.id == "level2" then
				highLighter.y = display.contentHeight/2
				gameLevel = 2
			elseif event.id == "level3" then
				highLighter.y = display.contentHeight/1.54
				gameLevel = 3
			end
		
			difficultyPageGroup:removeSelf()
			setFirstView()
		
		end
	end


	level1 = ui.newButton{
		default = "images/Easy-Unpressed.png",
		over = "images/Easy-Pressed.png",
		-- onPress = startGame,
		-- onRelease = setLevel,
		text = "",
		onEvent = setLevel,
		id = "level1",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize,
		emboss = true
	}
	level1.x = display.contentWidth/3.5; level1.y = display.contentHeight/3.2 
	level1:scale(display.contentWidth/(4.5*level1.width), display.contentWidth/(4.5*level1.width))
	difficultyPageGroup:insert(level1)

	level2 = ui.newButton{
		default = "images/Medium-Unpressed.png",
		over = "images/Medium-Pressed.png",
		-- onPress = startGame,
		-- onRelease = setLevel,
		text = "",
		onEvent = setLevel,
		id = "level2",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize,
		emboss = true
	}
	level2.default = "images/Medium-Pressed.png"
	level2.x = display.contentWidth/3.5; level2.y = display.contentHeight/2
	level2:scale(display.contentWidth/(4.5*level2.width), display.contentWidth/(4.5*level2.width))
	difficultyPageGroup:insert(level2)

	level3 = ui.newButton{
		default = "images/Extreme-Unpressed.png",
		over = "images/Extreme-Pressed.png",
		-- onPress = startGame,
		-- onRelease = setLevel,
		text = "",
		onEvent = setLevel,
		id = "level3",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize,
		emboss = true
	}
	level3.x = display.contentWidth/3.5; level3.y = display.contentHeight/1.45
	level3:scale(display.contentWidth/(4.5*level3.width), display.contentWidth/(4.5*level3.width))
	difficultyPageGroup:insert(level3)

    -- highLighter =  display.newRoundedRect(level3.x-level3.width/2-2,level3.y-level3.height/2-2,level3.width+4,level3.height+4,6 )
    highLighter =  display.newCircle(level3.x,level3.y,display.contentWidth*0.13 )--display.newCircle( xCenter, yCenter, radius )
    -- highLighter:scale(display.contentWidth/(4*highLighter.width), display.contentHeight/(7*highLighter.height))
    highLighter:setFillColor( 105, 122, 94, 255 )
    difficultyPageGroup:insert(highLighter)
    highLighter:toBack()



    local levelArray = {"EASY","MEDIUM","EXTREME",display.contentHeight/2.82,display.contentHeight/1.92,display.contentHeight/1.4}
    local levelText = {}
    for i=1,3 do
    	print(i)

    	levelText[i] = ui.newLabel{
		bounds = { display.contentWidth/2,tonumber(levelArray[i+3]), display.contentWidth/4, display.contentHeight/9 },
		text = levelArray[i],
		font = fontType,
		textColor = { 105, 122, 94, 255 },
		size = display.contentWidth/18,
		align = "left"
		}
		levelText[i].alpha = 0
		difficultyPageGroup:insert(levelText[i])
    end
	levelText[gameLevel].alpha = 1

    if gameLevel == 1 then
		highLighter.y = display.contentHeight/3.2

	    elseif gameLevel == 2 then
			highLighter.y = display.contentHeight/2 

		    elseif gameLevel == 3 then
				highLighter.y = display.contentHeight/1.45

    end



------------------------------------------------------------------------------------------------------------------------
------------------------SLIDE ANIMATION---------------------------------------------------------------------------------		
------------------------------------------------------------------------------------------------------------------------
		level1.y = level1.y - display.contentHeight
		level1:slideDown{ slideAlpha=1, distance=display.contentHeight}
		level2.y = level2.y - display.contentHeight
		level2:slideDown{ slideAlpha=1, distance=display.contentHeight}
		level3.y = level3.y - display.contentHeight
		level3:slideDown{ slideAlpha=1, distance=display.contentHeight}

		levelText[gameLevel].x = levelText[gameLevel].x + display.contentWidth
		levelText[gameLevel]:slideLeft{ slideAlpha=1, distance=display.contentWidth}
------------------------------------------------------------------------------------------------------------------------    

end--setDifficulty()




------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------START THE GAME----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

function startGame()--button1
	print("startGame()")
	-- media.playEventSound(loadNewViewSound )		
	
	timer.performWithDelay(110,setUpCards,1)
	
end


local cardGroup

function setUpCards()
	buttonQuitGameEnabled = true
	print("setUpCards()")
	cardGroup = display.newGroup()
	closedCard = {}
	faceCard = {}
	count = 0


	timerText = ui.newLabel{
		bounds = { margin , display.contentHeight/30, display.contentWidth/4, display.contentHeight/9 },--**read different values for different devices**
		text = "",
		font = fontType,
		textColor = { 85, 206, 91, 255 },
		size = display.contentWidth/15,
		align = "left"
	}

	cardGroup:insert(timerText)
		
	function timerClock()
		seconds = seconds +1
			if seconds%60 == 0 then
				minutes = minutes +1
			end
		timerText:setText( "TIMER - "..seconds )
		scoreTimer=timer.performWithDelay( 1000, timerClock, 1 )
	end


	timerClock()
	timerText.alpha = 1 --DISPLAY TIMERTEXT



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*RESET FOR TESTING*----------------------------------------------
-------------rows = 2;columns = 2


	if gameLevel == 1 then
		rows = 4;columns = 4
		gameImage = display.newImage( "images/Easy-Pressed.png" )
	    elseif gameLevel == 2 then
			rows = 6;columns = 6
			gameImage = display.newImage( "images/Medium-Pressed.png" )
		    elseif gameLevel == 3 then
				rows = 8;columns = 8
				gameImage = display.newImage( "images/Extreme-Pressed.png" )
    end

gameImage.x = display.contentWidth/1.1; gameImage.y = display.contentHeight/15
gameImage:scale(display.contentWidth/1400,display.contentWidth/1400)
cardGroup:insert( gameImage )

---------------------------------------------------------------------------------------------------------------------

	local totalImages = 32
	numberOfCards = (rows*columns) -1
	remainingCards	= numberOfCards
	local int cardWidth = (ContentWidth - margin)/rows --SET THIS VALUE ACCORDING TO THE DEVICE

	local startImageNumber = math.random(0,totalImages-1)
	--OPEN CARDS--
	for i=0,numberOfCards/2 do

		local n
		if (startImageNumber+ i >  totalImages-1) then
			startImageNumber = 0-i
		end
		n = startImageNumber+i
		faceCard[i] = display.newImage( "images/GVRFace"..n..".png" )
		faceCard[i].myName = n
		faceCard[i].isVisible = true
		cardGroup:insert( faceCard[i] )
	end


	for i=math.ceil (numberOfCards/2),numberOfCards do
		local n = faceCard[i-math.ceil (numberOfCards/2)].myName
		faceCard[i] = display.newImage( "images/GVRFace"..n..".png" )
		faceCard[i].myName = n
		faceCard[i].isVisible = true
		cardGroup:insert( faceCard[i])
	end


		--CLOSED CARDS--
	for	i=0,numberOfCards do
	closedCard[i] = display.newImage( "images/GVRFaceClosed.png" )--( "images/GVRClosedCard.png" ) --( "images/GVRFaceB.png" )
	closedCard[i].isVisible = true
	closedCard[i]:scale(cardWidth/closedCard[i].width, cardWidth/closedCard[i].height)
	closedCard[i].myName = i
	closedCard[i]:addEventListener("tap", selected)
	cardGroup:insert(closedCard[i])
	end

	scaleX = cardWidth/closedCard[0].width --use this for further scaling
	scaleY = cardWidth/closedCard[0].height --use this for further scaling

	--CODE FOR CO-ORDINATES OF N x N POINTS

	local int k = 0
	for i=0,columns-1 do
		for j=0,rows -1 do
			closedCard[k].x = i*ContentWidth/rows + ContentWidth/(2*rows) + margin/2 
			closedCard[k].y = j*ContentWidth/rows + ((ContentHeight-ContentWidth)/2+(ContentWidth/(2*rows)))
			closedCard[k].id = k



			k=k+1
		end
	end

		

	-- TO RANDOMIZE THE CONTENT OF THE ARRAY
		for i = #faceCard, 2, -1 do -- backwards
		    local r = math.random(i) -- select a random number between 1 and i
		    faceCard[i], faceCard[r] = faceCard[r], faceCard[i] -- swap the randomly selected item to position i
		    -- closedCard[i], closedCard[r] = closedCard[r], closedCard[i] 
		end

	-- CO ORDINATES FOR EACH FACECARDS
		for i=0,#faceCard do 
			-- print("faceCard[i] "..faceCard[i].myName)
			faceCard[i].x = closedCard[i].x
			faceCard[i].y =	closedCard[i].y
			faceCard[i]:scale(scaleX,scaleY)--adjust the card dimensions to required size
			faceCard[i].alpha = 0
		end


		-----------------------QUIT BUTTON ON GAME BOARD------------------

    function quitScreen(event)
		
		
		if event.phase == "release" then
			-- media.playEventSound(clickButtonSound )		
			audio.play(clickButtonSound_)
			if event.id == "buttonQuitGame" then
				print("quitScreen "..event.phase)
				if buttonQuitGameEnabled then
					timer.cancel(scoreTimer)
					cardGroup:removeSelf()
					seconds = 0;minutes = 0
					setFirstView()	
				end
			end

		end
	end

	buttonQuitGame = ui.newButton{
		default = "images/Quit-Unpressed.png",
		over = "images/Quit-Pressed.png",
		-- onPress = startGame,
		-- onRelease = removeSelfScreen,
		text = "",
		onEvent = quitScreen,
		id = "buttonQuitGame",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize*0.7,
		emboss = true
	}

	buttonQuitGame.x = display.contentWidth/7
	buttonQuitGame.y = display.contentHeight/1.07
	buttonQuitGame:scale(display.contentWidth/(4.5*buttonQuitGame.width),display.contentWidth/(4.5*buttonQuitGame.width))

	cardGroup:insert(buttonQuitGame)

	-- SLIDE ANIMATION
	cardGroup.x = -display.contentWidth
	cardGroup:slideRight{ slideAlpha=1, distance=display.contentWidth}

end


function selected(event)
	count = count + 1
	-- print("FLIP UP "..event.target.id)

	timer.performWithDelay(1000, flipUp(event), 1)	

		if(count == 1) then
			-- media.playEventSound(flipCardSound )
			audio.play(flipCardSound_)		
			card1 = event.target.id
			closedCard[card1]:removeEventListener("tap", selected)
		else if(count == 2) then
			buttonQuitGameEnabled = false
				card2 = event.target.id
				timer.performWithDelay(1000, listener, 1)
				count =0
					for	i=0,numberOfCards do
					 closedCard[i]:removeEventListener("tap", selected)
					end
			end
		end
	
end


function flipUp(event)--FLIP THE CLOSED CARD TO FACE CARDS
	local index = event.target.id
	print("flipUp "..index)

	closedCard[index].yScale = scaleY
	transition.to(closedCard[index], {time = 325,alpha = 0.0, xScale = .001})
	-- closedCard[index].isVisible = false

	faceCard[index].xScale = .001
	faceCard[index].yScale = scaleY
	-- faceCard[index].isVisible = true
	transition.to(faceCard[index],{time = 325, alpha = 1.0, delay = 130, xScale = scaleX })
	
end

function flipBack(index)
	print("flipBack "..index)
	-- media.playEventSound(flipBackSound )
	audio.play(flipBackSound_)		

	faceCard[index].yScale = scaleY
	transition.to(faceCard[index], {time = 225, alpha = 0.0, xScale = .001})
	-- faceCard[index].isVisible = false

	closedCard[index].xScale = .001
	closedCard[index].yScale = scaleY
	-- closedCard[index].isVisible = true
	transition.to(closedCard[index],{time = 225, alpha = 1.0, delay = 130, xScale = scaleX })
	buttonQuitGameEnabled = true
end


function listener( event )
	local int indx1 =  card1
	local int indx2 =  card2

	print("card1 "..card1)
	print("card2 "..card2)
	print("faceCard[indx1].myName "..faceCard[indx1].myName)
	print("faceCard[indx2].myName "..faceCard[indx2].myName)

	if (faceCard[indx1].myName == faceCard[indx2].myName) then
		timer.performWithDelay(1000, rotateAndShrink(indx1,indx2), 1)
		remainingCards = remainingCards -2
	else
	    print( "listener called : Empty function for delay" )
	    timer.performWithDelay(1000, flipBack(card1), 1)
		timer.performWithDelay(1000, flipBack(card2), 1)	
	end

	for	i=0,numberOfCards do
		closedCard[i]:addEventListener("tap", selected)
	end

	
	print("remainingCards"..remainingCards.."/"..numberOfCards)
	if remainingCards == -1 then
		timer.cancel(scoreTimer)
		timer.performWithDelay(2000, gameScore, 1)
	end

end


function gameScore()--DISPLAYS SCORE CARD AND CHECKS IF THE SCORE IS IN TOP 5
	print("gameScore()")
	gameScoreGroup = display.newGroup()
	cardGroup:removeSelf()
	

	-- SCORE and Resume/Quit button
	function quitScreen(event)
		
		
		if event.phase == "release" then
			timer.cancel(scoreTimer)
				gameScoreGroup:removeSelf()
				seconds = 0;minutes = 0
				print("gameScoreGroup quitScreen "..event.phase)
			if event.id == "buttonScoreQuit" then
				setFirstView()	
			elseif event.id == "buttonScoreResume" then
				setUpCards()
			end

		end
	end

	buttonScoreQuit = ui.newButton{
		default = "images/Quit-Unpressed.png",
		over = "images/Quit-Pressed.png",
		-- onPress = startGame,
		-- onRelease = removeSelfScreen,
		-- text = "QUIT",
		text = "",
		onEvent = quitScreen,
		id = "buttonScoreQuit",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize*0.7,
		emboss = true
	}

	buttonScoreQuit.x = display.contentWidth/7
	buttonScoreQuit.y = display.contentHeight/1.08
	buttonScoreQuit:scale(display.contentWidth/(4.5*buttonScoreQuit.width),display.contentWidth/(4.5*buttonScoreQuit.width))

	gameScoreGroup:insert(buttonScoreQuit)


	buttonScoreResume = ui.newButton{
		default = "images/RePlay-Unpressed.png",
		over = "images/RePlay-Pressed.png",
		text = "",
		onEvent = quitScreen,
		id = "buttonScoreResume",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = buttonFontSize*0.7,
		emboss = true
	}

	buttonScoreResume.x = display.contentWidth/1.18
	buttonScoreResume.y = display.contentHeight/1.08
	buttonScoreResume:scale(display.contentWidth/(4.5*buttonScoreQuit.width),display.contentWidth/(4.5*buttonScoreQuit.width))

	gameScoreGroup:insert(buttonScoreResume)

	scoreText = ui.newLabel{
		bounds = { display.contentWidth/2.6, display.contentHeight/2.5, display.contentWidth/4, display.contentHeight/9 },
		text = "",
		font = fontType,
		textColor = { 85, 206, 91, 255 },
		size = display.contentWidth/15,
		align = "center"
	}


	scoreText:setText( "SCORE IS "..seconds)--save the score, time, date, player here
	gameScoreGroup:insert(scoreText)
	
	local nothing = require( "scores" ).loadScores(seconds, gameLevel, fontType)-- call scores.lua for score calculation

	
end




function rotateAndShrink(object1, object2)
	buttonQuitGameEnabled = false
	print("ROTATE "..object1, object2)
	-- media.playEventSound(rotateAndShrinkSound)		
	audio.play(rotateAndShrinkSound_)
	faceCard[object1]:scale(scaleX, scaleY)
 
 	local time = system.getTimer()
 	local rotateAmount = 1

	startRotation = function()
		local j = faceCard[object1].xScale - .03
		faceCard[object1].xScale = j
		faceCard[object1].yScale = j
		faceCard[object2].xScale = j
		faceCard[object2].yScale = j

		if (faceCard[object1].xScale < 0.05) then
			Runtime:removeEventListener( "enterFrame", startRotation )
			faceCard[object1].alpha = 0
			faceCard[object2].alpha = 0
			buttonQuitGameEnabled = true
		end

		local now = system.getTimer()
		local elapsed = now-time
		local rotationAngle = rotateAmount * elapsed

		time = now
		faceCard[object1].rotation = faceCard[object1].rotation%360 +rotationAngle/2
		faceCard[object2].rotation = faceCard[object2].rotation%360 +rotationAngle/2
		print("rotationAngle\nrotationAngle\nrotationAnglerotationAnglerotationAngle"..rotationAngle)
	end
		
	Runtime:addEventListener( "enterFrame", startRotation )
	timer.performWithDelay(3000, createTwinkle(faceCard[object1]), 1)
	createTwinkle(faceCard[object2])

end

function splash()
	-- local splashGroup = display.newGroup()
	-- local splashImage = display.newImage( "images/Splash-iPhone.png" )
	-- splashImage.x = display.contentWidth/2
	-- splashImage.y = display.contentHeight/2
	-- splashGroup:insert(splashImage)
 
 -- 	local function removeSplashScreen()
 		
 		
 -- 		splashGroup:removeSelf()
 		
	-- 	audio.play(gameBackGroundSound_)
	-- 	setFirstView()
 -- 	end

 -- 	transition.to(splashImage,{time = 4000, alpha = 0.05, delay = 3000})
 -- 	timer.performWithDelay(4000,removeSplashScreen)

  	
end



splash()--GAME BEGINS HERE


------------------------------------------------------------------------------------------------------
--------------------------------TWINKLE ANIMATION-----------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Twinkle properties 
local minTwinkleRadius = 10 
local maxTwinkleRadius = 15
local numOfTwinkleParticles = 10
local twinkleFadeTime = 500
local twinkleFadeDelay = 300

local minTwinkleVelocityX = -150
local maxTwinkleVelocityX = 150
local minTwinkleVelocityY = -150
local maxTwinkleVelocityY = 150
-- Twinkle filter should not interact with other cards or the catch platform
local twinkleProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 4, maskBits = 8} } 

-- Creates a twinkleing effect that makes it look like stars are flying out of the card
function createTwinkle(card)

	local i
	for  i = 0, numOfTwinkleParticles do
		-- local twinkle = display.newCircle( fruit.x, fruit.y-50, math.random(minTwinkleRadius, maxTwinkleRadius) )
		local twinkle = display.newImage( "images/star.png", card.x, card.y-50, math.random(minTwinkleRadius, maxTwinkleRadius) )
		--twinkle:setFillColor(255, 0, 0, 255)
		
		twinkleProp.radius = twinkle.width / 2
		physics.addBody(twinkle, "dynamic", twinkleProp)

		local xVelocity = math.random(minTwinkleVelocityX, maxTwinkleVelocityX)
		local yVelocity = math.random(minTwinkleVelocityY, maxTwinkleVelocityY)

		twinkle:setLinearVelocity(xVelocity, yVelocity)
		
		transition.to(twinkle, {time = twinkleFadeTime, delay = twinkleFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) twinkle:removeSelf() end})		
	end

end


-- local fonts = native.getFontNames()
-- local count
-- for i,font in ipairs(fonts) do
-- print(font)
-- end