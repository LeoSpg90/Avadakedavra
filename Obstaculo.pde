class Obstaculo extends FBox
{
  String tipo;

  Obstaculo(float _w, float _h, String _tipo)
  {
    super(_w, _h);

    tipo = _tipo;
  }

  void inicializar(float _x, float _y)
  {
    if (tipo.equals("planta"))
    {
     
    }
    else if (tipo.equals("caja"))
    {
      setName("caja");
      setStatic(false);
      setRestitution(0.3);
      setFriction(1);
      setDamping(0.1);
caja.setDensity(0.5);
      //attachImage(loadImage("caja.png"));
    }
    

    setPosition(_x, _y);
    setRotatable(true);
  }
  
  void quitarGargola(){

    
    removeFromWorld();
  }
}
