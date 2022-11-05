import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'KhaltiPayment.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';



class KhaltiPaymentApp extends StatelessWidget {
  final String PhoneNo;
  final String Amt;
  const KhaltiPaymentApp({Key? key,required this.PhoneNo,required this.Amt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: "test_public_key_7c3e0857e34c4edcb0eedf702dcf5246",
        builder: (context, navigatorKey) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [KhaltiLocalizations.delegate,
           ],
            theme: ThemeData(
                primaryColor: const Color(0xFF56328c),
                appBarTheme: const AppBarTheme(
                  color: Color(0xFF56328c),
                )),
            title: 'Khalti Payment',
            home: KhaltiPaymentPage(PhoneNo: PhoneNo,Amt: Amt,),
          );
        });
  }
}