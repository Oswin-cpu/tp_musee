import 'package:flutter/material.dart';
import 'package:gesmuseum/Screens/ListePays.dart';

import '../Models/Pays.dart';
import '../main.dart';

class PaysScreen extends StatefulWidget {
  
  Pays? pays;
  PaysScreen({ Key? key, this.pays}) : super(key: key);

  @override
  State<PaysScreen> createState() => _PaysScreenState();
}

class _PaysScreenState extends State<PaysScreen> {
  TextEditingController txtCodePays = TextEditingController();
  TextEditingController txtNbHabitant = TextEditingController();
  bool validate_code = true;
  bool validate_nbhabitant = true;

  @override
  void initState() {
    
    if (widget.pays != null){
      txtCodePays.text = widget.pays!.codePays.toString();
      txtNbHabitant.text = widget.pays!.nbhabitant.toString();
      print('eeeee${widget.pays!.codePays.toString()}');
    }
      
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 40,
              child:TextFormField(
                controller: txtCodePays,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontSize: 14,),
                  hintText: 'Code du pays',
                  errorStyle: const TextStyle(color: Color(0xFFFDA384)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  errorText: validate_code == false ? 'Le champs est obligatoire ' : null,
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
                controller: txtNbHabitant,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontSize: 14,),
                  hintText: "Nombre d'habitants",
                  errorText: validate_nbhabitant == false ? 'Le champs est obligatoire ' : null,
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
                    setState(() {
                      txtCodePays.text.trim().isEmpty
                          ? validate_code = false
                          : validate_code = true;
                      txtNbHabitant.text.trim().isEmpty
                          ? validate_nbhabitant = false
                          : validate_nbhabitant = true;
                    });
                    if (validate_code && validate_nbhabitant) {
                      Pays pays = Pays(
                        codePays: txtCodePays.text.trim(), 
                        nbhabitant: int.parse(txtNbHabitant.text.trim()),
                      );
                      //await MuseeDatabase.instance.insertPays(pays);
                      Navigator.pop(context,true);
                    }
                    
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
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
            ),
                      
          ],
        ),
      ),
    );
  }
}