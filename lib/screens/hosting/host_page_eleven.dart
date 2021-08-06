import 'package:aloquei_app/screens/hosting/components/host_bottombar.dart';
import 'package:aloquei_app/screens/hosting/components/host_select_menu_eleven.dart';
import 'package:aloquei_app/screens/hosting/components/host_top_menu_gradient.dart';
import 'package:flutter/material.dart';

class HostPageEleven extends StatelessWidget {
  const HostPageEleven({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: HostBottomBar(
          text: 'Salvar sua listagem',
          color: Colors.pink,
          onPressedBack: () {
            Navigator.pop(context);
          },
          onpressedNext: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HostPageEleven()),
            );
          },
        ),
        body: Column(
          children: [
            HostTopMenuGradient(
              color1: 0xFF6b26c1,
              color2: 0xFF6d29be,
              text1: 'Revise a sua listagem!',
              text2: 'confirme seus dados',
            ),
            HostSelectMenuEleven(
              onpressed: () {},
            )
          ],
        ));
  }
}
