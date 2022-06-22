import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomCarouselSliders extends StatefulWidget {
  const CustomCarouselSliders({
    // Key? key,
    this.onTap,
    required this.itImages,
  }); //: super(key: key);

  final Function? onTap;
  final List<XFile> itImages;
  // final String? imageUrl;

  @override
  State<CustomCarouselSliders> createState() => _CustomCarouselSlidersState();
}

class _CustomCarouselSlidersState extends State<CustomCarouselSliders> {
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
          child: InkWell(
            onTap: () => widget.onTap != null ? widget.onTap!() : {},
            child: CarouselSlider(
              items: widget.itImages.isNotEmpty
                  ? widget.itImages.map(
                      (e) {
                        // if (e.isNotEmpty) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Image.file(File(e.path)),
                                ),
                              ],
                            );
                          },
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
                // autoPlay: true,
                enlargeCenterPage: true,
                height: 170,
                disableCenter: false,
                enableInfiniteScroll: false,
                onPageChanged: (
                  indexPage,
                  carousel,
                ) {
                  // cuando cambie la pagina
                },
                viewportFraction: 0.5,
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
