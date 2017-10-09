package models.kisrhombille;
import models.kisrhombille.KPoint;


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

