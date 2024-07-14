import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/core/ui_kit/word_view/stripe_list_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}



///
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: const Color(0xFF352839),
          borderRadius: BorderRadius.circular(20), // Change the value to adjust the roundness
        ),

        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: heading()
              ),

              const Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 2.0),
                child: Divider(
                  color: AppColors.text,
                  height: 0,
                  thickness: 0.2,
                ),
              ),

              list()
            ]
          ),
        )
      ),
    );
  }


  ///
  Widget heading() {
    return Row(
      children: [ 
        const Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StripeListWidget(
              path: 'German/Science Shit Ton/Computer',
              delimiter: '/',
            ),
          ),
        ),
    
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.navigation,
            ),
            onPressed: () {},
          ),
        ),
    
        IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.navigation,
          ),
          onPressed: () {},
        )
      ]
    );
  }


  ///
  Widget list() {
    List<String> words = ['Word1' , 'Word2' , 'Word3' , 'Word4' , 'Word5' , 'Word5' , 'Word6' , 'Word7', 'Word8', 'Word9'];

    return Expanded(
      child: ListView.builder(
        itemCount: words.length * 2,
        itemBuilder: (context, index) => index.isEven ? 
        _buildFolderTile(context, words[index ~/ 2]) : 
        const Padding(
          padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 0.0),
          child: Divider(
            color: AppColors.text,
            height: 0,
            thickness: 0.1,
          ),
        ),
      ),
    );
  }


  ///
  Widget _buildFolderTile(BuildContext context, String word) {
    return ListTile(
      title: Text(
        word,
        style: const TextStyle(
          color: AppColors.text, // Replace with your desired color
        ),
      ),
      subtitle: Text(
        word,
        style: const TextStyle(
          color: AppColors.text, // Replace with your desired color
        ),
      ),
    );
  }
}