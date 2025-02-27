import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

final cs.CarouselSliderController _controller = cs.CarouselSliderController();

class MyCarouselSlider extends StatelessWidget {
  MyCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        cs.CarouselSlider(
          options: cs.CarouselOptions(
            height: 200.0,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {},
          ),
          items: [
            'assets/images/slider1.png',
            'assets/images/slider2.png',
          ].map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: 8.0), // Espaçamento entre os slides
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius:
                        BorderRadius.circular(30.0), // Bordas arredondadas
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                            2, 2), // Sombra leve para destacar o carrossel
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        30.0), // Aplica o arredondamento nas imagens
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        // Indicadores abaixo do carrossel
        SizedBox(
            height: 8), // Ajusta a distância entre o carrossel e os indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 4.0), // Indicadores mais próximos ao carrossel
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey, // Ajuste a cor conforme necessário
              ),
            );
          }),
        ),
      ],
    );
  }
}
