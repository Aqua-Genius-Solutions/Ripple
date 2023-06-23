import 'dart:math';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';

class CustomFlareController extends FlareControls {
  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
  }

  @override
  void onCompleted(String animationName) {
    playRandomAnimation();
  }

  void playRandomAnimation() {
    List<String> animationNames = ['animation1', 'animation2', 'animation3'];
    String randomAnimation = animationNames[Random().nextInt(animationNames.length)];
    play(randomAnimation);
  }
}