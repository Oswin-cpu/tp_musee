import 'package:flutter/material.dart';
import 'package:gesmuseum/Models/Musee.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Bloc/MuseeBloc.dart';
import '../Bloc/PaysBloc.dart';
import '../Models/Pays.dart';
import '../main.dart';

class MuseeScreen extends StatefulWidget {
  Musee? musee;
  MuseeScreen({ Key? key , this.musee}) : super(key: key);

  @override
  State<MuseeScreen> createState() => _MuseeScreenState();
}

class _MuseeScreenState extends State<MuseeScreen> {
  TextEditingController txtCodePays = TextEditingController();
  TextEditingController txtNomMus = TextEditingController();
  TextEditingController txtNblivres = TextEditingController();
  bool validate_nom = true;
  bool validate_nblivres = true;
  String saveOrUpdateText = '';
  String codePays = '';
  final MuseeBloc museeBloc = MuseeBloc();
  final PaysBloc paysBloc = PaysBloc();
  List<Pays> listPays = [];

  @override
  void initState() {
    
    if (widget.musee != null){
      txtCodePays.text = widget.musee!.codePays.toString();
      txtNomMus.text = widget.musee!.nomMus.toString();
      txtNblivres.text = widget.musee!.nblivres.toString();
      saveOrUpdateText = "Modifier";
    }

    var list = paysBloc.getPays().then((value){
      listPays = value;
      codePays = listPays[0].codePays;
      print('Liste des pays ${listPays[0].codePays}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, title: Text("Musée"),),
      body: Center(
        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 40,
                      child:Row(
                        children: [
                          const Text("Pays"),
                          const Spacer(),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: false,
                              items: listPays.map((pays) {
                                return DropdownMenuItem<String>(
                                  value: pays.codePays,
                                  child: SizedBox(
                                    width: 150, //expand here
                                    child: Text(
                                      pays.codePays,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  codePays = newValue.toString();
                                });
                              },
                              hint: const SizedBox(
                                width: 150, //and here
                                child: Text(
                                  "Code du pays",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              style: TextStyle(color: Colors.green, decorationColor: Colors.red),
                              value: codePays,
                            ),
                          ),
                        ],
                      ),
                            
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child:TextFormField(
                        controller: txtNomMus,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14,),
                          hintText: 'Nom du musée',
                          errorStyle: const TextStyle(color: Color(0xFFFDA384)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          errorText: validate_nom == false ? 'Le champs est obligatoire ' : null,
                        ),
                        cursorColor: Colors.green,
                      ),                    
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child:
                      TextFormField(
                        controller: txtNblivres,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14,),
                          hintText: "Nombre d'habitants",
                          errorText: validate_nblivres == false ? 'Le champs est obligatoire ' : null,
                          errorStyle: const TextStyle(color: Color(0xFFFDA384)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ), 
                        ),
                        cursorColor: Colors.green,
                      ), 
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () async {
                            save();
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                //side: BorderSide(color: Colors.red)
                              ))),
                          //color: const Color(0xFF390047),
                          child: Text(
                            saveOrUpdateText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                    ),
                    const SizedBox(height: 20,),
                   ],
                ),
      ),
    );
          
  }

   @override
  void save() {
    setState(() {
      txtNomMus.text.trim().isEmpty
          ? validate_nom = false
          : validate_nom = true;
      txtNblivres.text.trim().isEmpty
          ? validate_nblivres = false
          : validate_nblivres = true;
    });
    if (validate_nom && validate_nblivres) {
      Musee musee = Musee(
        numMus: 0,
        nomMus: txtNomMus.text.trim(), 
        nblivres:  int.parse(txtNblivres.text.trim()),
        codePays: codePays,
      );
      if (saveOrUpdateText == 'Enregistrer'){
        museeBloc.addMusee(musee);
      }else{
        museeBloc.updateMusee(musee);
      }
     
    }
  }

  @override
  void delete(Musee musee) {
    var data = museeBloc.getMuseeFromOtherTables(musee.numMus).then((value) {
      print('value $value');
      if (value == false){
        museeBloc.deleteMusee(musee);
      }else{
        Fluttertoast.showToast(
          msg: "Désolé, vous ne pouvez pas supprimer ce musée car il est utilisé pour d'autres enregistrement",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 13.0
        );
      }
    });
  }
}