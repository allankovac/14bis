LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 12

aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 55,
    altura = 63,
    x = LARGURA_TELA/2 - 64/2,
    y = ALTURA_TELA - 64/2
}


function destroiAviao()
    destruicao:play()
    aviao_14bis.src = "imagens/explosao_nave.png"
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    aviao_14bis.largura = 67
    aviao_14bis.altura = 77
end


function temColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return X2 < X1 + L1 and X1 < X2 + L2 and Y1 < Y2 + A2 and Y2 < Y1 + A1

end


function checarColisao()
    for x,i in pairs(meteoros) do 
        if temColisao(i.x, i.y, i.largura, i.altura, aviao_14bis.x, aviao_14bis.y, aviao_14bis.largura, aviao_14bis.altura) then
            destroiAviao()
            FIM_JOGO = true
        end
    end
end


meteoros = {}


function removerMeteoro()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > ALTURA_TELA then
            table.remove(meteoros,i)
        end
    end
end


function criarMeteoro()
    meteoro = {
        x = math.random(LARGURA_TELA),
        y = -70,
        largura= 50,
        altura=44,
        peso = math.random(3),
        deslocamento_horizontal = math.random(-1,1)
    }

    table.insert(meteoros, meteoro)
end


function mover_meteoro()
    for k,i in pairs(meteoros) do
        i.y = i.y + i.peso
        i.x = i.x + i.deslocamento_horizontal
    end
end

function aviao_14bis_moves()
    if love.keyboard.isDown('w') then
        aviao_14bis.y = aviao_14bis.y - 1
    
    elseif love.keyboard.isDown('s') then 
        aviao_14bis.y = aviao_14bis.y + 1
    
    elseif love.keyboard.isDown('a') then
        aviao_14bis.x = aviao_14bis.x - 1

    elseif love.keyboard.isDown('d') then 
        aviao_14bis.x = aviao_14bis.x + 1
    end
end


function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false})
    love.window.setTitle("14bis vs meteoro")

    math.randomseed(os.time())
    
    background = love.graphics.newImage("imagens/background.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")

    musica_fundo = love.audio.newSource("audios/ambiente.wav", "static")
    musica_fundo:setLooping(true)
    musica_fundo:play()

    destruicao = love.audio.newSource("audios/destruicao.wav", "static")
end

function love.update(dt)
    if not FIM_JOGO then 
        if love.keyboard.isDown('w', 's', 'a', 'd') then
            aviao_14bis_moves()
       end
       
       removerMeteoro()
       if #meteoros < MAX_METEOROS then
            criarMeteoro()
       end
       mover_meteoro()
       checarColisao()
    
    end
end

function love.draw()

    love.graphics.draw(background, 0,0)
    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x,aviao_14bis.y)
    for y,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x,meteoro.y)
    end
    

end