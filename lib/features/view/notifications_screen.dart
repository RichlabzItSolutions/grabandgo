// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodel/notification_viewmodel.dart';
// import 'package:hygi_health/features/view/widgets/notification_tile.dart';
//
//
//
// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<NotificationViewModel>(context);
//     final groupedNotifications = viewModel.groupedNotifications;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//         backgroundColor: Colors.white,
//         elevation: 1,
//       ),
//       body: ListView(
//         children: groupedNotifications.entries.map<Widget>((entry) {
//           // Count unread notifications in this section
//           int unreadCount = entry.value.where((notification) => !notification.isRead).length;
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section Heading with "Mark All as Read" Button
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Section Title and Unread Count
//                     Row(
//                       children: [
//                         Text(
//                           entry.key.toUpperCase(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         if (unreadCount > 0) // Show unread count only if there are unread notifications
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: CircleAvatar(
//                               radius: 10,
//                               backgroundColor: Colors.red,
//                               child: Text(
//                                 '$unreadCount',
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     // "Mark All as Read" Button
//                     TextButton(
//                       onPressed: () {
//                         // Action: Mark all notifications in this section as read
//                         viewModel.markSectionAsRead(entry.key);
//                       },
//                       child: const Text(
//                         "Mark All as Read",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Notifications in the Section
//               ...entry.value.map<Widget>((notification) {
//                 return NotificationTile(notification: notification);
//               }).toList(),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
//
//
//
//
