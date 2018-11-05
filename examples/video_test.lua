-- Example: Playing a Theora video


function love.load()
    love.graphics.setFont(love.graphics.newFont(11))

	-- Load the video from a file, with audio
	video = love.graphics.newVideo( "assets/HA-1112-M1LBuchon_flyby.ogg", {true} )
	-- Get video height
	videoheight = video:getHeight()
	--Lower the volume
	video:getSource():setVolume(0.15)
	-- Start playing it
	video:play()
end

function love.draw()

	-- We have to draw our video on the screen
	love.graphics.draw( video, 50, 100 )

	-- If the video is not playing or left button is clicked
	if not video:isPlaying() or love.mouse.isDown(1) then
		-- Rewind to the start
		video:seek(0)
		-- And play
		video:play()
	end

    love.graphics.print(string.format("Time: %.1fs", video:tell()), 50, 100 - 12 )
	love.graphics.print("Copyright (c) 2005, Kogo on Wikimedia", 50, 100 + videoheight)
end

function love.keypressed(k)
    if k == "escape" then video:pause() end
end
