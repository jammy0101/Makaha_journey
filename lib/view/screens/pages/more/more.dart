
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
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
      'Prayer Reminders'.tr,
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
          error = 'No internet — showing last saved prayer times'.tr;
        });
        return;
      }

      if (defaultPrayerTimes.containsKey(selectedCity)) {
        setState(() {
          prayerTimes = defaultPrayerTimes[selectedCity]!;
          loading = false;
          error = 'No internet — showing default prayer times'.tr;
        });
        return;
      }

      setState(() {
        prayerTimes = {};
        loading = false;
        error = 'No internet and no prayer times available'.tr;
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
         SnackBar(content: Text('❌ No sound selected'.tr)),
      );
    }
  }

  /// =================== CUSTOM REMINDERS ===================
  Future<void> loadCustomReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('custom_reminders'.tr) ?? [];
    customReminders =
        savedList.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    setState(() {});
  }

  Future<void> saveCustomReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = customReminders.map((e) => json.encode(e)).toList();
    await prefs.setStringList('custom_reminders'.tr, encoded);
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
            title:  Text('Add Custom Reminder'.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                   InputDecoration(labelText: 'Reminder Title'.tr),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(selectedTime == null
                      ? 'Pick Time'.tr
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
                  child:  Text('Cancel'.tr)),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && selectedTime != null) {
                    addCustomReminder(
                        titleController.text.trim(), selectedTime!);
                    Navigator.pop(context);
                  }
                },
                child:  Text('Save'.tr),
              ),
            ],
          );
        },
      ),
    );
  }

  /// =================== UI ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.softBeige,
      appBar: AppBar(
        title:  Text('Prayer & Reminders'.tr),
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
             Center(
              child: Text(
                'Today’s Prayer Times'.tr,
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

             Text(
              'Custom Reminders'.tr,
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
                    label:  Text('Add Reminder'.tr),
                    onPressed: _showAddCustomReminderDialog),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.emeraldGreen,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    icon: const Icon(Icons.music_note),
                    label:  Text('Custom Sound'.tr),
                    onPressed: pickCustomSound),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    icon: const Icon(Icons.stop),
                    label:  Text('Stop Sound'.tr),
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
