import Foundation
import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {
    
    let floorImage : Image
    let cloudImage : Image
    let bigCloudImage : Image
    let bushImage : Image
    let bigBushImage : Image
    let backgroundFill : FillStyle = FillStyle(color:Color(red: 160, green: 161, blue: 254))
    var background : Rectangle
    var didGetInfo = false
    var bounds = Size(width:0,height:0)
    var time : Date

    // Returns a string with four numbers, replacing the leading numbers with zeros.
    func getFourZeroes(x:Int) -> String {
        var y = String(x)
        for _ in 0 ..< 4 - String(x).count {
            y = "0"+y
        }
        return y
    }

    // Get the width needed to not be out of bounds.
    func getWidthWithinBounds(x: Int, width: Int) -> Int {
        if(x > bounds.width) {return 0;}
        if(x + width <= bounds.width) {return width;}
        return width - ((x + width) - bounds.width);
    }

    // gets the height needed to not be out of bounds.
    func getHeightWithinBounds(y: Int, height: Int) -> Int {
        if(y > bounds.height) {return 0;}
        if(y + height <= bounds.height) {return height;}
        return height - ((y + height) - bounds.height);
    }
    
      
    init() {

        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }
        
        floorImage = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/floorTile.png")
        
        cloudImage = getImage(url: "https://www.codermerlin.com/users/travis-beach/mario/cloud.png")
        bigCloudImage = getImage(url: "https://www.codermerlin.com/users/travis-beach/mario/bigCloud.png")

        bushImage = getImage(url: "https://www.codermerlin.com/users/travis-beach/mario/bush.png")
        bigBushImage = getImage(url: "https://www.codermerlin.com/users/travis-beach/mario/bigBush.png")
        
        background = Rectangle(rect:Rect(topLeft:Point(x:0,y:0), size:Size(width:Int.max,height:Int.max)), fillMode:.fill)
        
        // the initial starting time.
        time = Date()
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }
    
    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(floorImage, cloudImage, bigCloudImage, bushImage, bigBushImage)
    }
    
    let floorTileSize = 96

    override func render(canvas:Canvas) {            
        if let canvasSize = canvas.canvasSize, !didGetInfo {
            didGetInfo = true

            // sets the bounds
            bounds = Size(width:canvasSize.width - 10, height: canvasSize.height - 30)

            // sets the background render
            background = Rectangle(rect:Rect(topLeft:Point(x:0,y:0), size:bounds), fillMode:.fill)
        }
        
        if didGetInfo && floorImage.isReady {
            // render white background
            canvas.render(FillStyle(color:Color(.white)), Rectangle(rect:Rect(topLeft:Point(x:bounds.width,y:0), size:Size(width: 10, height: bounds.height + 30)), fillMode: .fill))
            
            // Render Background:
            canvas.render(backgroundFill, background)

            // Render scores/text:
            canvas.render(FillStyle(color:Color(.white)), StrokeStyle(color:Color(.white)))

            // render the mario label
            var text = Text(location:Point(x:50, y:50), text:"MARIO")
            text.font = "30pt Arial"
            text.alignment = .left
            canvas.render(text)

            // render the time label
            text = Text(location:Point(x:bounds.width - 200, y:50), text:"TIME")
            text.font = "30pt Arial"
            text.alignment = .left
            canvas.render(text)

            // render the actual time
            text = Text(location:Point(x:bounds.width - 200, y:90), text: getFourZeroes(x: Int(Date().timeIntervalSince1970 - time.timeIntervalSince1970)))
            text.font = "30pt Arial"
            text.alignment = .left
            canvas.render(text)
            
            // Render floor:
            for i in 0 ..< 100 {
                let w = getWidthWithinBounds(x: i * floorTileSize, width: floorTileSize)
                let sourceRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:w, height:floorTileSize))
                let destinationRect = Rect(topLeft:Point(x:floorTileSize*i, y:bounds.height - floorTileSize), size:Size(width:w, height:floorTileSize))
                floorImage.renderMode = .sourceAndDestination(sourceRect:sourceRect, destinationRect:destinationRect)
                canvas.render(floorImage)
                if w != floorTileSize {
                    break
                }
            }

            // render clouds
            if cloudImage.isReady && bigCloudImage.isReady {
                let cloudDestinationRect = Rect(topLeft:Point(x:bounds.width / 4, y:bounds.height / 5), size:Size(width:96, height:96))
                cloudImage.renderMode = .destinationRect(cloudDestinationRect)
                canvas.render(cloudImage)
                
                let cloudDestinationRectB = Rect(topLeft:Point(x:bounds.width / 2 + bounds.width / 7, y:bounds.height / 6), size:Size(width:96, height:96))
                cloudImage.renderMode = .destinationRect(cloudDestinationRectB)
                canvas.render(cloudImage)

                
                let bigCloudDestinationRect = Rect(topLeft:Point(x: bounds.width / 2 + bounds.width / 4, y: bounds.height / 4), size:Size(width:192, height:96))
                bigCloudImage.renderMode = .destinationRect(bigCloudDestinationRect)
                canvas.render(bigCloudImage)

                let bigCloudDestinationRectB = Rect(topLeft:Point(x: bounds.width / 5 - bounds.width / 6, y: bounds.height / 3), size:Size(width:192, height:96))
                bigCloudImage.renderMode = .destinationRect(bigCloudDestinationRectB)
                canvas.render(bigCloudImage)

                let bigCloudDestinationRectC = Rect(topLeft:Point(x: bounds.width / 2, y: bounds.height / 2 - bounds.height / 7), size:Size(width:192, height:96))
                bigCloudImage.renderMode = .destinationRect(bigCloudDestinationRectC)
                canvas.render(bigCloudImage)
            }
            // render bushes
            if bushImage.isReady && bigBushImage.isReady {
                let bushDestinationRect = Rect(topLeft:Point(x:bounds.width / 4, y:bounds.height - 96 - 192), size:Size(width:192, height:192))
                bushImage.renderMode = .destinationRect(bushDestinationRect)
                canvas.render(bushImage)

                let bushDestinationRectB = Rect(topLeft:Point(x:bounds.width - bounds.width / 5, y:bounds.height - 96 - 192), size:Size(width:192, height:192))
                bushImage.renderMode = .destinationRect(bushDestinationRectB)
                canvas.render(bushImage)
                
                let bigBushDestinationRect = Rect(topLeft:Point(x:bounds.width - bounds.width / 2 - 192, y:bounds.height - 96 - 192), size:Size(width:384, height:192))
                bigBushImage.renderMode = .destinationRect(bigBushDestinationRect)
                canvas.render(bigBushImage)
            }
        }
    }
}
