import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiPaymentPage extends StatefulWidget {
  final String PhoneNo;
  final String Amt;

  const KhaltiPaymentPage({Key? key, required this.PhoneNo, required this.Amt})
      : super(key: key);

  @override
  State<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

class _KhaltiPaymentPageState extends State<KhaltiPaymentPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneNOController = TextEditingController();

  //getAmt() {
  // return int.parse(amountController.text) * 100; // Converting to paisa
  //}
  // getNum(){
  //return int.parse(phoneNOController.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            const Text(
              'Amount to Pay:',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'OpenSans',
                  color: Color(0xFF56328c),
                  fontWeight: FontWeight.bold),
            ),
            Text(widget.Amt,
                style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold)),
            const Text('Phone No:',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'OpenSans',
                    color: Color(0xFF56328c),
                    fontWeight: FontWeight.bold)),
            Text(widget.PhoneNo.toString(),
                style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold)),
            // For Amount
            // TextField(
            //   controller: amountController,
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //       labelText: "Enter Amount to pay",
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.black),
            //         borderRadius: BorderRadius.all(Radius.circular(8)),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.green),
            //         borderRadius: BorderRadius.all(Radius.circular(8)),
            //       )),
            // ),
            const SizedBox(
              height: 8,
            ),
            // TextField(
            //   controller: phoneNOController,
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //       labelText: "Enter khalti mobile Number",
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.black),
            //         borderRadius: BorderRadius.all(Radius.circular(8)),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.green),
            //         borderRadius: BorderRadius.all(Radius.circular(8)),
            //       )),
            // ),
            const SizedBox(
              height: 8,
            ),
            // For Button
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.red)),
                height: 50,
                color: const Color(0xFF56328c),
                child: const Text(
                  'Pay With Khalti',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onPressed: () {
                  KhaltiScope.of(context).pay(
                    config: PaymentConfig(
                      amount: int.parse(widget.Amt) * 100,
                      productIdentity: 'freel2022',
                      productName: 'FreeL',
                    ),
                    preferences: [
                      PaymentPreference.khalti,
                      PaymentPreference.connectIPS,
                    ],
                    onSuccess: (su) {
                      const successsnackBar = SnackBar(
                        content: Text('Payment Successful'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(successsnackBar);
                    },
                    onFailure: (fa) {
                      const failedsnackBar = SnackBar(
                        content: Text('Payment Failed'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(failedsnackBar);
                    },
                    onCancel: () {
                      const cancelsnackBar = SnackBar(
                        content: Text('Payment Cancelled'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(cancelsnackBar);
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
