
import 'package:flutter/cupertino.dart';

class CircleImage extends StatelessWidget {

  String url;
  double size;

  CircleImage({Key? key, required this.url, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image:  DecorationImage(
                fit: BoxFit.cover,
                image:  NetworkImage(
                    url
                )
            )
        )
    );
  }
}
