import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/core/localization/localization_helper.dart';
import 'package:instagram_clone/core/localization/localization_provider.dart';

class DirectionalityWrapper extends StatelessWidget {
  final Widget child;

  const DirectionalityWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, provider, _) {
        final isRtl = LocalizationHelper.isRtl(context);
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child,
        );
      },
    );
  }
}
