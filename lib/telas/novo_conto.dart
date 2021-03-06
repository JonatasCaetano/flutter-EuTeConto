import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NovoConto extends StatefulWidget {
  @override
  _NovoContoState createState() => _NovoContoState();
}

class _NovoContoState extends State<NovoConto> {

  User user;
  String categoria;
  String urlImagem;
  List<String> categorias = List();
  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
  }

  @override
  void initState() {
    super.initState();
    usuarioLogado();
  }

  TextEditingController tituloController = TextEditingController();
  TextEditingController textoController = TextEditingController();

  salvarTexto() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('categorias').doc(categoria).get();
    urlImagem = documentSnapshot.data()['imagem'];

    FirebaseFirestore.instance.collection('contos').add(
      {
        'data' : DateTime.now(),
        'autor' : user.uid,
        'titulo' : tituloController.text,
        'texto' : textoController.text,
        'curtidas' : List(),
        'categoria' : categoria,
        'comentarios' : 0,
        'imagem' : urlImagem,
        'visualizações' : 0,

      }
    ).then((_){    
      Navigator.of(context).pop();
    });
  }

  AdmobBanner getMiniBanner1(AdmobBannerSize size) {
    return AdmobBanner(
      adUnitId: 'ca-app-pub-1685263058686351/2708407285',
      adSize: size,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Banner');
      },
    );
  }
  /*
  AdmobBanner getMiniBanner2(AdmobBannerSize size) {
    return AdmobBanner(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      adSize: size,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Banner');
      },
    );
  }
  */
  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('Novo $adType Ad carregado!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad aberto!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad fechado!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType falhou ao carregar. :(');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f1b1b),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('categorias').get(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xffb34700),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffb34700))
                ),
              
              );
              break;
          default:
          if(snapshot.data.docs.length ==0 ){
                  return Center(
                    child: Text('Nada encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }else{
                  snapshot.data.docs.forEach((element) {
                    categorias.add(element['categoria']);
                  });
            return Container(
              margin: EdgeInsets.fromLTRB(16, 64, 16, 16 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    cursorColor: Color(0xffb34700),
                    controller: tituloController,
                    style: TextStyle(color: Colors.white),
                    maxLength: 140,
                    minLines: 1,
                    maxLines: 30,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0) ),
                        counterStyle: TextStyle(
                          color: Colors.white
                        ),
                        labelText: 'Titulo',
                        labelStyle: TextStyle(color: Colors.white),
                        
                        )
                  ),

                      SizedBox(
                        height: 8,
                      ),

                      Container(                                
                        child: getMiniBanner1(AdmobBannerSize.ADAPTIVE_BANNER(width: 300)),
                      ),     

                      SizedBox(
                        height: 8,
                      ),

                  TextField(
                    cursorColor: Color(0xffb34700),
                    controller: textoController,
                    style: TextStyle(color: Colors.white),
                    maxLength: 6000,                  
                    minLines: 10,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0) ),
                        counterStyle: TextStyle(
                          color: Colors.white
                        ),
                        labelText: 'Texto',
                        labelStyle: TextStyle(color: Colors.white),
                        
                        )
                  ),

                  /*
                   SizedBox(
                        height: 8,
                      ),

                      Container(                                
                        child: getMiniBanner2(AdmobBannerSize.ADAPTIVE_BANNER(width: 300)),
                      ),

                    */       

                  SizedBox(
                        height: 8,
                      ),
                  
                  Text('Categoria',
                    style: TextStyle(
                        color: Color(0xffb34700),
                        fontSize: 18.0
                        ),                
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  Container(
                    height: 30,
                    child: ListView.builder(
                      
                    scrollDirection: Axis.horizontal,                 
                    itemCount: categorias.length,
                    itemBuilder: (context, index){
                      return Container(
                        height: 28,
                        child: FlatButton(                       
                            onPressed: (){
                              
                              setState(() {
                                categoria = categorias[index];
                                categorias.removeAt(index);
                                categorias.insert(1, categoria);
                            
                              });
                            },
                            child: Text(categorias[index],
                              style: TextStyle(
                                color: categoria == categorias[index] ?  Colors.black : Color(0xffb34700),
                              ),
                            ),
                            color: categoria == categorias[index] ?  Colors.white : Colors.black38,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                            )
                            ),
                      );
                    }
                   )
                  ),
                  
                  SizedBox(
                    height: 8,
                  ),                 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                      child: Text('Publicar'),
                      shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                            ),
                      color: Colors.grey[400],
                      onPressed: (){
                       if(tituloController.text.isNotEmpty && textoController.text.isNotEmpty && textoController.text.length > 560){
                         salvarTexto();
                       }else{
                         SnackBar snackbar = SnackBar(content: Text('Verifique se o título e a categoria foram preenchidos e se o texto possui mais de 560 caracteres e tente novamente.',
                          style: TextStyle(
                            color: Colors.grey
                          ),
                         ));
                         Scaffold.of(context).showSnackBar(snackbar);                         
                       }
                      }
                    ),
                      ],
                    ),
                    SizedBox(
                    height: 8,
                  ),
                  
                  ],
              ),
            );
          }
            }}
      ),
        ),
      )
    );
  }
}