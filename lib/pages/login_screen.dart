import 'package:bkash/enums/home_menu.dart';
import 'package:bkash/widgets/cash_in_widget.dart';
import 'package:bkash/widgets/purpose_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sms_receiver.dart';
import '../styles/AppTheme.dart';
import '../widgets/dialog_animation.dart';
import '../widgets/dialog_widget.dart';
import 'inbox_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final cashProvider = Provider.of<SMSReceiverProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'THRIFT Login',
            style: AppTheme.actionBarText,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                          child: Text(
                            "Name",
                            style: AppTheme.ntitleText,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
                            child: TextField(
                              decoration: InputDecoration.collapsed(
                                  hintText: "Enter name",
                                  hintStyle: AppTheme.hintText),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Icon(
                            Icons.person,
                            color: Colors.black45,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                          child: Text(
                            "Phone",
                            style: AppTheme.ntitleText,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
                            child: TextField(
                              decoration: InputDecoration.collapsed(
                                  hintText: "Enter phone",
                                  hintStyle: AppTheme.hintText),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.black45,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: DropdownButton<String>(
                    value: cashProvider.selectedService,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                    elevation: 0,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? value) async {
                      await cashProvider.onServiceChanged(
                          val: value ?? services.first);
                    },
                    items:
                        services.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: ColoredBox(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value,
                                style: AppTheme.ntitleText,
                              ),
                            )),
                      );
                    }).toList(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InboxPage(
                                title: 'Summary',
                              )));
                },
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 4, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/priyo.jpg",
                              height: 40,
                              width: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                              child: Text(
                                "Submit",
                                style: AppTheme.priyoText,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
