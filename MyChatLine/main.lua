--
-- INIT CHAT:
-- This initializes the pubnub networking layer.
--
require "pubnub"
multiplayer = pubnub.new({
    publish_key   = "pub-f1093346-20c2-464b-909c-17b95eae0966",
    subscribe_key = "sub-0cb6d600-7a31-11e1-b2c6-5bb18828858d",
    secret_key    = "sec-82baf3f6-f683-49f0-b3a0-063f475bc2e7",
    ssl           = nil,
    origin        = "pubsub.pubnub.com"
})

local myName = "Girish"
local red = math.random (10, 200)
local blue = math.random (10, 200)
local green = math.random (10, 200)
local myText

local textoutline = 1
local function textout( text )

    if textoutline > 8 then textoutline = 1 end
    if textoutline == 1 then
        local background = display.newRect(
            0, 0,
            display.contentWidth,
            display.contentHeight
        )
        background:setFillColor(254,254,254)
    end

   
    myText = display.newText(
        text:gsub("^%s*(.-)%s*$", "%1"),
        0, 0, nil,
        display.contentWidth/20
    )

    myText:setTextColor( red,blue,green )
     -- myText:setTextColor( 200, 200, 180 )
    myText.x = math.floor(display.contentWidth/2)
    myText.y = (display.contentWidth/19) * textoutline + 45

    textoutline = textoutline + 1
    print(text)
end

textout("")

-- 
-- CHAT CHANNEL DEFINED HERE
-- 
CHAT_CHANNEL = "PubNub-Chat-Channel-Evoleas"

local myChannelText = display.newText(
        CHAT_CHANNEL:gsub("^%s*(.-)%s*$", "%1"),
        0, 0, nil,
        display.contentWidth/18
    )

    myChannelText:setTextColor( red,blue,green )
    myChannelText.x = math.floor(display.contentWidth/2)
    myChannelText.y = (display.contentWidth/10)     


--local myMessage = "Test Success" --{ "Girish", "2", "3", "4" ,"Hello"}
-- -- 
-- -- PUBNUB PUBLISH MESSAGE (SEND A MESSAGE) 
-- -- 
-- multiplayer:publish({ 
--     channel  = CHAT_CHANNEL, --"lua-corona-demo-channel",
--     message  = myMessage , --{ "1234", "2", "3", "4" },
--     callback = function(info) 
 
--         -- WAS MESSAGE DELIVERED? 
--         if info[1] then 
--             print("MESSAGE DELIVERED SUCCESSFULLY!") 
--         else 
--             print("MESSAGE FAILED BECAUSE -> " .. info[2]) 
--         end 
 
--     end 
-- })


    --
    -- A FUNCTION THAT WILL SEND A MESSAGE
    --
    function send_a_message(text)
        multiplayer:publish({
            channel  = CHAT_CHANNEL,
            message  = {myName, text }, --message  = { msgtext = text },
            callback = function(info)
             -- WAS MESSAGE DELIVERED? 
                    if info[1] then 
                        print("MESSAGE DELIVERED SUCCESSFULLY!") 
                    else 
                        print("MESSAGE FAILED BECAUSE -> " .. info[2]) 
                    end 
             

            end
        })
    end



local bool = 0
-- 
-- CREATE CHATBOX TEXT INPUT FIELD
-- 
chatbox = native.newTextField( 10, display.contentWidth/1.5, display.contentWidth - 20, 36, function(event)
    -- Only send when the user is ready.
    if not (event.phase == "ended" or event.phase == "submitted") then
        return
    end

    -- Don't send Empyt Message
    if chatbox.text == '' then return end
    if bool == 0 then 
        bool = 1
        myName = chatbox.text 
        chatbox.text = ''
        native.setKeyboardFocus(nil)
        return 
    end
    send_a_message(tostring(chatbox.text))
    chatbox.text = ''
    native.setKeyboardFocus(nil)
end )


local red1 = math.random (10, 200)
local blue1 = math.random (10, 200)
local green1 = math.random (10, 200)
 
-- 
-- PUBNUB SUBSCRIBE CHANNEL (RECEIVE MESSAGES) 
-- 
multiplayer:subscribe({ 
    channel  = CHAT_CHANNEL, --"lua-corona-demo-channel",
    callback = function(message) 
        -- MESSAGE RECEIVED!!! 
        print(message) 
        textout(message[1]..":"..message[2])
        myText:setTextColor( red1,blue1,green1 )

    end,
    errorback = function() 
        print("Network Connection Lost") 
    end 
})


-- 
-- PUBNUB SERVER TIME 
-- 
multiplayer:time({ 
    callback = function(time) 
        -- PRINT TIME 
        print("PUBNUB SERVER TIME: " .. time) 
    end 
})





-- local function onComplete( event )
--         if "clicked" == event.action then
--                 local i = event.index
--                 if 1 == i then
--                         -- Do nothing; dialog will simply dismiss
--                 elseif 2 == i then
--                         -- Open URL if "Learn More" (the 2nd button) was clicked
--                 end
--         end
-- end

-- chatbox = native.newTextField( 10, 50, 20, 36, function(event)
--     -- Only send when the user is ready.
--     if not (event.phase == "ended" or event.phase == "submitted") then
--         return
--     end

--     -- Don't send Empyt Message
--     if chatbox.text == '' then return end
--     native.setKeyboardFocus(nil)
-- end )

-- Show alert with five buttons
local alert = native.showAlert( "ENTER YOUR CHAT NAME FIRST", "", 
                                        { "OK" }, onComplete )



-- -- 
-- -- PUBNUB LOAD MESSAGE HISTORY 
-- -- 
-- multiplayer:history({ 
--     channel  = CHAT_CHANNEL,--"lua-corona-demo-channel",
--     limit    = 100,
--     callback = function(messages) 
--         if not messages then 
--             return print("ERROR LOADING HISTORY") 
--         end 
 
--         -- NO HISTORY? 
--         if not (#messages > 0) then 
--             return print("NO HISTORY YET") 
--         end 
 
--         -- LOOP THROUGH MESSAGE HISTORY 
--         for i, message in ipairs(messages) do 
--             print("History -")
--             print(Json.Encode(message)) 
--         end 
--     end 
-- })


