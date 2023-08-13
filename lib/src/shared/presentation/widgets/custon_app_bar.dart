import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';

import '../../../features/theme/presentation/cubit/theme_cubit.dart';
import '../../app/blocs/app/app_bloc.dart';

class CustomAppBar extends StatelessWidget
    with UiLoggy
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      actions: [
        IconButton(
          key: const Key('custmomAppBarSwitchThemeIconButton'),
          onPressed: () {
            ThemeMode themeMode = context.read<AppBloc>().state.themeMode;
            context.read<ThemeCubit>().switchTheme(themeMode);
            // loggy.debug("called cubit");
          },
          icon: Icon(context.read<AppBloc>().state.themeMode == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
