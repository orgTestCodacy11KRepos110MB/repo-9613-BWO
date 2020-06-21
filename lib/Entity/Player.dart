import 'dart:ui';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Player/PlayerActions.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/Frame.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

class Player extends Entity {
  TextConfig config = TextConfig(fontSize: 12.0, color: Colors.white);

  double xSpeed = 0;
  double ySpeed = 0;

  int accelerationSpeed = 3;
  double maxAngle = 5;
  double speedMultiplier = .7;

  double defaultY = 6.9; //angle standing up

  Paint boxPaint = Paint();
  Rect boxRect;

  SpriteController spriteController;

  double x = 0, y = 0;

  int worldSize;

  PlayerActions _playerActions;

  Player(int posX, int posY, this.worldSize) : super(posX, posY) {
    _playerActions = PlayerActions(this);

    accelerometerEvents.listen((AccelerometerEvent event) {
      //defaultY = defaultY == 0 ? event.y : defaultY;

      xSpeed =
          (event.x * accelerationSpeed).clamp(-maxAngle, maxAngle).toDouble() *
              speedMultiplier;
      ySpeed = ((event.y - defaultY) * -accelerationSpeed)
              .clamp(-maxAngle, maxAngle)
              .toDouble() *
          speedMultiplier;

      if (ySpeed.abs() + xSpeed.abs() < 0.6 ||
          _playerActions.isDoingAction) {
        xSpeed = 0;
        ySpeed = 0;
      }
    });

    loadSprites();
  }

  void draw(Canvas c) {
    x -= xSpeed;
    y -= ySpeed;

    var maxWalkSpeed = (maxAngle * speedMultiplier);
    var walkSpeed = max(xSpeed.abs(), ySpeed.abs());
    var deltaSpeed = (walkSpeed / maxWalkSpeed);
    var animSpeed = 0.07 + (0.1 - (deltaSpeed * 0.1));
    var playAnim = animSpeed < .17;
    //print(animSpeed);

    if (spriteController != null) {
      spriteController.draw(
          c, x, y, xSpeed, ySpeed, animSpeed, playAnim); //0.125 = 12fps
    }

    config.render(c, "Player", Position(x + 4, y - 45),
        anchor: Anchor.bottomCenter);

    posX = x ~/ worldSize;
    posY = y ~/ worldSize;
  }

  void update(MapController map) {
    _playerActions.interactWithTrees(map, posX, posY);
  }

  void setDirection(Offset target){
    spriteController.setDirection(target, Offset(posX.toDouble(), posY.toDouble()));
  }

  void loadSprites() async {
    SpriteBatch _forward =
        await SpriteBatch.withAsset('human/walk_forward.png');
    SpriteBatch _backward =
        await SpriteBatch.withAsset('human/walk_backward.png');
    SpriteBatch _left = await SpriteBatch.withAsset('human/walk_left.png');
    SpriteBatch _right = await SpriteBatch.withAsset('human/walk_right.png');
    SpriteBatch _forward_left =
        await SpriteBatch.withAsset('human/walk_left_down.png');
    SpriteBatch _forward_right =
        await SpriteBatch.withAsset('human/walk_right_down.png');
    SpriteBatch _backward_left =
        await SpriteBatch.withAsset('human/walk_top_left.png');
    SpriteBatch _backward_right =
        await SpriteBatch.withAsset('human/walk_top_right.png');

    Rect _viewPort = Rect.fromLTWH(0, 0, 10, 10);
    Offset _pivot = Offset(4, 7);
    double _scale = 7;
    Offset _gradeSize = Offset(2, 2);
    int framesCount = 0;

    spriteController = new SpriteController(
        _forward,
        _backward,
        _left,
        _right,
        _forward_left,
        _forward_right,
        _backward_left,
        _backward_right,
        _viewPort,
        _pivot,
        _scale,
        _gradeSize,
        framesCount);
    
  }
}