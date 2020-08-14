import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:sauda_task/Screens/ResultScreen/result_screen.dart';
import 'package:sauda_task/constants.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home Screen Id';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String input;
  bool showButton = false;
  String result = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    handleDynamicLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sauda Task B'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ///Placeholder for aligning elements automatically
              SizedBox(),

              ///Element containing textfield & button
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //TextField
                    Container(
                      margin: EdgeInsets.all(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.text_format),
                            labelText: 'Message',
                            hintText: 'Enter a message'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        validator: (input) {
                          if (input.isEmpty)
                            return 'Please enter a message to display';
                          return null;
                        },
                        onSaved: (value) => input = value,
                      ),
                    ),

                    //Button
                    RaisedButton(
                      onPressed: sentLink,
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.send), Text('Sent Message')],
                      ),
                    )
                  ],
                ),
              ),

              ///Button to show message from deep Link
              showButton
                  ? RaisedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                    message: result,
                                  ))),
                      child: Text('See Message'),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  //Handling Dynamic Link
  void handleDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    //After Installing App from Deep link
    _handleLink(data);

    //Pulling app to foreground from Deep Link
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLinkData) async => _handleLink(dynamicLinkData),
        onError: (OnLinkErrorException e) async =>
            print('Error loading dynamic link | ${e.message}'));
  }

  //Part of Handling Dynamic Link
  void _handleLink(PendingDynamicLinkData _data) {
    final Uri deepLink = _data?.link;

    if (deepLink != null) result = deepLink.pathSegments[0];

    if (result != '') {
      setState(() {
        showButton = true;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultScreen(
                    message: result,
                  )));
    }
  }

  //Creating dynamic link
  sentLink() async {
    //Validating Form
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String message = kLINK + input;
      final DynamicLinkParameters parameters = DynamicLinkParameters(
          uriPrefix: kDEEP_LINK,
          link: Uri.parse(message),
          androidParameters: AndroidParameters(packageName: kPKGNAME));
      final Uri dynamicUrl = await parameters.buildUrl();
      Share.share(kEND_USER_MESSAGE + dynamicUrl.toString());
    }
  }
}
