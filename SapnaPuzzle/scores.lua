module(..., package.seeall)
local ui = require("ui")
require("ice")


local playerArray = {} 
local scoresArray = {} 
local score = 0
local gameLevel
local defaultField
local fields
local textArea
local isNewEntry = true
local fontsType = "Noteworthy-Bold" --"Skia-Regular"--"Chalkboard-Bold"--


function  loadScores(seconds, gLevel, fontType)
	fontsType = fontType
	fields = display.newGroup()

	local buttonScoresQuit = buttonScoreQuit  ------FROM main.lua
	local buttonScoresResume = buttonScoreResume ---
	buttonScoresQuit.alpha = 0 ---
	buttonScoresResume.alpha = 0 -- buttons to be removed as long as the player name is not being set
	

	score = seconds
	gameLevel = gLevel
	playerArray = {}
	scoresArray = {}
	getScoresForLevel(gameLevel)


	function quitScreen(event)
			
		if event.phase == "release" then
			if event.id == "buttonSave" then
				-- SAVE THE PLAYER NAME AND REMOVE TEXT AREA, LABEL AND BUTTON
				fields:removeSelf()
				buttonScoresQuit.alpha = 1
				buttonScoresResume.alpha = 1
			end

		end
	end

	local buttonSave = ui.newButton{
			default = "images/Done-Unpressed.png",
			over = "images/Done-Pressed.png",
			text = "",
			onEvent = quitScreen,
			id = "buttonSave",
			font = fontsType,
			textColor = { 51, 51, 51, 255 },
			size =display.contentWidth*0.03,
			emboss = true
			}
		buttonSave.x = display.contentWidth/2
		buttonSave.y = display.contentHeight/1.1
		buttonSave:scale(display.contentWidth/(4.5*buttonSave.width),display.contentWidth/(4.5*buttonSave.width))
		
		fields:insert(buttonSave)



	printAllData()
end

function printAllData()
	for i = 1, 3 do
		local scores = ice:loadBox(i, "scores" )
		print("______________________________________"..i)
		scores:print()
		print("______________________________________"..i)
	end
end


function getScoresForLevel(gameLevel)
	
	local scores = ice:loadBox(gameLevel, "scores" )

	scoresArray = scores:retrieve("scoresArray") or {}
	playerArray = scores:retrieve("playerArray") or {}

	if #scoresArray < 5 then
		-- READ PLAYER NAME AND SAVE THE scores
		isNewEntry = true
		local name = readPlayerName()
	
	else
		-- CHECK FOR HIGH SCORE
		isNewEntry = false
		checkHighScores()
		
	end

end

function saveScoresForLevel(gameLevel)
	local scores = ice:newBox( gameLevel,"scores" )
	scores:store( "scoresArray", scoresArray )
	scores:store( "playerArray", playerArray)
	scores:save()
	
end


function checkHighScores()
	print("checkHighScores()"..scoresArray[1],score)
	if scoresArray[#scoresArray]<score then
	else		
		scoresArray[5] = score
	
		table.sort(scoresArray, function(a,b) return a<b end)
		print (table.concat(scoresArray, ", "))

		--Read PLAYER NAME AND INSERT IT INTO ITS NEW LOCATION
		isNewEntry = false
		local name = readPlayerName()
		
		
	end	
end

function highScoreSave( pName )
	-- body
	--TEST AND REARRANGE PLAYER ARRAY
		local index
		local int countArray = #scoresArray
		for i=1,countArray do
			if scoresArray[i] == score then
				index = i
				break
			end 
		end
		countArray = #playerArray
		for i= countArray, index, -1  do
			playerArray[i] = playerArray[i-1]
		end

		playerArray[index]= pName

		saveScoresForLevel(gameLevel)
end


function addNewEntry(pName)

	scoresArray[#scoresArray+1] = score
	table.sort(scoresArray, function(a,b) return a<b end)
	print (table.concat(scoresArray, ", "))

	--TEST AND REARRANGE PLAYER ARRAY
	local index
	for i=1,#scoresArray do
		if scoresArray[i] == score then
			index = i
		end 
	end

	for i= #playerArray, index, -1  do
		playerArray[i+1] = playerArray[i]
	end
		playerArray[index]= pName

	saveScoresForLevel(gameLevel)
		
end


function readPlayerName()
	
	local PlayerName = "Unknown"

	-- Determine if running on Corona Simulator
	--
	local isSimulator = "simulator" == system.getInfo("environment")
	-- Native Text Fields not supported on Simulator
	--
	-- isSimulator = false
	if isSimulator then
		local msg = display.newText( " HELLO ", 0, 120,fontsType, 12 )
		msg.text = "Native Text Fields not supported on Simulator!"
		msg.x = display.contentWidth/2		-- center title
		msg:setTextColor( 255,255,0 )
		fields:insert(msg)
		local date = os.date( "*t" )  --returns date able 
		PlayerName =  date.day.."D:"..date.hour.."H:"..date.min.."M"
		
		return PlayerName
	else
		


		function saveScore(msg)
			native.setKeyboardFocus( nil )-- Hide keyboard
			PlayerName = " "..defaultField.text 
			
			if PlayerName == " " then
				PlayerName = date.day.."D:"..date.hour.."H:"..date.min.."M"
			end
			
			textArea:setText(msg)

			if isNewEntry then
				addNewEntry(PlayerName)
			else
				highScoreSave( PlayerName )
			end
			defaultField.alpha = 0

		 return PlayerName

		end


		function fieldHandler( event )
			if ( "began" == event.phase ) then
				-- This is the "keyboard has appeared" event
				-- In some cases you may want to adjust the interface when the keyboard appears.
				
			elseif ( "ended" == event.phase ) then
				-- This event is called when the user stops editing a field: for example, when they touch a different field
				
				-- saveScore("ended")

			elseif ( "submitted" == event.phase ) then
				-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
				saveScore("submitted")
			end

		end

			-- Predefine local objects for use later

 		defaultField = native.newTextField(display.contentWidth*0.2, display.contentHeight*0.18, display.contentWidth*0.6,display.contentHeight*0.1, fieldHandler )
		defaultField.font = native.newFont( fontsType, display.contentHeight*0.06 )
		fields:insert(defaultField)

		textArea = ui.newLabel{
			bounds = { display.contentWidth/2.7, display.contentHeight/10, display.contentWidth/4, display.contentHeight/9 },
			text = " ",
			font = fontsType,
			textColor = { 85, 205, 91, 255 },
			size = display.contentWidth/15,
			align = "center"
			}
			
			textArea:setText("ENTER PLAYER NAME")
		fields:insert(textArea)

	end
	-- PlayerName = defaultField.text or date.day.."D:"..date.hour.."h:"..date.sec.."s"
	

end

