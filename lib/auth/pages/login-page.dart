// import 'package:finflex/handles/button-widgets/primary-button.dart';
// import 'package:finflex/styles/button-styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class LoginWidget extends StatefulWidget{
//   const LoginWidget({super.key});

//   @override
//   State<StatefulWidget> createState() => _LoginWidgetState();
// }

// class _LoginWidgetState extends State<LoginWidget>{

//   void _someShit(){

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [const Text("Вход"), StyledButton(onPressed: _someShit, text: "Гойда"), 
          
//           Container(
//             padding: Padding.EdgeInsets,
//             decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF4ca7ea), Color(0xFFFFFFFF)],
//                 ),
//                 borderRadius: BorderRadius.circular(20), // Закругленные углы
//             ),
//             child: ElevatedButton(
//                 onPressed: () {
//                   // Ваш код здесь
//                 },
//                 child: Text(
//                   'Нажми меня',
//                   style: TextStyle(fontSize: 18),
//                 ),
//             ),
//             )
          
//           ],
//         ),
//       )
//     );
//   }
// }