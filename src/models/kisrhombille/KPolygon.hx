package models.kisrhombille;
import luxe.Color; //this is the only dependancy - TODO: remove this.

class KPolygon {

    public var verticies:Array<KPoint>;
    public var colour:Color;

    public function new(){
       
        verticies = new Array<KPoint>();

        colour = Color.random(false);



    }

    public function addPoint(a,b,c,d):KPoint{
        var p = new KPoint(a,b,c,d);
        verticies.push(p);
        return p;
    }

    public function drawHexagon(center:KPoint){
        
    }

    public function getRelativeVerticies(){
       
        //find point closest to 0,0,0
        var temp:Array<KPoint> = verticies.copy();


        //sort our vertices by total distance from the origin.
        haxe.ds.ArraySort.sort(temp, function(a, b):Int {
            if (Math.abs(a.a) + Math.abs(a.b) + Math.abs(a.c) < Math.abs(b.a) + Math.abs(b.b) + Math.abs(b.c)) return -1;
            else if (Math.abs(a.a) + Math.abs(a.b) + Math.abs(a.c) > Math.abs(b.a) + Math.abs(b.b) + Math.abs(b.c)) return 1;
            return 0;
        });

        //this is the clostest to are origin
        var closestVertex = temp[0];


        //get the distance from 0,0,0 as a KPoint without a dog.
        var offset:KPoint = new KPoint(-closestVertex.a,-closestVertex.b,-closestVertex.c,0);

        //create a new vertacies array to populate with vertacies translated to touch the origin
        var absoluteVertacies = new Array<KPoint>();

        //transfor all the points to as close to the point as possible.
        for(i in 0...verticies.length){
            var vert = verticies[i];
            absoluteVertacies.push(new KPoint(vert.a + offset.a, vert.b + offset.b, vert.c + offset.c, vert.d));
        }


        //return this.
        return absoluteVertacies;

        
    }


}