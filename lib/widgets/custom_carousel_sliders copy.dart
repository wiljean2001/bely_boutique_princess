import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

import '../config/constrants.dart';

class CustomCarouselSliders2 extends StatefulWidget {
  const CustomCarouselSliders2({
    Key? key,
    this.onTap,
    required this.itImages,
  }) : super(key: key);

  final Function? onTap;
  final List<dynamic> itImages;
  // final String? imageUrl;

  @override
  State<CustomCarouselSliders2> createState() => _CustomCarouselSlidersState();
}

class _CustomCarouselSlidersState extends State<CustomCarouselSliders2> {
  final CarouselController controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => controller.previousPage(),
          child: Icon(
            Icons.keyboard_arrow_left_outlined,
            color: Theme.of(context).primaryColorDark,
            size: 45,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => widget.onTap != null ? widget.onTap!() : {},
            child: CarouselSlider(
              items: widget.itImages.isNotEmpty
                  ? widget.itImages.map(
                      (e) {
                        return Center(
                          child: widget.onTap != null
                              ? Image.network(e)
                              : PinchZoomImage(
                                  image: Image.network(e),
                                  zoomedBackgroundColor:
                                      const Color.fromRGBO(240, 240, 240, 1.0),
                                  // hideStatusBarWhileZooming: true,
                                  // onZoomStart: () {
                                  //   print('Zoom started');
                                  // },
                                  // onZoomEnd: () {
                                  //   print('Zoom finished');
                                  // },
                                ),
                        );
                      },
                    ).toList()
                  : [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: Theme.of(context).primaryColorDark,
                        size: 65,
                      ),
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: Theme.of(context).primaryColorDark,
                        size: 65,
                      ),
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: Theme.of(context).primaryColorDark,
                        size: 65,
                      ),
                    ],
              carouselController: controller,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: 170,
                autoPlay: true,
                autoPlayAnimationDuration: kLoginAnimationDuration,
                disableCenter: false,
                enableInfiniteScroll: false,
                onPageChanged: (
                  indexPage,
                  carousel,
                ) {
                  // cuando cambie la pagina
                },
                viewportFraction: 0.7,
                aspectRatio: 2.0,
                initialPage: 1,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => controller.nextPage(),
          child: Icon(
            Icons.keyboard_arrow_right_outlined,
            color: Theme.of(context).primaryColorDark,
            size: 45,
          ),
        ),
      ],
    );
  }
}
