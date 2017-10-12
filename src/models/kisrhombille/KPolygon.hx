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

  
    //a footprint consists of a array of the inside angles of each point in a polygon, this means we can match resized and translated polygons,
    // if we reverse the footprint we can also match for symmetry i think?
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
        // trace("footprint",angles);

        
    }

    public function addPoint(a,b,c,d):KPoint{
        var p = new KPoint(a,b,c,d);
        verticies.push(p);
        generateFootprint();
        return p;
    }

    public function drawHexagon(center:KPoint){
        
    }

}