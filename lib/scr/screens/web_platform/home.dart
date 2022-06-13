import 'package:digitalkeyholder/scr/config/themes.dart';
import 'package:digitalkeyholder/scr/screens/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var itemsClient = ['Asic', 'Claro'];
  var itemsProject = ['Base de datos', 'Administración de S.O'];
  var itemsCases = [
    'Ejecución Scrip Oracle',
    'Ampliar TABLESPACE',
    'Logs base de datos Oracle Windows',
    'Comando CMD Windows',
    'Liberar espacio SQL',
    'Ejecutar Script SQL'
  ];
  var scriptType = ['Batch', 'Powershell'];
  var _showProject = false;
  var _showCases = false;
  var _showForm = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                FormBuilderDropdown<String>(
                  //key: keyCategory,
                  //enabled: _enableField,
                  name: 'client',
                  //initialValue: items,
                  decoration: InputDecoration(
                      labelText: 'Cliente',
                      prefixIcon: Icon(Icons.house,
                          color: Colors.deepPurpleAccent, size: 18)),
                  hint: Text('Seleccionar cliente'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'Cliente requerido')
                  ]),
                  items: itemsClient.map((String items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _showProject = true;
                      });
                    }
                  },
                ),
                Visibility(
                  visible: _showProject,
                  child: FormBuilderDropdown<String>(
                    //key: keyCategory,
                    //enabled: _enableField,
                    name: 'project',
                    //initialValue: items,
                    decoration: InputDecoration(
                        labelText: 'Proyecto',
                        prefixIcon: Icon(Icons.source,
                            color: Colors.deepPurpleAccent, size: 18)),
                    hint: Text('Seleccionar proyecto'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Proyecto requerido')
                    ]),
                    items: itemsProject.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _showCases = true;
                        });
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: _showCases,
                  child: FormBuilderDropdown<String>(
                    //key: keyCategory,
                    //enabled: _enableField,
                    name: 'cases',
                    //initialValue: items,
                    decoration: InputDecoration(
                        labelText: 'Casos',
                        prefixIcon: Icon(Icons.remove_from_queue_sharp,
                            color: Colors.deepPurpleAccent, size: 18)),
                    hint: Text('Seleccionar caso'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Proyecto requerido')
                    ]),
                    items: itemsCases.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _showForm = true;
                        });
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: _showForm,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.750,
                    color: Colors.black54,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Formulario'),
                        FormBuilderTextField(
                          //key: keyUserName,
                          //controller: _keyUserNameController,
                          name: "userName",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: 'Ip Servidor'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido')
                          ]),
                          onChanged: (value) {},
                        ),
                        FormBuilderTextField(
                          //key: keyUserName,
                          //controller: _keyUserNameController,
                          name: "userName",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: 'Usuario'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido')
                          ]),
                          onChanged: (value) {},
                        ),
                        PasswordField(
                          //fieldKey: keyPassword,
                          //controller: _keyPassController,
                          //helperText: 'No más de 15 caracteres.',
                          labelText: 'Contraseña',
                          validator: FormBuilderValidators.required(
                              errorText: 'Contraseña requerida'),
                          onFieldChange: (value) {
                            //_keycodeModel!.password = value;
                          },
                        ),
                        FormBuilderDropdown<String>(
                          //key: keyCategory,
                          //enabled: _enableField,
                          name: 'cases',
                          //initialValue: items,
                          decoration: InputDecoration(
                              labelText: 'Tipo de script',
                              prefixIcon: Icon(Icons.vpn_key_outlined,
                                  color: Colors.deepPurpleAccent, size: 18)),
                          hint: Text('Tipo de script'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido')
                          ]),
                          items: scriptType.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _showForm = true;
                              });
                            }
                          },
                        ),
                        FormBuilderTextField(
                          //key: keyUserName,
                          //controller: _keyUserNameController,
                          name: "userName",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.label,
                                  color: Colors.deepPurpleAccent, size: 18),
                              labelText: 'Script'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido')
                          ]),
                          onChanged: (value) {},
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
    );
  }
}
