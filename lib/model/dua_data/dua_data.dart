
import '../dua_model/dua_model.dart';
import '../step_items/step_items.dart';

class DuaData {
  // ────────────────────────────── UMRAH DUAS ──────────────────────────────
  static Future<List<DuaModel>> fetchUmrahDuas() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      DuaModel(
        title: 'Preparation of the Day of Travelling',
        imagePath: 'assets/images/flight.jpeg',
        intro:
            'Quick checklist and step-by-step guidance to prepare for Umrah before you depart.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make the Intention (Niyyah)',
            subtitle:
                'Sincerely intend in your heart that you are going for Umrah for Allah’s sake.',
            extraNote: 'Niyyah is internal — no prescribed words required.',
          ),
          StepItem(
            order: 2,
            title: 'Pack Ihram and Essentials',
            subtitle:
                'Pack Ihram garments, comfortable shoes, travel documents, medicines and a copy of dua cards.',
          ),
          StepItem(
            order: 3,
            title: 'Perform Wudu before entering Miqat',
            subtitle:
                'Be in a state of ritual purity before assuming Ihram if possible.',
          ),
          StepItem(
            order: 4,
            title: 'Enter the state of Ihram (at Miqat)',
            subtitle:
                'Wear Ihram, say intention for Umrah (e.g., "Labbaik Allahumma Umrah") and avoid prohibited things.',
          ),
          StepItem(
            order: 5,
            title: 'Travel to Makkah & Begin Tawaf',
            subtitle:
                'On arrival to Masjid al-Haram, begin Tawaf from the Black Stone and perform 7 circuits.',
          ),
        ],
      ),
      DuaModel(
        title: 'Intention for Umrah',
        imagePath: 'assets/images/intention.png',
        intro:
            'Simple steps and sample wording to make your intention and enter Ihram correctly.',
        steps: [
          StepItem(
            order: 1,
            title: 'Approach the Miqat',
            subtitle: 'Stop at the appointed boundary (Miqat).',
          ),
          StepItem(
            order: 2,
            title: 'Put on Ihram',
            subtitle:
                'Men: two white unstitched cloths; Women: modest dress as usual.',
          ),
          StepItem(
            order: 3,
            title: 'Declare your Niyyah (sample)',
            subtitle:
                'Say in heart (or softly): "O Allah, I intend to perform Umrah."',
            extraNote: 'You may say: "Labbaik Allahumma Umrah".',
          ),
        ],
      ),
      DuaModel(
        title: 'Upon Entering Makkah',
        imagePath: 'assets/images/clock.jpg',
        intro:
            'When you enter the holy city of Makkah, it is recommended to enter with humility and gratitude, reciting prayers of peace and blessings as you approach the Sacred Mosque.',
        steps: [
          StepItem(
            order: 1,
            title: 'Enter Makkah with humility',
            subtitle:
                'Keep your heart filled with reverence and gratitude for being allowed to reach this sacred place.',
          ),
          StepItem(
            order: 2,
            title: 'Recite the Talbiyah',
            subtitle:
                'As you enter, say: “Labbaik Allahumma Labbaik, Labbaik La Shareeka Laka Labbaik, Innal-Hamda Wan-Ni‘mata Laka Wal-Mulk, La Shareeka Lak.”',
          ),
          StepItem(
            order: 3,
            title: 'Pause at the city entrance',
            subtitle:
                'Upon entering, pause briefly to offer praise to Allah and send blessings upon the Prophet ﷺ.',
          ),
          StepItem(
            order: 4,
            title: 'Enter Masjid al-Haram with the right foot',
            subtitle:
                'As you approach and enter the Haram, step in with your right foot and recite the dua for entering the mosque: \n\n“Bismillah, Allahumma salli ‘ala Muhammad, Allahumma iftah li abwaba rahmatik.”',
          ),
          StepItem(
            order: 5,
            title: 'Keep eyes lowered until seeing the Ka‘bah',
            subtitle:
                'Out of respect, keep your gaze down until you are close enough to view the Ka‘bah, then look upon it with devotion and make a heartfelt dua.',
          ),
          StepItem(
            order: 6,
            title: 'Make dua upon seeing the Ka‘bah',
            subtitle:
                'When you first see the Ka‘bah, raise your hands and supplicate sincerely — it is a moment when duas are accepted.',
          ),
        ],
      ),
      DuaModel(
        title: 'Tawaf',
        imagePath: 'assets/images/tawaf.jpg',
        intro:
            'Tawaf is one of the most important rituals of Hajj and Umrah. It involves walking around the Ka‘bah seven times in a counter-clockwise direction, starting from the Black Stone. It symbolizes unity, devotion, and submission to Allah.',
        steps: [
          StepItem(
            order: 1,
            title: 'Start at the Black Stone (Hijr al-Aswad)',
            subtitle:
                'Face the Black Stone, raise your right hand, and say “Bismillah, Allahu Akbar.” If possible, touch or kiss it; otherwise, point towards it with your right hand before beginning your Tawaf.',
          ),
          StepItem(
            order: 2,
            title: 'Move counter-clockwise, reciting dhikr',
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite any dua, Quranic verses, or supplications. The best dhikr is “Subhan Allah, Alhamdulillah, La ilaha illa Allah, Allahu Akbar.”',
          ),
          StepItem(
            order: 3,
            title: 'Complete seven circuits',
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility and devotion. Men should walk briskly (ramal) during the first three circuits and normally for the last four.',
          ),
          StepItem(
            order: 4,
            title: 'Pray two rak‘ahs near Maqam Ibrahim',
            subtitle:
                'After completing seven rounds, go to Maqam Ibrahim (the Station of Abraham) and pray two rak‘ahs. In the first rak‘ah, recite Surah Al-Kafirun, and in the second, recite Surah Al-Ikhlas, if possible.',
          ),
          StepItem(
            order: 5,
            title: 'Drink Zamzam water',
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah and make dua, as this is a moment of acceptance. Supplicate for health, forgiveness, and blessings.',
          ),
          StepItem(
            order: 6,
            title: 'Proceed to Sa‘i (if performing Umrah)',
            subtitle:
                'If you are performing Umrah, continue to Safa and Marwah for the Sa‘i ritual. Otherwise, conclude your Tawaf with gratitude and prayer.',
          ),
        ],
      ),
      DuaModel(
        title: 'Prayer at Maqam-e-Ibrahim',
        imagePath: 'assets/images/maqam_ibrahim.jpeg',
        intro:
            'After completing the Tawaf, it is Sunnah to pray two rak‘ahs behind Maqam-e-Ibrahim — the place where Prophet Ibrahim (A.S.) stood while constructing the Ka‘bah. This prayer signifies gratitude, humility, and closeness to Allah after completing the sacred Tawaf.',
        steps: [
          StepItem(
            order: 1,
            title: 'Move towards Maqam-e-Ibrahim',
            subtitle:
                'After finishing your seventh circuit of Tawaf, proceed calmly towards Maqam-e-Ibrahim. Keep the Ka‘bah in front of you and Maqam-e-Ibrahim between you and the Ka‘bah if possible. Recite the verse:\n\nوَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّى\n\n“Take the place of Ibrahim as a place of prayer.” (Surah Al-Baqarah 2:125)',
          ),
          StepItem(
            order: 2,
            title: 'Perform two rak‘ahs of prayer',
            subtitle:
                'Pray two rak‘ahs of Salah behind Maqam-e-Ibrahim. In the first rak‘ah, it is Sunnah to recite Surah Al-Kafirun after Surah Al-Fatihah, and in the second rak‘ah, Surah Al-Ikhlas after Surah Al-Fatihah. Maintain serenity and humility throughout the prayer.',
          ),
          StepItem(
            order: 3,
            title: 'Make sincere dua after Salah',
            subtitle:
                'Once you finish the prayer, raise your hands in dua. Praise Allah, send salutations upon the Prophet ﷺ, and ask for forgiveness, guidance, and acceptance of your Tawaf. This is a moment when duas are highly accepted.',
          ),
          StepItem(
            order: 4,
            title: 'Drink Zamzam water',
            subtitle:
                'After completing your prayer and dua, proceed to drink Zamzam water while facing the Ka‘bah. Make a heartfelt supplication — “O Allah, grant me beneficial knowledge, wide sustenance, and healing from all illnesses.”',
          ),
        ],
      ),
      DuaModel(
        title: 'Zamzam Water',
        imagePath: 'assets/images/zamzam.jpg',
        intro:
            'Zamzam water is a blessed water from the sacred Zamzam well in Makkah. Drinking it is a Sunnah and a source of spiritual and physical blessings. It is recommended to drink with devotion, make dua, and drink in small sips.',
        steps: [
          StepItem(
            order: 1,
            title: 'Face the Qiblah',
            subtitle:
                'When drinking Zamzam water, face the Ka‘bah (Qiblah) to show reverence and focus during supplication.',
          ),
          StepItem(
            order: 2,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Make a sincere intention in your heart that you are drinking Zamzam water for Allah’s blessings, health, and guidance.',
          ),
          StepItem(
            order: 3,
            title: 'Drink in small sips',
            subtitle:
                'Take the water in small sips rather than gulping it. This is Sunnah and helps in fully receiving the spiritual and physical benefits.',
          ),
          StepItem(
            order: 4,
            title: 'Recite Bismillah before drinking',
            subtitle:
                'Say “Bismillah” (In the name of Allah) before taking each sip to remember Allah and seek His blessings.',
          ),
          StepItem(
            order: 5,
            title: 'Make dua',
            subtitle:
                'While drinking, make heartfelt supplications. Ask for health, forgiveness, guidance, sustenance, or any personal needs. It is recommended to be specific and sincere in your dua.',
          ),
          StepItem(
            order: 6,
            title: 'Thank Allah',
            subtitle:
                'After finishing, express gratitude to Allah for the blessing of Zamzam water and His mercy. Continue to make dua even after drinking.',
          ),
        ],
      ),
      DuaModel(
        title: 'Sa‘i (Safa to Marwah)',
        imagePath: 'assets/images/sai.jpg',
        intro:
            'Sa‘i is the ritual of walking seven times between the hills of Safa and Marwah. It commemorates Hajar’s search for water for her son Isma‘il and symbolizes patience, devotion, and trust in Allah. Men are encouraged to run lightly (ramal) between the two markers in the first three circuits.',
        steps: [
          StepItem(
            order: 1,
            title: 'Start at Safa',
            subtitle:
                'Face the Ka‘bah, make intention (Niyyah) for Sa‘i, and start from the hill of Safa.',
          ),
          StepItem(
            order: 2,
            title: 'Recite dhikr while moving',
            subtitle:
                'While walking or lightly running, recite supplications, Quranic verses, or dhikr. Common dhikr includes “Rabbighfir warham wa anta khayrur rahimeen.”',
          ),
          StepItem(
            order: 3,
            title: 'Run lightly between the markers',
            subtitle:
                'Men should lightly run (ramal) between the two green markers (known as Raml area) during the first three circuits. Women walk normally throughout.',
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits',
            subtitle:
                'Each round begins at Safa and ends at Marwah (or vice versa). Complete seven circuits in total, keeping devotion and focus on Allah.',
          ),
          StepItem(
            order: 5,
            title: 'Make dua throughout',
            subtitle:
                'Supplicate for your needs, forgiveness, guidance, and blessings. Sa‘i is a time to pray earnestly and with humility.',
          ),
          StepItem(
            order: 6,
            title: 'Conclude at Marwah',
            subtitle:
                'After the seventh circuit, conclude your Sa‘i with gratitude, prayers, and remembrance of Allah’s mercy and guidance.',
          ),
        ],
      ),
      DuaModel(
        title: 'Halq or Taqsir (Shaving or Trimming Hair)',
        imagePath: 'assets/images/halk.jpg',
        intro:
            'Halq (shaving the head) or Taqsir (trimming the hair) is the final ritual of Hajj and Umrah. It symbolizes purification, humility, and the completion of the pilgrimage. Men usually shave their heads (Halq), while women trim a small portion of their hair (Taqsir).',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before shaving or trimming, make a sincere intention in your heart that this act is for Allah, completing your Hajj or Umrah rituals.',
          ),
          StepItem(
            order: 2,
            title: 'Choose Halq or Taqsir',
            subtitle:
                'Men typically perform Halq (shaving the entire head) while women perform Taqsir (trimming a small portion of hair). Ensure you follow the correct practice for your gender.',
          ),
          StepItem(
            order: 3,
            title: 'Recite Bismillah before starting',
            subtitle:
                'Say “Bismillah” (In the name of Allah) before shaving or trimming, remembering Allah and seeking His blessings.',
          ),
          StepItem(
            order: 4,
            title: 'Perform the act',
            subtitle:
                'Shave the head completely (Halq) or trim a small portion of hair (Taqsir). Ensure it is done respectfully and with focus on the spiritual significance.',
          ),
          StepItem(
            order: 5,
            title: 'Make dua after completion',
            subtitle:
                'After finishing, thank Allah for the opportunity to complete your Hajj or Umrah, and make dua for forgiveness, guidance, and blessings.',
          ),
          StepItem(
            order: 6,
            title: 'Conclude Ihram',
            subtitle:
                'After Halq or Taqsir, your state of Ihram ends. You may now wear regular clothes and continue normal activities while remaining mindful of Allah’s blessings.',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Leaving the Masjid',
        imagePath: 'assets/images/leaving.jpg',
        intro:
            'It is Sunnah to recite a specific dua when leaving the masjid. This supplication asks Allah for guidance, forgiveness, and protection, and reflects gratitude for the opportunity to pray in His house.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before leaving the masjid, have the intention in your heart to seek Allah’s blessings and protection as you depart.',
          ),
          StepItem(
            order: 2,
            title: 'Recite the dua',
            subtitle:
                'The common dua when leaving the masjid is: "Bismillah, wassalatu wassalamu ‘ala Rasulillah. Allahumma aftah li abwaba rahmatik." (In the name of Allah, peace and blessings be upon the Messenger of Allah. O Allah, open for me the doors of Your mercy.)',
          ),
          StepItem(
            order: 3,
            title: 'Step out with your right foot',
            subtitle:
                'It is Sunnah to exit the masjid with the right foot first as a sign of respect and following the Prophet’s practice (Sunnah).',
          ),
          StepItem(
            order: 4,
            title: 'Make personal dua',
            subtitle:
                'After reciting the prescribed dua, you may supplicate for personal needs, protection, guidance, and forgiveness.',
          ),
          StepItem(
            order: 5,
            title: 'Leave with humility and mindfulness',
            subtitle:
                'Depart the masjid with a humble heart, maintaining the spiritual awareness and blessings obtained during your visit.',
          ),
        ],
      ),
      DuaModel(
        title: 'Nafl Tawaf',
        imagePath: 'assets/images/nafle_tawaf.jpg',
        intro:
            'Nafl Tawaf is a voluntary circumambulation of the Ka‘bah performed outside of obligatory Tawaf during Hajj or Umrah. It is a highly rewarding act of worship, expressing devotion, humility, and love for Allah.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before starting Nafl Tawaf, make a sincere intention in your heart that you are performing this act for Allah alone.',
          ),
          StepItem(
            order: 2,
            title: 'Start at the Black Stone (Hijr al-Aswad)',
            subtitle:
                'Face the Black Stone, raise your right hand, and say “Bismillah, Allahu Akbar.” If possible, touch or kiss it; otherwise, point towards it with your right hand.',
          ),
          StepItem(
            order: 3,
            title: 'Move counter-clockwise, reciting dhikr',
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite dhikr, Quranic verses, or supplications. Common dhikr includes: “Subhan Allah, Alhamdulillah, La ilaha illa Allah, Allahu Akbar.”',
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits',
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility, focus, and devotion throughout the Tawaf.',
          ),
          StepItem(
            order: 5,
            title: 'Pray two rak‘ahs near Maqam Ibrahim',
            subtitle:
                'After completing the seven circuits, go to Maqam Ibrahim and pray two rak‘ahs, reciting Surah Al-Kafirun in the first and Surah Al-Ikhlas in the second, if possible.',
          ),
          StepItem(
            order: 6,
            title: 'Drink Zamzam water and make dua',
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah and make heartfelt supplications for forgiveness, guidance, and blessings.',
          ),
        ],
      ),
      DuaModel(
        title: 'Etiquettes of Entering Masjid al-Nabawi',
        imagePath: 'assets/images/visit.jpg',
        intro:
            'When entering Masjid al-Nabawi, there are specific etiquettes to follow. These actions reflect respect, humility, and mindfulness of Allah’s presence.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before entering the masjid, make a sincere intention in your heart that you are entering to worship Allah and seek His pleasure.',
          ),
          StepItem(
            order: 2,
            title: 'Enter with the right foot first',
            subtitle:
                'Follow the Sunnah of the Prophet (peace be upon him) by entering the masjid with your right foot, showing respect and mindfulness.',
          ),
          StepItem(
            order: 3,
            title: 'Recite the entry dua',
            subtitle:
                'While entering, recite: "Bismillah, wassalatu wassalamu ‘ala Rasulillah. Allahumma aftah li abwaba rahmatik." (In the name of Allah, peace and blessings be upon the Messenger of Allah. O Allah, open for me the doors of Your mercy.)',
          ),
          StepItem(
            order: 4,
            title: 'Maintain humility and silence',
            subtitle:
                'Walk calmly, avoid unnecessary talking, and be conscious of others in the masjid. Focus on your worship and reflection.',
          ),
          StepItem(
            order: 5,
            title: 'Perform voluntary prayers (Nafl)',
            subtitle:
                'After entering, you may perform voluntary prayers, sit quietly for dhikr, or recite Quran, following the etiquette of the Prophet (peace be upon him).',
          ),
          StepItem(
            order: 6,
            title: 'Respect the sacred areas',
            subtitle:
                'Avoid stepping over prayer lines, maintain cleanliness, and show reverence, especially near the Rawdah and Prophet’s grave area.',
          ),
        ],
      ),
      DuaModel(
        title: 'Visiting the Blessed Grave',
        imagePath: 'assets/images/grave.jpeg',
        intro:
            'Visiting the Blessed Grave of Prophet Muhammad (peace be upon him) is a recommended act of devotion. It is an opportunity to send salutations upon the Prophet, make dua, and reflect on one’s faith and deeds.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before visiting, make a sincere intention in your heart that you are coming to seek blessings, send salutations upon the Prophet, and supplicate to Allah.',
          ),
          StepItem(
            order: 2,
            title: 'Enter with the right foot first',
            subtitle:
                'Follow the Sunnah by entering the area with your right foot, demonstrating respect and mindfulness.',
          ),
          StepItem(
            order: 3,
            title: 'Send salutations upon the Prophet',
            subtitle:
                'Recite: "Assalamu ‘alaika ya Rasul Allah, wa rahmatullahi wa barakatuh." (Peace be upon you, O Messenger of Allah, and Allah’s mercy and blessings). You may also make personal salutations and prayers.',
          ),
          StepItem(
            order: 4,
            title: 'Make personal dua',
            subtitle:
                'Supplicate sincerely for forgiveness, guidance, health, and blessings. Speak to Allah with humility and devotion.',
          ),
          StepItem(
            order: 5,
            title: 'Maintain silence and respect',
            subtitle:
                'Avoid loud conversations, keep modest behavior, and respect the sanctity of the grave and surrounding areas.',
          ),
          StepItem(
            order: 6,
            title: 'Exit respectfully',
            subtitle:
                'Leave with the left foot first (following etiquette for exiting sacred areas) and continue to send salutations upon the Prophet as you depart.',
          ),
        ],
      ),
      DuaModel(
        title: 'Salat al-Janazah (Funeral Prayer)',
        imagePath: 'assets/images/feneral.jpg',
        intro:
            'Salat al-Janazah is the Islamic funeral prayer offered for the deceased. It is a communal obligation (Fard Kifayah) and a means of asking Allah for forgiveness, mercy, and blessings for the deceased.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before starting, make a sincere intention in your heart that you are performing Salat al-Janazah for the sake of Allah and seeking forgiveness for the deceased.',
          ),
          StepItem(
            order: 2,
            title: 'Stand in rows behind the imam',
            subtitle:
                'Join the congregation in straight rows, ensuring your shoulders align with others. Men stand behind the imam; women can attend in a separate area if available.',
          ),
          StepItem(
            order: 3,
            title: 'Takbir and opening supplication',
            subtitle:
                'Say "Allahu Akbar" (Takbir) and raise your hands, then recite silently: "Subhanaka Allahumma wa bihamdika, wa tabaarakasmuka, wa ta‘ala jadduka, wa la ilaha ghayruka."',
          ),
          StepItem(
            order: 4,
            title: 'Recite Al-Fatiha',
            subtitle:
                'After the second Takbir, recite Surah Al-Fatiha silently, seeking Allah’s mercy and blessings for the deceased.',
          ),
          StepItem(
            order: 5,
            title: 'Make dua for the deceased',
            subtitle:
                'After the third Takbir, raise your hands and supplicate for the deceased, asking Allah to forgive, have mercy, and grant them paradise. You may also make general dua for all believers.',
          ),
          StepItem(
            order: 6,
            title: 'Final Takbir and Salam',
            subtitle:
                'After the fourth Takbir, conclude the prayer by saying the Salam to the right (Assalamu Alaikum wa Rahmatullah). The funeral prayer is now complete.',
          ),
        ],
      ),
    ];
  }

  // ────────────────────────────── HAJJ DUAS ──────────────────────────────
  static Future<List<DuaModel>> fetchHajjDuas() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      DuaModel(
        title: '8th of Dhul Hijjah – The Day of Quenching (Yawm at-Tarwiyah)',
        imagePath: 'assets/images/mina.jpg',
        intro:
            'The 8th of Dhul Hijjah is the Day of Quenching, marking the start of the main Hajj rituals. Pilgrims enter Mina, offer prayers, and prepare for the sacred rites ahead.',
        steps: [
          StepItem(
            order: 1,
            title: 'Enter the state of Ihram (if not already in it)',
            subtitle:
                'Ensure your Ihram is worn properly, intentions are clear, and Talbiyah is being recited frequently.',
          ),
          StepItem(
            order: 2,
            title: 'Proceed to Mina',
            subtitle:
                'Travel to Mina in the morning, preferably after Fajr prayer. Walk with humility and devotion, remembering Allah along the way.',
          ),
          StepItem(
            order: 3,
            title: 'Perform Dhuhr, Asr, Maghrib, and Isha prayers in Mina',
            subtitle:
                'Offer all prayers at their prescribed times, either individually or in congregation. This is a Sunnah to stay in Mina and maintain spiritual focus.',
          ),
          StepItem(
            order: 4,
            title: 'Spend the day in devotion',
            subtitle:
                'Engage in dhikr, recite Quran, and make dua. Avoid unnecessary talk and focus on spiritual purification.',
          ),
          StepItem(
            order: 5,
            title: 'Recite Talbiyah frequently',
            subtitle:
                'Keep saying: "Labbaik Allahumma Labbaik, Labbaik La Shareeka Laka Labbaik…" to affirm your intention and devotion to Allah.',
          ),
          StepItem(
            order: 6,
            title: 'Prepare for Arafah',
            subtitle:
                'Rest and spiritually prepare for the next day, the Day of Arafah, which is the pinnacle of Hajj rituals.',
          ),
        ],
      ),
      DuaModel(
        title: "9th of Dhul Hijjah – The Day of 'Arafah",
        imagePath: 'assets/images/arafat.jpeg',
        intro:
            "The Day of ‘Arafah is the most important day of Hajj. Pilgrims gather at the plain of Arafah to stand in devotion, seeking Allah’s mercy, forgiveness, and guidance. Standing at Arafah (Wuquf) is the essence of Hajj.",
        steps: [
          StepItem(
            order: 1,
            title: 'Travel to Arafah',
            subtitle:
                'Depart from Mina to the plain of Arafah after Fajr. Arrive early to secure a place for standing in devotion (Wuquf).',
          ),
          StepItem(
            order: 2,
            title: 'Make intention (Niyyah) for Hajj at Arafah',
            subtitle:
                'Have a sincere intention in your heart that you are standing in Arafah for Allah’s pleasure and forgiveness.',
          ),
          StepItem(
            order: 3,
            title: 'Perform Dhuhr and Asr prayers',
            subtitle:
                'Pray Dhuhr and Asr combined at their respective times while standing in Arafah, as is Sunnah during Hajj.',
          ),
          StepItem(
            order: 4,
            title: 'Engage in dhikr and dua',
            subtitle:
                'Spend the day making sincere supplications, seeking forgiveness, mercy, and blessings. The Day of Arafah is a day when Allah accepts dua abundantly.',
          ),
          StepItem(
            order: 5,
            title: 'Recite Talbiyah and Quran',
            subtitle:
                'Continue reciting: "Labbaik Allahumma Labbaik…" and other dhikr. Reading Quran and sending salutations upon the Prophet is highly recommended.',
          ),
          StepItem(
            order: 6,
            title: 'Stay until sunset',
            subtitle:
                'Remain in Arafah until sunset, focusing on devotion and reflection. Leaving early is discouraged. The standing at Arafah concludes at Maghrib.',
          ),
          StepItem(
            order: 7,
            title: 'Depart to Muzdalifah after sunset',
            subtitle:
                'After sunset, depart for Muzdalifah to spend the night under the open sky, combining Maghrib and Isha prayers, and collecting pebbles for the stoning ritual.',
          ),
        ],
      ),
      DuaModel(
        title: "Night of 9th Dhul Hijjah – Muzdalifah",
        imagePath: 'assets/images/muzdalifa.png',
        intro:
            "After standing at Arafah, pilgrims travel to Muzdalifah to spend the night under the open sky. This night is a time for rest, devotion, and preparation for the stoning ritual (Ramy al-Jamarat) the next day.",
        steps: [
          StepItem(
            order: 1,
            title: 'Travel from Arafah to Muzdalifah',
            subtitle:
                'Depart from Arafah immediately after sunset and arrive at Muzdalifah, walking with humility and remembering Allah.',
          ),
          StepItem(
            order: 2,
            title: 'Combine Maghrib and Isha prayers',
            subtitle:
                'Pray Maghrib and Isha together at their respective times while at Muzdalifah, as is Sunnah during Hajj.',
          ),
          StepItem(
            order: 3,
            title: 'Collect pebbles for Ramy al-Jamarat',
            subtitle:
                'Pick 49 or 70 small pebbles (depending on the number of stoning rounds) from the ground to use the next day for the stoning of the Jamrah pillars in Mina.',
          ),
          StepItem(
            order: 4,
            title: 'Engage in dhikr and dua',
            subtitle:
                'Spend the night in supplication, seeking forgiveness, mercy, and blessings. This is a time of spiritual reflection and connection with Allah.',
          ),
          StepItem(
            order: 5,
            title: 'Rest respectfully',
            subtitle:
                'Sleep or rest lightly under the open sky, maintaining modesty and mindfulness. Avoid excessive talking or distraction from worship.',
          ),
          StepItem(
            order: 6,
            title: 'Prepare for the next day (Eid and Stoning)',
            subtitle:
                'Mentally and spiritually prepare for the 10th of Dhul Hijjah, which includes the stoning of the Jamrah and the sacrifice of Eid al-Adha.',
          ),
        ],
      ),
      DuaModel(
        title: "10th of Dhul Hijjah – The Day of Sacrifice",
        imagePath: 'assets/images/scrific.png',
        intro:
            "The 10th of Dhul Hijjah marks Eid al-Adha and the first day of stoning the Jamrah pillars in Mina. Pilgrims perform the sacrifice (Qurbani) and continue Hajj rituals, expressing devotion, obedience, and submission to Allah.",
        steps: [
          StepItem(
            order: 1,
            title: 'Fajr prayer in Mina',
            subtitle:
                'Wake early and offer the Fajr prayer in Mina, preferably in congregation, to begin the day with worship and reflection.',
          ),
          StepItem(
            order: 2,
            title: 'Stoning the Jamrah al-Aqaba (Ramy al-Jamarat)',
            subtitle:
                'Throw seven pebbles at the largest Jamrah (Jamrah al-Aqaba) in Mina, starting with the right hand, while saying: "Allahu Akbar" with each pebble.',
          ),
          StepItem(
            order: 3,
            title: 'Sacrifice (Qurbani / Udhiya)',
            subtitle:
                'Perform the ritual animal sacrifice to commemorate Prophet Ibrahim’s obedience. This can be done personally or through authorized agencies if outside the Haram.',
          ),
          StepItem(
            order: 4,
            title: 'Halq or Taqsir (Shaving or Trimming Hair)',
            subtitle:
                'Men shave their heads (Halq) or women trim a small portion of hair (Taqsir), symbolizing purification and the completion of this stage of Hajj.',
          ),
          StepItem(
            order: 5,
            title: 'Perform Tawaf al-Ifadah',
            subtitle:
                'After the sacrifice and hair ritual, perform Tawaf al-Ifadah at the Ka‘bah, followed by Sa‘i between Safa and Marwah.',
          ),
          StepItem(
            order: 6,
            title: 'Continue stoning for remaining days',
            subtitle:
                'After returning to Mina, continue stoning the three Jamrah pillars according to the prescribed days (11th and 12th of Dhul Hijjah).',
          ),
          StepItem(
            order: 7,
            title: 'Offer Eid prayers',
            subtitle:
                'Attend the Eid prayer at the designated area, reciting Takbir and performing the two-rak‘ah prayer in congregation, followed by Eid supplications.',
          ),
        ],
      ),
      DuaModel(
        title: 'Tawaf al-Ifadah (Tawaf al-Ziyarah)',
        imagePath: 'assets/images/ifdha.jpeg',
        intro:
            'Tawaf al-Ifadah is a compulsory Tawaf performed after standing at Arafah and returning from Mina. It signifies devotion, submission, and the fulfillment of Hajj obligations.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before beginning Tawaf al-Ifadah, make a sincere intention in your heart that you are performing this Tawaf to fulfill the Hajj obligation for Allah’s sake.',
          ),
          StepItem(
            order: 2,
            title: 'Start at the Black Stone (Hijr al-Aswad)',
            subtitle:
                'Face the Black Stone, raise your right hand, and say "Bismillah, Allahu Akbar." If possible, touch or kiss it; otherwise, point towards it with your right hand.',
          ),
          StepItem(
            order: 3,
            title: 'Move counter-clockwise around the Ka‘bah',
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite dhikr, Quranic verses, or supplications. Men may perform Ramal (walking briskly) during the first three circuits.',
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits',
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility, focus, and devotion throughout the Tawaf.',
          ),
          StepItem(
            order: 5,
            title: 'Pray two rak‘ahs near Maqam Ibrahim',
            subtitle:
                'After completing the seven circuits, pray two rak‘ahs behind Maqam Ibrahim, reciting Surah Al-Kafirun in the first and Surah Al-Ikhlas in the second, if possible.',
          ),
          StepItem(
            order: 6,
            title: 'Drink Zamzam water and make dua',
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah and make heartfelt supplications for forgiveness, guidance, and blessings.',
          ),
        ],
      ),
      DuaModel(
        title: '11th, 12th & 13th Dhul Hijjah – Stoning the Jamrah',
        imagePath: 'assets/images/drying.jpg',
        intro:
            'These days are dedicated to the stoning of the Jamrah pillars in Mina, commemorating the obedience of Prophet Ibrahim (peace be upon him). Pilgrims also perform Qurbani (sacrifice) and continue Hajj rituals with devotion and reflection.',
        steps: [
          StepItem(
            order: 1,
            title: 'Travel to Mina',
            subtitle:
                'Depart from Makkah or Muzdalifah to Mina early in the morning, maintaining humility and reciting Talbiyah along the way.',
          ),
          StepItem(
            order: 2,
            title: 'Stoning the three Jamrah pillars',
            subtitle:
                'Throw seven pebbles at each of the three Jamrah pillars (small, medium, and largest Jamrah) using your right hand while saying "Allahu Akbar" with each pebble. Follow the proper order: first the small Jamrah, then the medium, and finally the largest Jamrah (Jamrah al-Aqaba).',
          ),
          StepItem(
            order: 3,
            title: 'Perform Qurbani (Sacrifice)',
            subtitle:
                'If not done on the 10th, pilgrims may perform the animal sacrifice on these days as a continuation of Eid al-Adha rituals.',
          ),
          StepItem(
            order: 4,
            title: 'Halq or Taqsir (Shaving or Trimming Hair)',
            subtitle:
                'Men may shave or trim any remaining hair if not completed earlier, and women may trim a small portion to maintain purification and completion of rituals.',
          ),
          StepItem(
            order: 5,
            title: 'Stay in Mina for worship and reflection',
            subtitle:
                'Offer prayers, engage in dhikr, recite Quran, and make dua throughout the day and night. Maintain focus and humility while performing the rituals.',
          ),
          StepItem(
            order: 6,
            title: 'Return to Makkah after completion',
            subtitle:
                'After completing the stoning on the 12th (or 13th if staying the third day), pilgrims return to Makkah to perform Tawaf al-Wada (Farewell Tawaf) before leaving the holy city.',
          ),
        ],
      ),
      DuaModel(
        title: 'Tawaf al-Widā’ (Farewell Tawaf)',
        imagePath: 'assets/images/firewell.jpg',
        intro:
            'Tawaf al-Widā’ is the farewell circumambulation of the Ka‘bah performed at the end of Hajj or Umrah. It symbolizes gratitude, devotion, and the completion of the pilgrimage.',
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)',
            subtitle:
                'Before beginning Tawaf al-Widā’, make a sincere intention in your heart that you are performing this Tawaf to bid farewell to the Ka‘bah and complete your pilgrimage.',
          ),
          StepItem(
            order: 2,
            title: 'Start at the Black Stone (Hijr al-Aswad)',
            subtitle:
                'Face the Black Stone, raise your right hand, and say "Bismillah, Allahu Akbar." If possible, touch or kiss it; otherwise, point towards it with your right hand.',
          ),
          StepItem(
            order: 3,
            title: 'Move counter-clockwise around the Ka‘bah',
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite dhikr, Quranic verses, or supplications, focusing on gratitude and farewell.',
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits',
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility, devotion, and reflection throughout the Tawaf.',
          ),
          StepItem(
            order: 5,
            title: 'Pray two rak‘ahs near Maqam Ibrahim',
            subtitle:
                'After completing the seven circuits, pray two rak‘ahs behind Maqam Ibrahim, reciting Surah Al-Kafirun in the first and Surah Al-Ikhlas in the second, if possible.',
          ),
          StepItem(
            order: 6,
            title: 'Drink Zamzam water and make dua',
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah, expressing gratitude, and making heartfelt supplications for yourself, family, and the Muslim community.',
          ),
        ],
      ),
    ];
  }

  // ────────────────────────────── MASNOON DUAS ──────────────────────────────
  static Future<List<DuaModel>> fetchMasnoonDuas() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      DuaModel(
        title: 'Dua Before Sleeping',
        imagePath: 'assets/images/sleep.jpeg',
        intro: 'A beautiful Sunnah dua to recite before sleeping peacefully.',
        steps: [
          StepItem(order: 1, title: 'Recite Ayat-ul-Kursi'),
          StepItem(
            order: 2,
            title: 'Recite Surah Al-Ikhlas, Al-Falaq, and An-Nas',
          ),
          StepItem(
            order: 3,
            title: 'Blow on hands and wipe over the body three times',
          ),
          StepItem(
            order: 4,
            title: 'Say: "Bismika Allahumma ahya wa bismika amut"',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Leaving the House',
        imagePath: 'assets/images/leaving_home.jpg',
        intro:
            'Seek Allah’s protection and blessing before stepping out of your home.',
        steps: [
          StepItem(
            order: 1,
            title: 'Recite: "Bismillah, tawakkaltu ‘ala Allah"',
          ),
          StepItem(
            order: 2,
            title: 'Add: "La hawla wa la quwwata illa billah"',
          ),
          StepItem(order: 3, title: 'Trust Allah for your safety and success'),
        ],
      ),
      DuaModel(
        title: 'Dua After Eating',
        imagePath: 'assets/images/after_eating.jpg',
        intro: 'Show gratitude after a meal with this short, meaningful dua.',
        steps: [
          StepItem(
            order: 1,
            title: 'Say: "Alhamdulillahi allathee at‘amanee hatha"',
          ),
          StepItem(
            order: 2,
            title: 'And: "Wa razaqaneehi min ghayri hawlin minni wa la quwwah"',
          ),
          StepItem(order: 3, title: 'Thank Allah for His blessings'),
        ],
      ),
      DuaModel(
        title: 'Dua Upon Entering the Masjid',
        imagePath: 'assets/images/entring.jpg',
        intro:
            'Recite this dua when entering a mosque to seek blessings and protection while entering the house of Allah.',
        steps: [
          StepItem(
            order: 1,
            title: 'Say: "Bismillah, wassalatu wassalamu ‘ala Rasulillah"',
          ),
          StepItem(
            order: 2,
            title:
                'Followed by: "Allahumma aftah li abwaba rahmatik" (O Allah, open for me the doors of Your mercy)',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua Upon Leaving the Masjid',
        imagePath: 'assets/images/leaving_masjid.jpg',
        intro:
            'Recite this dua when leaving a mosque to seek Allah’s protection and continue His blessings in your day.',
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Bismillah, wassalatu wassalamu ‘ala Rasulillah. Allahumma inni as’aluka min fadhlika"',
          ),
          StepItem(
            order: 2,
            title:
                'Walk out with the right foot first as Sunnah, while remembering Allah and making personal supplications',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua Upon Waking Up',
        imagePath: 'assets/images/walking.jpg',
        intro:
            'A Sunnah supplication to thank Allah for life and health upon waking up in the morning.',
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Alhamdulillahil-lathee ahyana ba‘dama amatana wa ilayhin-nushoor"',
          ),
          StepItem(
            order: 2,
            title:
                'Reflect on gratitude for life, health, and the chance to perform good deeds today',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Sneezing',
        imagePath: 'assets/images/sneezing.jpg',
        intro:
            'A simple Sunnah dua to recite when sneezing, while the people around you say a response.',
        steps: [
          StepItem(order: 1, title: 'Say: "Alhamdulillah" when you sneeze'),
          StepItem(
            order: 2,
            title:
                'Those who hear you respond: "Yarhamuk Allah" (May Allah have mercy on you)',
          ),
          StepItem(
            order: 3,
            title:
                'You then say: "Yahdikumullahu wa yuslihu balakum" (May Allah guide you and rectify your affairs)',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Entering the Toilet',
        imagePath: 'assets/images/enter_toilet.jpg',
        intro:
            'A brief Sunnah supplication for entering the toilet to seek protection from impurities.',
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Bismillah, Allahumma inni a‘oozu bika minal khubthi wal khaba’ith"',
          ),
          StepItem(
            order: 2,
            title: 'Seek protection from all evil and harmful things',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua After Using the Toilet',
        imagePath: 'assets/images/exit_toilet.jpeg',
        intro:
            'A Sunnah supplication after leaving the toilet to thank Allah for cleanliness and protection.',
        steps: [
          StepItem(
            order: 1,
            title: 'Say: "Ghufranak" (I seek Your forgiveness, O Allah)',
          ),
          StepItem(
            order: 2,
            title: 'Reflect on gratitude for hygiene and protection from harm',
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Starting a Journey',
        imagePath: 'assets/images/start_journey.jpg',
        intro:
            'Recite this dua when beginning travel to seek Allah’s protection, guidance, and safety throughout the journey.',
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Bismillah, tawakkaltu ‘ala Allah, wa la hawla wa la quwwata illa billah"',
          ),
          StepItem(
            order: 2,
            title: 'Pray for a safe, blessed, and successful journey',
          ),
        ],
      ),
    ];
  }
}