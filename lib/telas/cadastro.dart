import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool senhaSecreta = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future cadastrar()async{
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
       password: senhaController.text
       ).then((value){
         Navigator.of(context).pop();
       }).catchError((error){
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Erro ao realizar cadastro')));
         
       });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:  Color(0xff272727),
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Form(
        key: _formKey,
      child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Column(              
            children: [
              SizedBox(height: 30),
              
              TextFormField(
                controller: emailController,
                validator: (texto){
                  if(texto.isEmpty || !texto.contains('@')) return 'Email inválido';
                },
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  suffixIcon: Icon(Icons.email)
                ),
              ),
              TextFormField(
                controller: senhaController,
                validator: (texto){
                  if(texto.isEmpty || texto.length < 6) return 'Senha inválida';
                },
                style: TextStyle(
                  color: Colors.white
                ),
                obscureText: senhaSecreta,              
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  suffixIcon: IconButton(
                    icon: senhaSecreta ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                     onPressed: (){
                      setState(() {
                         senhaSecreta = !senhaSecreta;
                      });
                     }
                     )
                ),
              ),
              SizedBox(height: 8,),
              RaisedButton(
                child: Text('Cadastrar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.grey[800],
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    cadastrar();
                  }
                }
                ),
              SizedBox(height: 8,),
             
            ],
          ),
          ),
      ),
    ),
    );
  }
}