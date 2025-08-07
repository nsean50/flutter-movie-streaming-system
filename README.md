# نظام الأفلام والمسلسلات

نظام متكامل لعرض وإدارة الأفلام والمسلسلات العربية والأجنبية، مكون من تطبيقين منفصلين مبنيين بـ Flutter.

## التطبيقات

### 1. تطبيق المستخدمين (User App)
- عرض الأفلام والمسلسلات مقسمة حسب الفئات (أكشن، دراما، رعب، كوميدي)
- تشغيل الفيديوهات من روابط خارجية (Google Drive, M3U8)
- مشغل فيديو بجودة تلقائية حسب سرعة الإنترنت
- إعلانات AdMob متكاملة
- واجهة مستخدم جذابة بتصميم Netflix-style
- لا يتطلب تسجيل دخول

### 2. تطبيق الإدارة (Admin App)
- تسجيل دخول بسيط برمز PIN (افتراضي: 1234)
- إضافة أفلام ومسلسلات جديدة
- تعديل وحذف المحتوى الموجود
- إدارة البيانات الوصفية (العنوان، الوصف، الفئة، اللغة، الروابط)
- واجهة إدارية سهلة الاستخدام

## المميزات التقنية

- **Flutter 3.19.0** - إطار عمل متقدم للتطبيقات المحمولة
- **Firebase Firestore** - قاعدة بيانات سحابية للتخزين المشترك
- **Video Player** - مشغل فيديو متقدم مع دعم الروابط الخارجية
- **AdMob Integration** - نظام إعلانات Google
- **GitHub Actions** - بناء تلقائي لملفات APK
- **Responsive Design** - تصميم متجاوب يدعم جميع أحجام الشاشات

## إعداد Firebase

### 1. إنشاء مشروع Firebase جديد
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على "إنشاء مشروع" أو "Create a project"
3. أدخل اسم المشروع (مثل: movie-streaming-app)
4. اختر إعدادات Google Analytics (اختياري)
5. انقر على "إنشاء المشروع"

### 2. إعداد Firestore Database
1. في لوحة تحكم Firebase، اذهب إلى "Firestore Database"
2. انقر على "إنشاء قاعدة بيانات" أو "Create database"
3. اختر "Start in test mode" للبداية
4. اختر موقع قاعدة البيانات (يفضل أقرب منطقة جغرافية)
5. انقر على "تم" أو "Done"

### 3. إعداد قواعد الأمان
في قسم "Rules" في Firestore، استخدم هذه القواعد:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // السماح بالقراءة للجميع، الكتابة للمطورين فقط
    match /movies/{document} {
      allow read: if true;
      allow write: if request.auth != null; // يمكن تعديلها حسب نظام المصادقة
    }
  }
}
```

### 4. إضافة التطبيقات إلى Firebase

#### للتطبيق الأول (User App):
1. انقر على أيقونة Android في لوحة التحكم
2. أدخل package name: `com.moviestreaming.userapp`
3. أدخل اسم التطبيق: `أفلام ومسلسلات`
4. حمل ملف `google-services.json`
5. ضع الملف في: `user_app/android/app/google-services.json`

#### للتطبيق الثاني (Admin App):
1. انقر على "إضافة تطبيق" واختر Android
2. أدخل package name: `com.moviestreaming.adminapp`
3. أدخل اسم التطبيق: `إدارة الأفلام والمسلسلات`
4. حمل ملف `google-services.json`
5. ضع الملف في: `admin_app/android/app/google-services.json`

### 5. تحديث إعدادات Android

أضف هذا السطر إلى ملف `android/app/build.gradle` في كلا التطبيقين:

```gradle
// في نهاية الملف
apply plugin: 'com.google.gms.google-services'
```

وأضف هذا السطر إلى ملف `android/build.gradle`:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

## إعداد AdMob

### الأكواد التجريبية المستخدمة حالياً:
- **Banner Ad**: `ca-app-pub-3940256099942544/6300978111`
- **Interstitial Ad**: `ca-app-pub-3940256099942544/1033173712`

### لاستخدام أكواد AdMob الحقيقية:
1. أنشئ حساب في [AdMob](https://admob.google.com/)
2. أضف تطبيقك وأنشئ وحدات إعلانية
3. استبدل الأكواد في ملف `user_app/lib/services/ad_service.dart`

## التثبيت والتشغيل

### متطلبات النظام:
- Flutter SDK 3.19.0 أو أحدث
- Android SDK
- Java 17

### خطوات التثبيت:

1. **استنساخ المشروع:**
```bash
git clone [repository-url]
cd movie_streaming_system
```

2. **تثبيت التبعيات:**
```bash
# للتطبيق الأول
cd user_app
flutter pub get

# للتطبيق الثاني
cd ../admin_app
flutter pub get
```

3. **إضافة ملفات Firebase:**
- ضع `google-services.json` في المجلدات المناسبة كما هو موضح أعلاه

4. **بناء التطبيقات:**
```bash
# بناء تطبيق المستخدمين
cd user_app
flutter build apk --release

# بناء تطبيق الإدارة
cd ../admin_app
flutter build apk --release
```

## البناء التلقائي

يتم بناء ملفات APK تلقائياً عند كل push إلى المستودع باستخدام GitHub Actions. ستجد ملفات APK في قسم "Releases" أو "Artifacts".

## هيكل المشروع

```
movie_streaming_system/
├── user_app/                 # تطبيق المستخدمين
│   ├── lib/
│   │   ├── models/          # نماذج البيانات
│   │   ├── services/        # خدمات Firebase و AdMob
│   │   ├── screens/         # شاشات التطبيق
│   │   ├── widgets/         # مكونات واجهة المستخدم
│   │   └── main.dart        # نقطة البداية
│   └── android/app/         # إعدادات Android
├── admin_app/               # تطبيق الإدارة
│   ├── lib/
│   │   ├── models/          # نماذج البيانات
│   │   ├── services/        # خدمات Firebase
│   │   ├── screens/         # شاشات التطبيق
│   │   └── main.dart        # نقطة البداية
│   └── android/app/         # إعدادات Android
├── .github/workflows/       # إعدادات GitHub Actions
└── README.md               # هذا الملف
```

## الاستخدام

### تطبيق المستخدمين:
1. افتح التطبيق
2. تصفح الأفلام حسب الفئات
3. انقر على أي فيلم لعرض التفاصيل
4. اضغط "مشاهدة الآن" لتشغيل الفيديو

### تطبيق الإدارة:
1. افتح التطبيق
2. أدخل رمز PIN: `1234`
3. أضف أفلام جديدة أو عدل الموجود
4. البيانات ستظهر فوراً في تطبيق المستخدمين

## الدعم الفني

للمساعدة أو الإبلاغ عن مشاكل، يرجى إنشاء issue في المستودع أو التواصل مع المطور.

## الترخيص

هذا المشروع مفتوح المصدر ومتاح للاستخدام الشخصي والتجاري.
