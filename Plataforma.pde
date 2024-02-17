class Plataforma extends FBox
{
 /* float bordeInferiorPosicionX;
  float bordeInferiorPosicionY;
  float bordeInferiorLongitud;
*/
  Plataforma(float _w, float _h)
  {
    super(_w, _h);
  }

  void inicializar(float _x, float _y, Boolean _movil, String _tipo)
  {

    setPosition(_x, _y);
    if (_tipo == "piso") {
      setName("piso");
      setStatic(true);
    } else {
      setName("plataforma");
      setStatic(_movil);
      setDensity(35);
    }
    setFriction(0.5);
    setFill(255, 255, 100);
    setGrabbable(false);
    /*
    // Calcular posición y longitud del borde inferior
    bordeInferiorPosicionX = _x;
    bordeInferiorPosicionY = _y;
    bordeInferiorLongitud = 60;
    */
  }
}
