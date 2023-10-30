import 'package:flutter/material.dart';
import 'package:food_app/providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class BoundingBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  const BoundingBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: results.map((e) {
        return _renderBox(
          e,
          onTap: (String label) {
            context.read<ProductsProvider>().addProduct(e["detectedClass"]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label added")),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _renderBox(dynamic re, {required Function(String label) onTap}) {
    var x1 = re["rect"]["x"];
    var w1 = re["rect"]["w"];
    var y1 = re["rect"]["y"];
    var h1 = re["rect"]["h"];
    dynamic scaleW, scaleH, x, y, w, h;

    if (screenH / screenW > previewH / previewW) {
      scaleW = screenH / previewH * previewW;
      scaleH = screenH;
      var difW = (scaleW - screenW) / scaleW;
      x = (x1 - difW / 2) * scaleW;
      w = w1 * scaleW;
      if (x1 < difW / 2) w -= (difW / 2 - x1) * scaleW;
      y = y1 * scaleH;
      h = h1 * scaleH;
    } else {
      scaleH = screenW / previewW * previewH;
      scaleW = screenW;
      var difH = (scaleH - screenH) / scaleH;
      x = x1 * scaleW;
      w = w1 * scaleW;
      y = (y1 - difH / 2) * scaleH;
      h = h1 * scaleH;
      if (y1 < difH / 2) h -= (difH / 2 - y1) * scaleH;
    }

    return Positioned(
      left: math.max(0, x),
      top: math.max(0, y),
      width: w,
      height: h,
      child: InkWell(
        onTap: () => onTap(re["detectedClass"]),
        child: Container(
          padding: const EdgeInsets.only(top: 5.0, left: 5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(37, 213, 253, 1.0),
              width: 3.0,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderStrings() {
    double offset = -10;
    return results.map((re) {
      offset = offset + 14;
      return Positioned(
        left: 10,
        top: offset,
        width: screenW,
        height: screenH,
        child: Text(
          "${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
          style: const TextStyle(
            color: Color.fromRGBO(37, 213, 253, 1.0),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _renderKeypoints() {
    var lists = <Widget>[];
    for (var re in results) {
      var list = re["keypoints"].values.map<Widget>((k) {
        var x1 = k["x"];
        var y1 = k["y"];
        dynamic scaleW, scaleH, x, y;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (x1 - difW / 2) * scaleW;
          y = y1 * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = x1 * scaleW;
          y = (y1 - difH / 2) * scaleH;
        }
        return Positioned(
          left: x - 6,
          top: y - 6,
          width: 100,
          height: 12,
          child: Text(
            "● ${k["part"]}",
            style: const TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 12.0,
            ),
          ),
        );
      }).toList();

      lists.addAll(list);
    }

    return lists;
  }
}
