class L {
  static String get(String key, String locale) {
    const dict = {
      // Slides Part => START
      'dict_slide1_title': {
        'en': 'CONNECT',
        'ar': 'ارتبط',
        'tr': 'BAĞLAN',
      },
      'dict_slide1_subtitle': {
        'en':
            'Connect devices to the same network - use Wi-Fi or Mobile Hotspot',
        'ar':
            'قم بتوصيل الأجهزة بالشبكة نفسها - استخدم واي-فاي أو نقطة اتصال جوال',
        'tr':
            'Cihazları aynı ağa bağlayın - Kablosuz veya Mobil Erişim Noktası kullanın',
      },
      'dict_slide2_title': {
        'en': 'SEND',
        'ar': 'أرسل',
        'tr': 'GÖNDER',
      },
      'dict_slide2_subtitle': {
        'en': 'Send any file or text or even a whole app!',
        'ar': '!أرسل أي ملف أو نص أو حتى تطبيق',
        'tr': 'Herhangi bir dosya, metin veya tam bir istek gönderin!',
      },
      'dict_slide3_title': {
        'en': 'RECEIVE',
        'ar': 'استلم',
        'tr': 'ALMAK',
      },
      'dict_slide3_subtitle': {
        'en': 'Receive the file on any device that is on the same network',
        'ar': 'استلم الملف على أي جهاز متصل بالشبكة نفسها',
        'tr': 'Dosyayı aynı ağdaki herhangi bir cihazdan alın',
      },
      'dict_slide4_title': {
        'en': 'EVERYWHERE',
        'ar': 'في كل مكان',
        'tr': 'HER YERDE',
      },
      'dict_slide4_subtitle': {
        'en':
            'Sharik is available for Android, Windows, macOS, and Linux! \n Click here to learn more',
        'ar':
            '!برنامج شارك متاح لاجهزة الأندرويد و الويندوز والماك و أيضا اللينكس \n انقر هنا لمعرفة المزيد',
        'tr':
            'Sharik Android, Windows, macOS ve Linux için kullanılabilir! \n Daha fazlasını öğrenmek için buraya tıklayın',
      },
      // Slides Part => END
      'dict_done': {
        'en': 'DONE',
        'ar': 'انتهى',
        'tr': 'YAPILAN',
      },
      'dict_next': {
        'en': 'NEXT',
        'ar': 'التالى',
        'tr': 'SONRAKİ',
      },
      'dict_loading': {
        'en': 'loading...',
        'ar': '...جار التحميل',
        'tr': 'Yükleniyor...',
      },
      'dict_mobile_hotspot': {
        'en': 'Mobile Hotspot',
        'ar': 'نقطة اتصال جوّال',
        'tr': 'Mobil Hotspot',
      },
      'dict_connect_to': {
        'en': 'Connect to',
        'ar': 'الاتصال بـ',
        'tr': 'Bağlanmak',
      },
      'dict_or_enable': {
        'en': 'or set up a',
        'ar': 'أو إعداد',
        'tr': 'veya bir',
      },
      'dict_not_connected': {
        'en': 'Not connected',
        'ar': 'غير متصل',
        'tr': 'Bağlı değil',
      },
      'dict_now_open': {
        'en': 'Now open this link in any browser',
        'ar': 'الآن افتح هذا الرابط في أي متصفح',
        'tr': 'Şimdi bu bağlantıyı herhangi bir tarayıcıda açın',
      },
      'dict_the_recipient': {
        'en': 'The recipient needs to be connected to the same network',
        'ar': 'يجب أن يكون المستلم متصلاً بنفس الشبكة',
        'tr': 'Alıcının aynı ağa bağlı olması gerekir',
      },
      'dict_select_file': {
        'en': 'Select a file',
        'ar': 'حدد ملف',
        'tr': 'Bir dosya seçin',
      },
      'dict_latest': {
        'en': 'Latest',
        'ar': 'الأحدث',
        'tr': 'En son',
      },
      'dict_undefined': {
        'en': 'Undefined',
        'ar': 'غير معرف',
        'tr': 'Tanımsız',
      },
      'dict_copied': {
        'en': 'Copied to clipboard',
        'ar': 'تم النسخ',
        'tr': 'Panoya kopyalandı',
      },
      'dict_type_text': {
        'en': 'Type some text',
        'ar': 'اكتب بعض النص',
        'tr': 'Biraz metin yazın',
      },
      'dict_close': {
        'en': 'Close',
        'ar': 'إغلاق',
        'tr': 'kapamak',
      },
      'dict_send': {
        'en': 'Send',
        'ar': 'أرسل',
        'tr': 'Gönder',
      },
      'dict_text': {
        'en': 'Text',
        'ar': 'نص',
        'tr': 'Metin',
      },
      'dict_app': {
        'en': 'App',
        'ar': 'تطبيق',
        'tr': 'Uygulama',
      },
      'dict_hide_system_apps': {
        'en': 'Hide system apps',
        'ar': 'إخفاء تطبيقات النظام',
        'tr': 'Sistem uygulamalarını gizle',
      },
      'dict_hide_nonlaunchable_apps': {
        'en': 'Hide non-launchable apps',
        'ar': 'إخفاء التطبيقات التي لا يمكن الوصول إليها',
        'tr': 'Yüklenemeyen uygulamaları gizle',
      },
      'dict_search': {
        'en': 'Search',
        'ar': 'بحث',
        'tr': 'Arama',
      },
      'dict_will_be_implemented': {
        'en': 'Will be implemented in a future update',
        'ar': 'سيتم تنفيذها في التحديث المستقبلي',
        'tr': 'Gelecekteki bir güncellemede uygulanacak'
      },
    };
    return dict[key][locale];
  }
}
