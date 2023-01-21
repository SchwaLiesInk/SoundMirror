class StarPoint{
Local local;
String name;
int red;
int green;
int blue;
int mag;
}
class Connected{
StarPoint from;
StarPoint to;
}
class Navigation{
Connected course;
double speed;
double time;
double dva;
GalaxyScreen screen;
Local currentLocal;
ArrayList locals;
ArrayList connections;
}
