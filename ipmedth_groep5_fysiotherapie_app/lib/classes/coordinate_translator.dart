import 'dart:ui';

//devides canvassize with imagesize to get the size difference between them to calculate the required new x
double translateX(double x, Size canvasSize, Size imageSize){
  return x * canvasSize.width / imageSize.width;
}

//devides canvassize with imagesize to get the size difference between them to calculate the required new y
double translateY(double y, Size canvasSize, Size imageSize){
  return y * canvasSize.height / imageSize.height;
}