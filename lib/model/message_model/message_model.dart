//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MessageModel {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String message;
//   final DateTime timestamp;
//   final bool isSeen;
//   final List<String> hiddenFor; // <- new field
//
//   MessageModel({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.timestamp,
//     this.isSeen = false,
//     this.hiddenFor = const [],
//   });
//
//   // Create from a Firestore DocumentSnapshot
//   factory MessageModel.fromDoc(DocumentSnapshot doc) {
//     final map = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
//
//     return MessageModel(
//       id: map['id']?.toString() ?? doc.id,
//       senderId: map['senderId']?.toString() ?? '',
//       receiverId: map['receiverId']?.toString() ?? '',
//       message: map['message']?.toString() ?? '',
//       timestamp: (map['timestamp'] is Timestamp)
//           ? (map['timestamp'] as Timestamp).toDate()
//           : DateTime.now(),
//       isSeen: map['isSeen'] as bool? ?? false,
//       hiddenFor: map['hiddenFor'] is List
//           ? List<String>.from(map['hiddenFor'])
//           : <String>[],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'message': message,
//       'timestamp': Timestamp.fromDate(timestamp),
//       'isSeen': isSeen,
//       'hiddenFor': hiddenFor,
//     };
//   }
//
//   // copyWith helper if useful
//   MessageModel copyWith({
//     String? id,
//     String? senderId,
//     String? receiverId,
//     String? message,
//     DateTime? timestamp,
//     bool? isSeen,
//     List<String>? hiddenFor,
//   }) {
//     return MessageModel(
//       id: id ?? this.id,
//       senderId: senderId ?? this.senderId,
//       receiverId: receiverId ?? this.receiverId,
//       message: message ?? this.message,
//       timestamp: timestamp ?? this.timestamp,
//       isSeen: isSeen ?? this.isSeen,
//       hiddenFor: hiddenFor ?? this.hiddenFor,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool delivered;
  final bool isSeen;
  final List<String> hiddenFor;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.delivered,
    required this.isSeen,
    required this.hiddenFor,
    required this.timestamp,
  });

  factory MessageModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;

    return MessageModel(
      id: doc.id,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      delivered: map['delivered'] ?? false,
      isSeen: map['isSeen'] ?? false,
      hiddenFor: List<String>.from(map['hiddenFor'] ?? []),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'delivered': delivered,
      'isSeen': isSeen,
      'hiddenFor': hiddenFor,
      'timestamp': timestamp,
    };
  }

  MessageModel copyWith({
    String? message,
    bool? delivered,
    bool? isSeen,
    List<String>? hiddenFor,
  }) {
    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message ?? this.message,
      delivered: delivered ?? this.delivered,
      isSeen: isSeen ?? this.isSeen,
      hiddenFor: hiddenFor ?? this.hiddenFor,
      timestamp: timestamp,
    );
  }
}
