// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

class ImageStack extends StatelessWidget {
  final List<String> imageList;
  final double? imageRadius;
  final int? imageCount;
  final int totalCount;
  final double? imageBorderWidth;
  final Color? imageBorderColor;
  final Color? extraCountBorderColor;
  final TextStyle extraCountTextStyle;
  final Color backgroundColor;
  final ImageSourceStack? imageSource;
  final List<Widget> children;
  final double? widgetRadius;
  final int? widgetCount;
  final double? widgetBorderWidth;
  final Color? widgetBorderColor;
  final List<ImageProvider> providers;
  final bool showTotalCount;

  ImageStack({
    super.key,
    required this.imageList,
    this.imageRadius = 25,
    this.imageCount = 3,
    required this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.imageSource = ImageSourceStack.network,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.extraCountBorderColor,
    this.backgroundColor = Colors.white,
  })  : children = [],
        providers = [],
        widgetBorderColor = null,
        widgetBorderWidth = null,
        widgetCount = null,
        widgetRadius = null;

  ImageStack.widgets({
    super.key,
    required this.children,
    this.widgetRadius = 25,
    this.widgetCount = 3,
    required this.totalCount,
    this.widgetBorderWidth = 2,
    Color this.widgetBorderColor = Colors.grey,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.extraCountBorderColor,
    this.backgroundColor = Colors.white,
  })  : imageList = [],
        providers = [],
        imageBorderColor = widgetBorderColor,
        imageBorderWidth = widgetBorderWidth,
        imageCount = widgetCount,
        imageRadius = widgetRadius,
        imageSource = null;

  ImageStack.providers({
    super.key,
    required this.providers,
    this.imageRadius = 25,
    this.imageCount = 3,
    required this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.extraCountBorderColor,
    this.backgroundColor = Colors.white,
  })  : imageList = [],
        children = [],
        widgetBorderColor = null,
        widgetBorderWidth = null,
        widgetCount = null,
        widgetRadius = null,
        imageSource = null;

  @override
  Widget build(BuildContext context) {
    List<String> items = [];
    items.addAll(imageList);
    int size = min(imageCount!, items.length);
    List<Widget> widgetList = items.sublist(0, size).asMap().map((index, value) => MapEntry(index, Padding(padding: EdgeInsets.only(left: 0.7 * imageRadius! * index), child: circularItem(value, index)))).values.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        widgetList.isNotEmpty
            ? Stack(
                clipBehavior: Clip.none,
                children: widgetList,
              )
            : const SizedBox(),
        Container(
            child: showTotalCount && totalCount - widgetList.length > 0
                ? Container(
                    padding: const EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        "+${totalCount - widgetList.length}",
                        textAlign: TextAlign.center,
                        style: extraCountTextStyle,
                      ),
                    ),
                  )
                : const SizedBox()),
      ],
    );
  }

  Widget circularItem(dynamic item, int index) {
    if (item is ImageProvider) {
      return circularProviders(item);
    } else if (item is Widget) {
      return circularWidget(item);
    } else if (item is String) {
        return circularImage(item);
    }
    return Container();
  }

  circularWidget(Widget widget) {
    return Container(
      height: widgetRadius,
      width: widgetRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: widgetBorderColor!,
          width: widgetBorderWidth!,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widgetRadius!),
        child: widget,
      ),
    );
  }

  Widget circularImage(String imageUrl) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: imageBorderColor!,
          width: imageBorderWidth!,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget circularStackImage(String imageUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: imageRadius,
          width: imageRadius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: imageBorderColor!,
              width: imageBorderWidth!,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(minWidth: imageRadius! - imageBorderWidth!),
          padding: const EdgeInsets.all(3),
          height: (imageRadius! - imageBorderWidth!),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(imageRadius! - imageBorderWidth!),
              border: Border.all(color: extraCountBorderColor ?? imageBorderColor!, width: imageBorderWidth!),
              color: Colors.black26.withOpacity(0.3)),
          child: Center(
            child: Text(
              "+${totalCount - min(imageCount!, imageList.length)}",
              textAlign: TextAlign.center,
              style: extraCountTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget circularProviders(ImageProvider imageProvider) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: imageBorderColor!,
          width: imageBorderWidth!,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  imageProvider(imageUrl) {
    if (imageSource == ImageSourceStack.asset) {
      return AssetImage(imageUrl);
    } else if (imageSource == ImageSourceStack.file) {
      return FileImage(imageUrl);
    }
    else if (imageSource == ImageSourceStack.offline) {
      return const AssetImage("assets/general/profile_default.png");
    }
    return NetworkImage(imageUrl);
  }
}

enum ImageSourceStack { asset, network, file, offline }
