import 'package:flutter/material.dart';
import 'package:p3/config/theme/app_theme.dart';
import 'package:p3/presentation/providers/chat_provider.dart';
import 'package:p3/presentation/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
      child: MaterialApp(
        title: 'Yes no App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColors: 6).theme(),
        home: const ChatScreen(),
      ),
    );
  }
}
