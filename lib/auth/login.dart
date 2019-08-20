import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mebook/auth/signup.dart';
import 'package:mebook/providers/loginController.dart';
import 'package:mebook/utils/margin.dart';
import 'package:mebook/widgets/textFields.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(builder: (context, counter, _) {
      var controller = Provider.of<LoginController>(context);
      return Scaffold(
        backgroundColor: Color(0xFF262B39),
        body: Form(
          key: controller.formKey,
          child: Container(
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  scale: 3,
                ),
                Image.asset(
                  'assets/login3.png',
                  scale: 4,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 22),
                      ),
                      const YMargin(5),
                      Text(
                        'Please Sign in',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const YMargin(30),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Email(controller),
                          const YMargin(25),
                          Password(controller),
                          const YMargin(34),
                          !controller.isLoading
                              ? SignInButton(controller, context)
                              : Container(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(),
                                ),
                          const YMargin(16),
                          !controller.isLoading
                              ? Column(children: <Widget>[
                                  GoogleSignInButton(controller, context),
                                  SignUpButton(controller)
                                ])
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
                const YMargin(30),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class SignInButton extends StatelessWidget {
  final LoginController controller;
  final BuildContext loginContext;

  const SignInButton(
    this.controller,
    this.loginContext, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CupertinoButton(
        color: Theme.of(context).primaryColor,
        onPressed: () => controller.postData(loginContext),
        pressedOpacity: 0.7,
        borderRadius: BorderRadius.circular(20),
        child: Text(
          "Sign in",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final LoginController controller;

  const SignUpButton(
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CupertinoButton(
        color: Colors.transparent,
        pressedOpacity: 0.7,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Text(
          "Create an Account",
          style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final LoginController controller;

  final BuildContext loginContext;

  const GoogleSignInButton(
    this.controller,
    this.loginContext, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CupertinoButton(
        color: Colors.white,
        onPressed: () {
          return controller.googleSignIn(loginContext);
        },
        pressedOpacity: 0.7,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/google.png',
              scale: 4,
            ),
            const XMargin(10),
            Text(
              "Sign in with Google",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF262B39),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
