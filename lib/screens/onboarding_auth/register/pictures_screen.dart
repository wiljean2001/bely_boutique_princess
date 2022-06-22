import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/responsive.dart';
import '../../../generated/l10n.dart';
import '../../../utils/show_alert.dart';
import '../../../widgets/custom_button_gradiant.dart';
import '../../../widgets/custom_image_container.dart';
import '/blocs/blocs.dart';

class PicturesScreen extends StatelessWidget {
  final TabController tabController;

  const PicturesScreen({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OnboardingLoaded) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Responsive.isMobile(context) ? 50 : 100,
                horizontal: Responsive.isMobile(context) ? 30 : 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).title_picture_screen,
                        style: Responsive.isMobile(context)
                            ? Theme.of(context).textTheme.titleLarge
                            : Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 350 : 700,
                        width: MediaQuery.of(context).size.width,
                        child: (state.user.image.isNotEmpty)
                            ? CustomImageContainer(imageUrl: state.user.image)
                            : CustomImageContainer(),
                      ),
                    ],
                  ),
                  //
                  CustomButtonGradiant(
                    height: Responsive.isMobile(context) ? 45 : 55,
                    width: Responsive.isMobile(context) ? 170 : 220,
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    text: Text(
                      S.of(context).bttn_register,
                      style: Responsive.isMobile(context)
                          ? Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.white,
                              )
                          : Theme.of(context).textTheme.headline5?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                    onPressed: () async {
                      if (state.user.image.isEmpty) {
                        ShowAlert.showErrorSnackBar(context,
                            message: S.of(context).image_no_selected);
                        return;
                      }
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text(S.of(context).error_desc);
        }
      },
    );
  }
}

          // var images = state.user.image;
          // var imageCount = images.length;
          // child: GridView.builder(
                        //   gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2,
                        //     childAspectRatio: 0.66,
                        //   ),
                        //   itemCount: 1,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return (imageCount > index)
                        //         ? CustomImageContainer(imageUrl: images[index])
                        //         : const CustomImageContainer();
                        //   },
                        // ),