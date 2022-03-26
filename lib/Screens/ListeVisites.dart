import 'package:flutter/material.dart';
import 'package:gesmuseum/Bloc/MomentBloc.dart';
import 'package:gesmuseum/Bloc/VisiterBloc.dart';
import 'package:gesmuseum/Models/Moment.dart';

import '../Bloc/MuseeBloc.dart';
import '../Models/Musee.dart';
import '../Models/Visiter.dart';
import '../main.dart';

class ListeVisites extends StatefulWidget {
  const ListeVisites({ Key? key }) : super(key: key);

  @override
  State<ListeVisites> createState() => _ListeVisitesState();
}

class _ListeVisitesState extends State<ListeVisites> implements AlertDialogCallback{
  TextEditingController txtNbVisiteurs = TextEditingController();
  bool validate_nbVisiteurs = true;
  String saveOrUpdateText = '';
  int museeNum = 0;
  String museeNom = '';
  Musee? museeSelected;
  final VisiterBloc visiterBloc= VisiterBloc();
  final MomentBloc momentBloc = MomentBloc();
  final MuseeBloc museeBloc = MuseeBloc();

  List<Musee> listMusee = [];
  List<Moment> listMoment = [];
  late dynamic selectedVisite ;
  String jour = "";
  bool enableMusee = true;
  bool enableMoment = true;

  @override
  void initState() {
    var listMu = museeBloc.getMusees().then((value){
      listMusee = value;
      museeSelected = listMusee[0];
      museeNum = listMusee[0].numMus;
      museeNom = listMusee[0].nomMus;
      print('Liste des Musées ${value}');
    });
    
    var listMo = momentBloc.getMoment().then((value){
      listMoment = value;
      jour = listMoment[0].jour;
      
    });

    super.initState();

  }
  @override
  void dispose(){
    super.dispose();
  }

  

  Widget getVisiteWidget(AsyncSnapshot<List> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  highlightColor:Colors.green,
                  onTap: () {
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index]['nomMus'].toString(),
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                            ),
                            Text(snapshot.data![index]['jour'].toString(), style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),),
                            Visibility(
                              visible: false,
                              child: Text(snapshot.data![index]['numMus'].toString(),
                                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 5,)
                          ],
                        ),
                        subtitle: Text(snapshot.data![index]['nbvisiteurs'].toString(),style: const TextStyle(fontSize: 12.0),),
                        trailing: Wrap(
                          children: [
                            IconButton(icon: const Icon(
                              Icons.edit, size: 20,
                            ), color: Colors.black,
                            onPressed: () {

                              setState(() {
                                selectedVisite = snapshot.data![index];
                                txtNbVisiteurs.text = snapshot.data![index]['nbvisiteurs'].toString();
                                museeNum = int.parse(snapshot.data![index]['numMus'].toString());
                                jour = snapshot.data![index]['jour'].toString();
                                enableMoment = false;
                                enableMusee = false;
                                saveOrUpdateText = 'Modifier';
                              });
                              _showDialog();
                              },),

                              IconButton(icon: const Icon(
                              Icons.delete, size: 20,
                            ), color: Colors.red,
                            onPressed: () {
                              setState(() {
                                selectedVisite = snapshot.data![index];
                              });
                              _showDialogConfirmation();
                            },),
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  ),
                ),
              );
            },
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Aucune visite n'a encore été enregistrée", style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                const SizedBox(height: 5,),
                Text("Cliquez sur le bouton du bas pour enregistrer une visite", style: TextStyle(color: Colors.grey[600]),),
              ],
            ),
          );

    }else{
      return const Center(child: CircularProgressIndicator());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                  height: 35,
                  width: double.infinity,
                  color: const Color(0xFFE6E6E6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text('Liste des visites', style: TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      
                    ],
                  ),
                ),
          ),
          
          StreamBuilder(
            stream: visiterBloc.visites,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              return getVisiteWidget(snapshot);
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            txtNbVisiteurs.text = "";
            enableMoment = true;
            enableMusee = true;
            saveOrUpdateText = 'Enregistrer';
            // enabledTxt = true;
          });
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Visites"),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 40,
                      child:Row(
                        children: [
                          const Text("Musée"),
                          const Spacer(),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<Musee>(
                              isExpanded: false,
                              items: listMusee.map((Musee musee) {
                                return DropdownMenuItem<Musee>(
                                  value: musee,
                                  child: SizedBox(
                                    width: 150, //expand here
                                    child: Text(
                                      musee.nomMus,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: enableMusee ? (newValue) {
                                setState(() {
                                  museeNum = newValue!.numMus;
                                  museeNom = newValue.nomMus.toString();
                                });
                                // onPaysChange(newValue.toString());
                              }
                              : null,
                              hint: const SizedBox(
                                width: 150, //and here
                                child: Text(
                                  "Musée",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              style: TextStyle(color: Colors.green, decorationColor: Colors.red),
                              value: museeSelected,
                            ),
                          ),
                        ],
                      ),
                            
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child:Row(
                        children: [
                          const Text("Moment"),
                          const Spacer(),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: false,
                              items: listMoment.map((moment) {
                                return DropdownMenuItem<String>(
                                  value: moment.jour,
                                  child: SizedBox(
                                    width: 150, //expand here
                                    child: Text(
                                      moment.jour,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: enableMoment ? (newValue) {
                                setState(() {
                                  jour = newValue.toString();
                                });
                              }
                              : null,
                              hint: const SizedBox(
                                width: 150, //and here
                                child: Text(
                                  "Moment",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              style: TextStyle(color: Colors.green, decorationColor: Colors.red),
                              value: jour,
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
                        controller: txtNbVisiteurs,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14,),
                          hintText: 'Nombre de visiteurs',
                          errorStyle: const TextStyle(color: Color(0xFFFDA384)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          errorText: validate_nbVisiteurs == false ? 'Le champs est obligatoire ' : null,
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
                                  MaterialStateProperty.all<Color>(Colors.green,),
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
                )
            );
          }
        ));
  }

  _showDialogConfirmation(){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation de suppression', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
            content: const Text("Voulez-vous vraiment supprimer cet enregistrement?", textAlign: TextAlign.center,),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                        Navigator.pop(context);
                    });
                  },
                  child: Text('Non', style: TextStyle(color: Colors.green),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                    )
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                        delete(jour, museeNum);
                        Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Oui',
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                    )
                  ),
                ),
              ),
            ],
          );
        });
  }


  @override
  void save() {
      Visiter visiter= Visiter(
        jour: jour,
        numMus: museeNum, 
        nbvisiteurs: int.parse(txtNbVisiteurs.text.trim()),
      );
      if (saveOrUpdateText == 'Enregistrer'){
        visiterBloc.addVisite(visiter);
      }else{
        print(visiter.jour);
        visiterBloc.updateVisite(visiter);
      }
     
  }

  @override
  void delete(String jour, int numMus) {
    visiterBloc.deleteVisite(jour, numMus);
  }
}

abstract class AlertDialogCallback {
  void save();
  void delete(String jour, int numMus);
}