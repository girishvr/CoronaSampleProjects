require ("physics")

physics.start()
-- physics.setDrawMode ( "hybrid" ) -- Uncomment in order to show in hybrid mode	
physics.setGravity( 0, 9.8 * 1)

physics.start()


local reverse = 0
local object
local closedCard = {}
local faceCard = {}
local count = 0
local int card1 = 0
local int card2 = 0


local function listener( event )
    print( "listener called : Empty function for delay" )
    timer.performWithDelay(1000, flipBack(card1), 1)
	timer.performWithDelay(1000, flipBack(card2), 1)	
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

	faceCard[object1].rotation = faceCard[object1].rotation%360 +20
	faceCard[object2].rotation = faceCard[object2].rotation%360 +20

	end
		
	Runtime:addEventListener( "enterFrame", startRotation )
	
	timer.performWithDelay(1000, createTwinkle(faceCard[object1]), 1)

	createTwinkle(faceCard[object2])

end


-- function selected(event)

-- 	count = count + 1
--        if reverse == 0 then
--        	local int i = event.target.myName
--   		    object = event.target
--   		    print("selected Function - "..event.target.myName)
--             if(count == 2) then
--             	reverse = 1
--             	count = 0
--             	timer.performWithDelay(1000, rotateAndShrink(event.target.myName,object.myName), 1)
--             end
-- 			event.target.xScale = .001
-- 			transition.to(event.target, {time = 125, xScale = .001})
-- 			event.target.isVisible = false
-- 			faceCard[i].xScale = .001
-- 			faceCard[i].isVisible = true
-- 			transition.to(faceCard[i],{time = 125, delay = 130, xScale = 1})
-- 			--timer.performWithDelay(1000, rotateAndShrink(event), 1)
-- 			--timer.performWithDelay(1000, selected, 1)
--         else
--             reverse = 0
-- 			object.isVisible = true   
-- 			object.xScale = .001
-- 			faceCard[i].xScale = .001
-- 			transition.to(faceCard[i], {time = 125, xScale = .001})
-- 			faceCard[i].isVisible = false
-- 			transition.to(object, {time = 125, xScale = .001})
-- 			transition.to(object,{time = 125, delay = 130, xScale = 1})
			
--        end
-- end

	function flipUp(card)
		closedCard[card].xScale = .001
		transition.to(closedCard[card], {time = 125, xScale = .001})
		closedCard[card].isVisible = false
		faceCard[card].xScale = .001
		faceCard[card].isVisible = true
		transition.to(faceCard[card],{time = 125, delay = 130, xScale = 1})

	end

	function flipBack(card)
		closedCard[card].isVisible = true   
		closedCard[card].xScale = .001
		faceCard[card].xScale = .001
		transition.to(faceCard[i], {time = 125, xScale = .001})
		faceCard[card].isVisible = false
		transition.to(closedCard[card], {time = 125, xScale = .001})
		transition.to(closedCard[card],{time = 125, delay = 130, xScale = 1})
	end


function selected(event)
	count = count + 1
	print("FLIP UP "..event.target.myName)

	timer.performWithDelay(1000, flipUp(event.target.myName), 1)	

		if(count == 1) then
				card1 = event.target.myName
		else if(count == 2) then
				card2 = event.target.myName
				count =0
					if(card1%4 == card2%4 ) then
						print(card1,card2.."CARD 1 CARD2")
						timer.performWithDelay(1000, rotateAndShrink(card1,card2), 1)
						-- createTwinkle(event.target)
						-- createTwinkle(faceCard[card1])
					else
						print("FLIP BACK")
						timer1 = timer.performWithDelay( 1000, listener )  -- wait 2 seconds
						
					end

			end
		end
	
end




--
--CODE FOR CREATING CARDS
--
for	i=0,7 do
closedCard[i] = display.newImage( "GVRFace.png" )
closedCard[i].isVisible = true
closedCard[i].myName = i
closedCard[i]:addEventListener("tap",selected) --on tap it calls selected function

	if(i>3) then
		local n = i%4
		faceCard[i] = display.newImage( "GVRFace"..n..".png" )
	else
		faceCard[i] = display.newImage( "GVRFace"..i..".png" )
	end
		
	faceCard[i].myName = i
	faceCard[i].isVisible = false
end


--
--CODE FOR CO-ORDINATES OF 8 POINTS
--
local int k = 0
	for i=1,2 do
		for j=1,4 do
			closedCard[k].x = i*120 - 20
			closedCard[k].y = j*110 - 30
			faceCard[k].x = closedCard[k].x
			faceCard[k].y = closedCard[k].y			
			k=k+1
		end
	end

-- -- TO RANDOMIZE THE CONTENT OF THE ARRAY
-- for i = 7, 2, -1 do -- backwards
--     local r = math.random(i) -- select a random number between 1 and i
--     faceCard[i], faceCard[r] = faceCard[r], faceCard[i] -- swap the randomly selected item to position i
--     closedCard[i], closedCard[r] = closedCard[r], closedCard[i] -- swap the randomly selected item to position i

-- end 

-- for	i=0,7 do
-- 	print("faceCard[i] "..faceCard[i].myName)
-- 	-- faceCard[i].myName = i
-- 	-- faceCard[i].isVisible = false
-- 	end



-- --
-- --CODE FOR CREATING CARDS
-- --
-- for	i=1,4 do
-- closedCard[i] = display.newImage( "GVRFace.png" )
-- closedCard[i].isVisible = true
-- closedCard[i].myName = i
-- closedCard[i]:addEventListener("tap",selected) --on tap it calls selected function
-- faceCard[i] = display.newImage( "GVRFace"..i..".png" )
-- faceCard[i].myName = i
-- faceCard[i].isVisible = false

-- end

-- --
-- --CODE FOR CO-ORDINATES OF 4 POINTS
-- --
-- local int k = 1
-- 	for i=1,2 do
-- 		for j=1,2 do
-- 			closedCard[k].x = i*120 - 20
-- 			closedCard[k].y = j*120 + 100
-- 			faceCard[k].x = i*120 - 20
-- 			faceCard[k].y = j*120 + 100			
-- 			k=k+1
-- 		end
-- 	end


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




-- TO RANDOMIZE THE CONTENT OF THE ARRAY

-- local t = {1,2,3,4,5,6,7}
-- for i = 1 , 7 do
-- print("ARRAY ->"..t[i]) 
-- end
-- for i = 7, 2, -1 do -- backwards
--     local r = math.random(i) -- select a random number between 1 and i
--     t[i], t[r] = t[r], t[i] -- swap the randomly selected item to position i
-- end 
-- for i = 1 , 7 do
-- print("\tARRAY ->"..t[i]) 
-- end