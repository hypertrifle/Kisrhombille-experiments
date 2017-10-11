package models.kisrhombille;
import luxe.Color; //this is the only dependancy - TODO: remove this.
import models.kisrhombille.KPoint;

class KPolygon {

    public var verticies:Array<KPoint>;
    public var colour:Color;
    public var footprint:Array<Float>;

    public function new(){
       
        verticies = new Array<KPoint>();

        colour = Color.random(false);



    }

    public function checkFootprint(in_footprint:Array<Float>):Bool{

        if(in_footprint.length != footprint.length){
            return false;
        }
        //this currently only detect rotated and scaled, for flipping i would just need to revrese the array and re check?

        var matches:Int = 0;
        var startIndex:Int = 0;

        for(i in 0...footprint.length){

            if(i == 0){

                startIndex = in_footprint.indexOf(footprint[i]);

                if(startIndex == -1){

                    return false;

                }
            }

            if(footprint[matches] != in_footprint[(i+startIndex)%footprint.length]) {
                return false;
            }

        }

        return true;

    }

  

    public function generateFootprint():Void {

        if(verticies.length < 3){
            return;
        }

        var angles = new Array<Float>();

        for(i in 0...verticies.length){

            //get current vert, previous and next
            var a:KPoint = (i == 0)? verticies[verticies.length-1] : verticies[i-1];
            var b:KPoint = verticies[i];
            var c:KPoint = (i == verticies.length-1)? verticies[0] : verticies[i+1];
            
            //we need to convert the cube coords to cartesean
            var A = Main.grid.toCartesien(a);
            var B = Main.grid.toCartesien(b);
            var C = Main.grid.toCartesien(c);

            //https://stackoverflow.com/questions/17763392/how-to-calculate-in-javascript-angle-between-3-points
            var AB = Math.sqrt(Math.pow(B.x-A.x,2)+ Math.pow(B.y-A.y,2)); 
            var BC = Math.sqrt(Math.pow(B.x-C.x,2)+ Math.pow(B.y-C.y,2));
            var AC = Math.sqrt(Math.pow(C.x-A.x,2)+ Math.pow(C.y-A.y,2));
            
            var round:Float = Math.round(Math.acos((BC*BC+AB*AB-AC*AC)/(2*BC*AB)) * 10000) / 10000;

            angles.push(round);


        }


        this.footprint = angles;
        trace("footprint",angles);

        
    }

    public function addPoint(a,b,c,d):KPoint{
        var p = new KPoint(a,b,c,d);
        verticies.push(p);
        generateFootprint();
        return p;
    }

    public function drawHexagon(center:KPoint){
        
    }

    public function getRelativeVerticies(){

        //this the inside angle footprint idea is gonna work better.
       
        //find point closest to 0,0,0
        var temp:Array<KPoint> = verticies.copy();


        //sort our vertices by total distance from the origin.
        haxe.ds.ArraySort.sort(temp, function(a, b):Int {                                         //dont hate me
            if (Math.abs(a.a) + Math.abs(a.b) + Math.abs(a.c) < Math.abs(b.a) + Math.abs(b.b) + Math.abs(b.c)) return -1;
            else if (Math.abs(a.a) + Math.abs(a.b) + Math.abs(a.c) > Math.abs(b.a) + Math.abs(b.b) + Math.abs(b.c)) return 1;
            return 0;
        });

        //this is the clostest to ore origin
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