import luxe.GameConfig;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import models.kisrhombille.*;

import C;

class Main extends luxe.Game {

    override function config(config:GameConfig) {

        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;
        
        //config.preload.textures.push({id:'assets/img/'});
        //config.preload.texts.push({id:'assets/text/'});

        return config;

    } //config

    public var grid:KGrid;
    public var polygons:Array<KPolygon>;
    // public var displayShapes:Array<


    public function hex(a:Int,b:Int,c:Int) {
        var poly = new KPolygon();
            
            poly.addPoint(a,b,c,2);
            poly.addPoint(a,b,c,3);
            poly.addPoint(a,b,c,4);
            poly.addPoint(a,b,c,5);
            poly.addPoint(a+1,b,c+1,2);
            poly.addPoint(a+1,b,c+1,1);
            poly.addPoint(a,b-1,c+1,4);
            poly.addPoint(a,b-1,c+1,3);
            poly.addPoint(a,b-1,c+1,2);
            poly.addPoint(a-1,b-1,c,5);
            poly.addPoint(a-1,b-1,c,4);
            poly.addPoint(a,b,c,1);
            return poly;
    }


    public function segment(a:Int,b:Int,c:Int,seg:Int){
        var poly = new KPolygon();
       
        switch(seg){
            case 0 :
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b,c,2);
            poly.addPoint(a,b,c,3);
            case 1 :
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b,c,3);
            poly.addPoint(a,b,c,4);
            case 2 :
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b,c,4);
            poly.addPoint(a,b,c,5);
            case 3 :
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b,c,5);
            poly.addPoint(a+1,b,c+1,2);
            case 4 :
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a+1,b,c+1,2);
            poly.addPoint(a+1,b,c+1,1);
            case 5:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a+1,b,c+1,1);
            poly.addPoint(a,b-1,c+1,4);
            case 6:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b-1,c+1,4);
            poly.addPoint(a,b-1,c+1,3);
            case 7:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b-1,c+1,3);
            poly.addPoint(a,b-1,c+1,2);
            case 8:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b-1,c+1,2);
            poly.addPoint(a-1,b-1,c,5);
            case 9:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a-1,b-1,c,5);
            poly.addPoint(a-1,b-1,c,4);
            case 10:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a-1,b-1,c,4);
            poly.addPoint(a,b,c,1);        
            case 11:
            poly.addPoint(a,b,c,0);        
            poly.addPoint(a,b,c,1);
            poly.addPoint(a,b,c,2);
        }
        return poly;
    }




    override function ready() {
        
        polygons = new Array<KPolygon>();

        grid = new KGrid(Luxe.screen.w/2,Luxe.screen.h/2,20,0,true);

        var size:Int = Math.floor((Luxe.screen.w / (grid.north*2))/1.2);


        var count = 0;

        for(a in -size...size){
            for(b in -size...size){
                for(c in -size...size){

                    //this is our golden rule!
                    if(-a+b+c == 0){

                         //do somthing for this cube.


                        //polygons.push(hex(a,b,c));  




                        var ittr = 12;

                        for(i in 0...ittr){
                            
                            var poly = segment(a,b,c,i);

                            var red = Math.sin(count/2)*0.5;
                            var green = Math.cos(count/4);
                            var blue = Math.abs(c/(size*2))  + (Math.random()*0.2);


                            poly.colour = new Color(red,green,blue);
                            polygons.push(poly);
                            count ++;
                             
                        }
                    }

                }
            }
        }

    


        // polygons[i-1].colour = Color.random(false);        
        renderPolygons(polygons);

        

        // trace("BOOTING");

    } //ready

    public function renderPolygons(polys) {
            trace(grid);


        for(i in 0...polygons.length){
            // trace("rendering poly - "+i);


            //we have to transform our coordinate systems into cartesian coords using the values from our grid instance.
            var poly = polygons[i];


            var points = new Array<Vector>();
            
            for(j in 0...poly.verticies.length){

                var pos = grid.toCartesien(poly.verticies[j]);

                points.push(new Vector(pos.x, pos.y));
            }

            Luxe.draw.poly({
            solid : true,
            color: poly.colour,
            points : points,
            visible: true,
            depth: 1,
            // batcher: batcher
            //texture: texture
            //shader: shader
        });

        }

    }


    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {

    } //update

    
    function connect_input() {

        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);
        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);
        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);
        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);
        Luxe.input.bind_key('space', Key.space);
        Luxe.input.bind_key('debug', Key.key_q);
        Luxe.input.bind_key('enter', Key.enter);
        Luxe.input.bind_key('reset', Key.key_r);

    }


} //Main
