
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../dua_model/dua_model.dart';
import '../step_items/step_items.dart';

class DuaData {
  // ────────────────────────────── UMRAH DUAS ──────────────────────────────
  static Future<List<DuaModel>> fetchUmrahDuas() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      DuaModel(
        title: 'Preparation of the Day of Travelling'.tr,
        imagePath: 'assets/images/flight.jpeg',
        intro:
            'Quick checklist and step-by-step guidance to prepare for Umrah before you depart.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make the Intention (Niyyah)'.tr,
            subtitle:
                'Sincerely intend in your heart that you are going for Umrah for Allah’s sake.'.tr,
            extraNote: 'Niyyah is internal — no prescribed words required.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Pack Ihram and Essentials'.tr,
            subtitle:
                'Pack Ihram garments, comfortable shoes, travel documents, medicines and a copy of dua cards.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Perform Wudu before entering Miqat'.tr,
            subtitle:
                'Be in a state of ritual purity before assuming Ihram if possible.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Enter the state of Ihram (at Miqat)'.tr,
            subtitle:
                'Wear Ihram, say intention for Umrah (e.g., "Labbaik Allahumma Umrah") and avoid prohibited things.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Travel to Makkah & Begin Tawaf'.tr,
            subtitle:
                'On arrival to Masjid al-Haram, begin Tawaf from the Black Stone and perform 7 circuits.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Intention for Umrah'.tr,
        imagePath: 'assets/images/intention.png',
        intro:
            'Simple steps and sample wording to make your intention and enter Ihram correctly.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Approach the Miqat'.tr,
            subtitle: 'Stop at the appointed boundary (Miqat).'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Put on Ihram'.tr,
            subtitle:
                'Men: two white unstitched cloths; Women: modest dress as usual.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Declare your Niyyah (sample)'.tr,
            subtitle:
                'Say in heart (or softly): "O Allah, I intend to perform Umrah."'.tr,
            extraNote: 'You may say: "Labbaik Allahumma Umrah".'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Upon Entering Makkah'.tr,
        imagePath: 'assets/images/clock.jpg',
        intro:
            'When you enter the holy city of Makkah, it is recommended to enter with humility and gratitude, reciting prayers of peace and blessings as you approach the Sacred Mosque.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Enter Makkah with humility'.tr,
            subtitle:
                'Keep your heart filled with reverence and gratitude for being allowed to reach this sacred place.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Recite the Talbiyah'.tr,
            subtitle:
                'As you enter, say: “Labbaik Allahumma Labbaik, Labbaik La Shareeka Laka Labbaik, Innal-Hamda Wan-Ni‘mata Laka Wal-Mulk, La Shareeka Lak.”'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Pause at the city entrance'.tr,
            subtitle:
                'Upon entering, pause briefly to offer praise to Allah and send blessings upon the Prophet ﷺ.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Enter Masjid al-Haram with the right foot'.tr,
            subtitle:
                'As you approach and enter the Haram, step in with your right foot and recite the dua for entering the mosque: \n\n“Bismillah, Allahumma salli ‘ala Muhammad, Allahumma iftah li abwaba rahmatik.”'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Keep eyes lowered until seeing the Ka‘bah'.tr,
            subtitle:
                'Out of respect, keep your gaze down until you are close enough to view the Ka‘bah, then look upon it with devotion and make a heartfelt dua.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Make dua upon seeing the Ka‘bah'.tr,
            subtitle:
                'When you first see the Ka‘bah, raise your hands and supplicate sincerely — it is a moment when duas are accepted.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Tawaf'.tr,
        imagePath: 'assets/images/tawaf.jpg',
        intro:
            'Tawaf is one of the most important rituals of Hajj and Umrah. It involves walking around the Ka‘bah seven times in a counter-clockwise direction, starting from the Black Stone. It symbolizes unity, devotion, and submission to Allah.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Start at the Black Stone (Hijr al-Aswad)'.tr,
            subtitle:
                'Face the Black Stone, raise your right hand, and say “Bismillah, Allahu Akbar.” If possible, touch or kiss it; otherwise, point towards it with your right hand before beginning your Tawaf.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Move counter-clockwise, reciting dhikr'.tr,
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite any dua, Quranic verses, or supplications. The best dhikr is “Subhan Allah, Alhamdulillah, La ilaha illa Allah, Allahu Akbar.”'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Complete seven circuits'.tr,
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility and devotion. Men should walk briskly (ramal) during the first three circuits and normally for the last four.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Pray two rak‘ahs near Maqam Ibrahim'.tr,
            subtitle:
                'After completing seven rounds, go to Maqam Ibrahim (the Station of Abraham) and pray two rak‘ahs. In the first rak‘ah, recite Surah Al-Kafirun, and in the second, recite Surah Al-Ikhlas, if possible.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Drink Zamzam water'.tr,
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah and make dua, as this is a moment of acceptance. Supplicate for health, forgiveness, and blessings.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Proceed to Sa‘i (if performing Umrah)'.tr,
            subtitle:
                'If you are performing Umrah, continue to Safa and Marwah for the Sa‘i ritual. Otherwise, conclude your Tawaf with gratitude and prayer.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Prayer at Maqam-e-Ibrahim'.tr,
        imagePath: 'assets/images/maqam_ibrahim.jpeg',
        intro:
            'After completing the Tawaf, it is Sunnah to pray two rak‘ahs behind Maqam-e-Ibrahim — the place where Prophet Ibrahim (A.S.) stood while constructing the Ka‘bah. This prayer signifies gratitude, humility, and closeness to Allah after completing the sacred Tawaf.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Move towards Maqam-e-Ibrahim'.tr,
            subtitle:
                'After finishing your seventh circuit of Tawaf, proceed calmly towards Maqam-e-Ibrahim. Keep the Ka‘bah in front of you and Maqam-e-Ibrahim between you and the Ka‘bah if possible. Recite the verse:\n\nوَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّى\n\n“Take the place of Ibrahim as a place of prayer.” (Surah Al-Baqarah 2:125)'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Perform two rak‘ahs of prayer'.tr,
            subtitle:
                'Pray two rak‘ahs of Salah behind Maqam-e-Ibrahim. In the first rak‘ah, it is Sunnah to recite Surah Al-Kafirun after Surah Al-Fatihah, and in the second rak‘ah, Surah Al-Ikhlas after Surah Al-Fatihah. Maintain serenity and humility throughout the prayer.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Make sincere dua after Salah'.tr,
            subtitle:
                'Once you finish the prayer, raise your hands in dua. Praise Allah, send salutations upon the Prophet ﷺ, and ask for forgiveness, guidance, and acceptance of your Tawaf. This is a moment when duas are highly accepted.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Drink Zamzam water'.tr,
            subtitle:
                'After completing your prayer and dua, proceed to drink Zamzam water while facing the Ka‘bah. Make a heartfelt supplication — “O Allah, grant me beneficial knowledge, wide sustenance, and healing from all illnesses.”'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Zamzam Water'.tr,
        imagePath: 'assets/images/zamzam.jpg',
        intro:
            'Zamzam water is a blessed water from the sacred Zamzam well in Makkah. Drinking it is a Sunnah and a source of spiritual and physical blessings. It is recommended to drink with devotion, make dua, and drink in small sips.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Face the Qiblah'.tr,
            subtitle:
                'When drinking Zamzam water, face the Ka‘bah (Qiblah) to show reverence and focus during supplication.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Make a sincere intention in your heart that you are drinking Zamzam water for Allah’s blessings, health, and guidance.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Drink in small sips'.tr,
            subtitle:
                'Take the water in small sips rather than gulping it. This is Sunnah and helps in fully receiving the spiritual and physical benefits.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Recite Bismillah before drinking'.tr,
            subtitle:
                'Say “Bismillah” (In the name of Allah) before taking each sip to remember Allah and seek His blessings.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Make dua'.tr,
            subtitle:
                'While drinking, make heartfelt supplications. Ask for health, forgiveness, guidance, sustenance, or any personal needs. It is recommended to be specific and sincere in your dua.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Thank Allah'.tr,
            subtitle:
                'After finishing, express gratitude to Allah for the blessing of Zamzam water and His mercy. Continue to make dua even after drinking.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Sa‘i (Safa to Marwah)'.tr,
        imagePath: 'assets/images/sai.jpg',
        intro:
            'Sa‘i is the ritual of walking seven times between the hills of Safa and Marwah. It commemorates Hajar’s search for water for her son Isma‘il and symbolizes patience, devotion, and trust in Allah. Men are encouraged to run lightly (ramal) between the two markers in the first three circuits.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Start at Safa'.tr,
            subtitle:
                'Face the Ka‘bah, make intention (Niyyah) for Sa‘i, and start from the hill of Safa.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Recite dhikr while moving'.tr,
            subtitle:
                'While walking or lightly running, recite supplications, Quranic verses, or dhikr. Common dhikr includes “Rabbighfir warham wa anta khayrur rahimeen.”'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Run lightly between the markers'.tr,
            subtitle:
                'Men should lightly run (ramal) between the two green markers (known as Raml area) during the first three circuits. Women walk normally throughout.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits'.tr,
            subtitle:
                'Each round begins at Safa and ends at Marwah (or vice versa). Complete seven circuits in total, keeping devotion and focus on Allah.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Make dua throughout'.tr,
            subtitle:
                'Supplicate for your needs, forgiveness, guidance, and blessings. Sa‘i is a time to pray earnestly and with humility.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Conclude at Marwah'.tr,
            subtitle:
                'After the seventh circuit, conclude your Sa‘i with gratitude, prayers, and remembrance of Allah’s mercy and guidance.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Halq or Taqsir (Shaving or Trimming Hair)'.tr,
        imagePath: 'assets/images/halk.jpg',
        intro:
            'Halq (shaving the head) or Taqsir (trimming the hair) is the final ritual of Hajj and Umrah. It symbolizes purification, humility, and the completion of the pilgrimage. Men usually shave their heads (Halq), while women trim a small portion of their hair (Taqsir).'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before shaving or trimming, make a sincere intention in your heart that this act is for Allah, completing your Hajj or Umrah rituals.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Choose Halq or Taqsir'.tr,
            subtitle:
                'Men typically perform Halq (shaving the entire head) while women perform Taqsir (trimming a small portion of hair). Ensure you follow the correct practice for your gender.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Recite Bismillah before starting'.tr,
            subtitle:
                'Say “Bismillah” (In the name of Allah) before shaving or trimming, remembering Allah and seeking His blessings.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Perform the act'.tr,
            subtitle:
                'Shave the head completely (Halq) or trim a small portion of hair (Taqsir). Ensure it is done respectfully and with focus on the spiritual significance.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Make dua after completion'.tr,
            subtitle:
                'After finishing, thank Allah for the opportunity to complete your Hajj or Umrah, and make dua for forgiveness, guidance, and blessings.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Conclude Ihram'.tr,
            subtitle:
                'After Halq or Taqsir, your state of Ihram ends. You may now wear regular clothes and continue normal activities while remaining mindful of Allah’s blessings.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Leaving the Masjid'.tr,
        imagePath: 'assets/images/leaving.jpg',
        intro:
            'It is Sunnah to recite a specific dua when leaving the masjid. This supplication asks Allah for guidance, forgiveness, and protection, and reflects gratitude for the opportunity to pray in His house.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before leaving the masjid, have the intention in your heart to seek Allah’s blessings and protection as you depart.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Recite the dua'.tr,
            subtitle:
                'The common dua when leaving the masjid is: "Bismillah, wassalatu wassalamu ‘ala Rasulillah. Allahumma aftah li abwaba rahmatik." (In the name of Allah, peace and blessings be upon the Messenger of Allah. O Allah, open for me the doors of Your mercy.)'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Step out with your right foot'.tr,
            subtitle:
                'It is Sunnah to exit the masjid with the right foot first as a sign of respect and following the Prophet’s practice (Sunnah).'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Make personal dua'.tr,
            subtitle:
                'After reciting the prescribed dua, you may supplicate for personal needs, protection, guidance, and forgiveness.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Leave with humility and mindfulness'.tr,
            subtitle:
                'Depart the masjid with a humble heart, maintaining the spiritual awareness and blessings obtained during your visit.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Nafl Tawaf'.tr,
        imagePath: 'assets/images/nafle_tawaf.jpg',
        intro:
            'Nafl Tawaf is a voluntary circumambulation of the Ka‘bah performed outside of obligatory Tawaf during Hajj or Umrah. It is a highly rewarding act of worship, expressing devotion, humility, and love for Allah.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before starting Nafl Tawaf, make a sincere intention in your heart that you are performing this act for Allah alone.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Start at the Black Stone (Hijr al-Aswad)'.tr,
            subtitle:
                'Face the Black Stone, raise your right hand, and say “Bismillah, Allahu Akbar.” If possible, touch or kiss it; otherwise, point towards it with your right hand.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Move counter-clockwise, reciting dhikr'.tr,
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite dhikr, Quranic verses, or supplications. Common dhikr includes: “Subhan Allah, Alhamdulillah, La ilaha illa Allah, Allahu Akbar.”'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits'.tr,
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility, focus, and devotion throughout the Tawaf.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Pray two rak‘ahs near Maqam Ibrahim'.tr,
            subtitle:
                'After completing the seven circuits, go to Maqam Ibrahim and pray two rak‘ahs, reciting Surah Al-Kafirun in the first and Surah Al-Ikhlas in the second, if possible.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Drink Zamzam water and make dua'.tr,
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah and make heartfelt supplications for forgiveness, guidance, and blessings.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Etiquettes of Entering Masjid al-Nabawi'.tr,
        imagePath: 'assets/images/visit.jpg',
        intro:
            'When entering Masjid al-Nabawi, there are specific etiquettes to follow. These actions reflect respect, humility, and mindfulness of Allah’s presence.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before entering the masjid, make a sincere intention in your heart that you are entering to worship Allah and seek His pleasure.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Enter with the right foot first'.tr,
            subtitle:
                'Follow the Sunnah of the Prophet (peace be upon him) by entering the masjid with your right foot, showing respect and mindfulness.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Recite the entry dua'.tr,
            subtitle:
                'While entering, recite: "Bismillah, wassalatu wassalamu ‘ala Rasulillah. Allahumma aftah li abwaba rahmatik." (In the name of Allah, peace and blessings be upon the Messenger of Allah. O Allah, open for me the doors of Your mercy.)'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Maintain humility and silence'.tr,
            subtitle:
                'Walk calmly, avoid unnecessary talking, and be conscious of others in the masjid. Focus on your worship and reflection.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Perform voluntary prayers (Nafl)'.tr,
            subtitle:
                'After entering, you may perform voluntary prayers, sit quietly for dhikr, or recite Quran, following the etiquette of the Prophet (peace be upon him).'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Respect the sacred areas'.tr,
            subtitle:
                'Avoid stepping over prayer lines, maintain cleanliness, and show reverence, especially near the Rawdah and Prophet’s grave area.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Visiting the Blessed Grave'.tr,
        imagePath: 'assets/images/grave.jpeg',
        intro:
            'Visiting the Blessed Grave of Prophet Muhammad (peace be upon him) is a recommended act of devotion. It is an opportunity to send salutations upon the Prophet, make dua, and reflect on one’s faith and deeds.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before visiting, make a sincere intention in your heart that you are coming to seek blessings, send salutations upon the Prophet, and supplicate to Allah.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Enter with the right foot first'.tr,
            subtitle:
                'Follow the Sunnah by entering the area with your right foot, demonstrating respect and mindfulness.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Send salutations upon the Prophet'.tr,
            subtitle:
                'Recite: "Assalamu ‘alaika ya Rasul Allah, wa rahmatullahi wa barakatuh." (Peace be upon you, O Messenger of Allah, and Allah’s mercy and blessings). You may also make personal salutations and prayers.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Make personal dua'.tr,
            subtitle:
                'Supplicate sincerely for forgiveness, guidance, health, and blessings. Speak to Allah with humility and devotion.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Maintain silence and respect'.tr,
            subtitle:
                'Avoid loud conversations, keep modest behavior, and respect the sanctity of the grave and surrounding areas.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Exit respectfully'.tr,
            subtitle:
                'Leave with the left foot first (following etiquette for exiting sacred areas) and continue to send salutations upon the Prophet as you depart.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Salat al-Janazah (Funeral Prayer)'.tr,
        imagePath: 'assets/images/feneral.jpg',
        intro:
            'Salat al-Janazah is the Islamic funeral prayer offered for the deceased. It is a communal obligation (Fard Kifayah) and a means of asking Allah for forgiveness, mercy, and blessings for the deceased.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before starting, make a sincere intention in your heart that you are performing Salat al-Janazah for the sake of Allah and seeking forgiveness for the deceased.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Stand in rows behind the imam'.tr,
            subtitle:
                'Join the congregation in straight rows, ensuring your shoulders align with others. Men stand behind the imam; women can attend in a separate area if available.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Takbir and opening supplication'.tr,
            subtitle:
                'Say "Allahu Akbar" (Takbir) and raise your hands, then recite silently: "Subhanaka Allahumma wa bihamdika, wa tabaarakasmuka, wa ta‘ala jadduka, wa la ilaha ghayruka."'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Recite Al-Fatiha'.tr,
            subtitle:
                'After the second Takbir, recite Surah Al-Fatiha silently, seeking Allah’s mercy and blessings for the deceased.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Make dua for the deceased'.tr,
            subtitle:
                'After the third Takbir, raise your hands and supplicate for the deceased, asking Allah to forgive, have mercy, and grant them paradise. You may also make general dua for all believers.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Final Takbir and Salam'.tr,
            subtitle:
                'After the fourth Takbir, conclude the prayer by saying the Salam to the right (Assalamu Alaikum wa Rahmatullah). The funeral prayer is now complete.'.tr,
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
        title: '8th of Dhul Hijjah – The Day of Quenching (Yawm at-Tarwiyah)'.tr,
        imagePath: 'assets/images/mina.jpg',
        intro:
            'The 8th of Dhul Hijjah is the Day of Quenching, marking the start of the main Hajj rituals. Pilgrims enter Mina, offer prayers, and prepare for the sacred rites ahead.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Enter the state of Ihram (if not already in it)'.tr,
            subtitle:
                'Ensure your Ihram is worn properly, intentions are clear, and Talbiyah is being recited frequently.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Proceed to Mina'.tr,
            subtitle:
                'Travel to Mina in the morning, preferably after Fajr prayer. Walk with humility and devotion, remembering Allah along the way.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Perform Dhuhr, Asr, Maghrib, and Isha prayers in Mina'.tr,
            subtitle:
                'Offer all prayers at their prescribed times, either individually or in congregation. This is a Sunnah to stay in Mina and maintain spiritual focus.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Spend the day in devotion'.tr,
            subtitle:
                'Engage in dhikr, recite Quran, and make dua. Avoid unnecessary talk and focus on spiritual purification.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Recite Talbiyah frequently'.tr,
            subtitle:
                'Keep saying: "Labbaik Allahumma Labbaik, Labbaik La Shareeka Laka Labbaik…" to affirm your intention and devotion to Allah.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Prepare for Arafah'.tr,
            subtitle:
                'Rest and spiritually prepare for the next day, the Day of Arafah, which is the pinnacle of Hajj rituals.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: "9th of Dhul Hijjah – The Day of 'Arafah".tr,
        imagePath: 'assets/images/arafat.jpeg',
        intro:
            "The Day of ‘Arafah is the most important day of Hajj. Pilgrims gather at the plain of Arafah to stand in devotion, seeking Allah’s mercy, forgiveness, and guidance. Standing at Arafah (Wuquf) is the essence of Hajj.".tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Travel to Arafah'.tr,
            subtitle:
                'Depart from Mina to the plain of Arafah after Fajr. Arrive early to secure a place for standing in devotion (Wuquf).'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Make intention (Niyyah) for Hajj at Arafah'.tr,
            subtitle:
                'Have a sincere intention in your heart that you are standing in Arafah for Allah’s pleasure and forgiveness.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Perform Dhuhr and Asr prayers'.tr,
            subtitle:
                'Pray Dhuhr and Asr combined at their respective times while standing in Arafah, as is Sunnah during Hajj.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Engage in dhikr and dua'.tr,
            subtitle:
                'Spend the day making sincere supplications, seeking forgiveness, mercy, and blessings. The Day of Arafah is a day when Allah accepts dua abundantly.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Recite Talbiyah and Quran'.tr,
            subtitle:
                'Continue reciting: "Labbaik Allahumma Labbaik…" and other dhikr. Reading Quran and sending salutations upon the Prophet is highly recommended.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Stay until sunset'.tr,
            subtitle:
                'Remain in Arafah until sunset, focusing on devotion and reflection. Leaving early is discouraged. The standing at Arafah concludes at Maghrib.'.tr,
          ),
          StepItem(
            order: 7,
            title: 'Depart to Muzdalifah after sunset'.tr,
            subtitle:
                'After sunset, depart for Muzdalifah to spend the night under the open sky, combining Maghrib and Isha prayers, and collecting pebbles for the stoning ritual.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: "Night of 9th Dhul Hijjah – Muzdalifah".tr,
        imagePath: 'assets/images/muzdalifa.png',
        intro:
            "After standing at Arafah, pilgrims travel to Muzdalifah to spend the night under the open sky. This night is a time for rest, devotion, and preparation for the stoning ritual (Ramy al-Jamarat) the next day.".tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Travel from Arafah to Muzdalifah'.tr,
            subtitle:
                'Depart from Arafah immediately after sunset and arrive at Muzdalifah, walking with humility and remembering Allah.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Combine Maghrib and Isha prayers'.tr,
            subtitle:
                'Pray Maghrib and Isha together at their respective times while at Muzdalifah, as is Sunnah during Hajj.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Collect pebbles for Ramy al-Jamarat'.tr,
            subtitle:
                'Pick 49 or 70 small pebbles (depending on the number of stoning rounds) from the ground to use the next day for the stoning of the Jamrah pillars in Mina.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Engage in dhikr and dua'.tr,
            subtitle:
                'Spend the night in supplication, seeking forgiveness, mercy, and blessings. This is a time of spiritual reflection and connection with Allah.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Rest respectfully'.tr,
            subtitle:
                'Sleep or rest lightly under the open sky, maintaining modesty and mindfulness. Avoid excessive talking or distraction from worship.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Prepare for the next day (Eid and Stoning)'.tr,
            subtitle:
                'Mentally and spiritually prepare for the 10th of Dhul Hijjah, which includes the stoning of the Jamrah and the sacrifice of Eid al-Adha.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: "10th of Dhul Hijjah – The Day of Sacrifice".tr,
        imagePath: 'assets/images/scrific.png',
        intro:
            "The 10th of Dhul Hijjah marks Eid al-Adha and the first day of stoning the Jamrah pillars in Mina. Pilgrims perform the sacrifice (Qurbani) and continue Hajj rituals, expressing devotion, obedience, and submission to Allah.".tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Fajr prayer in Mina'.tr,
            subtitle:
                'Wake early and offer the Fajr prayer in Mina, preferably in congregation, to begin the day with worship and reflection.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Stoning the Jamrah al-Aqaba (Ramy al-Jamarat)'.tr,
            subtitle:
                'Throw seven pebbles at the largest Jamrah (Jamrah al-Aqaba) in Mina, starting with the right hand, while saying: "Allahu Akbar" with each pebble.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Sacrifice (Qurbani / Udhiya)'.tr,
            subtitle:
                'Perform the ritual animal sacrifice to commemorate Prophet Ibrahim’s obedience. This can be done personally or through authorized agencies if outside the Haram.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Halq or Taqsir (Shaving or Trimming Hair)'.tr,
            subtitle:
                'Men shave their heads (Halq) or women trim a small portion of hair (Taqsir), symbolizing purification and the completion of this stage of Hajj.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Perform Tawaf al-Ifadah'.tr,
            subtitle:
                'After the sacrifice and hair ritual, perform Tawaf al-Ifadah at the Ka‘bah, followed by Sa‘i between Safa and Marwah.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Continue stoning for remaining days'.tr,
            subtitle:
                'After returning to Mina, continue stoning the three Jamrah pillars according to the prescribed days (11th and 12th of Dhul Hijjah).'.tr,
          ),
          StepItem(
            order: 7,
            title: 'Offer Eid prayers'.tr,
            subtitle:
                'Attend the Eid prayer at the designated area, reciting Takbir and performing the two-rak‘ah prayer in congregation, followed by Eid supplications.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Tawaf al-Ifadah (Tawaf al-Ziyarah)'.tr,
        imagePath: 'assets/images/ifdha.jpeg',
        intro:
            'Tawaf al-Ifadah is a compulsory Tawaf performed after standing at Arafah and returning from Mina. It signifies devotion, submission, and the fulfillment of Hajj obligations.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before beginning Tawaf al-Ifadah, make a sincere intention in your heart that you are performing this Tawaf to fulfill the Hajj obligation for Allah’s sake.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Start at the Black Stone (Hijr al-Aswad)'.tr,
            subtitle:
                'Face the Black Stone, raise your right hand, and say "Bismillah, Allahu Akbar." If possible, touch or kiss it; otherwise, point towards it with your right hand.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Move counter-clockwise around the Ka‘bah'.tr,
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite dhikr, Quranic verses, or supplications. Men may perform Ramal (walking briskly) during the first three circuits.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits'.tr,
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility, focus, and devotion throughout the Tawaf.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Pray two rak‘ahs near Maqam Ibrahim'.tr,
            subtitle:
                'After completing the seven circuits, pray two rak‘ahs behind Maqam Ibrahim, reciting Surah Al-Kafirun in the first and Surah Al-Ikhlas in the second, if possible.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Drink Zamzam water and make dua'.tr,
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah and make heartfelt supplications for forgiveness, guidance, and blessings.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: '11th, 12th & 13th Dhul Hijjah – Stoning the Jamrah'.tr,
        imagePath: 'assets/images/drying.jpg',
        intro:
            'These days are dedicated to the stoning of the Jamrah pillars in Mina, commemorating the obedience of Prophet Ibrahim (peace be upon him). Pilgrims also perform Qurbani (sacrifice) and continue Hajj rituals with devotion and reflection.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Travel to Mina'.tr,
            subtitle:
                'Depart from Makkah or Muzdalifah to Mina early in the morning, maintaining humility and reciting Talbiyah along the way.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Stoning the three Jamrah pillars'.tr,
            subtitle:
                'Throw seven pebbles at each of the three Jamrah pillars (small, medium, and largest Jamrah) using your right hand while saying "Allahu Akbar" with each pebble. Follow the proper order: first the small Jamrah, then the medium, and finally the largest Jamrah (Jamrah al-Aqaba).'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Perform Qurbani (Sacrifice)'.tr,
            subtitle:
                'If not done on the 10th, pilgrims may perform the animal sacrifice on these days as a continuation of Eid al-Adha rituals.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Halq or Taqsir (Shaving or Trimming Hair)'.tr,
            subtitle:
                'Men may shave or trim any remaining hair if not completed earlier, and women may trim a small portion to maintain purification and completion of rituals.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Stay in Mina for worship and reflection'.tr,
            subtitle:
                'Offer prayers, engage in dhikr, recite Quran, and make dua throughout the day and night. Maintain focus and humility while performing the rituals.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Return to Makkah after completion'.tr,
            subtitle:
                'After completing the stoning on the 12th (or 13th if staying the third day), pilgrims return to Makkah to perform Tawaf al-Wada (Farewell Tawaf) before leaving the holy city.'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Tawaf al-Widā’ (Farewell Tawaf)'.tr,
        imagePath: 'assets/images/firewell.jpg',
        intro:
            'Tawaf al-Widā’ is the farewell circumambulation of the Ka‘bah performed at the end of Hajj or Umrah. It symbolizes gratitude, devotion, and the completion of the pilgrimage.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Make intention (Niyyah)'.tr,
            subtitle:
                'Before beginning Tawaf al-Widā’, make a sincere intention in your heart that you are performing this Tawaf to bid farewell to the Ka‘bah and complete your pilgrimage.'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Start at the Black Stone (Hijr al-Aswad)'.tr,
            subtitle:
                'Face the Black Stone, raise your right hand, and say "Bismillah, Allahu Akbar." If possible, touch or kiss it; otherwise, point towards it with your right hand.'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Move counter-clockwise around the Ka‘bah'.tr,
            subtitle:
                'Walk around the Ka‘bah in a counter-clockwise direction, keeping it to your left. Recite dhikr, Quranic verses, or supplications, focusing on gratitude and farewell.'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Complete seven circuits'.tr,
            subtitle:
                'Each round begins and ends at the Black Stone. Maintain humility, devotion, and reflection throughout the Tawaf.'.tr,
          ),
          StepItem(
            order: 5,
            title: 'Pray two rak‘ahs near Maqam Ibrahim'.tr,
            subtitle:
                'After completing the seven circuits, pray two rak‘ahs behind Maqam Ibrahim, reciting Surah Al-Kafirun in the first and Surah Al-Ikhlas in the second, if possible.'.tr,
          ),
          StepItem(
            order: 6,
            title: 'Drink Zamzam water and make dua'.tr,
            subtitle:
                'After the prayer, drink Zamzam water while facing the Ka‘bah, expressing gratitude, and making heartfelt supplications for yourself, family, and the Muslim community.'.tr,
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
        title: 'Dua Before Sleeping'.tr,
        imagePath: 'assets/images/sleep.jpeg',
        intro: 'A beautiful Sunnah dua to recite before sleeping peacefully.'.tr,
        steps: [
          StepItem(order: 1, title: 'Recite Ayat-ul-Kursi'.tr),
          StepItem(
            order: 2,
            title: 'Recite Surah Al-Ikhlas, Al-Falaq, and An-Nas'.tr,
          ),
          StepItem(
            order: 3,
            title: 'Blow on hands and wipe over the body three times'.tr,
          ),
          StepItem(
            order: 4,
            title: 'Say: "Bismika Allahumma ahya wa bismika amut"'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Leaving the House'.tr,
        imagePath: 'assets/images/leaving_home.jpg',
        intro:
            'Seek Allah’s protection and blessing before stepping out of your home.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Recite: "Bismillah, tawakkaltu ‘ala Allah"'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Add: "La hawla wa la quwwata illa billah"'.tr,
          ),
          StepItem(order: 3, title: 'Trust Allah for your safety and success'.tr),
        ],
      ),
      DuaModel(
        title: 'Dua After Eating'.tr,
        imagePath: 'assets/images/after_eating.jpg',
        intro: 'Show gratitude after a meal with this short, meaningful dua.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Say: "Alhamdulillahi allathee at‘amanee hatha"'.tr,
          ),
          StepItem(
            order: 2,
            title: 'And: "Wa razaqaneehi min ghayri hawlin minni wa la quwwah"'.tr,
          ),
          StepItem(order: 3, title: 'Thank Allah for His blessings'.tr),
        ],
      ),
      DuaModel(
        title: 'Dua Upon Entering the Masjid'.tr,
        imagePath: 'assets/images/entring.jpg',
        intro:
            'Recite this dua when entering a mosque to seek blessings and protection while entering the house of Allah.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Say: "Bismillah, wassalatu wassalamu ‘ala Rasulillah"'.tr,
          ),
          StepItem(
            order: 2,
            title:
                'Followed by: "Allahumma aftah li abwaba rahmatik" (O Allah, open for me the doors of Your mercy)'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua Upon Leaving the Masjid'.tr,
        imagePath: 'assets/images/leaving_masjid.jpg',
        intro:
            'Recite this dua when leaving a mosque to seek Allah’s protection and continue His blessings in your day.'.tr,
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Bismillah, wassalatu wassalamu ‘ala Rasulillah. Allahumma inni as’aluka min fadhlika"'.tr,
          ),
          StepItem(
            order: 2,
            title:
                'Walk out with the right foot first as Sunnah, while remembering Allah and making personal supplications'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua Upon Waking Up'.tr,
        imagePath: 'assets/images/walking.jpg',
        intro:
            'A Sunnah supplication to thank Allah for life and health upon waking up in the morning.'.tr,
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Alhamdulillahil-lathee ahyana ba‘dama amatana wa ilayhin-nushoor"'.tr,
          ),
          StepItem(
            order: 2,
            title:
                'Reflect on gratitude for life, health, and the chance to perform good deeds today'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Sneezing'.tr,
        imagePath: 'assets/images/sneezing.jpg',
        intro:
            'A simple Sunnah dua to recite when sneezing, while the people around you say a response.'.tr,
        steps: [
          StepItem(order: 1, title: 'Say: "Alhamdulillah" when you sneeze'.tr),
          StepItem(
            order: 2,
            title:
                'Those who hear you respond: "Yarhamuk Allah" (May Allah have mercy on you)'.tr,
          ),
          StepItem(
            order: 3,
            title:
                'You then say: "Yahdikumullahu wa yuslihu balakum" (May Allah guide you and rectify your affairs)'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Entering the Toilet'.tr,
        imagePath: 'assets/images/enter_toilet.jpg',
        intro:
            'A brief Sunnah supplication for entering the toilet to seek protection from impurities.'.tr,
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Bismillah, Allahumma inni a‘oozu bika minal khubthi wal khaba’ith"'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Seek protection from all evil and harmful things'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua After Using the Toilet'.tr,
        imagePath: 'assets/images/exit_toilet.jpeg',
        intro:
            'A Sunnah supplication after leaving the toilet to thank Allah for cleanliness and protection.'.tr,
        steps: [
          StepItem(
            order: 1,
            title: 'Say: "Ghufranak" (I seek Your forgiveness, O Allah)'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Reflect on gratitude for hygiene and protection from harm'.tr,
          ),
        ],
      ),
      DuaModel(
        title: 'Dua When Starting a Journey'.tr,
        imagePath: 'assets/images/start_journey.jpg',
        intro:
            'Recite this dua when beginning travel to seek Allah’s protection, guidance, and safety throughout the journey.'.tr,
        steps: [
          StepItem(
            order: 1,
            title:
                'Say: "Bismillah, tawakkaltu ‘ala Allah, wa la hawla wa la quwwata illa billah"'.tr,
          ),
          StepItem(
            order: 2,
            title: 'Pray for a safe, blessed, and successful journey'.tr,
          ),
        ],
      ),
    ];
  }
}