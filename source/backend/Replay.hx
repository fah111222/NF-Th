package backend;

class Replay
{
    //整个组>摁压类型>行数>时间
    static public var saveData:Array<Array<Array<Float>>> = [
        [
            [],
            [],
            [],
            []
        ],
        [   
            [],
            [],
            [],
            []
        ]
    ];

    static public var hitData:Array<Array<Array<Float>>> = [
        [
            [],
            [],
            [],
            []
        ],
        [   
            [],
            [],
            [],
            []
        ]
    ];

    static public var saveSpec:Array<Array<Array<Dynamic>>> = [
        [
            [],
            []
        ],
        [
            [],
            []
        ]
    ];
    //整个组>软编程类型>摁压类型>时间&键

    static public var hitSpec:Array<Array<Array<Dynamic>>> = [
        [
            [],
            []
        ],
        [
            [],
            []
        ]
    ];

    static public function push(time:Float, type:Int, state:Int) 
    {
        if (!PlayState.replayMode) saveData[state][type].push(time);
    }

    static public function pushSpec(type:Int, state:Int, keyName:String) 
    {
        saveSpec[type][state].push([Conductor.songPosition, keyName]);
    }

    static public function keysCheck(elapsed:Float)
    {
        for (type in 0...4)
        {
            if (hitData[1][type].length > 0 && hitData[1][type][0] < Conductor.songPosition) reCheck(type, elapsed);
        }
    }

    static var allowHit:Array<Bool> = [true, true, true, true];
    static function reCheck(type:Int, elapsed:Float) {
        if (hitData[0][type][0] >= Conductor.songPosition) 
        {
            PlayState.instance.keysCheck(type, Conductor.songPosition);
            if (allowHit[type])
            {
                PlayState.instance.keyPressed(type,hitData[1][type][0]);
                allowHit[type] = false;
            }
        } else {
            if (allowHit[type]) {
                PlayState.instance.keyPressed(type, hitData[1][type][0]); //摁下松开时间如果短没检测到
            }
            PlayState.instance.keysCheck(type, Conductor.songPosition); //长键多一帧的检测
            PlayState.instance.keyReleased(type);
            allowHit[type] = true;
            hitData[0][type].splice(0, 1);
            hitData[1][type].splice(0, 1);
        }
    }

    static public function init()
    {
        hitData = 
        [
            [
                [],
                [],
                [],
                []
            ],
            [   
                [],
                [],
                [],
                []
            ]
        ];
        for (state in 0...2)
            for (type in 0...4)
                for (hit in 0...saveData[state][type].length)
                {
                    hitData[state][type].push(saveData[state][type][hit]);
                }
        allowHit = [true, true, true, true];

        //只能这么复制 --狐月影
    }

    static public function reset() 
    {
        saveData = hitData = 
        [
            [
                [],
                [],
                [],
                []
            ],
            [   
                [],
                [],
                [],
                []
            ]
        ];
    }   //愚蠢但是有用 --狐月影
}