import 'dart:math';
import 'dart:ui';
import 'package:BWO/Effects/FoamWaterEffect.dart';
import 'package:BWO/Effects/WaterStarsEffect.dart';
import 'package:BWO/Map/tile.dart';
import 'package:BWO/game_controller.dart';
import 'package:flutter/material.dart';

class Ground extends Tile {
  WaterStarsEffect waterStarsEffect;
  FoamWaterEffect foamWaterEffect = new FoamWaterEffect();

  Ground(int posX, int posY, int height, int size, Color color)
      : super(posX, posY, height, size, color) {
    var tileColor = getTileDetailsBasedOnHight(this.height);
    boxPaint.color = color != null ? color : tileColor;

    waterStarsEffect = WaterStarsEffect(boxRect);
  }

  void draw(Canvas c) {
    if (height >= 108 && height <= 110) {
      boxPaint.color = foamWaterEffect.getFoamColor(height, posX, posY);//Colors.blue[200];
    }
    c.drawRect(boxRect, boxPaint);

    if (height < 107) {
      waterStarsEffect.blinkWaterEffect(c);
    }
  }

  Color getTileDetailsBasedOnHight(int heightLvl) {
    this.height = heightLvl;
    var green = 255 - heightLvl;
    if (heightLvl < 50) {
      return Colors.blue[700];
    } else if (heightLvl < 75) {
      return Colors.blue[600];
    } else if (heightLvl < 95) {
      return Colors.blue;
    } else if (heightLvl < 110) {
      return Colors.blue[400];
    } else if (heightLvl < 117) {
      return Colors.amber[200];
    } else if (heightLvl < 140) {
      return Color.fromRGBO(80, green, 30, 1);
    } else if (heightLvl < 160) {
      return Color.fromRGBO(40, green, 30, 1);
    } else if (heightLvl < 170) {
      return Color.fromRGBO(40, green, 40, 1);
    } else if (heightLvl < 195) {
      return Color.fromRGBO(30, green, 40, 1);
    } else {
      return Color.fromRGBO(
          heightLvl - 130, heightLvl - 130, heightLvl - 130, 1);
    }
  }

  
}
