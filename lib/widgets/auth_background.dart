import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({super.key, required this.child}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),

          _HeaderIcon(),
          
          child
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width:double.infinity,
        margin: const EdgeInsets.only( top: 30 ),
        child: const Icon( Icons.person_pin, color: Colors.white, size: 100,),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: const [
          Positioned(top: 150, left: -30,child: _Bubble(),),
          Positioned(top: 50, right: -30,child: _Bubble(),),
          Positioned(top: -50, left: 20,child: _Bubble(),),
          Positioned(bottom: -50, left: 11,child: _Bubble(),),
          Positioned(bottom: 50, right: 50,child: _Bubble(),),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(25,104,68, 1),
        Color.fromRGBO(25,104,68, 1),
      ]
    )
  );
}

class _Bubble extends StatelessWidget {
  const _Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}