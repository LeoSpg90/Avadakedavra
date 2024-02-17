class Personaje extends FBox
{
  Boolean izqPresionado, derPresionado, arribaPresionado;
  Boolean puedeSaltar;
  Boolean dispara;
  Boolean vivo;
  float x;
  float y;
  float velocidad;
  String direccion;
  FBody getHechizo;
  //PImage imgHechizo1;
  int vidas;

  Personaje(float _w, float _h)
  {
    super(_w, _h);
  }



  void inicializar(float _x, float _y, int n)
  {
    vivo = true;
    x = _x;
    y = _y;
    izqPresionado = false;
    derPresionado = false;
    arribaPresionado = false;
    puedeSaltar = false;
    dispara = false;
    setName(naming[n]);
    vidas = 10;

    setPosition(_x, _y);

    setDamping(0);
    setRestitution(0);
    setFriction(0);
    setRotatable(false);
    direccion = "";
  }
  int getVidas() {
    return vidas;
  }

  void actualizar()
  {
    if (vivo)
    {

      if (izqPresionado)
      {
        direccion = "izq";
        setVelocity(-150, getVelocityY());
        valorDireccion = -1;
        //setPosition(getX()-10, getY());
      }

      if (derPresionado)
      {
        direccion = "der";
        setVelocity(150, getVelocityY());
        valorDireccion = 1;

        //setPosition(getX()+10, getY());
      }

      if (!izqPresionado && !derPresionado)
      {
        setVelocity(0, getVelocityY());
      }

      if (arribaPresionado && puedeSaltar)
      {
        setVelocity(getVelocityX(), -450);
        sonidoSalto.play();
        puedeSaltar = false;
      }
      //-------------Sprites Personaje 1-------------------------------------
      if ( getName() == "personaje 1") {
        if (direccion == "der" && puedeSaltar == false) {
          p1.attachImage(imgMago1DerSalto);
        }
        if (direccion =="izq" && puedeSaltar == false) {
          p1.attachImage(imgMago1IzqSalto);
        }
        if (direccion == "der" && puedeSaltar == true) {
          p1.attachImage(imgMagoDer);
        }
        if (direccion == "izq" && puedeSaltar == true) {
          p1.attachImage(imgMagoIzq);
        }
      }

      //-------------Sprites Personaje 2-------------------------------------
      if ( getName() == "personaje 2") {
        if (direccion == "der" && puedeSaltar == false) {
          p2.attachImage(imgMago2DerSalto);
        }
        if (direccion =="izq" && puedeSaltar == false) {
          p2.attachImage(imgMago2IzqSalto);
        }
        if (direccion == "der" && puedeSaltar == true) {
          p2.attachImage(imgMago2Der);
        }
        if (direccion == "izq" && puedeSaltar == true) {
          p2.attachImage(imgMago2Izq);
        }
      }
    }
  }


  void disparar( FWorld world ) {
    if (vivo == true && (frameCount % 24) == 0) {
      FCircle hechizo = new FCircle( 5 );
      //   hechizo.attachImage(imgHechizo1);
      hechizo.setDensity(100);
      hechizo.setDamping(0);
      if (p1.dispara == true) {

        //hechizo.setFill( 90, 111, 54 );
        hechizo.setFill( 3, 228, 255 );
        hechizo.setName( "hechizo 1" );
        println(hechizo.getName());
        varita1.addTorque(-torqueHechizo);
        varita1_izq.addTorque(torqueHechizo);
        p1.dispara = false;
        sonidoHechizo1.play();
      } else  if (p2.dispara == true) {
        hechizo.setFill( 255, 3, 184 );
        hechizo.setName( "hechizo 2" );
        println(hechizo.getName());
        varita2_der.addTorque(-torqueHechizo);
        varita2.addTorque(torqueHechizo);
        sonidoHechizo2.play();
        p2.dispara = false;
      }

      if (direccion == "der") {
        hechizo.setPosition(esteX, esteY );
        hechizo.setVelocity( 40000*radians(cos(esteAngulo)), -25000*radians(sin(esteAngulo)) );
        world.add( hechizo );
      } else {

        hechizo.setPosition(esteX, esteY );
        hechizo.setVelocity( -40000*radians(cos(esteAngulo)), 25000*radians(sin(esteAngulo)) );
        world.add( hechizo );
      }
    }
  }

  void reducirVida() {

    vidas--;



    if (vidas <= 0) {
      matar();  // Llama al método matar si no quedan vidas
    }
  }
  void matar()
  {
    vivo = false;
    world.remove(this);

  }

  void cleanHechizos() {
    ArrayList <FBody> cuerpos = world.getBodies();
    for (FBody este : cuerpos) {
      String nombre = este.getName();
      if (nombre!= null) {
        if (nombre.equals("hechizo 1") )
          world.remove( este );
      }
    }
  }
}
