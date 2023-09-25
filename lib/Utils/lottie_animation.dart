import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class LoadingOnly extends StatelessWidget {
  const LoadingOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child:  Lottie.asset('assets/loading.json'),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child:  Lottie.asset('assets/pencil_Loading.json'),
    );
  }
}


class LoadingHome extends StatelessWidget {
  const LoadingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child:  Lottie.asset('assets/Home.json'),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height /2,
            width: MediaQuery.of(context).size.width,
            child:  Lottie.asset('assets/Home.json'),
          ),
          RichText(
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Engineered By:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: '  Muhammad Dawood Zafar',
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}