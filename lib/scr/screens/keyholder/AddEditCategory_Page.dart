import 'package:digitalkeyholder/scr/config/language.dart';
import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/services/db_service.dart';
import 'package:digitalkeyholder/scr/services/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class AddEditCategoryPage extends StatefulWidget {
  AddEditCategoryPage(
      {Key? key, this.iconColor, this.textColor, this.shadowColor})
      : super(key: key);
  final Color? textColor;
  final Color? iconColor;
  final Color? shadowColor;


  @override
  _AddEditCategoryPageState createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  Categories? categoryModel;
  DBService? dbService;
  var langWords = LangWords();
  final _formKeyCard = GlobalKey<FormBuilderState>();
  final _categoryController = TextEditingController();
  var visibleDatePicker = false;
  var myFormat = DateFormat('d-MM-yyyy');

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    categoryModel = new Categories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //color: Colors.pinkAccent,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.97,
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(5),
                            1: FlexColumnWidth(90)
                          },
                          children: [
                            TableRow(children: [
                              Icon(Icons.label),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Crear categoría',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: widget.textColor),
                                  ),
                                ],
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: FormBuilder(
                    key: _formKeyCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        FormBuilderTextField(
                          controller: _categoryController,
                          name: "keylabel",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: langWords.label),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: langWords.requiredField)
                          ]),
                          maxLength: 20,
                          onChanged: (value) {
                            categoryModel!.category = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NeumorphicFloatingActionButton(
              style: NeumorphicStyle(
                  color: widget.iconColor,
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: widget.shadowColor,
                  depth: 3,
                  intensity: 3),
              tooltip: langWords.cancel,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.cancel,
                  color: widget.textColor,
                  size: 30,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            NeumorphicFloatingActionButton(
              style: NeumorphicStyle(
                  color: widget.iconColor,
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  shadowLightColor: widget.shadowColor,
                  depth: 3,
                  intensity: 3),
              tooltip: langWords.addkey,
              child: Container(
                margin: EdgeInsets.all(2),
                child: Icon(
                  Icons.add_circle,
                  color: widget.textColor,
                  size: 30,
                ),
              ),
              onPressed: () {
                if (_formKeyCard.currentState!.saveAndValidate()) {
                  var getCategory =
                      "SELECT * FROM categorytable WHERE category = "
                      "'${_categoryController.text}'";

                  dbService!.getKeycodeByCategory(getCategory).then((value) {
                    if (value.length == 0) {
                      dbService!.addCategory(categoryModel!).then((value) {
                        EasyLoading.showInfo('Categoría registrada correctamente',
                            maskType: EasyLoadingMaskType.custom,duration: Duration(milliseconds: 2000));
                        _resetForm();
                        Navigator.of(context).pop();
                      });
                    } else {
                      FormHelper.showMessage(
                          context,
                          'QBayes Step Up!',
                          'Ya existe la categoría ${_categoryController.text}',
                          'Ok', () {
                        Navigator.of(context).pop();
                      });
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    _formKeyCard.currentState!.reset();
    _categoryController.clear();
  }
}
