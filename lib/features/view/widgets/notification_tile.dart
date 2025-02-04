// import 'package:flutter/material.dart';
// import '../../../data/model/notification_model.dart';
//
// class NotificationTile extends StatelessWidget {
//   final NotificationModel notification;
//
//   const NotificationTile({Key? key, required this.notification}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Choose the icon based on notification type
//     IconData icon;
//     switch (notification.type) {
//       case "order":
//         icon = Icons.local_shipping;
//         break;
//       case "sale":
//         icon = Icons.local_offer;
//         break;
//       case "review":
//         icon = Icons.rate_review;
//         break;
//       default:
//         icon = Icons.notifications;
//     }
//
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: notification.isRead ? Colors.grey[300] : Colors.blue[100],
//         child: Icon(
//           icon,
//           color: notification.isRead ? Colors.grey : Colors.blue,
//         ),
//       ),
//       title: Row(
//         children: [
//           // Notification Description Text
//           Expanded( // Ensures the text takes available space and prevents overflow
//             child: Text(
//               notification.description,
//               style: TextStyle(
//                 fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
//                 color: notification.isRead ? Colors.grey : Colors.black, // Set grey if read
//               ),
//             ),
//           ),
//           // Show a badge for unread notifications
//           if (!notification.isRead)
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Container(
//                 padding: const EdgeInsets.all(4.0),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: const Text(
//                   'NEW',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       trailing: Flexible( // Ensures the trailing widget doesn't overflow
//         child: Text(
//           notification.time,
//           style: TextStyle(
//             color: notification.isRead ? Colors.grey : Colors.black, // Set grey if read
//             overflow: TextOverflow.ellipsis, // If the time text is too long, it will be truncated
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
