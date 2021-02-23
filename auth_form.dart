import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_com_firebase/widgets/conversa_form.dart';
import 'package:translator/translator.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
 // TextEditingController _nome = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
   // FirebaseAuth auth = FirebaseAuth.instance;
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: <Widget>[
                  /*TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),*/
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                    controller: _email,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    controller: _senha,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    child: Text('Entrar'),
                    onPressed: () async {
                      int i = 0;
                      UserCredential userCredential;
                      try {
                        userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      // await _showDialog(context, "userCredential", userCredential.user.email);
                      } on FirebaseAuthException catch (e) {
                        translator
                            .translate(e.code, to: 'pt')
                            .then((result) => _showDialog(context, 'Erro', result.text));


                        /*if (e.code == 'user-not-found') {
                          _showDialog(context, 'Erro',
                              'Nenhum usuário encontrado para esse e-mail.');
                          //print('Nenhum usuário encontrado para esse e-mail.');
                        } else if (e.code == 'wrong-password') {
                          _showDialog(context, 'Erro',
                              'Senha errada fornecida para esse usuário.');
                          // print('Senha errada fornecida para esse usuário.');
                        }*/
                        i = 1;
                      }

                      if (i == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => conversa_form(Email: userCredential.user.email)));
                      }
                    },
                  ),
                  TextButton(
                    child: Text('Criar uma nova conta?'),
                    onPressed: () async {
                      int i = 0;
                      try {
                       // UserCredential userCredential =
                        await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      } on FirebaseAuthException catch (e) {
                        translator
                            .translate(e.code, to: 'pt')
                            .then((result) => _showDialog(context, 'Erro', result.text));


                        if (e.code == 'weak-password') {
                          /*_showDialog(context, 'Erro',
                              'The password provided is too weak.');*/
                          // print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          /*_showDialog(context, 'Erro',
                              'The account already exists for that email.');
                          // print('The account already exists for that email.');*/
                        }
                        i = 1;
                      }
                      if (i == 0) {
                        _showDialog(context, 'Aviso', "Registrou!");
                        //print("Registrou!");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, titulo, texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(texto),
        actions: <Widget>[
          // define os botões na base do dialogo
          new TextButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
