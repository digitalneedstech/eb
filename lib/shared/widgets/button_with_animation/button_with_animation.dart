import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/assets/colors/colors.dart';

class ButtonWithAnimationWidget extends StatefulWidget {

  Function callback;
  Color color;
  final bool isLoadingButtonOnPhoneScreenEnabled;
  final String buttonText, buttonSubText;
  double width;
  ButtonWithAnimationWidget(
      {
        required this.callback,
        required this.buttonText,
        this.color=Colors.black,
        this.buttonSubText="",
        required this.isLoadingButtonOnPhoneScreenEnabled,this.width=0});
  ButtonWithAnimationWidgetState createState() =>
      ButtonWithAnimationWidgetState();
}

class ButtonWithAnimationWidgetState extends State<ButtonWithAnimationWidget>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  late double _width;

  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller);
  }

  Widget build(BuildContext context) {
    _width =widget.width==0?double.maxFinite:widget.width;
    return Container(
      key: _globalKey,
      height: 48,
      width: _width,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: widget.isLoadingButtonOnPhoneScreenEnabled
              ? Colors.grey.shade600
              : widget.color,
          onPressed: widget.isLoadingButtonOnPhoneScreenEnabled
              ? null
              : () {
                  _buttonClickAndExecuteCallback(context);
                },
          child: getChild()),
    );
  }

  void _buttonClickAndExecuteCallback(BuildContext context) {
    animateButton();

    setState(() {});
    widget.callback();
  }

  Widget getChild() {
    return widget.isLoadingButtonOnPhoneScreenEnabled
        ? SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  "Please Wait ...",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                )
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.buttonText,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              if (widget.buttonSubText != "")
                Text(
                  widget.buttonSubText,
                  style: TextStyle(
                      fontSize: 8.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                )
            ],
          );
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext!.size!.width;

    _controller.forward();
  }
}
