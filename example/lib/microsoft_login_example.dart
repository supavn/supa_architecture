import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/blocs/authentication/authentication_bloc.dart';

import 'pages/login_screen.dart';

class MicrosoftLoginExample extends StatefulWidget {
  const MicrosoftLoginExample({super.key});

  @override
  State<MicrosoftLoginExample> createState() => _MicrosoftLoginExampleState();
}

class _MicrosoftLoginExampleState extends State<MicrosoftLoginExample> {
  late AuthenticationBloc _authBloc;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthenticationBloc();

    // Configure Azure AD OAuth with the navigator key and redirect URI
    _authBloc.configureAzureAD(
      _navigatorKey,
      dotenv.env['AZURE_REDIRECT_URI'] ??
          'https://login.microsoftonline.com/common/oauth2/nativeclient',
    );

    _authBloc.handleInitialize();
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microsoft Login Example',
      navigatorKey: _navigatorKey,
      home: BlocProvider.value(
        value: _authBloc,
        child: const LoginScreen(),
      ),
    );
  }
}
