import luxe.GameConfig;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import models.kisrhombille.*;

import C;

import phoenix.Batcher;
import phoenix.Shader;
import phoenix.Texture;
import phoenix.RenderTexture;
import luxe.Sprite;
import luxe.Rectangle;

class Main extends luxe.Game {

    override function config(config:GameConfig) {

        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;
        config.preload.textures.push({ id:'assets/img/01.jpg' });

        #if web
        config.preload.shaders.push({ id:'post_shader', frag_id:'assets/text/post_web.glsl', vert_id:'default' });
        #end

        #if cpp
        config.preload.shaders.push({ id:'post_shader', frag_id:'assets/text/post.glsl', vert_id:'default' });
        #end

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



    public var post_shader:Shader;
    public var post_batcher:Batcher;
    public var post_texture:RenderTexture;
    public var display_sprite:Sprite;
    public var shaderTime:Float;




    override function ready() {

        //initilise our shaders and batchers
        post_shader = Luxe.resources.shader('post_shader');
        post_shader.set_float("time",0);
        post_shader.set_vector2("resolution",new Vector(Luxe.screen.w,Luxe.screen.h));

        //this is the texture we will use for the post processing
        var texture_overlay = Luxe.resources.texture('assets/img/01.jpg');
        texture_overlay.slot = 1;
        post_shader.set_texture("tex1", texture_overlay);
        shaderTime = 0;
        post_shader.set_float("time",0);

        //create a post_batcher
        post_batcher = Luxe.renderer.create_batcher({
             name : 'post_batcher',
             layer : 1,
             no_add : false,
         });

        //set the post batchers view to our current window viewport
        post_batcher.view.viewport = new Rectangle(0,0,Luxe.screen.width,Luxe.screen.height);

        //hook in our "before" and "after" to allow the render texture to capture the programs output
        post_batcher.on(prerender, before);
        post_batcher.on(postrender, after);


         //create a render target of a fixed size
         post_texture = new RenderTexture({ id:'rtt', width:Luxe.screen.w, height:Luxe.screen.h });

        //this is our final display sprite, after output has been capture (what we apply our post shader to)
         display_sprite = new Sprite({
             texture : post_texture,
             size : new Vector(Luxe.screen.width,Luxe.screen.height),
             pos : Luxe.screen.mid,
             shader: post_shader,
             // visible:false
         });

        
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

                            var red = (Math.sin(i/3)+ (Math.random()*0.2) -0.1) * 0.7;
                            var blue = Math.cos(count/10)*1.8;
                            var green = Math.sin(count/20) + (Math.random()*0.2) -0.1;



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

     //our before render
    function before(_) {

            //Set the rendering target to the texture
                Luxe.renderer.target = post_texture;
                //clear the texture to an obvious color
                // Luxe.renderer.clear(clear);

    } //before

    //our after render.
    function after(_) {

            //reset the target back to no target (i.e the screen)
            Luxe.renderer.target = null;

    } //after

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
             batcher: post_batcher
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
        shaderTime += dt; //increase current tome
        post_shader.set_float("time",shaderTime);

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
