#include "colors.inc"
#include "textures.inc"
#include "woods.inc"
#include "stones.inc"

// radiosity (global illumination) settings
#default{ finish{ ambient 0 diffuse 1 }} 
//--------------------------------------------------------------------------
#declare Photons=on;

global_settings {
 
  max_trace_level 100
  #if (Photons)          // global photon block
    photons {
      spacing 0.02                 // specify the density of photons
      count 100000               // alternatively use a total number of photons

      //gather min, max            // amount of photons gathered during render [20, 100]
      //media max_steps [,factor]  // media photons
      //jitter 1.0                 // jitter phor photon rays
      //max_trace_level 5          // optional separate max_trace_level
      //adc_bailout 1/255          // see global adc_bailout
      //save_file "filename"       // save photons to file
      //load_file "filename"       // load photons from file
      //autostop 0                 // photon autostop option
      //radius 10                  // manually specified search radius
      // (---Adaptive Search Radius---)
      //steps 1
      //expand_thresholds 0.2, 40
    }

  #end
}

sky_sphere{ 
    pigment{ 
        gradient <0,1,0>
        color_map { 
          [0.00 rgb <0.6,0.7,1.0>]
          [0.35 rgb <0.0,0.1,0.8>]
          [0.65 rgb <0.0,0.1,0.8>]
          [1.00 rgb <0.6,0.7,1.0>] 
        } 
        scale 2         
    } 
}


fog { 
    fog_type   2
    distance   100
    color      White*0.5  
    fog_offset 0.1
    fog_alt    2.0
    turbulence 0.1
}
//------------------------------------------------- end of ground fog


#declare camera_distance = 6;
#declare cameraFrente =
    camera {
    	location <camera_distance*1.5, 0, 0>
    	look_at  <0, 0,  0>
    }

#declare cameraCima =
camera {
	location <0, camera_distance*10, 0>
	look_at  <0, 0,  0>
}

#declare cameraLado =
    camera {
        location <0, 4, -camera_distance*1.5>
        look_at  <0, 0, 0>
    }

#declare camera45 =
    camera {
        location <camera_distance*1.5, 4, camera_distance*1.5>
        look_at  <0, -1.5, 0>
    }
    
#declare cameraCajado =
    camera {
        location <camera_distance*1.5, 5, -camera_distance*1>
        look_at  <0, 1, 0>
    }   

#declare chapeu_azul = 
    texture { 
        pigment{ color rgb< 0.0, 0.0, 0.6> }
        finish { 
            phong 0
            specular 0
            diffuse 0.8
        }
    }
    
#declare chapeu_amarelo = 
    texture { 
        pigment{ color rgb< 0.6, 0.6, 0> }
        finish { 
            phong 0
            specular 0
            diffuse 0.8
        }
    }   

#declare chapeu_vermelho = 
    texture { 
        pigment{ color rgb< 0.8, 0.0, 0> }
        finish { 
            phong 0
            specular 0
            diffuse 0.8
        }
    }

#declare chapeu_laranja = 
    texture { 
        pigment{ color rgb< 1, 0.5, 0> }
        finish { 
            phong 0
            specular 0
            diffuse 0.8
        }
    }
       
#declare gold=
    texture{
         pigment { rgb<1,0.84,0> }
         finish {
            ambient .2
            diffuse .6
            specular .75
            roughness .001
            reflection {
               .5
            }
         }
    }

#declare M_Glass =
    material {
      texture {
        pigment {rgbt 1}
        finish {
          ambient 0.0
          diffuse 0.05
          specular 0.6
          roughness 0.005
          reflection {
            0.1, 1.0
            fresnel on
          }
          conserve_energy
        }
      }
      interior {
        ior 1.5
        fade_power 1001
        fade_distance 0.9
        fade_color <0.5,0.8,0.6>
      }
    }       

#declare brick_wall=
    texture{ 
        pigment{ 
            brick color rgb<0.3,0.3,0.3>                // color mortar
            color rgb<0.55,0.25,0.1>    // color brick
            brick_size <0.25, 0.0525, 0.125> // format in x ,y and z- direction 
            mortar 0.005                      // size of the mortar 
        } // end of pigment
        normal {wrinkles 0.3 scale 0.01}
        finish {ambient 0.15 diffuse 0.95 phong 0.2} 
        scale 10
        rotate<0,0,0>  translate<0.01, 0.04,-0.10>
    } // end of texture
       
#declare chapeu =
    union{
        #declare chapeu_base =
            union{
            
            	difference{
                	difference{
                		union{
                			sphere {
                				<0, 0, 0>, 0.95
                			}
                			sphere{
                				<0,0,0>, 1.8
                				scale <1,0.2,1>
                			}
        
                		}
                		box{
                			<-2,-2,-2>,
                			< 2, 0, 2>
                		}
            	    }
            	    
            	    //Corte na base
            	    box{
               			<2, 1, 0.02>,
               			<1.3,  -1, -0.02>
               			
               			rotate 10*y
                    }
                }
                texture{chapeu_azul}
        
            }
        
        // Chapéu Ligação
        #declare chapeu_ligacao =
            box{
                <-0.02,-0.075,-0.05>
                <0.02,0.075,0.05>
                texture{chapeu_laranja}
            }
                         
        // Chapéu Topo
        #declare chapeu_topo = 
            union{
                
            	//Cone 1
            	union{
            		cone{
            			<0, 0, 0>, 1,
            			<0, 1.5, 0>, 0.6
            		}
            		cone{
            			<0, 0.05, 0>, 0.98
            			<0, 0.5, 0>, 0.90
            			texture {chapeu_amarelo}
            		}
            	}
            
            	//Cone 2
            	union{
            	    #local base_raio = 0.6;
            	    #local base_h = 1.5;
            		
            		cone{
            			<0, 0, 0>, base_raio,
            			<0, 1, 0>, base_raio - 0.3
                    }
            		cone{
            			<0, 0.15, 0>, base_raio - 0.02,
            			<0, 0.25, 0>, base_raio - 0.05 
            			texture {chapeu_vermelho}
            		}
            		
            		#local i = 0;
            		#local n = 8;
            		#while (i < n)
            		    
            		    object{chapeu_ligacao
            		        rotate<0,0,15>
            		        translate<base_raio,0,0>
            		        rotate<0,i*360/n,0>
            		    }
            		    
            		    #local i = i + 1;
            		#end
            		
            		translate<0,base_h,0>
            	}
            
            	//Cone 3
            	union{
            	    #local base_raio = 0.3;
            	    #local base_h = 2.5;
                    
                    cone{
                		<0, 0, 0>, base_raio,
                		<0, 0.75, 0>, 0
            		}
            		
            		#local i = 0;
            		#local n = 5;
            		#local offset_degree = 36;
            		#while (i < n)
            		    
            		    object{chapeu_ligacao
            		        scale<0.7,0.7,0.7>
            		        rotate<0,0,20>
            		        translate<base_raio,0,0>
            		        rotate<0,(i*360/n) + offset_degree,0>
            		    }
            		    
            		    #local i = i + 1;
            		#end    		
            		
            		
            		translate<0,base_h,0>
            	}
        
            	texture{chapeu_azul}
            }

        object{chapeu_topo}
        object{chapeu_base}
        
        translate<0,0.18,0>
    }
    

#declare mesa =
    union{
        
        #local mesa_w = 8;
        #local mesa_l = 8;
        #local mesa_h = 4;

        #local perna_w = 0.4;
        
        #declare perna =
            box{
                <-perna_w/2,-mesa_h/2,-perna_w/2>
                < perna_w/2, mesa_h/2, perna_w/2>
            }
        
        difference{
            box{
                <-mesa_w/2,-mesa_h/16,-mesa_l/2>
                < mesa_w/2, mesa_h/16, mesa_l/2>
            }
            box{
                <-mesa_w/2.2,-mesa_h/20,-mesa_l/2.2>
                < mesa_w/2.2, mesa_h/20, mesa_l/2.2>
                
                translate <0,mesa_h/10,0>
            }
        }
        
        object{perna translate<(-mesa_w/2)+perna_w/2,-mesa_h/2,(-mesa_l/2)+perna_w/2>}
        object{perna translate<(-mesa_w/2)+perna_w/2,-mesa_h/2,( mesa_l/2)-perna_w/2>}
        object{perna translate<( mesa_w/2)-perna_w/2,-mesa_h/2,(-mesa_l/2)+perna_w/2>}
        object{perna translate<( mesa_w/2)-perna_w/2,-mesa_h/2,( mesa_l/2)-perna_w/2>}
          
        texture{ T_Wood29    
            normal { wood 0.5 scale 0.5 turbulence 0.05 rotate<0,0,0> }
            finish { phong 1 } 
            rotate<0,0,0> scale 0.5 translate<0,0,0>
        }
        
    }

#declare livro =
    merge{
        #declare paginas=
            box{
                <-1.5,-0.2,-1>
                < 1.5, 0.2, 1>
                
                texture{pigment{color White}}
            }
        
        
        #declare cover_thing =
            difference{
                #declare cover_w = 1.75;
                box{
                    <-1,-0.01,-1>
                    < 1, 0.01, 1>
                }
                cone{
                    <0,-1.5,0>, cover_w
                    <0, 1.5,0>, cover_w
                    
                    translate <-1,0,1>
                }
                
                texture{gold}
                
            }
            
        #declare cover_things_side=
            merge{
                #local size_thing = 0.25;
                
                object{cover_thing
                    scale<size_thing,0,size_thing>
                    rotate 180*y
                    translate<-1.5+size_thing,0,1.5-3*size_thing>
                }
        
                object{cover_thing
                    scale<size_thing,0,size_thing>
                    rotate -90*y
                    translate<1.5-size_thing,0,1.5-3*size_thing>
                }
        
                object{cover_thing
                    scale<size_thing,0,size_thing>
                    rotate 90*y
                    translate<-1.5+size_thing,0,-1.5+3*size_thing>
                }
        
                object{cover_thing
                    scale<size_thing,0,size_thing>
                    rotate 0*y
                    translate<1.5-size_thing,0,-1.5+3*size_thing>
                }        
            }    
        
        #declare cover_lock =
            difference{
                box{
                    <-0.15,-0.3,-0.2>
                    < 0.15, 0.3, 0.2>
                }
                
                box{
                    <-0.5,-0.25,-0.5>
                    < 0.5, 0.25, 0.15>            
                }
                
                merge{
                    cone{
                        <0,0,0>, 0.05
                        <0,1,0>, 0.05
                        translate x*-0.05
                    }
                    box{
                        < 0.15, 0,-0.025>
                        <   0, 1, 0.025>
                    }
                }
                
                texture{gold}
            }

        #declare cover =
            union{
                difference{
                    box{
                        <-1.5,-0.25,-1.1>
                        < 1.5, 0.25, 1>
                        
                        texture{pigment{color Brown}}
                    }
                    object{paginas scale<1.5,0,1.01>}
                }
                
                object{cover_things_side translate<0, 0.25,0>}
                object{cover_things_side translate<0,-0.25,0>}
        
                object{cover_lock translate<0, 0, 1 - 0.125>}
                
            }    
        object{cover}
        object{paginas}
    }


#declare staff = 
    merge{
        #local staff_h = 5;
    
        #declare staff_thing =
            union{
                cone{
                    <0,0,0>, 0.2
                    <0.3,0.5,0>, 0.1
                }
                cone{
                    <0.3,0.5,0>, 0.1
                    <0.25,1,0>, 0.05
                }
                cone{
                    <0.25,1,0>, 0.05
                    <0.1, 1.5,0>, 0.025
                }
            }
            
        #declare staff_body =
            cone{
                <0,0,0>, 0.05
                <0,staff_h,0>, 0.1
            }

        object{staff_body}

		#local i = 0;
		#local n = 8;
		#while (i < n)
		    
		    object{staff_thing
		        scale 0.5
		        rotate<0,0,-10>
		        translate<0,staff_h,0>
		        rotate<0,i*360/n,0>
		    }
		    
		    #local i = i + 1;
		#end

        sphere{
            <0,staff_h+0.5,0>, 0.15
            
            material{M_Glass}
            
            photons {  // photon block for an object
                target 1.0
                refraction on
                reflection on
            }
            
        }

        texture{ T_Wood12    
            finish { phong 1 } 
            rotate<0,0,0> scale 0.5 translate<0,0,0>
        } // end of texture 
    }

#declare default_scale = 1;
   
//Aumentar para suavizar a distorção
//Cerca de 300 já fica bonito
#declare bend_smoothness = 200;

#declare object_axis1 = <0, 0, 0>;
#declare object_axis2 = y*5*default_scale;
#declare bend_angle = -220;
#declare bend_start = 0.2;


camera{
    //cameraFrente
    //cameraLado
    //cameraCima
    //camera45
    cameraCajado
}

object{mesa scale default_scale}
#declare bend_object = object{chapeu scale default_scale}

object{livro scale 0.5 translate<2.5,0.33,2.5> scale default_scale}
    
object{staff scale 1.5 translate -2.5*y  rotate 10*z translate <4.4,-1.5,-3> scale 1*default_scale }


//REFERENTE AO AMBIENTE
plane{
    y, -4*default_scale
    material{
        texture { T_Grnt12
            //normal { agate 0.15 scale 0.15}
            finish { phong 0.5 } 
            scale 1 
        } // end of texture 
    }
}
              
#declare WallSize = 20;              
              
#declare Wall = 
    box{
        <-0.5*default_scale,-4*default_scale,-WallSize*default_scale>
        < 0.5*default_scale,10*default_scale,+WallSize*default_scale>
        
        texture{brick_wall}
    }

#declare Roof = 
    box{
        <-0.5*default_scale,-WallSize*default_scale,-WallSize*default_scale>
        < 0.5*default_scale,+WallSize*default_scale,+WallSize*default_scale>
        
        texture{pigment{color Gray}}
    }

object{Wall
    translate<-WallSize,0,0>
    rotate<0,0,0>
}

difference{
    //Parede
    object{Wall
        translate<-WallSize,0,0>
        rotate<0,90,0>
    }
    
    #local JanelaSize = 3;    
    //Janela
    difference{
        box{
            <-JanelaSize,-JanelaSize,-2>
            < JanelaSize, JanelaSize, 2>
            
        }
        
        box{
            <-JanelaSize/8,-JanelaSize-1,-JanelaSize-1>
            < JanelaSize/8, JanelaSize+1, JanelaSize+1>
        }
        box{
            <-0.25,-3,-3>
            < 0.25, 3, 3>
            
            rotate <0,0,90>
        }

        translate <0,3,WallSize+1>
        texture{brick_wall}
    }
    
}

object{Wall
    translate<-WallSize,0,0>
    rotate<0,180,0>
}

object{Wall
    translate<-WallSize,0,0>
    rotate<0,270,0>
}

//Teto
object{Roof
    rotate<0,0,90>
    translate<0,10,0>
}

//Inside Light

light_source {  <(WallSize/2)*0.5, 8, 0>
                color rgb<0.5,0.5,0.5>
                fade_distance 0.1
             }


//Sun
light_source{ <(WallSize/4), 8, (WallSize*2)*1.5>
              color Orange
              area_light
              <5, 0, 0> <0, 5, 0>
              4,4 // numbers in directions
              adaptive 1  // 0,1,2,3...
              jitter // random softening
              rotate x*-5
             }

#include "Bend.inc"