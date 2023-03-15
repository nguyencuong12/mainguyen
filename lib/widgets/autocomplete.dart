import 'package:flutter/material.dart';
import 'package:mainguyen/utils/colorApps.dart';
import 'package:mainguyen/utils/sizeAppbarButton.dart';
import 'package:mainguyen/utils/utilsFunction.dart';
import 'package:mainguyen/widgets/productDetails/productDetails.dart';

import '../utils/textSize.dart';

class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  @override
  String toString() {
    return '$name, $email';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => Object.hash(email, name);
}

class AutoCompleteCustom extends StatelessWidget {
  const AutoCompleteCustom({super.key});
  static const List<User> _userOptions = <User>[
    User(
      name: 'Alice',
      email: 'alice@example.com',
    ),
    User(name: 'Bob', email: 'bob@example.com'),
    User(
      name: 'Charlie',
      email: 'charlie123@gmail.com',
    ),
  ];

  static String _displayStringForOption(User option) => option.name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 60.0,
      child: InputDecorator(
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff0E9447), width: 2.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff0E9447), width: 2.0),
              ),
              labelText: "Tìm kiếm",
              labelStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: TextSize().getLabelTextSize()),
              prefixIcon: Icon(
                Icons.search,
                size: sizeButtonAppBar,
              ),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none),
          child: RawAutocomplete<User>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return _userOptions.where((User option) {
                // Search based on User.toString, which includes both name and
                // email, even though the display string is just the name.
                return option
                    .toString()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            // displayStringForOption: _displayStringForOption,
            displayStringForOption: _displayStringForOption,
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.red,
                        fontSize: TextSize().getNormalTextSize()),
                    hintText: "Nhập sản phẩm cần tìm"),
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  // onFieldSubmitted();
                },
              );
            },
            optionsViewBuilder: (context, onSelected, Iterable<User> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                    elevation: 4.0,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        // height: 300,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            User option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           const ProductDetails()),
                                // );
                                UtilsFunction().closeKeyboard();
                                onSelected(option);
                              },
                              child: Card(
                                child: ListTile(
                                  leading: const FlutterLogo(),
                                  title: Text(_displayStringForOption(option)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )),
              );
            },
          )),
    );
  }
}
