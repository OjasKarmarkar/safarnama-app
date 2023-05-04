import 'package:dropdown_below/dropdown_below.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safarnama/screens/home.dart';
import 'package:safarnama/utils/colors.dart';
import 'package:safarnama/utils/data.dart' as data;
import 'package:safarnama/utils/utils.dart';
import 'package:safarnama/utils/wrapper.dart';
import '../controller/db.dart';

class SelectPrefs extends StatefulWidget {
  const SelectPrefs({Key? key}) : super(key: key);

  @override
  State<SelectPrefs> createState() => _SelectPrefsState();
}

class _SelectPrefsState extends State<SelectPrefs> {
  late List<DropdownMenuItem> _dropdownCities;
  var _selectedCity;
  List<String> cities = [];
  List<String> categories = [];
  List<String> ageGrps = [];
  late List<DropdownMenuItem> _dropdownCategories;
  late List<DropdownMenuItem> _dropdownAgeGrp;
  TextEditingController ageController = new TextEditingController();
  var _selectedCategory;
  var _selectedAgeGrp;

  @override
  void initState() {
    cities = data.Data.places;
    cities.sort();
    categories = data.Data.categories;
    ageGrps = data.Data.ageGrps;
    categories.sort();

    _dropdownCities = buildDropdownTestItems(cities);
    _dropdownCategories = buildDropdownTestItems(categories);
    _dropdownAgeGrp = buildDropdownTestItems(ageGrps);
    super.initState();
  }

  List<DropdownMenuItem> buildDropdownTestItems(List _testList) {
    _testList.sort();
    List<DropdownMenuItem> items = <DropdownMenuItem>[];
    int j = 0;
    for (var i in _testList) {
      j += 1;
      items.add(
        DropdownMenuItem(
          value: j,
          child: Text(i),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    setState(() {
      _selectedCity = selectedTest;
    });
  }

  onChangeDropdownCat(selectedTest) {
    setState(() {
      _selectedCategory = selectedTest;
    });
  }

  onChangeDropdownAgeGrp(selectedTest) {
    setState(() {
      _selectedAgeGrp = selectedTest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return themeWrapper(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("What is your peronality...\nBeach or Mountain ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: darkAccent)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      "Before you start exploring , Help us identify your type by answering simple questions below !",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.grey)),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownBelow(
                    dropdownColor: Colors.white,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accentColor,

                        //width: 5.0,
                      ),
                    ),
                    itemWidth: 320,
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 6, right: 4),
                      child: Icon(
                        FeatherIcons.chevronDown,
                        color: Colors.grey,
                      ),
                    ),
                    itemTextstyle: GoogleFonts.montserrat(color: Colors.black),
                    boxTextstyle: GoogleFonts.montserrat(color: Colors.black),
                    boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                    boxHeight: 50,
                    //  boxWidth: 320,
                    hint: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Icon(FeatherIcons.globe),
                        ),
                        SizedBox(width: 20),
                        Text("City you'd like to visit? ",
                            style: GoogleFonts.montserrat()),
                      ],
                    ),
                    value: _selectedCity,
                    items: _dropdownCities,
                    onChanged: onChangeDropdownTests,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownBelow(
                    dropdownColor: Colors.white,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accentColor,

                        //width: 5.0,
                      ),
                    ),
                    itemWidth: 320,
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 6, right: 4),
                      child: Icon(
                        FeatherIcons.chevronDown,
                        color: Colors.grey,
                      ),
                    ),
                    itemTextstyle: GoogleFonts.montserrat(color: Colors.black),
                    boxTextstyle: GoogleFonts.montserrat(color: Colors.black),
                    boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                    boxHeight: 50,
                    //  boxWidth: 320,
                    hint: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Icon(FeatherIcons.zap),
                        ),
                        SizedBox(width: 20),
                        Text('Kind of place you like..',
                            style: GoogleFonts.montserrat()),
                      ],
                    ),
                    value: _selectedCategory,
                    items: _dropdownCategories,
                    onChanged: onChangeDropdownCat,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownBelow(
                    dropdownColor: Colors.white,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accentColor,

                        //width: 5.0,
                      ),
                    ),
                    itemWidth: 320,
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 6, right: 4),
                      child: Icon(
                        FeatherIcons.chevronDown,
                        color: Colors.grey,
                      ),
                    ),
                    itemTextstyle: GoogleFonts.montserrat(color: Colors.black),
                    boxTextstyle: GoogleFonts.montserrat(color: Colors.black),
                    boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                    boxHeight: 50,
                    //  boxWidth: 320,
                    hint: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Icon(FeatherIcons.zap),
                        ),
                        SizedBox(width: 20),
                        Text('Age Group', style: GoogleFonts.montserrat()),
                      ],
                    ),
                    value: _selectedAgeGrp,
                    items: _dropdownAgeGrp,
                    onChanged: onChangeDropdownAgeGrp,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    //   controller: deviceID,
                    decoration: UiUtils.inputDecoration(
                        context, "Last place you visited", FeatherIcons.code),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: TextButton(
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 44)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(accentColor)),
                        onPressed: () {
                          GetStorage().write("city", cities[_selectedCity - 1]);

                          GetStorage().write(
                              "age",
                              data.Data
                                  .getAgeGrp[ageGrps[_selectedAgeGrp - 1]]);
                          final email = GetStorage().read("uid");
                          final name = GetStorage().read("name");

                          DataBase().setData(
                              email,
                              name,
                              cities[_selectedCity - 1],
                              categories[_selectedCategory - 1],
                              ageGrps[_selectedAgeGrp - 1]);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const HomeScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            //     fontFamily: 'Segoe UI',
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
