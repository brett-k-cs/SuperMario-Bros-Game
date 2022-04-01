import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel = 1
    var interactionLayer : InteractionLayer?
    var score = 0
    var activeEntities : [RenderableEntity] = [];
    
    init(mario:Mario) {
        marioSprite = mario

        super.init(name: "LevelHandler")

        marioSprite.setLevelHandler(handler: self)
    }

    override func calculate(canvasSize: Size) {
        if(marioSprite.topLeft.x + marioSprite.marioSize.width > marioSprite.cSize.width + 10) {
            clearLevel()

            currentLevel += 1
            switch(currentLevel) {
            case 1:
                levelOne(canvasSize: canvasSize)
            case 2:
                levelTwo(canvasSize: canvasSize)
            case 3:
                levelThree(canvasSize: canvasSize)
            default:
                print("You reached the end!")
            }
        }
    }

    override func render(canvas: Canvas) {
        let text = Text(location:Point(x:50, y:90), text:String(score))
        text.font = "30pt Arial"
        canvas.render(text)
    }

    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }

    func setScore(value: Int) {
        score = value
    }

    func clearLevel() {
        for entity in activeEntities {
            if let interactionLayer = interactionLayer {                
                interactionLayer.removeEntity(entity:entity)
            }
        }
        marioSprite.setBoxes(tiles: [])
        marioSprite.setCoins(tiles: [])
        activeEntities = []

        marioSprite.topLeft = Point(x:10, y:marioSprite.topLeft.y)
    }

    func levelOne(canvasSize:Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
            coin.setActive(value: false)
            
            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 400, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 600, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)

            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setBoxes(tiles: [questionTile])

            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, questionTile, coin])
        }
    }

    func levelTwo(canvasSize: Size) {
        print("level 2")
    }

    func levelThree(canvasSize: Size) {
    }

    func levelFour() {
    }

    func levelFive() {
    }

    func levelSix() {
    }

    func levelSeven() {
    }

    func levelEight() {
    }

    func levelNine() {
    }

    func levelTen() {
    }
}
