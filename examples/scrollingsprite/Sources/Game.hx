package;

import gecko.Gecko;
import gecko.Screen;

import gecko.Assets;
import gecko.systems.draw.DrawSystem;
import gecko.components.draw.ScrollingSpriteComponent;

class Game {
    public function new(){
        //add the draw system
        Gecko.currentScene.addSystem(DrawSystem.create());

        //Load the sprites
        Assets.load([
            "images/opengameart/mountain.png",
            "images/opengameart/carbon_fiber.png"
        ], _onLoadAssets).start();
    }

    //create an entity with a scrolling-component using spritename, position and size
    private function _createScrollingSprite(sprite:String, x:Float, y:Float, width:Float, height:Float) : ScrollingSpriteComponent {
        //create a new entity in the currentScene
        var entity = Gecko.currentScene.createEntity();

        //set his position in the screen
        entity.transform.position.set(x, y);

        //add the ScrollingComponent using the width and height passed and return the component
        return entity.addComponent(ScrollingSpriteComponent.create(sprite, width, height));
    }

    private function _onLoadAssets() {
        //create a scrollingSprite using the spriteName, position, and size
        var scroll1 = _createScrollingSprite("images/opengameart/mountain.png", Screen.centerX, Screen.centerY, Screen.width, Screen.height);
        scroll1.speed.x = 20;

        var scroll2 = _createScrollingSprite("images/opengameart/carbon_fiber.png", 150, Screen.centerY, 200, 500);
        scroll2.speed.y = -30;

        var scroll3 = _createScrollingSprite("images/opengameart/carbon_fiber.png", 550, Screen.centerY, 400, 300);
        scroll3.speed.set(20, 20);
        scroll3.scale.set(0.5, 0.5);
    }
}