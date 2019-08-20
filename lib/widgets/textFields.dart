import 'package:flutter/material.dart';
import 'package:mebook/providers/uploadController.dart';
import 'package:mebook/utils/validator.dart';

class Email extends StatelessWidget {
  final controller;
  const Email(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.withOpacity(0.1),
      ),
      child: TextFormField(
        // initialValue: 'chiziaruhoma@gmail.com',
        validator: (value) {
          if (isEmail(value)) {
            controller.email = value;

            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Email is Invalid";
          }
        },
        style: TextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Email'),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class Name extends StatelessWidget {
  final controller;
  const Name(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.withOpacity(0.1),
      ),
      child: TextFormField(
        // initialValue: 'chiziaruhoma@gmail.com',
        validator: (value) {
          if (value.isNotEmpty) {
            controller.name = value;

            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Name is Invalid";
          }
        },
        style: TextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Name'),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class Password extends StatelessWidget {
  final controller;
  const Password(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.withOpacity(0.1),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        //initialValue: 'qqqqqq',
        validator: (value) {
          if (value.length > 4) {
            controller.password = value;
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Password is Invalid";
          }
        },
        style: TextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Password'),
        keyboardType: TextInputType.text,
        obscureText: true,
      ),
    );
  }
}

class UploadTitle extends StatelessWidget {
  final text;
  final UploadController controller;
  const UploadTitle(this.controller, {Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueGrey.withOpacity(0.1),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        initialValue: text,
        validator: (value) {
          if (value.isNotEmpty) {
            controller.title = value;
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Title is Invalid";
          }
        },
        style: TextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Title'),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
