import 'package:flutter/material.dart';


class TermPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  home: ActivationHelpExactPage(),
  );
  }
  }

class ActivationHelpExactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- Section 1.0 -----------------
            Text(
              "1.0 When you register a new account, it shows \"Email exists, please log in\".",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCase(
              "Case 1",
              "(The mailbox has been registered and activated) --- Please log in directly.",
            ),
            _buildCase(
              "Case 2",
              "(The mailbox has been registered, but not activated) --- Please check the activation   email in the registered mailbox (need to check the trash), and then log in after activation.",
            ),

            const SizedBox(height: 20),

            // ----------------- Section 1.1 -----------------
            Text(
              "1.1 When you login your account, it shows \"Please go to your mailbox to activate the account\".",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCase(
              "Case 1",
              "(The account is not activated) --- Please check the activation email in the registered mailbox (need to check the trash box), and then log in after activation.",
            ),
            _buildCase(
              "Case 2",
              "(The account is not activated, but no activation email can be found in the registered mailbox) --- In this case, please try to click \"Resend activation mail\" and check the trash box again. If still not received, please contact the customer service staff in time and submit the email account or phone number in order to check and solve the problem as soon as possible.",
            ),
            _buildCase(
              "Case 3",
              "(The account has been activated, but the login still shows that it is not activated) --- In this case, please contact the customer service staff in time and submit the email account or phone number in order to check and solve the problem as soon as possible.",
            ),

            const SizedBox(height: 20),

            // ----------------- Section 1.2 -----------------
            Text(
              "1.2 How to reset password ?",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCase(
              "Case 1",
              "(Reset password email received in the registered mailbox (need to check the trash)) --- After the customer service staff resets the new password, the email account information. If the problem cannot be solved, you are recommended to change your email account to confirm again.",
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable method to build each case in a bordered container
  Widget _buildCase(String caseTitle, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caseTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
