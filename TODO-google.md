Login con Google - Istruzioni
Per implementare il login con Google in Flutter, devi seguire questi passaggi:

1. Configurazione Firebase

# Aggiungi Firebase al progetto

flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add google_sign_in 2. Configurazione Firebase Console
Vai su https://console.firebase.google.com/
Crea un nuovo progetto o seleziona quello esistente
Aggiungi la tua app Flutter (Android/iOS/Web)
Scarica i file di configurazione:
Android: google-services.json → android/app/
iOS: GoogleService-Info.plist → ios/Runner/
Web: Copia lo snippet di configurazione 3. Configurazione Android (android/app/build.gradle)
dependencies {
classpath 'com.google.gms:google-services:4.3.15'
}

apply plugin: 'com.google.gms.google-services' 4. Codice di esempio per Google Sign-In
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
final FirebaseAuth \_auth = FirebaseAuth.instance;
final GoogleSignIn \_googleSignIn = GoogleSignIn();

// Login con Google
Future<UserCredential?> signInWithGoogle() async {
try {
// Trigger del flow di autenticazione
final GoogleSignInAccount? googleUser = await \_googleSignIn.signIn();

      if (googleUser == null) {
        // L'utente ha annullato il login
        return null;
      }

      // Ottieni i dettagli di autenticazione dalla richiesta
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crea una nuova credenziale
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Una volta firmato, restituisci UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Errore durante il login con Google: $e');
      return null;
    }

}

// Logout
Future<void> signOut() async {
await \_googleSignIn.signOut();
await \_auth.signOut();
}

// Stream dello stato di autenticazione
Stream<User?> get authStateChanges => \_auth.authStateChanges();
} 5. Esempio di utilizzo in un widget
ElevatedButton(
onPressed: () async {
final authService = GoogleAuthService();
final userCredential = await authService.signInWithGoogle();

    if (userCredential != null) {
      print('Login riuscito: ${userCredential.user?.displayName}');
      // Naviga alla home page
    } else {
      print('Login annullato');
    }

},
child: Text('Accedi con Google'),
) 6. Configurazione SHA-1 (Android)
Per ottenere l'SHA-1 fingerprint:

cd android
./gradlew signingReport
Copia l'SHA-1 e aggiungilo nella console Firebase → Project Settings → Your apps → Android app

Note importanti:

Assicurati di abilitare "Google" come provider di accesso nella Firebase Console (Authentication → Sign-in method)
Per iOS, aggiungi l'URL scheme nel file Info.plist
Per Web, configura il dominio autorizzato nella Firebase Console
