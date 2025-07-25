
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _email_controller = TextEditingController();
  final TextEditingController _pass_controller = TextEditingController();
  final TextEditingController _address_controller = TextEditingController();

  // Globalkey para o form
  final _form_key = GlobalKey<FormState>();

  // Criando uma globalKey navigator para mostrar o snackBar  e passando  para a key do scaffold ou
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final Color primary_color = Theme.of(context).primaryColor;

    return Scaffold(
      key: navigatorKey,
      appBar: AppBar(
        backgroundColor: primary_color,
        title: Text('Criar Conta', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){

          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);
          return Form(
              key: _form_key,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  TextFormField(
                    controller: _name_controller,
                    validator:(field){
                      if(field!.isEmpty){
                        return 'Campo vazio!';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Nome Completo',
                    ),
                  ),
                  SizedBox(height: 20.0),

                  TextFormField(
                    controller: _email_controller,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                    validator: (field){
                      if(field!.isEmpty || !field.contains('@')){
                        return 'E-mail Inválid!';
                      };
                    },
                  ),
                  SizedBox(height: 20.0),

                  TextFormField(
                    controller: _pass_controller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                    ),
                    validator: (field){
                      if(field!.isEmpty || field.length < 6){
                        return 'Senha inválida!, minimu '"6"' carácteres ';
                      }
                    },
                  ),
                  SizedBox(height: 20.0),

                  TextFormField(
                    controller: _address_controller,
                    decoration: InputDecoration(
                        hintText: 'Endereço'
                    ),
                    validator: (field){
                      if(field!.isEmpty){
                        return 'Campo vazio';
                      }
                    },
                  ),
                  SizedBox(height: 32.0),

                  SizedBox(
                    height: 54.0,
                    child: ElevatedButton(
                      onPressed: (){
                        Map<String, dynamic> user_data = {};

                        if(_form_key.currentState!.validate()){
                          user_data = {
                            'name':_name_controller.text,
                            'email': _email_controller.text,
                            'address': _address_controller.text,
                          };
                        };

                        // Function call to signup
                        model.signUp(
                          user_data: user_data,
                          pass: _pass_controller.text,
                          onSuccess: onSuccess,
                          onFail: onFail);

                      },
                      child: Text('Crial Conta', style: TextStyle(fontSize:24.0, color: Colors.white)),
                      style: TextButton.styleFrom(
                          backgroundColor: primary_color,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0))
                      ),
                    ),
                  )

                ],
              )
          );
        },
      ),
    );
  }


  void onSuccess()async{
    // pegando o context para passar  para o saffoldMessenger.fo(context)
    final BuildContext? current_context = navigatorKey.currentContext;

    await ScaffoldMessenger.of(current_context!).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(current_context).primaryColor ,
        content: Text('Usuário criado com sucesso!', style: TextStyle(fontSize: 22.0))),
    );

    Future.delayed(Duration(seconds:3)).then((_){
      Navigator.of(current_context).pop();
    });

  }

  void onFail(){
    final BuildContext? current_context = navigatorKey.currentContext;

    ScaffoldMessenger.of(current_context!).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Erro ao criar usuario', style: TextStyle(fontSize: 22.0),))
    );
  }

}
