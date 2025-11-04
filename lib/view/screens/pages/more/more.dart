//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
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
//   String selectedCity = 'Current Location';
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
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
//   Future<void> initSetup() async {
//     await _requestPermissions();
//     await initNotifications();
//     await loadSavedPreferences();
//     await fetchPrayerTimes();
//     await loadCustomReminders();
//   }
//
//   Future<void> _requestPermissions() async {
//     if (await Permission.location.isDenied) {
//       await Permission.location.request();
//     }
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//   }
//
//   Future<void> initNotifications() async {
//     tz.initializeTimeZones();
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }
//
//   // =====================================================
//   // 📍 FETCH PRAYER TIMES
//   // =====================================================
//   Future<void> fetchPrayerTimes() async {
//     try {
//       setState(() => loading = true);
//
//       late Uri url;
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
//       final data = json.decode(res.body);
//
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
//   // =====================================================
//   // 💾 SAVE + LOAD SETTINGS
//   // =====================================================
//   Future<void> loadSavedPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     final keys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
//     for (var key in keys) {
//       reminderStatus[key] = prefs.getBool('reminder_$key') ?? false;
//     }
//
//     minutesBeforePrayer = prefs.getInt('minutes_before') ?? 0;
//     soundType = prefs.getString('sound_type') ?? 'default';
//     selectedCity = prefs.getString('selected_city') ?? 'Current Location';
//   }
//
//   Future<void> savePreference(String key, bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('reminder_$key', value);
//   }
//
//   Future<void> saveCustomSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('minutes_before', minutesBeforePrayer);
//     await prefs.setString('sound_type', soundType);
//     await prefs.setString('selected_city', selectedCity);
//   }
//
//   // =====================================================
//   // 🔔 NOTIFICATION LOGIC
//   // =====================================================
//   Future<void> scheduleNotification(String title, String body, DateTime date) async {
//     if (date.isBefore(DateTime.now())) return;
//
//     final androidDetails = AndroidNotificationDetails(
//       'custom_channel',
//       'Reminders',
//       channelDescription: 'Prayer and custom reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: soundType != 'silent',
//     );
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       date.hashCode,
//       title,
//       body,
//       tz.TZDateTime.from(date, tz.local),
//       NotificationDetails(android: androidDetails),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//   // =====================================================
//   // 📅 CUSTOM REMINDERS (Add / Load / Delete)
//   // =====================================================
//   Future<void> loadCustomReminders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedList = prefs.getStringList('custom_reminders') ?? [];
//     customReminders = savedList
//         .map((e) => json.decode(e) as Map<String, dynamic>)
//         .toList();
//     setState(() {});
//   }
//
//
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
//
//     await scheduleNotification('🔔 Reminder: $title',
//         'It’s time for your reminder!', date);
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
//       builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
//         return AlertDialog(
//           title: const Text('Add Custom Reminder'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration:
//                 const InputDecoration(labelText: 'Reminder Title'),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.access_time),
//                 label: Text(selectedTime == null
//                     ? 'Pick Time'
//                     : selectedTime!.format(context)),
//                 onPressed: () async {
//                   final picked = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (picked != null) {
//                     setDialogState(() => selectedTime = picked);
//                   }
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel')),
//             ElevatedButton(
//               onPressed: () {
//                 if (titleController.text.isNotEmpty && selectedTime != null) {
//                   addCustomReminder(
//                       titleController.text.trim(), selectedTime!);
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   // =====================================================
//   // 🧭 UI
//   // =====================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Prayer & Custom Reminders'),
//         centerTitle: true,
//         actions: [
//           //IconButton(icon: const Icon(Icons.settings), onPressed: _showCustomizationDialog),
//           IconButton(icon: const Icon(Icons.refresh), onPressed: fetchPrayerTimes),
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
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//
//           // 🌍 Location dropdown
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.location_on),
//               const SizedBox(width: 8),
//               DropdownButton<String>(
//                 value: selectedCity,
//                 items: cities
//                     .map((city) => DropdownMenuItem(
//                   value: city,
//                   child: Text(city),
//                 ))
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
//
//           const SizedBox(height: 16),
//
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
//                     await savePreference(e.key, value);
//
//                     if (value) {
//                       final dateFormat = DateFormat('HH:mm');
//                       final parsedTime =
//                       dateFormat.parse(e.value);
//                       final now = DateTime.now();
//                       final date = DateTime(
//                         now.year,
//                         now.month,
//                         now.day,
//                         parsedTime.hour,
//                         parsedTime.minute,
//                       ).subtract(Duration(minutes: minutesBeforePrayer));
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
//
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
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () => deleteCustomReminder(r),
//               ),
//             ),
//           )),
//           const SizedBox(height: 10),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.add_alarm),
//             label: const Text('Add Custom Reminder'),
//             onPressed: _showAddCustomReminderDialog,
//           ),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.music_note),
//             label: const Text('Select Custom Sound'),
//             onPressed: pickCustomSound,
//           ),
//         ],
//       ),
//
//     );
//
//   }
//
//
//
//
//
// }
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';

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

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  // =====================================================
  // ⚙️ INITIAL SETUP
  // =====================================================
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
  }

  Future<void> initNotifications() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // =====================================================
  // 🌍 FETCH PRAYER TIMES
  // =====================================================
  Future<void> fetchPrayerTimes() async {
    try {
      setState(() => loading = true);

      late Uri url;
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
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  // =====================================================
  // 💾 SAVE + LOAD SETTINGS
  // =====================================================
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

  Future<void> savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_$key', value);
  }

  Future<void> saveCustomSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('minutes_before', minutesBeforePrayer);
    await prefs.setString('sound_type', soundType);
    if (customSoundPath != null) {
      await prefs.setString('custom_sound_path', customSoundPath!);
    }
    await prefs.setString('selected_city', selectedCity);
  }


  Future<void> scheduleNotification(String title, String body, DateTime date) async {
    if (date.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      'custom_channel',
      'Reminders',
      channelDescription: 'Prayer and custom reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false, // turn off default sound
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      date.hashCode,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Schedule the audio manually using a delayed Future
    Future.delayed(date.difference(DateTime.now()), () async {
      if (customSoundPath != null) {
        final player = AudioPlayer();
        await player.play(DeviceFileSource(customSoundPath!));
      }
    });
  }


  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // =====================================================
  // 🎵 PICK CUSTOM SOUND
  // =====================================================
  Future<void> pickCustomSound() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        customSoundPath = result.files.single.path!;
        soundType = 'custom';
      });
      await saveCustomSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Custom sound selected successfully!')),
      );
    }
  }

  // =====================================================
  // 📅 CUSTOM REMINDERS (Add / Load / Delete)
  // =====================================================
  Future<void> loadCustomReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('custom_reminders') ?? [];
    customReminders = savedList.map((e) => json.decode(e) as Map<String, dynamic>).toList();
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
    await scheduleNotification('🔔 Reminder: $title', 'It’s time for your reminder!', date);

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
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Add Custom Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Reminder Title'),
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
                  if (picked != null) {
                    setDialogState(() => selectedTime = picked);
                  }
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
                  addCustomReminder(titleController.text.trim(), selectedTime!);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      }),
    );
  }

  // =====================================================
  // 🧭 UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer & Custom Reminders'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchPrayerTimes),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(index: 3),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text('Error: $error'))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Today’s Prayer Times',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 🌍 Location dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedCity,
                items: cities
                    .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                ))
                    .toList(),
                onChanged: (value) async {
                  if (value != null) {
                    setState(() => selectedCity = value);
                    await saveCustomSettings();
                    await fetchPrayerTimes();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 🕌 Prayer times list
          ...prayerTimes.entries.map((e) {
            final isEnabled = reminderStatus[e.key] ?? false;
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(e.key,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(e.value),
                trailing: Switch(
                  value: isEnabled,
                  onChanged: (value) async {
                    setState(() => reminderStatus[e.key] = value);
                    await savePreference(e.key, value);

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
            );
          }),

          const Divider(height: 32),
          const Text(
            '⏰ Custom Reminders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...customReminders.map((r) => Card(
            child: ListTile(
              title: Text(r['title']),
              subtitle: Text('Time: ${r['time']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteCustomReminder(r),
              ),
            ),
          )),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_alarm),
            label: const Text('Add Custom Reminder'),
            onPressed: _showAddCustomReminderDialog,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.music_note),
            label: const Text('Select Custom Sound'),
            onPressed: pickCustomSound,
          ),
        ],
      ),
    );
  }
}
