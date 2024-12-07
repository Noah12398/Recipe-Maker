import 'package:flutter/material.dart';
import 'package:recipe/utils/app_styles.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mainbutton( () => null, 'newfile'),
                Row(
                  children: [
                    actionButton(() => null, Icons.file_upload),
                    const SizedBox(width: 8),
                    actionButton(() => null, Icons.folder),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  ElevatedButton mainbutton(Function()? onPressed,String text){
    return ElevatedButton(onPressed: onPressed,style: _buttonStyle(), child: Text(text));
  }
  IconButton actionButton(Function()? onPressed,IconData icon){
    return IconButton(onPressed: onPressed,splashRadius: 20,splashColor: AppTheme.accent, icon: Icon(icon,color:AppTheme.medium,));
  }
  ButtonStyle _buttonStyle(){
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accent,
      foregroundColor: AppTheme.dark,
      disabledBackgroundColor:AppTheme.disabledBackgroundColor,
      disabledForegroundColor:AppTheme.disabledForegroundColor
    );
  }
}