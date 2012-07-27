































require ("physics")
local ui = require("ui")
require("ice")
physics.start()
-- physics.setDrawMode ( "hybrid" ) -- Uncomment in order to show in hybrid mode	
physics.setGravity( 0, 9.8 * 1)

physics.start()

local reverse = 0
local object
local closedCard = {}
local faceCard = {}
local imageArray = {}
local count = 0
local int card1 = 0
local int card2 = 0
local int CardNumber = 0
local int NumberOfRows = 4
local int NumberOfColumns = 4



function sessionComplete(event)
	event.target.x = 10		 
	event.target.y = 10

	imageArray[#imageArray +1] = event.target
	-- print("closedCard[CardNumber].width "..closedCard[CardNumber].width)
	-- print("closedCard[CardNumber].height "..closedCard[CardNumber].height)
	-- print("event.target.width "..event.target.width)
	-- print("event.target.height "..event.target.height)
	-- print("scale "..closedCard[CardNumber].width/event.target.width.."\n"..closedCard[CardNumber].height/event.target.height)


	-- event.target.x = closedCard[CardNumber].x 
	-- event.target.y = closedCard[CardNumber].y

	-- event.target:scale(closedCard[CardNumber].width/event.target.width,closedCard[CardNumber].height/event.target.height)
	-- closedCard[CardNumber] = event.target
	
	
	-- closedCard[CardNumber].alpha = 0.9

	for i = 0, #imageArray do
		imageArray[#imageArray].x = 50+i*10
		imageArray[#imageArray].y = 50+i*10
	end
	

end

local buttonHandler = function( event )
	print( "id = " .. event.id .. ", phase = " .. event.phase )

	if event.phase == "release" then
		--READS THE DEVICE PHOTO LIBRARY AND LOADS THE SELECTED IMAGES
		media.show( media.SavedPhotosAlbum, sessionComplete )
	end

end

local loadButton = ui.newButton{
	default = "buttonGray.png",
	over = "buttonBlue.png",
	onEvent = buttonHandler,
	id = "loadButton",
	text = "Load Image",
	font = "MarkerFelt-Thin",
	size = 28,
	emboss = true
}

loadButton.x = 160; loadButton.y = 480-40

local function gameSetUp()
CardNumber = (NumberOfRows*NumberOfColumns)-1
		cardGroup = display.newGroup()
		  
		for	i=0,CardNumber do
			closedCard[i] = display.newImage( "GVRFace.png" )
			closedCard[i].isVisible = true
			closedCard[i].alpha = 0.8
			closedCard[i].myName = i
			cardGroup:insert( closedCard[i] )
		end

		--
		--CODE FOR CO-ORDINATES OF 25 POINTS
		--
		local int k = 0
			for i=0,NumberOfRows-1 do
				for j=0,NumberOfColumns-1 do
					closedCard[k].x = i*80 + 40 
					closedCard[k].y = j*80 + 120
					closedCard[k].id = k
					closedCard[k]:addEventListener("tap",selected) --on tap it calls selected function
					k=k+1
				end
			end


		for i=0,CardNumber do
			if(i>3) then
				local n = i%4
				faceCard[i] = display.newImage( "GVRFace"..n..".png" )
				faceCard[i].myName = n
			else
				faceCard[i] = display.newImage( "GVRFace"..i..".png" )
				faceCard[i].myName = i
			end
			
			faceCard[i].isVisible = false
			cardGroup:insert( faceCard[i] )
		end



		-- TO RANDOMIZE THE CONTENT OF THE ARRAY
		for i = CardNumber, 2, -1 do -- backwards
		    local r = math.random(i) -- select a random number between 1 and i
		    faceCard[i], faceCard[r] = faceCard[r], faceCard[i] -- swap the randomly selected item to position i
		    -- closedCard[i], closedCard[r] = closedCard[r], closedCard[i] 
		end


		for i=0,CardNumber do
			print("faceCard[i] "..faceCard[i].myName)
			faceCard[i].x = closedCard[i].x
			faceCard[i].y =	closedCard[i].y
		end

end
local function resetGame()
	cardGroup:removeSelf()
	gameSetUp()
end
local function listener( event )
	local int indx1 =  card1
	local int indx2 =  card2

	print("card1 "..card1)
	print("card2 "..card2)
	print("faceCard[indx1].myName "..faceCard[indx1].myName)
	print("faceCard[indx2].myName "..faceCard[indx2].myName)

	if (faceCard[indx1].myName == faceCard[indx2].myName) then
		timer.performWithDelay(1000, rotateAndShrink(indx1,indx2), 1)
		CardNumber = CardNumber -2
	else
	    print( "listener called : Empty function for delay" )
	    timer.performWithDelay(1000, flipBack(card1), 1)
		timer.performWithDelay(1000, flipBack(card2), 1)	
	end

	for	i=0,(NumberOfRows*NumberOfColumns)-1 do
		closedCard[i]:addEventListener("tap", selected)
	end

	
	print("cardNumber==============="..CardNumber)
	if CardNumber == -1 then
		timer.performWithDelay(2000, resetGame, 1)
	end


	local scores = ice:newBox( 1,"scores" )
	
	scores:store("girish" ,5)
	scores:decrement("girish" ,3)
	scores:storeIfNew("1girish" ,51)
	scores:store("girish1" ,15)

		scores:save()

    local scoresRet = ice:loadBox( 1,"scores" )
    print("\n-------------------------------------")
		scoresRet:print()
    print("\n-------------------------------------")




end


function rotateAndShrink(object1, object2)
	
	print("ROTATE "..object1, object2)
	-- local int i = event.target.myName
	faceCard[object1].xScale =1
	faceCard[object1].yScale =1
 
	startRotation = function()
	local j = faceCard[object1].xScale - .03
		faceCard[object1].xScale = j
		faceCard[object1].yScale = j
		faceCard[object2].xScale = j
		faceCard[object2].yScale = j

		if (faceCard[object1].xScale < 0.3) then
			Runtime:removeEventListener( "enterFrame", startRotation )
			faceCard[object1].alpha = 0
			faceCard[object2].alpha = 0
		end

	faceCard[object1].rotation = faceCard[object1].rotation%360 +30
	faceCard[object2].rotation = faceCard[object2].rotation%360 +30

	end
		
	Runtime:addEventListener( "enterFrame", startRotation )
	
	timer.performWithDelay(1000, createTwinkle(faceCard[object1]), 1)

	createTwinkle(faceCard[object2])

end


function flipUp(event)
	local index = event.target.id






























	print("event.target.id"..event.target.id)	
	print("closedCard[index].myName "..closedCard[index].myName)
	print("faceCard[index].myName "..faceCard[index].myName)
	print("closedCard[index].id "..closedCard[index].id)
	print("flipUp Index "..index)

		closedCard[index].xScale = .001
		transition.to(closedCard[index], {time = 125, xScale = .001})
		closedCard[index].isVisible = false
		-- faceCard[index].xScale = .001
		-- faceCard[index].isVisible = true
		-- transition.to(faceCard[index],{time = 125, delay = 130, xScale = 1})
timer.performWithDelay(2000,flipBack(index),1)
end


function flipBack(card)
		closedCard[card].isVisible = true   
		closedCard[card].xScale = .001
		--faceCard[card].xScale = .001
		--transition.to(faceCard[i], {time = 125, xScale = .001})
		--faceCard[card].isVisible = false
		transition.to(closedCard[card], {time = 125, xScale = .001})
		transition.to(closedCard[card],{time = 125, delay = 130, xScale = 1})
	end


function selected(event)
	count = count + 1
	-- print("FLIP UP "..event.target.id)

	timer.performWithDelay(1000, flipUp(event), 1)	

		if(count == 1) then
				card1 = event.target.myName
		else if(count == 2) then
				card2 = event.target.myName
				timer.performWithDelay(1000, listener, 1)
				count =0
					for	i=0,(NumberOfRows*NumberOfColumns)-1 do
					 closedCard[i]:removeEventListener("tap", selected)
					end
			end
		end
	
end




gameSetUp()

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
		local twinkle = display.newImage( "star.png", card.x, card.y-50, math.random(minTwinkleRadius, maxTwinkleRadius) )
		--twinkle:setFillColor(255, 0, 0, 255)
		
		twinkleProp.radius = twinkle.width / 2
		physics.addBody(twinkle, "dynamic", twinkleProp)

		local xVelocity = math.random(minTwinkleVelocityX, maxTwinkleVelocityX)
		local yVelocity = math.random(minTwinkleVelocityY, maxTwinkleVelocityY)

		twinkle:setLinearVelocity(xVelocity, yVelocity)
		
		transition.to(twinkle, {time = twinkleFadeTime, delay = twinkleFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) twinkle:removeSelf() end})		
	end

end

