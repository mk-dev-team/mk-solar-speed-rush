current_scene = "splash_screen" -- splash_screen, main_menu, game, end_game
total_elapsed_time = 0
DEBUG = true

function love.load(arg)
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
  load_assets()
  splash_screen_setup()
  main_menu_setup()
  game_setup()
end

function load_assets()
  asset_background = love.graphics.newImage("assets/background.png")
  asset_background_cloud = love.graphics.newImage("assets/background_cloud.png")
  asset_background_stars_a = love.graphics.newImage("assets/background_stars_a.png")
  asset_background_stars_b = love.graphics.newImage("assets/background_stars_b.png")
  asset_background_stars_c = love.graphics.newImage("assets/background_stars_c.png")
end

-- Update ----------------------------------------------------------------------

function handle_input()
  key_up = love.keyboard.isDown("w")
  key_down = love.keyboard.isDown("s")
  key_left = love.keyboard.isDown("a")
  key_right = love.keyboard.isDown("d")

  key_attack = love.keyboard.isDown("space")
end

function love.update(delta_time)
  handle_input()
  update_soundmanager()
  total_elapsed_time = total_elapsed_time + delta_time

  if current_scene == "splash_screen" then
    update_splash_screen(delta_time)
  elseif current_scene == "main_menu" then
    update_main_menu(delta_time)
  elseif current_scene == "game" then
    update_game(delta_time)
  elseif current_scene == "end_game" then
    update_end_game(delta_time)
  end
end

-- Draw ------------------------------------------------------------------------
function love.draw()
  height_scale_factor = love.graphics.getHeight() / 600
  width_scale_factor =  love.graphics.getWidth() / 800

  if current_scene == "splash_screen" then
    draw_splash_screen()
  elseif current_scene == "main_menu" then
    draw_main_menu()
  elseif current_scene == "game" then
    draw_game()
  elseif current_scene == "end_game" then

  end
end

function draw_paralax(background_location, speed)
  love.graphics.draw(asset_background, 0, math.floor(background_location * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background, 0, math.floor(background_location * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_cloud, 0, math.floor(background_location * 1.1 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_cloud, 0, math.floor(background_location * 1.1 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_stars_a, 0, math.floor(background_location * 1.2 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_stars_a, 0, math.floor(background_location * 1.2 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_stars_b, 0, math.floor(background_location * 1.5 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_stars_b, 0, math.floor(background_location * 1.5 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

  love.graphics.draw(asset_background_stars_c, 0, math.floor(background_location * 1.9 * speed) % love.graphics.getHeight() - love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)
  love.graphics.draw(asset_background_stars_c, 0, math.floor(background_location * 1.9 * speed) % love.graphics.getHeight(), 0, width_scale_factor, height_scale_factor)

end

-- splash screen -------------------------------------------------------------------

splash_time = 0

function splash_screen_setup()
  asset_maker_logo = love.graphics.newImage("assets/maker.png")
  asset_font_bebas = love.graphics.newFont("assets/bebas.ttf", 26)
end

function update_splash_screen(delta_time)
  splash_time = splash_time + delta_time

  if splash_time > 4 or key_attack then
    main_menu_switch()
  end
end

function draw_splash_screen()
  draw_paralax(total_elapsed_time, 32)
  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)
  love.graphics.setColor(255,255,255, math.min(255, 255 * math.sin(splash_time)))
  love.graphics.draw(asset_maker_logo, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.5, 0.5, asset_maker_logo:getWidth() / 2, asset_maker_logo:getHeight() / 2)
  love.graphics.print("Present a game made in 48Hours for the 39th \"Ludum Dare\".", love.graphics.getWidth() / 2 - asset_maker_logo:getWidth() / 4 - 32, love.graphics.getHeight() / 2 + 64)
  love.graphics.setColor(255,255,255,255)
end

-- Main Menu -------------------------------------------------------------------

function main_menu_switch()
  current_scene = "main_menu"
  menu_fade = 0
end

function main_menu_setup()
  asset_game_logo = love.graphics.newImage("assets/game_logo.png")
  asset_help = love.graphics.newImage("assets/help.png")
end

function update_main_menu(delta_time)
  menu_fade = menu_fade + 1
end

function draw_main_menu()
  draw_paralax(total_elapsed_time, 32)

  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)
  love.graphics.setColor(255,255,255, math.min(255, menu_fade))
  love.graphics.draw(asset_game_logo, 32, 32)
  love.graphics.draw(asset_help, love.graphics.getWidth() - asset_help:getWidth(), love.graphics.getHeight() - asset_help:getHeight(), 0, 1, 1)

  if button("play", 32 + 76, asset_game_logo:getHeight() + 16, 400, 32) then
    game_switch()
  end
  love.graphics.setColor(255,255,255, math.min(255, menu_fade))
  button("exit", 32 + 76, asset_game_logo:getHeight() + 16 + 32 + 16, 400, 32)
  love.graphics.setColor(255,255,255,255)
end

-- Game ------------------------------------------------------------------------

function game_switch()
  current_scene = "game"
  setup_space_ship()

  game = {}
  game.progress = 0
  game.max_progress = 50000
  asset_speedup:play()
  asset_speedup:setLooping(true)
end

function game_setup()
  -- spaceship -----------------------------------------------------------------
  asset_spaceship = love.graphics.newImage("assets/spaceship.png")
  asset_truster = love.graphics.newImage("assets/truster.png")
  asset_bullet = love.graphics.newImage("assets/bullet.png")

  asset_speedup = love.audio.newSource("assets/speed_up.wav", "stream")
end

function update_game(delta_time)
  update_spaceship_bullet()
  update_spaceship(delta_time)
end

function draw_game()
  draw_paralax(game.progress, 0.25)
  love.graphics.rectangle("line", 4, 4, love.graphics.getWidth() - 8, love.graphics.getHeight() - 8)
  draw_spaceship_bullet()
  draw_spaceship()
end

-- Spaceship -------------------------------------------------------------------

function setup_space_ship()
  spaceship = {}

  spaceship.cooldown = 20
  spaceship.cooldown_time = 20
  spaceship.shooted_bullet = {}
  spaceship.shooted_bullet_count = 1

  spaceship.speed = {}
  spaceship.speed.y = 0
  spaceship.speed.x = 0
  spaceship.speed_up_y = false
  spaceship.speed_up_x = false

  spaceship.max_speed = {}
  spaceship.max_speed.y = 25
  spaceship.max_speed.x = 10

  spaceship.x = love.graphics.getWidth() / 2 - 32
  spaceship.y = love.graphics.getHeight() - 128

  spaceship.width = 64
  spaceship.height = 64
end

function update_spaceship(delta_time)
  -- Moves ---------------------------------------------------------------------
  spaceship.speed_up_y = false
  spaceship.speed_up_x = false

  if key_up then
    spaceship.speed.y = spaceship.speed.y + 5 * delta_time
    spaceship.speed_up_y = true
  end

  if key_down then
    spaceship.speed.y = spaceship.speed.y - 5 * delta_time
    spaceship.speed_up_y = true
  end

  if key_left then
    spaceship.speed.x = spaceship.speed.x - 100 * delta_time
    spaceship.speed_up_x = true
  end

  if key_right then
    spaceship.speed.x = spaceship.speed.x + 100 * delta_time
    spaceship.speed_up_x = true
  end

  -- check speed x -------------------------------------------------------------
  if not spaceship.speed_up_x then
    spaceship.speed.x = spaceship.speed.x * 0.9
  end

  if spaceship.speed.x > spaceship.max_speed.x then
    spaceship.speed.x = spaceship.max_speed.x
  end

  if spaceship.speed.x < -spaceship.max_speed.x then
    spaceship.speed.x = -spaceship.max_speed.x
  end

  -- Check speed y -------------------------------------------------------------
  if spaceship.speed.y > spaceship.max_speed.y then
    spaceship.speed.y = spaceship.max_speed.y
  end

  if spaceship.speed.y < 0 then
    spaceship.speed.y = 0
  end

  spaceship.x = spaceship.x + spaceship.speed.x
  game.progress = game.progress + spaceship.speed.y

  if spaceship.x < 0 then spaceship.x = 0 end
  if spaceship.x > love.graphics.getWidth() - spaceship.width then spaceship.x = love.graphics.getWidth() - spaceship.width end

  -- bullet shooting -----------------------------------------------------------
  if not (spaceship.cooldown == 0) then spaceship.cooldown = spaceship.cooldown - 1 end

  if key_attack and (spaceship.cooldown == 0) then
    spaceship.cooldown = spaceship.cooldown_time
    spaceship_shoot_bullet(spaceship.x + spaceship.width / 2 - 2)
  end

  -- sound effects -------------------------------------------------------------
  asset_speedup:setVolume((spaceship.speed.y / spaceship.max_speed.y) / 2)
  asset_speedup:setPitch(1 + (spaceship.speed.y / spaceship.max_speed.y) / 2)
end

function draw_spaceship()
  local size_factor = spaceship.speed.y / spaceship.max_speed.y

  -- Draw spaceship hitbox.
  if DEBUG then love.graphics.rectangle("line", spaceship.x, spaceship.y, spaceship.width, spaceship.height) end

  -- draw the spaceship
  love.graphics.push()
  love.graphics.translate(math.random(-50, 50) / 50 * size_factor, 0)
  love.graphics.draw(asset_spaceship, spaceship.x, spaceship.y, 0, 2, 2 - (size_factor) / 5)
  love.graphics.setColor(255,255,255,255 * size_factor)
  love.graphics.draw(asset_truster, spaceship.x, spaceship.y, 0, 2, 2  - (size_factor) / 5)
  love.graphics.setColor(255,255,255,255)
  love.graphics.pop()
end

-- spaceship shoot -------------------------------------------------------------
function spaceship_shoot_bullet(x)
  soundmanager_play("assets/shoot.wav")
  spaceship.shooted_bullet[spaceship.shooted_bullet_count] = {x = x, y = love.graphics.getHeight() - 100, size = 4}
  spaceship.shooted_bullet_count = spaceship.shooted_bullet_count + 1
end

function update_spaceship_bullet()
  for i,e in pairs(spaceship.shooted_bullet) do
    if e.y < -256 then spaceship.shooted_bullet[i] = nil
    else
    e.y = e.y - 10
    end
  end
end

function draw_spaceship_bullet()
  for i,e in pairs(spaceship.shooted_bullet) do
    love.graphics.draw(asset_bullet, e.x - 2, e.y - 2, 0, 2, 2)
    if DEBUG then love.graphics.rectangle("line", e.x, e.y, e.size, e.size) end
  end
end

-- Entities --------------------------------------------------------------------

function entities_setup()

end

function entities_update(delta_time)

end

function entities_draw()

end

-- End Game Screen -------------------------------------------------------------

function end_game_setup()

end

function update_end_game()

end

function draw_end_game()

end

-- GUI -------------------------------------------------------------------------

function button(text, x, y, width, height)

  if CheckCollision(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 1, 1) then
    love.graphics.setColor(255, 216, 0, 255)
  end

  local text = love.graphics.newText( asset_font_bebas, text )
  love.graphics.draw(text, x + width / 2 - text:getWidth() / 2, y + height / 2 - text:getHeight() / 2 + 2)
  love.graphics.rectangle("line", x, y, width, height)

  if CheckCollision(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 1, 1) then
    love.graphics.setColor(255, 255, 255, 255)
  end

  return CheckCollision(x, y, width, height, love.mouse.getX(), love.mouse.getY(), 1, 1) and love.mouse.isDown(1)
end

-- Sound Manager ---------------------------------------------------------------

soundmanager_sources = {}

function update_soundmanager()

  local remove = {}
  for _,s in pairs(soundmanager_sources) do
      if s:isStopped() then
          remove[#remove + 1] = s
      end
  end

  for i,s in ipairs(remove) do
      soundmanager_sources[s] = nil
  end
end

function soundmanager_play(source)
  src = love.audio.newSource(source, "stream")
  src:play()
  soundmanager_sources[source] = src
end

-- Utils -----------------------------------------------------------------------
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
