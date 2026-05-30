import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffFFF2F6),

      body: SingleChildScrollView(

        child: Column(

          children: [

            Container(

              width:double.infinity,

              padding:
              const EdgeInsets.only(
                  top:60,
                  left:20,
                  right:20,
                  bottom:30),

              decoration:
              const BoxDecoration(

                color:
                Color(0xffF48FB1),

                borderRadius:
                BorderRadius.only(

                  bottomLeft:
                  Radius.circular(30),

                  bottomRight:
                  Radius.circular(30),
                ),
              ),

              child: const Row(

                children: [

                  Icon(
                    Icons.notifications,
                    color:
                    Colors.white,
                  ),

                  SizedBox(width:15),

                  Text(

                    "Notifications",

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.bold,

                      fontSize:28,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height:20),

            notificationCard(
              Icons.calendar_month,
              "Your period starts in 3 days 🌸",
              "2 min ago",
              Colors.pink,
            ),

            notificationCard(
              Icons.inventory,
              "Pads running low (2 left)",
              "10 min ago",
              Colors.deepPurple,
            ),

            notificationCard(
              Icons.location_on,
              "Risa accepted your request",
              "25 min ago",
              Colors.green,
            ),

            notificationCard(
              Icons.favorite,
              "Remember to drink water 💧",
              "1 hour ago",
              Colors.red,
            ),

            notificationCard(
              Icons.medication,
              "Time to take your medicine",
              "2 hours ago",
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }


  Widget notificationCard(

      IconData icon,
      String title,
      String time,
      Color color){

    return Container(

      margin:
      const EdgeInsets.symmetric(
          horizontal:16,
          vertical:8),

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(25)
      ),

      child: Row(

        children: [

          CircleAvatar(

            radius:28,

            backgroundColor:
            color.withOpacity(.15),

            child:
            Icon(
              icon,
              color:color,
            ),
          ),

          const SizedBox(width:15),

          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,

                    fontSize:16,
                  ),
                ),

                const SizedBox(height:6),

                Text(
                  time,

                  style:
                  const TextStyle(
                    color:
                    Colors.grey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}