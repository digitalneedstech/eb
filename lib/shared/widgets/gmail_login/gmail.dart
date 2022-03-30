import 'package:flutter/material.dart';

class GmailWidget extends StatefulWidget {
  Function callBack;
  GmailWidget({required this.callBack});
  GmailWidgetState createState() => GmailWidgetState();
}

class GmailWidgetState extends State<GmailWidget> {
  late bool _isClickable;
  void initState() {
    super.initState;
    _isClickable = true;
  }

  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFFD34B3E),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          highlightColor: Colors.transparent,
          onTap: _isClickable
              ? () async {
                  widget.callBack();
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign In With Google",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              /*isLoggedIn
                  ? CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.green),
              )
                  : Container()*/
            ],
          ),
        ),
      ),
    );
  }
}
