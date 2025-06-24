# XP-FIT 🏃‍♂️💪

A gamified mobile fitness and nutrition tracking application that transforms health monitoring into a fun and engaging experience.

![WhatsApp Image 2025-04-24 à 17 56 55_a34ba628](https://github.com/user-attachments/assets/780e64df-1952-40af-81c2-9deba0431e10)


## 📱 Project Overview

XP-FIT is a comprehensive Flutter-based mobile application designed to help users achieve their fitness goals through gamification, personalized tracking, and intelligent nutrition guidance. The app combines modern UI/UX design with powerful backend integrations to create an engaging fitness experience.

## ✨ Key Features

### 🎯 **Physical Evolution Tracking**
- Monitor progress from current to target weight
- Visual progress indicators and milestone celebrations
- Personalized avatar system with progression rewards

### 🍽️ **Weekly Meal Planning**
- Structured nutrition guidance with API-powered meal suggestions
- Detailed nutritional information and calorie tracking
- Customizable meal preferences and dietary restrictions

### 💪 **Exercise Library**
- Comprehensive workout database with detailed instructions
- GIF demonstrations for proper exercise form
- Muscle-specific exercise targeting
- Difficulty level categorization

### ⭐ **Favorites System**
- Save preferred meals and exercises for quick access
- Personalized recommendations based on user preferences
- Offline access to saved content

### 🤖 **AI-Powered Chatbot**
- Interactive fitness and nutrition guidance
- Personalized workout and meal recommendations
- Real-time answers to health and fitness questions

### 🔐 **User Authentication**
- Secure user registration and login system
- Password hashing with bcrypt
- Profile management with avatar customization

## 🛠️ Technology Stack

### **Frontend**
- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **UI Components**: Material Design with custom theming
- **Icons**: Font Awesome Flutter
- **Typography**: Google Fonts

### **Backend & Data**
- **Local Database**: SQLite (sqflite)
- **Caching**: Shared Preferences
- **API Integration**: HTTP package
- **Security**: bcrypt for password hashing

### **External APIs**
- **Nutrition Data**: Spoonacular API
- **Exercise Database**: ExerciseDB API
- **AI Integration**: Google Generative AI

### **Development Tools**
- **IDE**: VS Code / Android Studio
- **API Testing**: Postman
- **Version Control**: Git

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── UI/
│   ├── pages/
│   │   ├── auth/            # Authentication pages
│   │   ├── home.page.dart   # Main dashboard
│   │   ├── nutrition.page.dart
│   │   ├── exercice.page.dart
│   │   ├── favorites.page.dart
│   │   ├── chatbot.page.dart
│   │   └── avatar_selection.page.dart
│   └── widgets/             # Reusable UI components
├── DB/
│   └── db_helper.dart       # SQLite database operations
└── API/
    ├── nutrition.api.dart   # Nutrition API integration
    └── exercice.api.dart    # Exercise API integration
```

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/XP-FIT.git
   cd XP-FIT
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Setup**
   - Create a `.env` file in the project root
   - Add your API keys:
     ```
     SPOONACULAR_API_KEY=your_spoonacular_api_key
     EXERCISEDB_API_KEY=your_exercisedb_api_key
     GOOGLE_AI_API_KEY=your_google_ai_api_key
     ```

4. **Run the application**
   ```bash
   flutter run
   ```

### API Keys Required
- **Spoonacular API**: For nutrition and meal data
- **ExerciseDB API**: For workout and exercise information
- **Google Generative AI**: For chatbot functionality

## 🎮 Usage Guide

### Getting Started
1. **Registration**: Create a new account with email and password
2. **Avatar Selection**: Choose your personalized avatar
3. **Profile Setup**: Enter your current weight and target goals
4. **Explore Features**: Navigate through nutrition, exercises, and favorites

### Main Features
- **Dashboard**: View your progress and quick access to features
- **Nutrition**: Browse meals, plan weekly nutrition, and track calories
- **Exercises**: Discover workouts by muscle group and difficulty
- **Favorites**: Access your saved meals and exercises
- **Chatbot**: Get personalized fitness advice and recommendations

## 🏗️ Architecture

### **Database Schema**
- User profiles and authentication data
- Favorites (meals and exercises)
- Progress tracking and milestones
- Weekly nutrition plans

### **API Integration**
- **Weekly Caching**: Optimized API usage with local caching
- **Error Handling**: Robust error management and offline support
- **Data Synchronization**: Seamless online/offline experience

### **Security Features**
- Password hashing with bcrypt
- Secure API key management
- Local data encryption

## 📊 Features in Detail

### **Physical Evolution Tracking**
- Visual progress bars and charts
- Milestone achievements and rewards
- Avatar progression system
- Goal setting and monitoring

### **Nutrition System**
- Comprehensive meal database
- Nutritional information display
- Weekly meal planning
- Calorie and macro tracking
- Dietary preference management

### **Exercise Library**
- Categorized by muscle groups
- Difficulty level filtering
- Step-by-step instructions
- Animated GIF demonstrations
- Equipment requirements

### **Gamification Elements**
- Achievement system
- Progress rewards
- Avatar customization
- Streak tracking
- Social features (planned)

## 🤝 Contributing

We welcome contributions to XP-FIT! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart best practices
- Maintain consistent code formatting
- Add appropriate comments and documentation
- Test thoroughly before submitting

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Khalil Omar Badr** - Lead Developer
- **XP-FIT Development Team**

## 📞 Support

For support, email support@xp-fit.com or create an issue in this repository.

## 🔮 Roadmap

### Upcoming Features
- [ ] Social features and friend challenges
- [ ] Advanced analytics and insights
- [ ] Integration with wearable devices
- [ ] Meal photo recognition
- [ ] Voice-guided workouts
- [ ] Multi-language support

### Version History
- **v1.0.0** - Initial release with core features
- **v1.1.0** - Enhanced UI and performance improvements
- **v1.2.0** - AI chatbot integration

---

<div align="center">
  <p>Made with ❤️ by the XP-FIT Team</p>
  <p>Transform your fitness journey with XP-FIT!</p>
</div>
