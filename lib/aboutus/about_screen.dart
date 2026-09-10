import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value; // 0 = English, 1 = Hindi

        final Color scaffoldBg = isDark
            ? const Color(0xFF131315)
            : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDark ? Colors.white70 : Colors.black87;
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);
        final Color dividerColor = isDark ? Colors.white12 : Colors.black12;

        final List<Map<String, String>> aboutSections = [
          {
            'title': lang == 0 ? "🕉️ Guru's Preachings" : "🕉️ सतगुरुओं की पावन शिक्षाएं",
            'body': lang == 0
                ? 'The foundational spiritual teachings of the Satgurus have been:\n\n• Continuous "JAP" (devout chanting) of "OM"\n• Living life strictly in accordance with Guru\'s spiritual guidance\n• Pure, selfless Seva (service) of all human beings\n• Imbibing absolute humility, unconditional love, compassion, and care for every soul.'
                : 'पूज्य सतगुरुओं के पावन जीवन और उपदेशों के मुख्य स्तंभ:\n\n• पावन "ॐ" (OM) का निरंतर जप एवं सिमरन\n• सतगुरु के वचनों और आज्ञा अनुसार मर्यादित जीवन जीना\n• सभी प्राणियों की निष्काम, निःस्वार्थ भाव से सेवा करना\n• मन में परम विनम्रता, प्रेम, करुणा और परोपकार को धारण करना।',
          },
          {
            'title': lang == 0 ? "🛕 Origin of Darbar" : "🛕 दरबार का पावन उद्गम",
            'body': lang == 0
                ? 'Kambar Darbar had its sacred origin in 1887 when Sai Jiwatsingh Sahib decided to construct a holy shrine in memory of his Satguru, Vali Vilayatrai Sahib, at Kambar, Larkana (Sindh, now in Pakistan), and consecrated his holy Samadhi there.\n\nDarbar Sahib was established in Kambar because Vali Vilayatrai Sahib had moved from his native village Halla to spend his final years in Kambar. Later, the sacred Samadhis of Sai Jiwatsingh Sahib and Sai Vishindas Sahib were established adjacent to Sai Vilayatrai’s Samadhi on the same podium, adorned with sacred silver straps.'
                : 'कांबर दरबार की पावन स्थापना 1887 में हुई, जब सांईं जीवतसिंह साहिब ने अपने सतगुरु सांईं वली विलायतराय साहिब की स्मृति में कांबर, लरकाना (सिंध, वर्तमान पाकिस्तान) में पावन समाधि स्थल का निर्माण कराया।\n\nदरबार साहिब की स्थापना कांबर में इसलिए हुई क्योंकि सांईं विलायतराय जी अपने पैतृक गांव हाला से आकर अपने जीवन के अंतिम वर्षों में कांबर में ही विराजित रहे। कालांतर में सांईं जीवतसिंह जी और सांईं विशिनदास जी की समाधियां भी उसी चबूतरे पर एक साथ स्थापित की गईं, जो रजत पट्टिकाओं (silver straps) से सुशोभित थीं।',
          },
          {
            'title': lang == 0
                ? "📍 Establishment at Kandivali, Mumbai"
                : "📍 कांदिवली, मुंबई में पावन स्थापना",
            'body': lang == 0
                ? 'Following the partition in 1947, a vast majority of devotees migrated to India, primarily settling in Mumbai. There was an intense longing to re-establish Kambar Darbar in Mumbai, yet establishing it without bringing the sacred soil and holy ashes from the original Samadhis in Pakistan seemed incomplete.\n\nAfter many difficult attempts, Saijan guided his great-grandson Dada Kishinchand Villait along with three trusted devotees to visit Kambar, Pakistan. Following divine instructions precisely, Dada Kishinchand succeeded in bringing the sacred ashes.\n\nThe foundation stone at Kandivali was laid on the auspicious day of Cheti Chand in 1960 by revered Mata Chaini Bai. Late Trustee Shri Narain Vaswani spearheaded the establishment. In 1970, Dadi Gopi assumed the spiritual stewardship until 1998, followed by Dadi Kamla Badlani until 2015. The iconic building was designed by esteemed architect Shri Ram Hingoraney as pure selfless Seva.'
                : '1947 के विभाजन के उपरांत अधिकांश सिंधी श्रद्धालु भारत आकर मुख्य रूप से मुंबई में बस गए। संगत के हृदय में कांबर दरबार को पुनः स्थापित करने की प्रबल अभिलाषा थी, परंतु सिंध (पाकिस्तान) में स्थित मूल समाधियों की पावन भस्म लाए बिना यह संभव नहीं था।\n\nअनेक कठिनाइयों के बाद, सांईंजन की प्रेरणा से उनके प्रपौत्र दादा किशनचंद विलायत 3 अन्य श्रद्धालुओं के साथ कांबर गए और अत्यंत कुशलतापूर्वक पावन समाधियों की पवित्र भस्म लाने में सफल हुए।\n\nकांदिवली दरबार की आधारशिला 1960 में चेटीचंड के पावन पर्व पर पूज्य माता चैनीबाई के कर-कमलों द्वारा रखी गई। समर्पित ट्रस्टी श्री नारायण वासवानी जी ने इस पावन स्थल का निर्माण कराया। 1970 में आदी चैनीबाई के उपरांत पूज्य दादी गोपी जी ने तथा 1999 से 2015 तक पूज्य दादी कमला बदलानी जी ने आध्यात्मिक बागडोर संभाली। इस भव्य भवन का वास्तुशिल्प प्रसिद्ध वास्तुकार श्री राम हिंगोराणी जी ने निष्काम सेवा भाव से तैयार किया था।',
          },
          {
            'title': lang == 0 ? "✨ Sain Vilayatrai Sahib" : "✨ सांईं वली विलायतराय साहिब",
            'body': lang == 0
                ? '• Divine Awakening:\nBorn on Janmashtami in 1825 in Halla (Sindh) to Munshi Pratab Rai and Mata Cheti Bai. While working as a revenue official (Tapedar), he experienced a divine vision from Guru Nanak Devji urging him to realize his spiritual mission as an enlightened Yogi from previous births.\n\n• Teachings & Grace:\nHe preached "Bhakti in Grahasti"—that God is nearer to you than your own eyes, and Supreme Realization is achievable through pure love, Simran, and selfless Seva while fulfilling family duties. Devotees attained instant samadhi simply by meeting his radiant gaze.\n\n• Mahasamadhi:\nOn 14th January 1887, after an evening Satsang, he announced his departure and merged with the Supreme Divine at precisely 4:00 AM on 15th January 1887 at the age of 62.'
                : '• पावन प्राकट्य एवं जागृति:\nसांईंजन का जन्म 1825 की श्रीकृष्ण जन्माष्टमी को हाला (सिंध) में मुंशी प्रताप राय और माता चेतीबाई के घर हुआ। ब्रिटिश काल में राजस्व अधिकारी (तपेदार) के पद पर रहते हुए उन्हें श्री गुरु नानक देव जी के साक्षात दर्शन हुए, जिन्होंने उन्हें पूर्व जन्म के उच्च योगी स्वरूप का स्मरण कराकर जनकल्याण का आदेश दिया।\n\n• उपदेश व कृपा:\nउन्होंने "गृहस्थ में भक्ति" का पावन मार्ग दिखाया कि ईश्वर हमारी अपनी आंखों से भी अधिक निकट है, जिसे प्रेम, सेवा और ॐ के जप द्वारा सरलता से पाया जा सकता है। उनकी एक कृपा दृष्टि से भक्तों के जन्म-जन्मांतर के संताप मिट जाते थे।\n\n• महासमाधि:\n14 जनवरी 1887 की रात सत्संग समाप्त कर उन्होंने अपने प्रयाण की घोषणा की और 15 जनवरी 1887 को प्रातः ठीक 4:00 बजे 62 वर्ष की आयु में ब्रह्मलीन हो गए।',
          },
          {
            'title': lang == 0 ? "🌸 Sain Jiwatsingh Sahib" : "🌸 सांईं जीवतसिंह साहिब",
            'body': lang == 0
                ? '• Transformation:\nBorn in 1831 to a prominent family in Kambar. A single divine glance from Vali Vilayatrai transformed him from a luxury-seeking young man into one of Sindh\'s most humble, reverent saints.\n\n• Service & Shabads:\nBestowed with divine boons, he composed over 125 sacred hymns (Kalaams/Kafis) filled with deep devotion for Krishna and Guru. When asked by his Guru to redirect miracles into tangible relief, he initiated the practice of charitable medicine and blessings for the suffering—a legacy flourishing today.\n\n• Ichha-Mrityu:\nBestowed with the boon of departing at will, he announced his departure one year in advance. Sleeping at 10:00 PM on 14th January 1899 chanting "OM", he peacefully departed exactly at 4:00 AM on 15th January 1899, mirroring the exact date and hour of his Satguru.'
                : '• पावन रूपांतरण:\n1831 में कांबर के प्रतिष्ठित परिवार में जन्मे सांईं जीवतसिंह जी पहले सांसारिक सुखों में लीन थे। परंतु सांईं विलायतराय साहिब की एक पावन दृष्टि ने उनके भीतर वैराग्य और भक्ति का दीप प्रज्वलित कर दिया।\n\n• सेवा एवं पावन कलाम:\nवे सतगुरु और भगवान श्रीकृष्ण के अनन्य प्रेमी बने। उन्होंने 125 से अधिक भक्तिमय कलामों की रचना की जो आज भी दरबार में गाए जाते हैं। गुरु आज्ञा से उन्होंने चमत्कारों के स्थान पर औषधियों और आशीष द्वारा दीन-दुखियों के कष्ट हरने की जो परंपरा शुरू की, वह आज आधुनिक चिकित्सालय के रूप में विद्यमान है।\n\n• इच्छामृत्यु का वरदान:\nउन्होंने अपने गुरु की भांति एक वर्ष पूर्व ही निर्वाण की घोषणा कर दी थी। 14 जनवरी 1899 की रात्रि 10:00 बजे ॐ का जप करते हुए वे ध्यानस्थ हुए और ठीक 15 जनवरी प्रातः 4:00 बजे अपने सतगुरु के पावन चरणों में विलीन हो गए।',
          },
          {
            'title': lang == 0 ? "🌼 Sain Vishindas Sahib" : "🌼 सांईं विशिनदास साहिब",
            'body': lang == 0
                ? '• Early Life & Asceticism:\nBorn in 1889 to Shri Karamchand Sainani at Kambar. At the tender age of 14, he assumed spiritual stewardship of Kambar Darbar. A lifelong celibate (Bal Brahmachari), he mastered scriptures and embodied absolute Karma Yoga.\n\n• Unmatched Humility & Dispensary:\nHe expanded free charitable medical treatments across multiple specialties (Eye, ENT, Skin, Ortho, Gynec). Despite boundless divine powers, he remained deeply humble, never allowing devotees to touch his feet and attributing every miracle to his Satgurus.\n\n• Vision of the Trust:\nForeseeing the sociopolitical upheaval and future partition, he established the formal Trust structure to protect and preserve Kambar Darbar’s spiritual assets before taking Mahasamadhi in 1942 at age 53.'
                : '• बाल्यकाल एवं वैराग्य:\n1889 में कांबर में जन्मे सांईं विशिनदास साहिब ने मात्र 14 वर्ष की अल्पायु में कांबर दरबार की सेवा संभाल ली। आजीवन बाल ब्रह्मचारी रहकर उन्होंने वेद-वेदांत, गुरु ग्रंथ साहिब का गहन अध्ययन किया और निष्काम कर्मयोग का आदर्श स्थापित किया।\n\n• विनम्रता एवं चिकित्सा सेवा:\nउन्होंने निःशुल्क औषधालय का व्यापक विस्तार किया जहां नेत्र, त्वचा, अस्थि आदि रोगों का उपचार किया जाता था। अपार सिद्धियों के स्वामी होने पर भी उन्होंने कभी किसी को चरण स्पर्श नहीं करने दिया और सारा श्रेय अपने सतगुरुओं को समर्पित किया।\n\n• दूरदर्शी ट्रस्ट का गठन:\nभविष्य के विभाजन और विस्थापन को पहले ही भांपकर, उन्होंने दरबार की व्यवस्था और मर्यादा को अक्षुण्ण रखने हेतु 1942 में ट्रस्ट का गठन किया और 53 वर्ष की आयु में महासमाधि प्राप्त की।',
          },
          {
            'title': lang == 0 ? "🪔 Mata Chaini Bai (Adi Darbar Wari)" : "🪔 पूज्य माता चैनीबाई (आदी दरबार वारी)",
            'body': lang == 0
                ? 'Born in Larkana, Mata Chaini Bai dedicated her entire life to Kambar Darbar following the early demise of her husband. She raised Sai Vishindas Sahib with maternal devotion akin to Mata Yashoda nurturing Krishna.\n\nHer selfless round-the-clock service, intense meditation, and unwavering purity granted her high spiritual realization and foresight. She guarded the Darbar in Pakistan after partition until the sacred ashes were safely dispatched to India. Arriving in Mumbai, she laid the foundation stone for the Kandivli shrine in 1960 and remained its spiritual pillar until merging with the Divine in 1966 at age 95.'
                : 'लरकाना में जन्मी माता चैनीबाई ने युवावस्था में ही अपना जीवन दरबार साहिब को समर्पित कर दिया। उन्होंने सांईं विशिनदास साहिब का लालन-पालन उसी वात्सल्य भाव से किया जैसे माता यशोदा ने भगवान श्रीकृष्ण का किया था।\n\nसंगत की दिन-रात सेवा, अखंड सिमरन और पवित्रता के बल पर उन्हें अपार आध्यात्मिक शक्तियां प्राप्त हुईं। विभाजन के बाद भी वे सिंध में दरबार की रक्षा करती रहीं और तभी भारत आईं जब समाधियों की पवित्र भस्म सुरक्षित मुंबई भेज दी गई। उन्होंने 1960 में कांदिवली दरबार की नींव रखी और 1966 में 95 वर्ष की आयु में महाप्रयाण किया।',
          },
          {
            'title': lang == 0 ? "🕊️ Dadi Gopi Sahib" : "🕊️ पूज्य दादी गोपी साहिब",
            'body': lang == 0
                ? 'Born in 1921 at Larkana, Dadi Gopi was the daughter of Trustee Shri Brahmanand Sainani (brother of Sai Vishindas Sahib). Under Saijan\'s guidance, she embraced a life of pure spiritual dedication and Naam Simran.\n\nAssuming spiritual stewardship in 1970, Dadiji established the cherished Sunday morning Satsangs, evening Katha, and grand 3-day Diwali Melas, uniting devotees across India and worldwide (USA, Spain, UAE, UK). Her compassion, divine guidance, and loving Ardaas brought solace to thousands until her peaceful departure on 25th October 1998.'
                : '1921 में लरकाना में जन्मी दादी गोपी साहिब, सांईं विशिनदास जी के अनुज दादा ब्रह्मानंद जी की सुपुत्री थीं। सतगुरु के वचनानुसार उन्होंने सांसारिक बंधनों से मुक्त रहकर अपना जीवन नाम-सिमरन और दरबार सेवा में लगाया।\n\n1970 में दरबार की आध्यात्मिक बागडोर संभालकर उन्होंने नियमित रविवार प्रभात सत्संग, सांध्य कथा और 3-दिवसीय दीपावली मेले की भव्य परंपरा स्थापित की, जिससे देश-विदेश की संगत जुड़ी। अपनी ममतामयी अरदास और मार्गदर्शन से अनगिनत श्रद्धालुओं के कष्ट हरते हुए वे 25 अक्टूबर 1998 को ज्योति-जोत समाईं।',
          },
          {
            'title': lang == 0 ? "🌺 Dadi Kamla Badlani" : "🌺 पूज्य दादी कमला बदलानी",
            'body': lang == 0
                ? 'Born on 31st May 1917, Dadi Kamla was the living embodiment of a "Poorna Yogi"—anchored in desireless simplicity, tranquility, and unconditional Krishna Bhakti. Early tragedies and the loss of her husband in 1942 deepened her detachment from worldly allurements.\n\nBlessed directly by Sai Vishindas Sahib with the 18th Chapter of the Bhagavad Gita and Sukh Sagar, she guided the Darbar\'s spiritual activities from 1999 onwards. Free from anger and material longing, she led the Sangat with motherly grace until peacefully merging into Krishna’s eternal presence in February 2015 at age 97.'
                : '31 मई 1917 को जन्मी पूज्य दादी कमला साहिब एक "पूर्ण योगी" का साक्षात स्वरूप थीं। युवावस्था में ही जीवन साथी के वियोग के उपरांत उन्होंने वेदांत, सामी के श्लोकों और कृष्ण भक्ति को अपने जीवन का आधार बनाया।\n\nसांईं विशिनदास साहिब ने उन्हें गीता के 18वें अध्याय व सुख सागर की पावन दीक्षा दी थी। 1999 से उन्होंने दरबार की आध्यात्मिक सेवा अत्यंत कुशलतापूर्वक संभाली। क्रोध, लोभ और सांसारिक इच्छाओं से सर्वथा मुक्त रहकर उन्होंने संगत को वात्सल्य दिया और फरवरी 2015 में 97 वर्ष की पावन आयु में श्रीकृष्ण चरणों में लीन हुईं।',
          },
          {
            'title': lang == 0 ? "🏢 Trust Administration & Facilities" : "🏢 ट्रस्ट प्रबंधन एवं सेवा प्रकल्प",
            'body': lang == 0
                ? 'Managing the sacred one-acre campus at Shantilal Modi Road, Kandivli (West), Mumbai:\n\n• Four Key Buildings: Main Sanctum, Block A, Blocks C & D (guest accommodation with over 100 rooms for visiting devotees), and Block E (Medical Center).\n• Multi-Specialty Charitable Clinic: Providing highly subsidized OPD, cataract eye surgeries, cervical cancer vaccination, pathology diagnostics, dental care, and specialty consultations.\n• Strict Non-Solicitation Policy: Neither the trustees nor the administration ever solicit donations. All Seva is carried out voluntarily purely on devotees\' unguided devotion.'
                : 'कांदिवली (पश्चिम), मुंबई स्थित शांतिलाल मोदी रोड पर एक एकड़ में फैले पावन परिसर का संचालन:\n\n• 4 प्रमुख भवन: मुख्य समाधि मंदिर, ब्लॉक A, ब्लॉक C व D (देश-विदेश के श्रद्धालुओं हेतु 100 से अधिक सुसज्जित कक्ष) एवं ब्लॉक E (आधुनिक चिकित्सा केंद्र)।\n• बहु-विशेषज्ञता चेरिटेबल क्लिनिक: अत्यंत न्यूनतम दरों पर सामान्य ओपीडी, मोतियाबिंद ऑपरेशन, सर्वाइकल कैंसर टीका, पैथोलॉजी लैब, एक्स-रे और दंत चिकित्सा।\n• दान न मांगने का सिद्धांत: सतगुरुओं के आदेशानुसार दरबार में कभी किसी से दान नहीं मांगा जाता। सभी सेवा प्रकल्प श्रद्धालुओं के स्वैच्छिक सहयोग से सुचारू रूप से संचालित होते हैं।',
          },
          {
            'title': lang == 0 ? "👥 Board of Trustees & Contact" : "👥 मार्गदर्शक ट्रस्टी मंडल एवं संपर्क",
            'body': lang == 0
                ? '• Sai Vilayatrai Sai Jiwatsingh Kambar Darbar Sahib Trust:\n1. Shri Prabhu S. Sainani (Resident Trustee)\n2. Shri Shamsunder L. Sidhwani\n3. Shri Raveen Chugani\n4. Shri Narain Chhalwani\n\n• Sai Vilayatrai Sai Jiwatsingh Sai Vishindas Charitable Trust:\n1. Shri Prabhu S. Sainani\n2. Shri Shamsunder L. Sidhwani\n3. Shri Ashok Dudani\n4. Dr. Prakash Chandiramani\n\n• Contact Details:\n- General Enquiries: 8976081672\n- Medical Clinic: 9029911644\n- Dental Clinic: 7400072847\n- Email: info@kambardarbar.org | p_sainani@rediffmail.com'
                : '• सांईं विलायतराय सांईं जीवतसिंह कांबर दरबार साहिब ट्रस्ट:\n1. श्री प्रभु एस. सैनाणी (रेजिडेंट ट्रस्टी)\n2. श्री श्यामसुंदर एल. सिद्धवाणी\n3. श्री रवीण चुगानी\n4. श्री नारायण छलवाणी\n\n• सांईं विलायतराय सांईं जीवतसिंह सांईं विशिनदास चेरिटेबल ट्रस्ट:\n1. श्री प्रभु एस. सैनाणी\n2. श्री श्यामसुंदर एल. सिद्धवाणी\n3. श्री अशोक दुदानी\n4. डॉ. प्रकाश चंदीरमाणी\n\n• संपर्क सूत्र:\n- दरबार कार्यालय: 8976081672\n- जनरल मेडिकल क्लिनिक: 9029911644\n- डेंटल क्लिनिक: 7400072847\n- ईमेल: info@kambardarbar.org | p_sainani@rediffmail.com',
          },
        ];

        final String overviewText = lang == 0
            ? "Kambar Darbar is situated at Kandivali (West), Mumbai, India. The sacred site was selected by late Trustee Shri Narain Vaswani, who was miraculously guided to this serene location. The Darbar primarily houses the holy Samadhis of our revered Satgurus: Sai Vilayatrai Sahib, Sai Jiwatsingh Sahib, and Sai Vishindas Sahib.\n\nAdjacent to the central Samadhi room are two sacred halls: one housing the Guru Granth Sahibji, and the other displaying life-size divine portraits of the Satgurus, Shri Nathji, alongside the sacred Samadhis of Adi Chaini Bai and Dadi Gopi Sahib, who preserved and expanded the spiritual lineage in India. The subsequent spiritual head was Dadi Kamla Badlani, who merged into the Divine in 2015."
            : "कांबर दरबार कांदिवली (पश्चिम), मुंबई, भारत में स्थित है। इस पावन स्थल का चयन दिवंगत ट्रस्टी श्री नारायण वासवानी जी द्वारा किया गया था, जिन्हें अलौकिक प्रेरणा से यह शांत वातावरण प्राप्त हुआ। दरबार में मुख्य रूप से हमारे पूज्य सतगुरुओं—सांईं विलायतराय साहिब, सांईं जीवतसिंह साहिब और सांईं विशिनदास साहिब की पवित्र समाधियां स्थापित हैं।\n\nसमाधि कक्ष के समीप दो पावन कक्ष हैं: एक में श्री गुरु ग्रंथ साहिब जी का प्रकाश है तथा दूसरे में सतगुरुओं, श्रीनाथजी के भव्य चित्र और पूज्य आदी चैनीबाई व दादी गोपी साहिब की समाधियां सुशोभित हैं जिन्होंने भारत में संगत को निरंतर आध्यात्मिक मार्गदर्शन प्रदान किया। इसके पश्चात पूज्य दादी कमला बदलानी जी ने 2015 तक आध्यात्मिक दायित्व का निर्वहन किया।";

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              lang == 0 ? 'About Kambar Darbar' : 'दरबार परिचय एवं इतिहास',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: accentColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              // Overview Lead Card
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFFFE0B2).withOpacity(0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black45 : Colors.orange.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.temple_hindu_rounded, color: accentColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lang == 0 ? "Sacred Abode in Mumbai" : "कांदिवली में पावन धाम",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        overviewText,
                        maxLines: _isReadMore ? 100 : 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                          onPressed: () {
                            setState(() {
                              _isReadMore = !_isReadMore;
                            });
                          },
                          icon: Icon(
                            _isReadMore ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                            size: 18,
                            color: accentColor,
                          ),
                          label: Text(
                            _isReadMore
                                ? (lang == 0 ? "Show Less" : "कम देखें")
                                : (lang == 0 ? "Read Full Overview" : "पूरा विवरण पढ़ें"),
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Detailed Expandable Modules
              ...aboutSections.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black.withOpacity(0.04),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black45 : Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                        secondary: accentColor,
                      ),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      title: Text(
                        item['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      iconColor: accentColor,
                      collapsedIconColor: isDark ? Colors.white54 : Colors.grey,
                      children: [
                        Divider(height: 1, color: dividerColor),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['body']!,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                              color: secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}