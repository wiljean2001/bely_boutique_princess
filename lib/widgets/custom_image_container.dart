import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/blocs.dart';
import '../config/responsive.dart';
import '../generated/l10n.dart';
import '../utils/show_alert.dart';

class CustomImageContainer extends StatefulWidget {
  CustomImageContainer({
    Key? key,
    this.imageUrl,
    this.imageUrlLocal,
    this.onPressed,
  }) : super(key: key);

  String? imageUrl;
  XFile? imageUrlLocal;
  final Function(XFile file)? onPressed;

  @override
  State<CustomImageContainer> createState() => _CustomImageContainerState();
}

class _CustomImageContainerState extends State<CustomImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: (widget.imageUrl == null)
            ? Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  iconSize: Responsive.isMobile(context) ? null : 60,
                  icon: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    ImagePicker _picker = ImagePicker();
                    final XFile? _image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      // imageQuality: 50,
                    );

                    if (_image == null) {
                      ShowAlert.showErrorSnackBar(
                        context,
                        message: S.of(context).image_no_selected,
                      );
                    }

                    if (_image != null) {
                      if (widget.onPressed == null) {
                        BlocProvider.of<OnboardingBloc>(context).add(
                          UpdateUserImages(image: _image),
                        );
                        ShowAlert.showAlertSnackBar(
                          context,
                          message: S.of(context).image_uploading,
                        );
                      } else {
                        widget.onPressed!(_image);
                        setState(() {
                          widget.imageUrl = _image.path;
                          widget.imageUrlLocal = _image;
                        });
                      }
                    }
                  },
                ),
              )
            : widget.imageUrlLocal == null
                ? widget.imageUrl != 'empty'
                    ? Image.network(widget.imageUrl!, fit: BoxFit.cover)
                    : Center(
                        child: Text('Sin imagen'),
                      )
                : Image.file(File(widget.imageUrlLocal!.path),
                    fit: BoxFit.cover),
      ),
    );
  }
}
