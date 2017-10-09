package models;
import luxe.Color;
typedef Point = { public var x:Float; public var y:Float; }


class KPoint {

    public var transformations_move:Array<Array<Int>>;


    public var a:Int;
    public var b:Int;
    public var c:Int;
    public var d:Int;

    public function new(ant,bat,cat,dog){

        transformations_move = new Array<Array<Int>>();
        transformations_move.push([1,0,-1]);
        transformations_move.push([1,-1,0]);
        transformations_move.push([0,-1,1]);
        transformations_move.push([-1,0,1]);
        transformations_move.push([-1,1,0]);
        transformations_move.push([0,1,-1]);
        

        a = ant;
        b = bat;
        c = cat;
        d = dog;
    }


    public function moveCube(direction:Int){

    }
}

class KPolygon {

    public var verticies:Array<KPoint>;
    public var colour:Color;

    public function new(){
       
        verticies = new Array<KPoint>();

        colour = Color.random(false);



    }

    public function addPoint(a,b,c,d){

        verticies.push(new KPoint(a,b,c,d));
  
    }

    public function drawHexagon(center:KPoint){
        
    }


}

class KSegment {

    public var from:KPoint;
    public var to:KPoint;

    public function new(_from:KPoint, _to:KPoint){
        from = _from;
        to = _to;
    }
}

class KGrid {
    //this stores all of the setttings for our grid used to render the grid how we wish.

    public var origin:Point;
    public var north:Float;
    
    public var fish:Float;
    public var goat:Float;
    public var hare:Float;
    public var ibex:Float;

    private var dog_lookup:Array<Point>;

    public var isClockwise:Bool;

    public var THETA:Float;

    public function new(x:Float,y:Float,n:Float,f:Float, clockwise:Bool ){

        //in the kishombille all angles that span around the center point of a single cude is 30 degrees.
        THETA = 30 * (Math.PI/180);

        //save or origin
        origin = {x:x,y:y};

        //north is the longest edge
        north = n;

        //fish is the smallest edge
        fish = Math.sin(THETA) * north;

        //goat is the length of the lines not on horizontal or verticle axis (our hypotenuse if treating each segment as a right angle triangle).
        goat = Math.sqrt(north*north - fish*fish);

        //hare is the oppisite edge of the goat and the ibex is the adjacent.
        hare = Math.abs(Math.sin(THETA) * goat);
        ibex = Math.abs(Math.cos(THETA) * goat);

        //this is sort of a simplified multiplication matrix based on the dog property outlined in https://github.com/johnalexandergreene/Geom_Kisrhombille
        dog_lookup = new Array<Point>();
        dog_lookup.push({x:0,y:0});
        dog_lookup.push({x:-hare,y:-ibex});
        dog_lookup.push({x:0,y:-north});
        dog_lookup.push({x:hare,y:-ibex});
        dog_lookup.push({x:goat,y:-fish});
        dog_lookup.push({x:goat,y:0});

        //not sure what this is for yet.
        isClockwise = clockwise;

    }

    public function toCartesien(_kpoint:KPoint):Point{

        //based on paper maths, hopefully this is right!
        var x:Float = (_kpoint.b + _kpoint.a) * this.goat;
        var y:Float = ( (-_kpoint.b + _kpoint.a) * this.ibex ) + (_kpoint.c * this.ibex);

        // calculate the coords of the master "cube" for the space.
        var cube:Point = {x:origin.x + x, y:origin.y + y};

        //now based on the dog value
        var pointOffset:Point = dog_lookup[_kpoint.d];

        //add to our "cube" position and offset
        return {x: cube.x+pointOffset.x, y: cube.y + pointOffset.y }; 




    }

}

