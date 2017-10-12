package models.kisrhombille;


typedef Point = { public var x:Float; public var y:Float; }


enum KPointType {
  Center;
  North;
  Goat;
}

class KPoint {

    public var transformations_move:Array<Array<Int>>;


    public var a:Int;
    public var b:Int;
    public var c:Int;
    public var d(default,set):Int;

    public var point_type:KPointType;

    public function new(?ant = 0,?bat = 0,?cat = 0,?dog = 0){


        //validate the "cube" co-ordinates.
        if(-ant + bat + cat != 0){
            throw "KPoint initilised with a non cube co-ordinate -- A: "+ ant + " B: " + bat + " C: "+ cat;
        }



        transformations_move = new Array<Array<Int>>();

        // moves are one of 6 directions, and move clockwise around the center point of our cube.
        transformations_move.push([1,0,-1]); //1 O'Clock -  0
        transformations_move.push([1,-1,0]); //3 O'Clock -  1

        transformations_move.push([0,-1,1]); //5 O'Clock -  2
        transformations_move.push([-1,0,1]); //7 O'Clock -  3

        transformations_move.push([-1,1,0]); //9 O'Clock -  4
        transformations_move.push([0,1,-1]); //11 O'Clock - 5

        
        
        //set our cube co-ordinates
        a = ant;
        b = bat;
        c = cat;

        set_d(dog); //call our set D function as our point_type is derrived from this value.


    } // end of constructor

    public function clone():KPoint {
        return new KPoint(a,b,c,d);
    }

    //effects this kPoint
    public function moveCube(direction:Int, ?distance:Int = 1):KPoint{
        for(i in 0...distance){
            this.a += transformations_move[direction][0];
            this.b += transformations_move[direction][1];
            this.c += transformations_move[direction][2];
        }

        return this;
    }


    public function set_d(value:Int):Int{
        this.d = value;

         if([1,3,5].indexOf(d) > -1){
            point_type = Goat;
        } else if([2,4].indexOf(d) > -1){
            point_type = North;   
        } else if(d == 0) {
            point_type = Center;
        } else {
            trace("unknown DOG can't set point type");
        }

        return value;

    }

    //gets a new KPoint
    public function getKPointWithCubeMove(direction){
        return new KPoint(a + transformations_move[direction][0], b + transformations_move[direction][1], c + transformations_move[direction][2], d );
    }


}
