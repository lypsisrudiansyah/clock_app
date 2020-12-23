import 'package:flutter/material.dart';

class ModalHelper {
  static ModalHelper instance = ModalHelper();

  modalKeluar(BuildContext context, {String modalTitle, Function onClick}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Spacer(),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      modalTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        FlatButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 30,
                          ),
                          color: Colors.red[400],
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text("No"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FlatButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 30,
                          ),
                          color: Colors.green[400],
                          textColor: Colors.white,
                          onPressed: () => onClick != null
                              ? onClick()
                              : Navigator.pop(context),
                          icon: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text("Yes"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.orange[400],
                      minRadius: 30,
                      maxRadius: 50,
                      child: Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}