import 'package:flutter/material.dart';

class ProfileExpandDialog extends StatelessWidget {

   ProfileExpandDialog({Key? key}) : super(key: key);

  late ThemeData _theme;

   final String _profileUrl = 'https://assets.pikiran-rakyat.com/crop/0x159:1080x864/x/photo/2022/04/03/941016597.jpeg';

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: _theme.colorScheme.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Photo 😍🥹',
                            style: _theme.textTheme.headline4,
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(0),
                            icon: Icon(Icons.close, color: _theme.colorScheme.onPrimary,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16,),
                      Image.network(_profileUrl),
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }
}
