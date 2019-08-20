import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mebook/providers/signupController.dart';
import 'package:mebook/utils/margin.dart';
import 'package:mebook/widgets/textFields.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignupController>(builder: (context, counter, _) {
      var controller = Provider.of<SignupController>(context);
      return Scaffold(
        backgroundColor: Color(0xFF262B39),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFF262B39),
          ),
          backgroundColor: Color(0xFF262B39),
          brightness: Brightness.dark,
          elevation: 0,
          title: Image.asset(
            'assets/logo.png',
            scale: 3,
          ),
        ),
        body: Form(
          key: controller.formKey,
          child: Container(
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/signup.png',
                  scale: 4,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hey!',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 22),
                      ),
                      const YMargin(5),
                      Text(
                        'Create an account',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const YMargin(20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Name(controller),
                          const YMargin(19),
                          Email(controller),
                          const YMargin(19),
                          Password(controller),
                          const YMargin(25),
                          !controller.isLoading
                              ? SignUpButton(controller, context)
                              : Container(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(),
                                ),
                          const YMargin(10),
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

class SignUpButton extends StatelessWidget {
  final SignupController controller;
  final BuildContext signupBuildContext;

  const SignUpButton(
    this.controller,
    this.signupBuildContext, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CupertinoButton(
        color: Theme.of(context).primaryColor,
        onPressed: () => controller.postData(signupBuildContext),
        pressedOpacity: 0.7,
        borderRadius: BorderRadius.circular(20),
        child: Text(
          "Sign up",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
