import 'package:flutter/material.dart';
import 'package:weather/view/search/search_widgets.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: SearchWidgets().appBar(isDark),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 80),
            SearchWidgets().textField(controller, context, isDark),
            SearchWidgets().cityInformation(isDark),
          ],
        ),
      ),
    );
  }
}
