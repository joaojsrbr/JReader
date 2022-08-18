// ignore_for_file: prefer_final_fields

import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Session {
  signInWithGoogle(BuildContext context) {
    _signIn((error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.white,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            content: const Text(
              'Login Success',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        Navigator.of(context).pushReplacementNamed(RoutesName.HOME);
      }
    });
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _signIn(Function(String?) call) async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(signInOption: SignInOption.standard).signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        call(null);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        call('Essa conta já existe com uma credencial diferente.');
      } else if (e.code == 'invalid-credential') {
        call('Ocorreu um erro ao acessar as credenciais.');
      } else {
        call('Ocorreu um erro ao tentar entrar com o Google.');
      }
    } catch (e) {
      call('Ocorreu um erro ao tentar entrar com o Google.');
    }
  }
}
