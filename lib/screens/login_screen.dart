
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/user_model.dart';



class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  final TextEditingController email_controller = TextEditingController();
  final TextEditingController pass_controller = TextEditingController();
  // Para receber um context ###
  var may_context;

  // final GlobalKey<NavigatorState> navigator_context = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    may_context = context;
    final Color primary_color = Theme.of(context).primaryColor;

    // validate form field
    final _form_key = GlobalKey<FormState>();

    return Scaffold(
      // key: navigator_context,
      appBar: AppBar(
        backgroundColor: primary_color,
        // leading: ,
        title: Text('Entrar ', style: TextStyle(fontWeight: FontWeight.bold ,color:Colors.white),),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignupScreen()));
            },
            child: Text('CRIAR CONTA', style: TextStyle(fontSize: 18.0, color: Colors.white)))
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context,child, model){

          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);

          return Form(
              key: _form_key,
              child: ListView(
                padding: EdgeInsets.all(18.0),
                children: [
                  TextFormField(
                    controller: email_controller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                    validator:(field){
                      if(field!.isEmpty){
                        return 'Campo vasio!';
                      }else if(!field.contains('@')){
                        return 'E-mail Invalido! ';
                      }
                    },
                  ),
                  SizedBox(height: 16.0),

                  TextFormField(
                      controller: pass_controller,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                      ),
                      validator:(field){
                        if(field!.isEmpty){
                          return 'Campo vazio!';
                        }else if(field.length < 6){
                          return 'maximo caractere '"6"' ';
                        }
                      }
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('Esqueci minha senha!', style: TextStyle( fontSize: 18.0)),
                      onPressed: (){
                        if(email_controller.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Insira o seu Email', style: TextStyle(fontSize: 22.0)),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds:5)
                            )
                          );
                        }else{
                          // Recuperando email
                          model.recoverPass(email_controller.text);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              content:const Text('Verifique sue Email', style:TextStyle(fontSize: 22.0)),
                              duration: Duration(seconds:4)
                            )
                          );
                        }


                      },
                    ),
                  ),
                  SizedBox(height:20.0),

                  ElevatedButton(
                    onPressed: (){
                      // Asking to valid the fields forms
                      // Pedindo para validar os campos
                      if(_form_key.currentState!.validate());
                        model.signIn(email: email_controller.text,password: pass_controller.text, onSuccess:onSuccess, onFail: onFail);


                    },

                    child: Text('ENTRAR', style: TextStyle(color: Colors.white, fontSize: 19.0)),
                    style: TextButton.styleFrom(
                        backgroundColor: primary_color,
                        fixedSize: Size(1000.0, 54.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
                    ),
                  ),

                ],
              )
          );
        }
      ),
    );
  }

  void onSuccess(){

    // Criando um context para o context
    // final BuildContext context = navigator_context.currentContext!;
    final context = may_context;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text('Logado com exito!', style: TextStyle(fontSize: 22.0,)),
      )
    );

    Future.delayed(Duration(seconds:2)).then((onValue){
      Navigator.of(context).pop();
    });
  }


  void onFail(){
    // final BuildContext? context = navigator_context.currentContext;

    final context = may_context;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Falha no login', style: TextStyle(fontSize: 22.0)))
    );
  }

}
