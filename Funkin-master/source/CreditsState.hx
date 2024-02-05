package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxSort;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;


class CreditsState extends MusicBeatState
{
    var bg:FlxSprite;
    //var wallBG:FlxSprite;
    //var wallBGBlend:BlendMode;
    var gridBackdrop:FlxBackdrop;

    var creditsList:Array<Array<String>> = [
        ['Engine Team'],
        ['jtsf',                        'JTSF',                 'Engine Director',                                          'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
        ['winn',                        'Sonamaker',            'Coding Teacher\nFor JTSF',                                 'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
        ['Funkin Crew'],
        ['ninjamuffin',                 'ninjamuffin99',        'FNF Programmer',                                           'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
        ['kawaisprite',                 'kawaisprite',          'FNF Composer',                                             'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
        ['phantomarcade',               'PhantomArcade',        'FNF Animator',                                             'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
        ['evilsk8r',                    'Evilsk8r',             'FNF Artist',                                               'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
        ['Testing Another'],
        ['bf',                          'Boyfriend',            'Rapper',                                                   'https://ninja-muffin24.itch.io/funkin',                                    '31B0D1'],
    ];

    var headingsAndBoxes:Array<Array<Dynamic>> = [];
    var daSelection:Int = 1;

    var boxesToSelect:Array<String> = [];
    //var creditIcons:Array<String> = [];

    var aCounter:Int = 0;
    var boxCounter:Int = 0;

    var yCoordinate:Int = 0;
    var haveNotAddedAnythingYet:Bool = true;

    override function create() {
        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

        /*
        wallBG = new FlxSprite(0, 0);
        wallBG.frames = Paths.getSparrowAtlas('creditsBG');
        wallBG.animation.addByPrefix('boil', "Wall BG", 24);
        wallBG.animation.play('boil');
        wallBG.alpha = 0.7;
        wallBG.blend = MULTIPLY;
        wallBG.alpha = 0.5;
        add(wallBG);
        wallBG.screenCenter(X);
        wallBG.screenCenter(Y);
        */

        gridBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(75, 50, 150, 100, true, 0x46250C16, 0x0));
        gridBackdrop.velocity.set(50, 25);
        //gridBackdrop.alpha = 0;
		//FlxTween.tween(gridBackdrop, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(gridBackdrop);

        for (i in creditsList) {
            if (i.length == 1) {
                if (!haveNotAddedAnythingYet && boxCounter != 0) yCoordinate += 250;

                if (boxCounter == 2) {
                    headingsAndBoxes.push(["Nothing"]);
                } else if (boxCounter == 1) {
                    headingsAndBoxes.push(["Nothing"]);
                    headingsAndBoxes.push(["Nothing"]);
                }

                headingsAndBoxes.push(["Heading"]);
                headingsAndBoxes.push(["Heading"]);
                headingsAndBoxes.push(["Heading"]);

                var heading:FlxSprite = new FlxSprite().loadGraphic(Paths.image('creditHeading'));
                heading.x = 25;
                heading.y = 25 + yCoordinate;
                add(heading);

                /*var headingTxt:FlxText = new FlxText(0, heading.y + 5, 1280, i[0], 50);
                headingTxt.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                headingTxt.alignment = CENTER;
                add(headingTxt);*/

                var headingText:Alphabet = new Alphabet(0, heading.y, i[0], true, false);
                headingText.screenCenter(X);
                add(headingText);

                yCoordinate += 100;
                boxCounter = 0;
                
            } else {
                var box:FlxSprite = new FlxSprite(0, 0); // First is 70, then it's 470, then it's 870 for the X.
                box.frames = Paths.getSparrowAtlas('creditBoxes');
                box.animation.addByPrefix('notSelected', "Credit box0", 24);
                box.animation.addByPrefix('selected', "Credit box selected", 24);
                box.animation.play('notSelected');
                box.x = 400 * boxCounter + 70;
                box.y = yCoordinate;
                headingsAndBoxes.push(["A Box", box]);
                add(box);

                var iconThingy:FlxSprite = new FlxSprite().loadGraphic(Paths.image('creditIcons/' + i[0]));
                iconThingy.x = box.x - 80;
                iconThingy.y = box.y + 20;
                add(iconThingy);

                var name:FlxText = new FlxText(box.x + (box.width / 2) - (1280 / 2), box.y, 1280, i[1], 30);
                name.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                name.alignment = CENTER;
                add(name);

                var description:FlxText = new FlxText(box.x + (box.width / 2) - (1280 / 2), box.y + 40, 1280, i[2], 16);
                description.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                description.alignment = CENTER;
                add(description);

                if (boxCounter == 2) {
                    boxCounter = 0;
                    yCoordinate += 275;
                } else {
                    boxCounter++;
                }
            }

            haveNotAddedAnythingYet = false;
            //aCounter++;
        }

        super.create();
    }

    override function update(elapsed:Float) {
        if (controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                exitToMainMenu();
            }

        if (controls.UI_LEFT_P) {
            if (daSelection == 1) {
                daSelection = headingsAndBoxes.length;
            } else {
                daSelection--;
            }
        }
        if (controls.UI_DOWN_P) {
            if (daSelection == headingsAndBoxes.length) {
                daSelection = 3;
            } else if (daSelection == headingsAndBoxes.length - 1) {
                daSelection = 2;
            } else if (daSelection == headingsAndBoxes.length - 2) {
                daSelection = 1;
            } else {
                daSelection += 3;
            }
        }
        if (controls.UI_UP_P) {
            if (daSelection == 3) {
                daSelection = headingsAndBoxes.length;
            } else if (daSelection == 2) {
                daSelection = headingsAndBoxes.length - 1;
            } else if (daSelection == 1) {
                daSelection = headingsAndBoxes.length - 2;
            } else {
                daSelection -= 3;
            }
        }
        if (controls.UI_RIGHT_P) {
            if (daSelection == headingsAndBoxes.length) {
                daSelection = 1;
            } else {
                daSelection++;
            }
        }

        if (FlxG.keys.pressed.SEVEN) {
            trace(headingsAndBoxes);
        }

        super.update(elapsed);
    }

    override function finishTransIn()
    {
        super.finishTransIn();
    }

    function addANewThing() {
        
    }

    function exitToMainMenu()
    {
        FlxG.switchState(new MainMenuState());
    }
}