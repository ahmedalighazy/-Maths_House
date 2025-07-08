import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/views/home/packages/packege_screen.dart';
import 'package:maths_house/core/widgets/build_card_home.dart';

import 'live_model/live_model_screen.dart';
import 'payment/payment_screen.dart';
import 'pending_payments/pending_screen.dart';
import 'students/students_screen.dart';
import 'teachers/teachers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/man.png'),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Welcome ',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        TextSpan(
                          text: 'Moaz',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Cards Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    HomeCard(
                      icon: Icons.access_time,
                      title: 'Pending Payments',
                      count: 3,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PendingScreen()));
                      },),
                    HomeCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Payment',
                      count: 1,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const  PaymentScreen()));
                      },),
                    HomeCard(
                      icon: Icons.school,
                      title: 'Teachers',
                      count: 10,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const  TeachersScreen()));
                      },),
                    HomeCard(
                      icon: Icons.person,
                      title: 'Students',
                      count: 50,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const StudentsScreen()));

                      },),
                    HomeCard(
                      icon: Icons.layers,
                      title: 'Packages',
                      count: 9,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PackagesScreen()));
                      },),
                    HomeCard(icon: Icons.play_circle_fill,
                      title: 'Live Module',
                      count: 3,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LiveModelScreen()));
                      },),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}