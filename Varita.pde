class Varita extends FBox
{
  float x;
  float y;
  float angulo;



  Varita (float _w, float _h, float angulo) {
    super(_w, _h);
  }
  void inicializar(float _x, float _y, float angulo) {
    x = _x;
    y = _y;
    setName("varita");
    setPosition(_x, _y);
    setRotatable(true);
  }



  void actualizar() {


    if (p1.direccion == "izq") {
      varita1.setDrawable(false);
      varita1.setSensor(true);
      mano1.setDrawable(false);
      varita1_izq.setDrawable(true);
      mano1Izq.setDrawable(true);
    } else {
      varita1.setDrawable(true);
      mano1.setDrawable(true);
      varita1_izq.setDrawable(false);
      mano1Izq.setDrawable(false);
      varita1_izq.setSensor(true);
    }
    if (p2.direccion == "izq") {
      varita2.setDrawable(true);
      mano2.setDrawable(true);
      varita2_der.setDrawable(false);
      mano2Der.setDrawable(false);
      varita2_der.setSensor(true);
    } else {
      varita2.setDrawable(false);
      varita2.setSensor(true);
      mano2.setDrawable(false);
      varita2_der.setDrawable(true);
      mano2Der.setDrawable(true);
    }
  }

  void posicionVarita1() {
    //------------------POSICION VARITA PERSONAJE 1---------------------
    if (p1.direccion == "izq") {
      esteAngulo = varita1_izq.getRotation();
      estaPosicionX = varita1_izq.getX();
      esteX = varita1_izq.getX() - largoVarita /2;
      esteY = varita1_izq.getY()- largoVarita /2 * (sin(esteAngulo));
    } else {
      esteAngulo = varita1.getRotation();
      estaPosicionX = varita1.getX();
      esteX = varita1.getX() + largoVarita /2;
      esteY = varita1.getY()+ largoVarita /2 * (sin(esteAngulo));
    }
  }

  void posicionVarita2() {
    //------------------POSICION VARITA PERSONAJE 2---------------------
    if (p2.direccion == "der") {
      esteAngulo = varita2_der.getRotation();
      estaPosicionX = varita2_der.getX();
      esteX = varita2_der.getX() + largoVarita /2;
      esteY = varita2_der.getY()+ largoVarita /2 * (sin(esteAngulo));
    } else {
      esteAngulo = varita2.getRotation();
      estaPosicionX = varita2.getX();
      esteX = varita2.getX() - largoVarita /2;
      esteY = varita2.getY()- largoVarita /2 * (sin(esteAngulo));
    }
  }
}
