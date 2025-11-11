//
// import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
//
// class More extends StatefulWidget {
//   const More({super.key});
//
//   @override
//   State<More> createState() => _MoreState();
// }
//
// class _MoreState extends State<More> {
//   Map<String, String> prayerTimes = {};
//   Map<String, bool> reminderStatus = {};
//   List<Map<String, dynamic>> customReminders = [];
//
//   bool loading = true;
//   String error = '';
//
//   int minutesBeforePrayer = 0;
//   String soundType = 'default';
//   String? customSoundPath;
//   String selectedCity = 'Current Location';
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   final AudioPlayer player = AudioPlayer();
//
//   final List<String> cities = [
//     'Current Location',
//     'Makkah',
//     'Madinah',
//     'Riyadh',
//     'Lahore',
//     'Karachi',
//     'Islamabad',
//     'Cairo',
//     'Jakarta',
//     'Istanbul',
//     'Bannu',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     initSetup();
//   }
//
//   /// =================== INITIAL SETUP ===================
//   Future<void> initSetup() async {
//     await _requestPermissions();
//     await initNotifications();
//     await loadSavedPreferences();
//     await fetchPrayerTimes();
//     await loadCustomReminders();
//   }
//
//   Future<void> _requestPermissions() async {
//     await Permission.location.request();
//     await Permission.notification.request();
//     await Permission.storage.request();
//   }
//
//
//
//
//   /// =================== NOTIFICATIONS ===================
//
//   Future<void> initNotifications() async {
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final InitializationSettings initSettings =
//     InitializationSettings(android: androidSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) async {
//         // STOP_RING action pressed
//         if (details.actionId == 'STOP_RING') {
//           await stopSound();
//           return;
//         }
//
//         // Notification tapped
//         if (soundType == 'custom' && customSoundPath != null) {
//           await player.stop();
//           await player.play(DeviceFileSource(customSoundPath!), volume: 1.0);
//         }
//         // No need to play Azan here for default: notification already played automatically
//       },
//     );
//
//     // 1️⃣ Default Azan channel
//     const defaultAzanChannel = AndroidNotificationChannel(
//       'default_azan_channel',
//       'Prayer Reminders',
//       description: 'Default Azan notifications',
//       importance: Importance.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('azan'),
//     );
//
//     // 2️⃣ Silent channel for custom sounds
//     const silentChannel = AndroidNotificationChannel(
//       'silent_channel',
//       'Silent Reminders',
//       description: 'Notifications without sound, custom AudioPlayer will play',
//       importance: Importance.high,
//       playSound: false,
//     );
//
//     final androidPlugin = flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     if (androidPlugin != null) {
//       await androidPlugin.createNotificationChannel(defaultAzanChannel);
//       await androidPlugin.createNotificationChannel(silentChannel);
//     }
//   }
//
//
//   /// Schedule a prayer or custom reminder notification
//   Future<void> scheduleNotification(
//       String title, String body, DateTime date) async {
//     if (date.isBefore(DateTime.now())) return;
//
//     final isCustomSoundSet = (soundType == 'custom' && customSoundPath != null);
//
//     // Notification channel for custom sound
//     final androidDetails = AndroidNotificationDetails(
//       isCustomSoundSet ? 'silent_channel' : 'default_azan_channel',
//       'Prayer Reminders',
//       channelDescription: isCustomSoundSet
//           ? 'Silent notifications, AudioPlayer plays custom sound'
//           : 'Default Azan notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: !isCustomSoundSet, // Only play system sound if not custom
//       sound: !isCustomSoundSet
//           ? RawResourceAndroidNotificationSound('azan')
//           : null,
//       actions: <AndroidNotificationAction>[
//         AndroidNotificationAction(
//           'STOP_RING',
//           'Stop',
//           showsUserInterface: true,
//         ),
//       ],
//     );
//
//     final notificationDetails = NotificationDetails(android: androidDetails);
//
//     // Schedule notification
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       date.hashCode,
//       title,
//       body,
//       tz.TZDateTime.from(date, tz.local),
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//
//     // Play custom sound in foreground if set
//     if (isCustomSoundSet) {
//       final delay = date.difference(DateTime.now());
//       if (delay.inSeconds > 0) {
//         Future.delayed(delay, () async {
//           if (!mounted) return;
//           try {
//             await player.stop();
//             await player.play(DeviceFileSource(customSoundPath!), volume: 1.0);
//
//             // Optional: show the same notification again in foreground
//             await flutterLocalNotificationsPlugin.show(
//               date.hashCode,
//               title,
//               body,
//               notificationDetails,
//             );
//           } catch (e) {
//             debugPrint('❌ Custom sound playback failed: $e');
//           }
//         });
//       }
//     }
//   }
//
//
//   /// Stop currently playing sound
//   Future<void> stopSound() async {
//     try {
//       await player.stop();
//     } catch (e) {
//       debugPrint('❌ Stop sound failed: $e');
//     }
//   }
//
//
//
//   /// =================== FETCH PRAYER TIMES ===================
//   Future<void> fetchPrayerTimes() async {
//     try {
//       setState(() => loading = true);
//
//       Uri url;
//       if (selectedCity == 'Current Location') {
//         final pos = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high);
//         url = Uri.parse(
//             'https://api.aladhan.com/v1/timings?latitude=${pos.latitude}&longitude=${pos.longitude}&method=2');
//       } else {
//         url = Uri.parse(
//             'https://api.aladhan.com/v1/timingsByCity?city=$selectedCity&country=Saudi%20Arabia&method=2');
//       }
//
//       final res = await http.get(url);
//       if (res.statusCode != 200) throw Exception('Failed to fetch timings');
//
//       final data = json.decode(res.body);
//       final timings = Map<String, String>.from(data['data']['timings']);
//       timings.removeWhere(
//               (k, _) => ['Sunrise', 'Imsak', 'Midnight'].contains(k));
//
//       setState(() {
//         prayerTimes = timings;
//         loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         loading = false;
//       });
//     }
//   }
//
//   /// =================== LOAD / SAVE SETTINGS ===================
//   Future<void> loadSavedPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     final keys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
//
//     for (var key in keys) {
//       reminderStatus[key] = prefs.getBool('reminder_$key') ?? false;
//     }
//
//     minutesBeforePrayer = prefs.getInt('minutes_before') ?? 0;
//     soundType = prefs.getString('sound_type') ?? 'default';
//     customSoundPath = prefs.getString('custom_sound_path');
//     selectedCity = prefs.getString('selected_city') ?? 'Current Location';
//   }
//
//   Future<void> saveCustomSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('minutes_before', minutesBeforePrayer);
//     await prefs.setString('sound_type', soundType);
//     if (customSoundPath != null)
//       await prefs.setString('custom_sound_path', customSoundPath!);
//     await prefs.setString('selected_city', selectedCity);
//   }
//
//
//
//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//
//   /// =================== PICK CUSTOM SOUND ===================
//   Future<void> pickCustomSound() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.audio);
//     if (result != null && result.files.single.path != null) {
//       customSoundPath = result.files.single.path!;
//       soundType = 'custom';
//       await saveCustomSettings();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('✅ Custom sound selected:\n$customSoundPath')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ No sound selected')),
//       );
//     }
//   }
//
//   /// =================== CUSTOM REMINDERS ===================
//   Future<void> loadCustomReminders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedList = prefs.getStringList('custom_reminders') ?? [];
//     customReminders =
//         savedList.map((e) => json.decode(e) as Map<String, dynamic>).toList();
//     setState(() {});
//   }
//
//   Future<void> saveCustomReminders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final encoded = customReminders.map((e) => json.encode(e)).toList();
//     await prefs.setStringList('custom_reminders', encoded);
//   }
//
//   Future<void> addCustomReminder(String title, TimeOfDay time) async {
//     final now = DateTime.now();
//     final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//
//     final reminder = {
//       'id': date.hashCode,
//       'title': title,
//       'time': time.format(context),
//     };
//
//     customReminders.add(reminder);
//     await saveCustomReminders();
//     await scheduleNotification(
//         '🔔 Reminder: $title', 'It’s time for your reminder!', date);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('✅ Reminder set for ${time.format(context)}')),
//     );
//     setState(() {});
//   }
//
//   Future<void> deleteCustomReminder(Map<String, dynamic> reminder) async {
//     customReminders.remove(reminder);
//     await saveCustomReminders();
//     await cancelNotification(reminder['id']);
//     setState(() {});
//   }
//
//   void _showAddCustomReminderDialog() {
//     TextEditingController titleController = TextEditingController();
//     TimeOfDay? selectedTime;
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             title: const Text('Add Custom Reminder'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration:
//                   const InputDecoration(labelText: 'Reminder Title'),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.access_time),
//                   label: Text(selectedTime == null
//                       ? 'Pick Time'
//                       : selectedTime!.format(context)),
//                   onPressed: () async {
//                     final picked = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (picked != null)
//                       setDialogState(() => selectedTime = picked);
//                   },
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel')),
//               ElevatedButton(
//                 onPressed: () {
//                   if (titleController.text.isNotEmpty && selectedTime != null) {
//                     addCustomReminder(
//                         titleController.text.trim(), selectedTime!);
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Save'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//
//   /// =================== UI ===================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Prayer & Custom Reminders'),
//         centerTitle: true,
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: fetchPrayerTimes)
//         ],
//       ),
//       bottomNavigationBar: const BottomNavigation(index: 3),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//           ? Center(child: Text('Error: $error'))
//           : ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Text(
//             'Today’s Prayer Times',
//             style:
//             TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.location_on),
//               const SizedBox(width: 8),
//               DropdownButton<String>(
//                 value: selectedCity,
//                 items: cities
//                     .map((city) => DropdownMenuItem(
//                     value: city, child: Text(city)))
//                     .toList(),
//                 onChanged: (value) async {
//                   if (value != null) {
//                     setState(() => selectedCity = value);
//                     await saveCustomSettings();
//                     await fetchPrayerTimes();
//                   }
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...prayerTimes.entries.map((e) {
//             final isEnabled = reminderStatus[e.key] ?? false;
//             return Card(
//               elevation: 3,
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               child: ListTile(
//                 leading: const Icon(Icons.access_time),
//                 title: Text(e.key,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16)),
//                 subtitle: Text(e.value),
//                 trailing: Switch(
//                   value: isEnabled,
//                   onChanged: (value) async {
//                     setState(() => reminderStatus[e.key] = value);
//                     final prefs =
//                     await SharedPreferences.getInstance();
//                     await prefs.setBool('reminder_${e.key}', value);
//
//                     if (value) {
//                       final dateFormat = DateFormat('HH:mm');
//                       final parsedTime = dateFormat.parse(e.value);
//                       final now = DateTime.now();
//                       final date = DateTime(
//                         now.year,
//                         now.month,
//                         now.day,
//                         parsedTime.hour,
//                         parsedTime.minute,
//                       ).subtract(
//                           Duration(minutes: minutesBeforePrayer));
//
//                       await scheduleNotification(
//                         '🕌 ${e.key} Prayer Reminder',
//                         minutesBeforePrayer == 0
//                             ? "It's time for ${e.key} prayer."
//                             : "$minutesBeforePrayer min left for ${e.key} prayer.",
//                         date,
//                       );
//                     } else {
//                       await cancelNotification(e.key.hashCode);
//                     }
//                   },
//                 ),
//               ),
//             );
//           }),
//           const Divider(height: 32),
//           const Text(
//             '⏰ Custom Reminders',
//             style:
//             TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           ...customReminders.map((r) => Card(
//             child: ListTile(
//               title: Text(r['title']),
//               subtitle: Text('Time: ${r['time']}'),
//               trailing: IconButton(
//                 icon:
//                 const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () => deleteCustomReminder(r),
//               ),
//             ),
//           )),
//           const SizedBox(height: 10),
//           ElevatedButton.icon(
//               icon: const Icon(Icons.add_alarm),
//               label: const Text('Add Custom Reminder'),
//               onPressed: _showAddCustomReminderDialog),
//           const SizedBox(height: 10),
//           ElevatedButton.icon(
//               icon: const Icon(Icons.music_note),
//               label: const Text('Select Custom Sound'),
//               onPressed: pickCustomSound),
//           const SizedBox(height: 10),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.stop),
//             label: const Text('Stop Ringtone'),
//             onPressed: stopSound,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/colors/colors.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  Map<String, String> prayerTimes = {};
  Map<String, bool> reminderStatus = {};
  List<Map<String, dynamic>> customReminders = [];

  bool loading = true;
  String error = '';

  int minutesBeforePrayer = 0;
  String soundType = 'default';
  String? customSoundPath;
  String selectedCity = 'Current Location';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AudioPlayer player = AudioPlayer();

  final List<String> cities = [
    'Current Location',
    'Makkah',
    'Madinah',
    'Riyadh',
    'Lahore',
    'Karachi',
    'Islamabad',
    'Cairo',
    'Jakarta',
    'Istanbul',
    'Bannu',
  ];

  /// Default prayer times for offline fallback
  final Map<String, Map<String, String>> defaultPrayerTimes = {
    'Makkah': {
      'Fajr': '04:30',
      'Dhuhr': '12:15',
      'Asr': '15:30',
      'Maghrib': '18:00',
      'Isha': '19:15',
    },
    'Madinah': {
      'Fajr': '04:40',
      'Dhuhr': '12:20',
      'Asr': '15:35',
      'Maghrib': '18:05',
      'Isha': '19:20',
    },
    'Riyadh': {
      'Fajr': '04:50',
      'Dhuhr': '12:25',
      'Asr': '15:40',
      'Maghrib': '18:10',
      'Isha': '19:25',
    },
    'Lahore': {
      'Fajr': '05:00',
      'Dhuhr': '12:30',
      'Asr': '15:45',
      'Maghrib': '18:15',
      'Isha': '19:30',
    },
    'Karachi': {
      'Fajr': '04:50',
      'Dhuhr': '12:20',
      'Asr': '15:35',
      'Maghrib': '18:05',
      'Isha': '19:20',
    },
    'Islamabad': {
      'Fajr': '05:05',
      'Dhuhr': '12:35',
      'Asr': '15:50',
      'Maghrib': '18:20',
      'Isha': '19:35',
    },
  };

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  Future<void> initSetup() async {
    await _requestPermissions();
    await initNotifications();
    await loadSavedPreferences();
    await fetchPrayerTimes();
    await loadCustomReminders();
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
    await Permission.notification.request();
    await Permission.storage.request();
  }

  /// =================== NOTIFICATIONS ===================
  Future<void> initNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (details.actionId == 'STOP_RING') {
          await stopSound();
          return;
        }

        if (soundType == 'custom' && customSoundPath != null) {
          await player.stop();
          await player.play(DeviceFileSource(customSoundPath!), volume: 1.0);
        }
      },
    );

    const defaultAzanChannel = AndroidNotificationChannel(
      'default_azan_channel',
      'Prayer Reminders',
      description: 'Default Azan notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('azan'),
    );

    const silentChannel = AndroidNotificationChannel(
      'silent_channel',
      'Silent Reminders',
      description: 'Notifications without sound, custom AudioPlayer will play',
      importance: Importance.high,
      playSound: false,
    );

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(defaultAzanChannel);
      await androidPlugin.createNotificationChannel(silentChannel);
    }
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime date) async {
    if (date.isBefore(DateTime.now())) return;

    final isCustomSoundSet = (soundType == 'custom' && customSoundPath != null);

    final androidDetails = AndroidNotificationDetails(
      isCustomSoundSet ? 'silent_channel' : 'default_azan_channel',
      'Prayer Reminders',
      channelDescription: isCustomSoundSet
          ? 'Silent notifications, AudioPlayer plays custom sound'
          : 'Default Azan notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: !isCustomSoundSet,
      sound: !isCustomSoundSet
          ? RawResourceAndroidNotificationSound('azan')
          : null,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'STOP_RING',
          'Stop',
          showsUserInterface: true,
        ),
      ],
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      date.hashCode,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    if (isCustomSoundSet) {
      final delay = date.difference(DateTime.now());
      if (delay.inSeconds > 0) {
        Future.delayed(delay, () async {
          if (!mounted) return;
          try {
            await player.stop();
            await player.play(DeviceFileSource(customSoundPath!), volume: 1.0);

            await flutterLocalNotificationsPlugin.show(
              date.hashCode,
              title,
              body,
              notificationDetails,
            );
          } catch (e) {
            debugPrint('❌ Custom sound playback failed: $e');
          }
        });
      }
    }
  }

  Future<void> stopSound() async {
    try {
      await player.stop();
    } catch (e) {
      debugPrint('❌ Stop sound failed: $e');
    }
  }

  /// =================== FETCH PRAYER TIMES WITH OFFLINE SUPPORT ===================
  Future<void> fetchPrayerTimes() async {
    setState(() {
      loading = true;
      error = '';
    });

    final prefs = await SharedPreferences.getInstance();

    try {
      Uri url;
      if (selectedCity == 'Current Location') {
        final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        url = Uri.parse(
            'https://api.aladhan.com/v1/timings?latitude=${pos.latitude}&longitude=${pos.longitude}&method=2');
      } else {
        url = Uri.parse(
            'https://api.aladhan.com/v1/timingsByCity?city=$selectedCity&country=Saudi%20Arabia&method=2');
      }

      final res = await http.get(url);
      if (res.statusCode != 200) throw Exception('Failed to fetch timings');

      final data = json.decode(res.body);
      final timings = Map<String, String>.from(data['data']['timings']);
      timings.removeWhere((k, _) => ['Sunrise', 'Imsak', 'Midnight'].contains(k));

      setState(() {
        prayerTimes = timings;
        loading = false;
        error = '';
      });

      await prefs.setString(
          'saved_prayer_times_$selectedCity', json.encode(timings));
    } catch (e) {
      debugPrint('❌ Fetch prayer times failed: $e');

      final saved = prefs.getString('saved_prayer_times_$selectedCity');
      if (saved != null) {
        setState(() {
          prayerTimes = Map<String, String>.from(json.decode(saved));
          loading = false;
          error = 'No internet — showing last saved prayer times';
        });
        return;
      }

      if (defaultPrayerTimes.containsKey(selectedCity)) {
        setState(() {
          prayerTimes = defaultPrayerTimes[selectedCity]!;
          loading = false;
          error = 'No internet — showing default prayer times';
        });
        return;
      }

      setState(() {
        prayerTimes = {};
        loading = false;
        error = 'No internet and no prayer times available';
      });
    }
  }

  /// =================== LOAD / SAVE SETTINGS ===================
  Future<void> loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (var key in keys) {
      reminderStatus[key] = prefs.getBool('reminder_$key') ?? false;
    }

    minutesBeforePrayer = prefs.getInt('minutes_before') ?? 0;
    soundType = prefs.getString('sound_type') ?? 'default';
    customSoundPath = prefs.getString('custom_sound_path');
    selectedCity = prefs.getString('selected_city') ?? 'Current Location';
  }

  Future<void> saveCustomSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('minutes_before', minutesBeforePrayer);
    await prefs.setString('sound_type', soundType);
    if (customSoundPath != null) await prefs.setString('custom_sound_path', customSoundPath!);
    await prefs.setString('selected_city', selectedCity);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// =================== PICK CUSTOM SOUND ===================
  Future<void> pickCustomSound() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      customSoundPath = result.files.single.path!;
      soundType = 'custom';
      await saveCustomSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Custom sound selected:\n$customSoundPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ No sound selected')),
      );
    }
  }

  /// =================== CUSTOM REMINDERS ===================
  Future<void> loadCustomReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('custom_reminders') ?? [];
    customReminders =
        savedList.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    setState(() {});
  }

  Future<void> saveCustomReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = customReminders.map((e) => json.encode(e)).toList();
    await prefs.setStringList('custom_reminders', encoded);
  }

  Future<void> addCustomReminder(String title, TimeOfDay time) async {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    final reminder = {
      'id': date.hashCode,
      'title': title,
      'time': time.format(context),
    };

    customReminders.add(reminder);
    await saveCustomReminders();
    await scheduleNotification(
        '🔔 Reminder: $title', 'It’s time for your reminder!', date);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Reminder set for ${time.format(context)}')),
    );
    setState(() {});
  }

  Future<void> deleteCustomReminder(Map<String, dynamic> reminder) async {
    customReminders.remove(reminder);
    await saveCustomReminders();
    await cancelNotification(reminder['id']);
    setState(() {});
  }

  void _showAddCustomReminderDialog() {
    TextEditingController titleController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Custom Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                  const InputDecoration(labelText: 'Reminder Title'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(selectedTime == null
                      ? 'Pick Time'
                      : selectedTime!.format(context)),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setDialogState(() => selectedTime = picked);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && selectedTime != null) {
                    addCustomReminder(
                        titleController.text.trim(), selectedTime!);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// =================== UI ===================
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Prayer & Custom Reminders'),
  //       centerTitle: true,
  //       actions: [
  //         IconButton(icon: const Icon(Icons.refresh), onPressed: fetchPrayerTimes)
  //       ],
  //     ),
  //     bottomNavigationBar: const BottomNavigation(index: 3),
  //     body: loading
  //         ? const Center(child: CircularProgressIndicator())
  //         : ListView(
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         if (error.isNotEmpty)
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 8),
  //             child: Text(
  //               error,
  //               style: const TextStyle(
  //                   color: Colors.orange, fontWeight: FontWeight.bold),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         const Text(
  //           'Today’s Prayer Times',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Icon(Icons.location_on),
  //             const SizedBox(width: 8),
  //             DropdownButton<String>(
  //               value: selectedCity,
  //               items: cities
  //                   .map((city) =>
  //                   DropdownMenuItem(value: city, child: Text(city)))
  //                   .toList(),
  //               onChanged: (value) async {
  //                 if (value != null) {
  //                   setState(() => selectedCity = value);
  //                   await saveCustomSettings();
  //                   await fetchPrayerTimes();
  //                 }
  //               },
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         ...prayerTimes.entries.map((e) {
  //           final isEnabled = reminderStatus[e.key] ?? false;
  //           return Card(
  //             elevation: 3,
  //             margin: const EdgeInsets.symmetric(vertical: 6),
  //             child: ListTile(
  //               leading: const Icon(Icons.access_time),
  //               title: Text(e.key,
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.bold, fontSize: 16)),
  //               subtitle: Text(e.value),
  //               trailing: Switch(
  //                 value: isEnabled,
  //                 onChanged: (value) async {
  //                   setState(() => reminderStatus[e.key] = value);
  //                   final prefs = await SharedPreferences.getInstance();
  //                   await prefs.setBool('reminder_${e.key}', value);
  //
  //                   if (value) {
  //                     final dateFormat = DateFormat('HH:mm');
  //                     final parsedTime = dateFormat.parse(e.value);
  //                     final now = DateTime.now();
  //                     final date = DateTime(
  //                       now.year,
  //                       now.month,
  //                       now.day,
  //                       parsedTime.hour,
  //                       parsedTime.minute,
  //                     ).subtract(Duration(minutes: minutesBeforePrayer));
  //
  //                     await scheduleNotification(
  //                       '🕌 ${e.key} Prayer Reminder',
  //                       minutesBeforePrayer == 0
  //                           ? "It's time for ${e.key} prayer."
  //                           : "$minutesBeforePrayer min left for ${e.key} prayer.",
  //                       date,
  //                     );
  //                   } else {
  //                     await cancelNotification(e.key.hashCode);
  //                   }
  //                 },
  //               ),
  //             ),
  //           );
  //         }),
  //         const Divider(height: 32),
  //         const Text(
  //           '⏰ Custom Reminders',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 10),
  //         ...customReminders.map((r) => Card(
  //           child: ListTile(
  //             title: Text(r['title']),
  //             subtitle: Text('Time: ${r['time']}'),
  //             trailing: IconButton(
  //               icon: const Icon(Icons.delete, color: Colors.red),
  //               onPressed: () => deleteCustomReminder(r),
  //             ),
  //           ),
  //         )),
  //         const SizedBox(height: 10),
  //         ElevatedButton.icon(
  //             icon: const Icon(Icons.add_alarm),
  //             label: const Text('Add Custom Reminder'),
  //             onPressed: _showAddCustomReminderDialog),
  //         const SizedBox(height: 10),
  //         ElevatedButton.icon(
  //             icon: const Icon(Icons.music_note),
  //             label: const Text('Select Custom Sound'),
  //             onPressed: pickCustomSound),
  //         const SizedBox(height: 10),
  //         ElevatedButton.icon(
  //           icon: const Icon(Icons.stop),
  //           label: const Text('Stop Ringtone'),
  //           onPressed: stopSound,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.softBeige,
      appBar: AppBar(
        title: const Text('Prayer & Reminders'),
        centerTitle: true,
        backgroundColor: AppColor.emeraldGreen,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPrayerTimes,
            tooltip: 'Refresh Prayer Times',
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(index: 3),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: AppColor.emeraldGreen))
          : RefreshIndicator(
        onRefresh: fetchPrayerTimes,
        color: AppColor.emeraldGreen,
        backgroundColor: AppColor.whiteCream,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Error / Offline Message
            if (error.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColor.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.gold),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColor.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        error,
                        style: const TextStyle(
                            color: AppColor.gold, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // City Selector
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColor.emeraldGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedCity,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: cities
                            .map((city) =>
                            DropdownMenuItem(value: city, child: Text(city)))
                            .toList(),
                        onChanged: (value) async {
                          if (value != null) {
                            setState(() => selectedCity = value);
                            await saveCustomSettings();
                            await fetchPrayerTimes();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Header
            const Center(
              child: Text(
                'Today’s Prayer Times',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.emeraldGreen),
              ),
            ),
            const SizedBox(height: 16),

            // Prayer Time Cards with Gradient
            ...prayerTimes.entries.map((e) {
              final isEnabled = reminderStatus[e.key] ?? false;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [AppColor.emeraldGreen.withOpacity(0.2), AppColor.softBeige],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.deepCharcoal.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColor.emeraldGreen.withOpacity(0.2),
                    child: const Icon(Icons.access_time, color: AppColor.emeraldGreen),
                  ),
                  title: Text(e.key,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.deepCharcoal)),
                  subtitle: Text(e.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14, color: AppColor.deepCharcoal)),
                  trailing: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Switch(
                      key: ValueKey(isEnabled),
                      activeColor: AppColor.emeraldGreen,
                      value: isEnabled,
                      onChanged: (value) async {
                        setState(() => reminderStatus[e.key] = value);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('reminder_${e.key}', value);

                        if (value) {
                          final dateFormat = DateFormat('HH:mm');
                          final parsedTime = dateFormat.parse(e.value);
                          final now = DateTime.now();
                          final date = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            parsedTime.hour,
                            parsedTime.minute,
                          ).subtract(Duration(minutes: minutesBeforePrayer));

                          await scheduleNotification(
                            '🕌 ${e.key} Prayer Reminder',
                            minutesBeforePrayer == 0
                                ? "It's time for ${e.key} prayer."
                                : "$minutesBeforePrayer min left for ${e.key} prayer.",
                            date,
                          );
                        } else {
                          await cancelNotification(e.key.hashCode);
                        }
                      },
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            const Text(
              'Custom Reminders',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.emeraldGreen),
            ),
            const SizedBox(height: 16),

            // Custom Reminders Cards
            ...customReminders.map((r) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.whiteCream,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.deepCharcoal.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColor.emeraldGreen.withOpacity(0.2),
                  child: const Icon(Icons.alarm, color: AppColor.emeraldGreen),
                ),
                title: Text(r['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.deepCharcoal)),
                subtitle: Text('Time: ${r['time']}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColor.deepCharcoal)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: AppColor.error),
                  onPressed: () => deleteCustomReminder(r),
                ),
              ),
            )),

            const SizedBox(height: 20),

            // Action Buttons with modern style
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.emeraldGreen,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    icon: const Icon(Icons.add_alarm),
                    label: const Text('Add Reminder'),
                    onPressed: _showAddCustomReminderDialog),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.emeraldGreen,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    icon: const Icon(Icons.music_note),
                    label: const Text('Custom Sound'),
                    onPressed: pickCustomSound),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Sound'),
                    onPressed: stopSound),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }


}
