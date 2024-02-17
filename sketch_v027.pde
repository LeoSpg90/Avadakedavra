import gifAnimation.*; //<>//
import fisica.*;
import processing.sound.*;
import TUIO.*;
TuioProcessing tuioClient;

GifMaker gifExport;
PImage logo;

FWorld world;
String estado;
Boolean activo;
PImage imgMagoIzq, imgMagoDer, imgMago2Der, imgMago2Izq, imgMago2DerSalto, imgMago2IzqSalto, imgMago1IzqSalto, imgMago1DerSalto, imgObstaculo1, imgLadrillo, imgWorld, imgPiso, imgVarita1, imgMenu, imgGana1, imgGana2, imgFin, imgImpactoUno, imgImpactoDos;
SoundFile sonidoHechizo1, sonidoHechizo2, sonidoSalto, hechizoImpacto, impactoGargolaMago, impactoGargolaPiso, musicaMenu, musicaJuego;

Plataforma piso;
//String [] estado = {"menu", "juego", "reinicio"};
ArrayList<Plataforma> plataformas;
ArrayList<Personaje> hechizos;

Obstaculo caja, planta1, planta2, tubo;
Personaje p1;
Personaje p2;

Boolean p1Dispara;
Boolean p2Dispara;
Boolean contactoGargolaPiso;
Boolean dañoMago1 = false;
Boolean dañoMago2 = false;
Boolean unoPresente, dosPresente, tresPresente, cuatroPresente;

String [] naming = {"personaje 1", "personaje 2"};

int tiempoInicio = 0;
int contador1;
int transcurrido1;
int contador2;
int transcurrido2;
Boolean contando;


Varita varita1;
Varita varita1_izq;

Varita varita2;
Varita varita2_der;

float altoRect = 70;
float largoVarita = 25;
float anchoVarita = 2;
float anchoRect = 35;
float anguloVarita1;
float esteX;
float esteY;
float esteAngulo;
float estaPosicionX;
float estaPosicionY;
float torqueHechizo = (15 + random(1, 15));
float x1, x2, y1, y2;

float anguloSimbolo1;
float anguloSimbolo2;

FRevoluteJoint mano1;
FRevoluteJoint mano2;
FRevoluteJoint mano1Izq;
FRevoluteJoint mano2Der;
int vidas;
int valorDireccion =1; //1 --> , -1 <--
float angulo = cos(radians(180));


//-------------------------- SETUP ----------------------------
void setup()
{
  size(1280, 720);

  tuioClient  = new TuioProcessing(this);



  Fisica.init(this);
  world = new FWorld();
  estado= "menu";

  sonidoHechizo1 = new SoundFile(this, "hechizo1.mp3");
  sonidoHechizo2 = new SoundFile(this, "hechizo2.mp3");
  hechizoImpacto = new SoundFile(this, "hechizo_impacto.wav");
  sonidoSalto = new SoundFile(this, "sonidoSalto.wav");
  musicaMenu = new SoundFile(this, "musicaMenu.mp3");
  impactoGargolaMago= new SoundFile(this, "impactoGargolaMago.mp3");
  impactoGargolaPiso= new SoundFile(this, "explosionDistante.wav");
  //musicaJuego = new SoundFile(this, "musicaJuego.mp3");


  //Imágenes Mago 1
  imgMagoIzq = loadImage("Mago_1_izq.png");
  imgMagoDer = loadImage("Mago_1_der.png");
  imgMago1DerSalto = loadImage("Mago_1_der_salto.png");
  imgMago1IzqSalto = loadImage("Mago_1_izq_salto.png");
  imgVarita1 = loadImage("varita1.png");
  imgImpactoUno = loadImage("Impacto1.png");
  imgImpactoDos = loadImage("Impacto2.png");

  //Imágenes Mago 2
  imgMago2Izq = loadImage("Mago_2_izq.png");
  imgMago2Der = loadImage("Mago_2_der.png");
  imgMago2DerSalto = loadImage("Mago_2_der_salto.png");
  imgMago2IzqSalto = loadImage("Mago_2_izq_salto.png");

  //Imágenes Obstáculos
  imgObstaculo1 = loadImage("gargola1.png");

  //Imágenes Plataforma
  imgLadrillo = loadImage("ladrillo.png");

  //Imagen Piso
  imgPiso = loadImage("piso.png");
  imgWorld = loadImage("mundo.png");
  world.setGravity(0, 500);

  world.setEdges(color(0, 0, 0));

  //Imagen Pantallas
  imgMenu = loadImage("Inicio.png");
  imgGana1 = loadImage("Gana1.png");
  imgGana2 = loadImage("Gana2.png");
  imgFin = loadImage("Fin.png");
}

//--------------------------DRAW----------------------------

void draw()
{
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();

  //////////////MENÚ

  if (estado == "menu") {

    if (!musicaMenu.isPlaying()) {
      musicaMenu.amp(0.35);
      musicaMenu.loop();
    }


    image(imgMenu, 0, 0, width, height);

    for (int i=0; i<tuioObjectList.size (); i++) {
      //en cada ciclo del for creamos un objeto auxiliar de tipo TuioObject y
      //con get(i) el cargamos el objeto del arreglo
      TuioObject patron = tuioObjectList.get(i);
      //declaramos una variable y con el métodos getSymbolID()
      //le asignamos el núnero de ID
      int ID=patron.getSymbolID();
      //pushMatrix();
      //dibujamos el texto segun las coordenadas del patron
      translate(patron.getScreenX(width), patron.getScreenY(height));
      //condicionamos distintas acciones según el ID


      if (ID==1) {

        fill(100, 193, 227);
        rect(50, 90, 75, 75);
        println(y1,y2);
        if (y1<0.25 && y1 > 0.01) {
          estado="juego";
          inicializarMundo();
        }
      }
      if (ID==2) {

        fill(203, 67, 145);
        rect(50, 90, 75, 75);
        if (y2<0.25 && y2 > 0.01) {
          estado="juego";
          inicializarMundo();
        }
      }
    }
  }
  //////////////JUEGO

  if (estado == "juego")
  {
    contando = true;
    contador1 = millis();
    contador2 = millis();
    pushStyle();
    textSize(25);
    textAlign(LEFT);
    image(imgWorld, 0, 0, width, height);
    noStroke();
    fill(91, 113, 58);
    rect(54, 49, 110, 35);
    fill(255);
    textAlign(CENTER);
    text ("VIDAS: ", 102, 75 );
    text (p1.getVidas(), 145, 75 );
    noStroke();
    fill(99, 39, 121);
    rect(1116, 49, 110, 35);
    fill(255);
    textAlign(CENTER);
    text ("VIDAS: ", 1164, 75 );
    text (p2.getVidas(), 1207, 75 );
    popStyle();

    int diferenciaTiempo1 = contador1 - transcurrido1;
    int diferenciaTiempo2 = contador2 - transcurrido2;

    /*push();
     textSize(25);
     fill(255);
     text (contador1, 102, 300 );
     text (transcurrido1, 102, 350 );
     text (contador2, 252, 300 );
     text (transcurrido2, 252, 350 );
     text (diferenciaTiempo1, 102, 370 );
     text (diferenciaTiempo2, 252, 370 );
     pop();
     */

    pushStyle();
    if (dañoMago1 == true) {
      transcurrido1 = millis();
      if (diferenciaTiempo1 > 550) {
        image(imgImpactoUno, 0, 0, 1280, 720);
        p1.reducirVida();
        contador1 = millis();
      }
    }
    popStyle();
    pushStyle();
    if (dañoMago2 == true) {
      transcurrido2 = millis();
      if (diferenciaTiempo2 > 550) {
        image(imgImpactoDos, 0, 0, 1280, 720);
        p2.reducirVida();
        contador2 = millis();
      }
    }
    popStyle();

    for (int i=0; i<tuioObjectList.size (); i++) {
      //en cada ciclo del for creamos un objeto auxiliar de tipo TuioObject y
      //con get(i) el cargamos el objeto del arreglo
      TuioObject patron = tuioObjectList.get(i);
      //declaramos una variable y con el métodos getSymbolID()
      //le asignamos el núnero de ID
      int ID=patron.getSymbolID();
      pushMatrix();
      //dibujamos el texto segun las coordenadas del patron



      translate(patron.getScreenX(width), patron.getScreenY(height));
      //condicionamos distintas acciones según el ID





      //----PERSONAJE 1-----------------------------------------------------------
      if (ID==1 ) {

        if (unoPresente) {
          if (p1.arribaPresionado == false && p1.derPresionado == false && p1.izqPresionado ==false) {
            pushMatrix();
            push();
            noStroke();
            translate(100, 150);

            if (p1.dispara ==true) {
              push();
              fill(100, 255, 100, 50);
              pop();
            }
            fill(100, 255, 100, 80);
            rotate(anguloSimbolo1);
            circle(0, 0, anchoRect);
            pop();
            popMatrix();
          } else {
            pushMatrix();
            push();
            noStroke();
            rectMode(CENTER);
            translate(100, 150);
            fill(100, 255, 100, 50);
            rotate(anguloSimbolo1);
            //translate(width/2, height/2);
            rect(0, 0, anchoRect/2, altoRect);
            triangle(-anchoRect/2, -altoRect/2, anchoRect-anchoRect, -altoRect*0.8, anchoRect/2, -altoRect/2  );
            pop();
            popMatrix();
          }




          if ( anguloSimbolo1 > 0.5 && anguloSimbolo1 < 2.1) {

            p1.derPresionado = true;
            p1.izqPresionado = false;
            p1.actualizar();
            varita1.actualizar();
          } else if (anguloSimbolo1>4 && anguloSimbolo1 < 5.6) {
            p1.derPresionado = false;
            p1.izqPresionado = true;
            p1.actualizar();
            varita1.actualizar();
          } else if (anguloSimbolo1>0 && anguloSimbolo1 < 0.5 || anguloSimbolo1>2.3 && anguloSimbolo1<3.8 ) {
            p1.derPresionado = false;
            p1.izqPresionado = false;
            p1.actualizar();
            varita1.actualizar();
          }
          if (y1<0.5) {
            p1.arribaPresionado=true;
          } else if (y1>0.5) {
            p1.arribaPresionado=false;
          }
        }
        if (!unoPresente) {
          p1.derPresionado = false;
          p1.izqPresionado = false;
        }
      }

      //Disparo p1
      if (ID==3) {
        if (tresPresente) {
          p1.dispara = true;
        } else {
          p1.dispara = false;
        }
      }

      //----PERSONAJE 2------------------------------------
      if (ID==2 ) {
        if (dosPresente) {
          //println("angulo simbolo2", anguloSimbolo2);
          if (p2.arribaPresionado == false && p2.derPresionado == false && p2.izqPresionado ==false) {
            pushMatrix();
            push();
            noStroke();
            translate(100, 150);
            fill(250, 10, 100, 70);
            rotate(anguloSimbolo2);
            circle(0, 0, anchoRect);
            pop();
            popMatrix();
          } else {
            pushMatrix();
            push();
            noStroke();
            rectMode(CENTER);
            translate(100, 150);
            fill(250, 10, 100, 70);
            rotate(anguloSimbolo2);
            //translate(width/2, height/2);
            rect(0, 0, anchoRect/2, altoRect);
            triangle(-anchoRect/2, -altoRect/2, anchoRect-anchoRect, -altoRect*0.8, anchoRect/2, -altoRect/2  );
            pop();
            popMatrix();
          }



          if ( anguloSimbolo2 > 0.5 && anguloSimbolo2 < 2.1) {
            p2.derPresionado = true;
            p2.izqPresionado = false;
            p2.actualizar();
            varita2.actualizar();
          } else if (anguloSimbolo2>4 && anguloSimbolo2 < 5.6) {
            p2.derPresionado = false;
            p2.izqPresionado = true;
            p2.actualizar();
            varita2.actualizar();
          } else if (anguloSimbolo2>0 && anguloSimbolo2 < 0.5 || anguloSimbolo2>2.3 && anguloSimbolo2<3.8 ) {
            p2.derPresionado = false;
            p2.izqPresionado = false;
            p2.actualizar();
            varita2.actualizar();
          }
          if (y2<0.5) {
            p2.arribaPresionado=true;
            p2.actualizar();
            varita2.actualizar();
          } else if (y2>0.5) {
            p2.arribaPresionado=false;
            p2.actualizar();
            varita2.actualizar();
          }
        }
        if (!dosPresente) {
          p2.derPresionado = false;
          p2.izqPresionado = false;
        }
      }

      //Disparo p2
      if (ID==4) {
        if (cuatroPresente) {
          p2.dispara = true;
        } else {
          p2.dispara = false;
        }
      }

      popMatrix();
    }

    if (frameCount%1000 == 0) {
      caja = new Obstaculo(40, 40, "caja");
      caja.inicializar(random(width), random(0, -300));
      caja.attachImage(imgObstaculo1);
      println("GARGOLA");
      world.add(caja);
    }



    if (p1.dispara == true) {
      varita1.posicionVarita1();
      p1.disparar(world);
    }

    if (p2.dispara == true) {
      varita2.posicionVarita2();
      p2.disparar(world);
    }

    if (p2.vidas <= 0) {

      p1.vivo=true;
      p2.vivo=false;
      estado= "Gana 1";
    }
    if (p1.vidas <=0) {
      p2.vivo=true;
      p1.vivo=false;
      estado = "Gana2";
    }
    world.step();
    world.draw();
  }



  //////////////GANA 1

  if (estado=="Gana 1") {
    //musicaMenu.stop();
    println("GANA 1");
    background(255, 111, 111);
    image(imgGana1, 0, 0, width, height);



    for (int i=0; i<tuioObjectList.size (); i++) {
      //en cada ciclo del for creamos un objeto auxiliar de tipo TuioObject y
      //con get(i) el cargamos el objeto del arreglo
      TuioObject patron = tuioObjectList.get(i);
      //declaramos una variable y con el métodos getSymbolID()
      //le asignamos el núnero de ID
      int ID=patron.getSymbolID();
      pushMatrix();
      //dibujamos el texto segun las coordenadas del patron
      translate(patron.getScreenX(width), patron.getScreenY(height));
      //condicionamos distintas acciones según el ID


      if (ID==1) {

        fill(100, 193, 227);
        rect(50, 90, 75, 75);
        if (y1<0.25 && y1 > 0.01) {
          estado="juego";
          inicializarMundo();
        }
      }
      popMatrix();
      /*pushMatrix();
       if (ID==2) {
       
       fill(100, 193, 227);
       rect(50, 90, 75, 75);
       if (y2<0.08) {
       estado="juego";
       inicializarMundo();
       }
       }
       popMatrix();*/
    }
  }
  //////////////GANA 2

  if (estado == "Gana2") {

    image(imgGana2, 0, 0, width, height);
    musicaMenu.stop();

    for (int i=0; i<tuioObjectList.size (); i++) {
      //en cada ciclo del for creamos un objeto auxiliar de tipo TuioObject y
      //con get(i) el cargamos el objeto del arreglo
      TuioObject patron = tuioObjectList.get(i);
      //declaramos una variable y con el métodos getSymbolID()
      //le asignamos el núnero de ID
      int ID=patron.getSymbolID();

      pushMatrix();
      //dibujamos el texto segun las coordenadas del patron
      translate(patron.getScreenX(width), patron.getScreenY(height));
      //condicionamos distintas acciones según el ID

      if (ID==1) {

        fill(100, 193, 227);
        rect(50, 90, 75, 75);
        if (y1<0.25 && y1 > 0.01) {
          estado="juego";
          inicializarMundo();
        }

      }
      popMatrix();

      /*pushMatrix();
       if (ID==2) {
       
       fill(100, 193, 227);
       rect(50, 90, 75, 75);
       if (y2<0.08) {
       estado="juego";
       inicializarMundo();
       }
       }
       popMatrix();*/
    }
  }

  //////////////FIN

  if (estado == "fin") {

    image(imgFin, 0, 0, width, height);

    if (keyCode == ENTER) {
      musicaMenu.stop();
      inicializarMundo();
    }
  }
}


//-------------------------- KEY PRESSED ----------------------------

void keyPressed()
{
  if (key == 'a') {
    p1.izqPresionado = true;
  }

  if (key == 'd') {
    p1.derPresionado = true;
  }
  if (key == 'w' && p1.direccion == "izq") {
    p1.arribaPresionado = true;
  }
  if (key == 'w' && p1.direccion == "der") {
    p1.arribaPresionado = true;
  }
  if (keyCode == LEFT) {
    p2.izqPresionado = true;
  }
  if (keyCode == RIGHT) {
    p2.derPresionado = true;
  }
  if (keyCode == UP && p2.direccion == "izq") {
    p2.arribaPresionado = true;
  }
  if (keyCode == UP && p2.direccion == "der") {
    p2.arribaPresionado = true;
  }
}

//-------------------------- KEY RELEASED ----------------------------

void keyReleased()
{
  if (key == 'a') {
    p1.izqPresionado = false;
  }
  if (key == 'd') {
    p1.derPresionado = false;
  }
  if (key == 'w' && p1.direccion == "izq") {
    p1.arribaPresionado = false;
  }
  if (key == 'w' && p1.direccion == "der") {
    p1.arribaPresionado = false;
  }
  if (key == 'y') {
    inicializarMundo();
  }

  if (keyCode == LEFT) {
    p2.izqPresionado = false;
  }
  if (keyCode == RIGHT) {
    p2.derPresionado = false;
  }
  if (keyCode == UP && p2.direccion == "izq") {
    p2.arribaPresionado = false;
  }
  if (keyCode == UP && p2.direccion == "der") {
    p2.arribaPresionado = false;
  }
  if (key ==  ' ') {

    p1.dispara = true;
  }
  if (key == '*') {

    p2.dispara =true;
  }
  if (key == '1') {
    println("1vamuriendo");
    p1.reducirVida();
  }
  if (key == '9') {
    println("2vamuriendo");
    p2.reducirVida();
  }
}


//-------------------------- CONTACTOS ----------------------------

void contactStarted(FContact contact)
{
  FBody _body1 = contact.getBody1();
  FBody _body2 = contact.getBody2();


  //---------- CONTACTO ENTRE PERSONAJE 1 Y PLATAFORMA

  if (((_body1.getName() == "personaje 1" && (_body2.getName() == "plataforma" || _body2.getName() == "caja" || _body2.getName() == "piso"))
    || (_body2.getName() == "personaje 1" && (_body1.getName() == "plataforma" || _body1.getName() == "caja" || _body1.getName() == "piso" ))))

  {
    if ((contact.getNormalX() == 0 )&& p1.getVelocityY() >= 0)
    {
      if (_body1.getName() == "personaje 1" && contact.getNormalY() > 0)
      {
        p1.puedeSaltar = true;
      } else if (_body2.getName() == "personaje 1" && contact.getNormalY() < 0)
      {

        p1.puedeSaltar = true;
      }
    }
  }

  //---------- CONTACTO ENTRE PERSONAJE 2 Y PLATAFORMA

  if (((_body1.getName() == "personaje 2" && (_body2.getName() == "plataforma" || _body2.getName() == "caja" || _body2.getName() == "piso"))
    || (_body2.getName() == "personaje 2" && (_body1.getName() == "plataforma" || _body1.getName() == "caja"|| _body1.getName() == "piso"))))
  {
    if (contact.getNormalX() == 0 && p2.getVelocityY() >= 0)
    {
      if (_body1.getName() == "personaje 2" && contact.getNormalY() > 0)
      {
        p2.puedeSaltar = true;
      } else if (_body2.getName() == "personaje 2" && contact.getNormalY() < 0)
      {
        p2.puedeSaltar = true;
      }
    }
  }


  //-----------CONTACTO ENTRE PERSONAJE 1 Y HECHIZO 2

  if ((_body1.getName() == "personaje 1" && _body2.getName() == "hechizo 2") || (_body2.getName() == "personaje 1" && _body1.getName() == "hechizo 2"))
  {
    dañoMago1 = true;
    hechizoImpacto.play();

    world.remove(_body2);
  } else {
    dañoMago1 =false;
  }


  //-----------CONTACTO ENTRE PERSONAJE 2 Y HECHIZO 1

  if ((_body1.getName() == "personaje 2" && _body2.getName() == "hechizo 1") || (_body2.getName() == "personaje 2" && _body1.getName() == "hechizo 1"))
  {
    dañoMago2 = true;
    hechizoImpacto.play();

    world.remove(_body2);
  } else {
    dañoMago2 = false;
  }
  //---------CONTACTO GARGOLA - MAGO 1
  if ((_body1.getName() == "personaje 1" && _body2.getName() == "caja") || (_body2.getName() == "personaje 1" && _body1.getName() == "caja"))
  {

    dañoMago1 = true;
    //println("vidas p1 ", vidas);
    impactoGargolaMago.play();
    caja.setSensor(true);
    if ((_body1.getName() ==  "caja")) {
      world.remove(_body1);
    }
    if ((_body2.getName() ==  "caja")) {

      world.remove(_body2);
    }
  }

  //---------CONTACTO GARGOLA - MAGO 2
  if ((_body1.getName() == "personaje 2" && _body2.getName() == "caja") || (_body2.getName() == "personaje 2" && _body1.getName() == "caja"))
  {

    dañoMago2 = true;
   //  println("vidas p2 ", vidas);
    impactoGargolaMago.play();


    println("REMOVER");
    if ((_body1.getName() ==  "caja")) {
      world.remove(_body1);
    }
    if ((_body2.getName() ==  "caja")) {
      world.remove(_body2);
    }
  }

  //---------CONTACTO GARGOLA - PISO
  if (((_body1.getName() == "plataforma" ||  _body1.getName() == "piso") && _body2.getName() == "caja") || ((_body2.getName() == "plataforma" || _body2.getName() == "piso") && _body1.getName() == "caja"))
  {
    contactoGargolaPiso = true;

    if ((_body1.getName() ==  "caja")) {
      _body1.setVelocity(random(-110, 110), random(-400, -500));
      _body1.addTorque(random(-5, 5));
    }
    if ((_body2.getName() ==  "caja")) {
      _body2.setVelocity(random(-110, 110), random(-400, -500));
      _body2.addTorque(random(-5, 5));
    }
  }
  //-------CONTACTO HECHIZO - PISO---------------------

  if (((_body1.getName() == "hechizo 1" || _body1.getName() == "hechizo 2") && (_body2.getName() == "plataforma" || _body2.getName() == "piso")))
  {
    world.remove(_body1);
  }

  if (((_body2.getName() == "hechizo 1" || _body2.getName() == "hechizo 2") && (_body1.getName() == "plataforma" || _body1.getName() == "piso")))
  {
    world.remove(_body2);
  }

  //-------CONTACTO HECHIZOS - PLATAFORMA MÓVIL ---------------------

  if ((_body1.getName() == "hechizo 1" && _body2.getName() == "plataforma")  || (_body2.getName() == "hechizo 1" && _body1.getName() == "plataforma" ) || (_body1.getName() == "hechizo 2" && _body2.getName() == "plataforma")  || (_body2.getName() == "hechizo 2" && _body1.getName() == "plataforma" ))
  {

    if ((_body2.getName() ==  "hechizo 1") || (_body2.getName() ==  "hechizo 2")) {
      world.remove(_body2);


      float posXPlat = _body1.getX();
      float posYPlat = _body1.getY();
      if (_body1.isStatic()) {
        world.remove(_body1);

        Plataforma p = new Plataforma(60, 20);
        p.inicializar(posXPlat, posYPlat, false, "plataforma");
        p.attachImage(imgLadrillo);
        world.add(p);
        plataformas.add(p);
      }
    } else if ((_body1.getName() ==  "hechizo 1")| (_body1.getName() ==  "hechizo 2")) {
      world.remove(_body1);
    }

    if (_body1.getName() == "piso") {
      world.remove(_body2);
    }
  }
}



//INICIALIZAR MUNDO
void inicializarMundo() {
  estado = "juego";

  if (estado == "juego") {

    println("Reinicializo mundo");

    ArrayList <FBody> todosLosCuerpos = world.getBodies();
    for (FBody estosCuerpos : todosLosCuerpos) {
      String nombre = estosCuerpos.getName();
      if (nombre!= null) {
        world.remove( estosCuerpos );
      }
    }
    //Plataformas
    plataformas = new ArrayList <Plataforma> ();
    for (int i = 0; i < 11; i++)
    {
      Plataforma p = new Plataforma(60, 20);
      p.inicializar(i* 60 + 320, height - altoRect * 1.55, true, "plataforma");
      p.attachImage(imgLadrillo);
      world.add(p);
      plataformas.add(p);
    }

    for (int i = 0; i < random (10); i++)
    {
      Plataforma p = new Plataforma(60, 20);
      p.inicializar(i* 60 +400, height - altoRect * 3 - random(-50, 50), true, "plataforma");
      p.attachImage(imgLadrillo);
      world.add(p);
      plataformas.add(p);
    }
    for (int i = 0; i < random(10); i++)
    {
      Plataforma p = new Plataforma(60, 20);
      p.inicializar(i+random(800), height - altoRect * 4.5- random(-50, 50), true, "plataforma");
      p.attachImage(imgLadrillo);
      world.add(p);
      plataformas.add(p);
    }
    for (int i = 0; i < random(10); i++)
    {
      Plataforma p = new Plataforma(60, 20);
      p.inicializar(i*random(800), height - altoRect * 6- random(-50, 50), true, "plataforma");
      p.attachImage(imgLadrillo);
      world.add(p);
      plataformas.add(p);
    }

    for (int i = 0; i < random(200, 230); i++)
    {
      Plataforma p = new Plataforma(60, 20);
      p.inicializar(i*random(800), height - altoRect * 7.5- random(-50, 50), true, "plataforma");
      p.attachImage(imgLadrillo);
      world.add(p);
      plataformas.add(p);
    }

    //Piso
    piso = new Plataforma(width, 20);
    piso.inicializar(width / 2, height - 8, true, "piso");
    piso.attachImage(imgPiso);
    world.add(piso);


    //Gárgolas
    for (int i = 1; i < random(10, 20); i++) {
      caja = new Obstaculo(40, 40, "caja");
      caja.inicializar(i*random(width), random(0, -300));
      caja.attachImage(imgObstaculo1);
      world.add(caja);
    }

    //Personaje 1
    p1 = new Personaje(anchoRect*valorDireccion, altoRect);
    p1.inicializar(anchoRect, height * 0.75, 0);
    p1.direccion = "der";
    p1.attachImage(imgMagoDer);
    world.add(p1);

    //Personaje 2
    p2 = new Personaje(anchoRect, altoRect);
    p2.inicializar(width-anchoRect, height * 0.75, 1);
    p2.direccion = "izq";
    p2.attachImage(imgMago2Izq);
    world.add(p2);

    //Varita 1
    varita1_izq = new Varita(largoVarita, anchoVarita, angulo);
    varita1_izq.inicializar(p1.x-anchoRect+5, p1.y, angulo);
    // varita1_izq.attachImage(imgVarita1);
    varita1_izq.setFill(0, 255, 0);
    world.add (varita1_izq);

    varita1 = new Varita(largoVarita, anchoVarita, angulo);
    varita1.inicializar(p1.x+anchoRect-5, p1.y, angulo);
    varita1.setFill(0, 255, 0);
    world.add (varita1);

    //Varita 2
    varita2 = new Varita(largoVarita, anchoVarita, angulo);
    varita2.inicializar(p2.x-anchoRect+5, p2.y, angulo);
    varita2.setFill(255, 255, 0);
    world.add (varita2);

    varita2_der = new Varita(largoVarita, anchoVarita, angulo);
    varita2_der.inicializar(p2.x+anchoRect-5, p2.y, angulo);
    varita2_der.setFill(255, 255, 0);
    world.add (varita2_der);

    //Mano 1
    mano1 = new FRevoluteJoint(p1, varita1);
    mano1.setAnchor(p1.x + (anchoRect/2), p1.y);
    mano1.setEnableLimit(true);
    mano1.setLowerAngle(radians((-25)));
    mano1.setUpperAngle(radians((5)));
    mano1.setFill(0, 0, 0, 0);
    mano1.setStroke(0, 0, 0, 0);

    //mano1.setFill(56,55,125);


    world.add (mano1);

    mano1Izq = new FRevoluteJoint(p1, varita1_izq);
    mano1Izq.setAnchor(p1.x - (anchoRect/2), p1.y);
    mano1Izq.setEnableLimit(true);
    mano1Izq.setLowerAngle(radians((-5)));
    mano1Izq.setUpperAngle(radians((35)));
    mano1Izq.setFill(0, 0, 0, 0);
    mano1Izq.setStroke(0, 0, 0, 0);

    world.add (mano1Izq);

    //Mano 2
    mano2 = new FRevoluteJoint(p2, varita2);
    mano2.setAnchor(p2.x - anchoRect/2, p2.y);
    mano2.setEnableLimit(true);
    mano2.setLowerAngle(radians((-5)));
    mano2.setUpperAngle(radians((35)));
    mano2.setFill(0, 0, 0, 0);
    mano2.setStroke(0, 0, 0, 0);
    world.add (mano2);

    mano2Der = new FRevoluteJoint(p2, varita2_der);
    mano2Der.setAnchor(p2.x + (anchoRect/2), p1.y);
    mano2Der.setEnableLimit(true);
    mano2Der.setLowerAngle(radians((-35)));
    mano2Der.setUpperAngle(radians((5)));
    mano2Der.setFill(0, 0, 0, 0);
    mano2Der.setStroke(0, 0, 0, 0);
    world.add (mano2Der);
  }
}




void addTuioObject (TuioObject tobj) {
  if (tobj.getSymbolID() == 1) {
    unoPresente = true;
  } else   if (tobj.getSymbolID() == 2) {
    dosPresente = true;
  } else   if (tobj.getSymbolID() == 3) {
    tresPresente = true;
  } else   if (tobj.getSymbolID() == 4) {
    cuatroPresente = true;
  }
}

void updateTuioObject (TuioObject tobj) {
  if (tobj.getSymbolID() == 1) {
    x1= tobj.getX();
    anguloSimbolo1 = tobj.getAngle();
    //println(anguloSimbolo1);
    y1=tobj.getY();
  }
  if (tobj.getSymbolID() == 2) {
    x2= tobj.getX();
    y2=tobj.getY();
    anguloSimbolo2 = tobj.getAngle();
  }
}
void removeTuioObject (TuioObject tobj) {
  if (tobj.getSymbolID() == 1) {
    // unoPresente = false;
  }
}
