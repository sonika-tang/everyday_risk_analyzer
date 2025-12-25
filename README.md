# Everyday Risk Analyzer 📊⚠️

Everyday Risk Analyzer is a **fully offline Flutter mobile application** designed to help users become aware of small, repeated risky behaviors in daily life.  

Instead of focusing on extreme dangers, the app highlights **micro-risks**—habits that seem harmless but can accumulate into serious health, safety, or financial problems over time.

This project was developed as a **final project for Mobile Development course**, following strict offline and architectural requirements.

## Purpose & Problem

In everyday life, people often:
- Sleep too late  
- Skip meals  
- Forget safety equipment (helmets, seatbelts)  
- Ignore hydration  
- Overspend casually  

While each action appears minor, repeated behavior can lead to long-term consequences. Most people **do not recognize these patterns early**.

**Everyday Risk Analyzer** helps students and young adults:
- Log daily risky actions  
- Identify repeating risk patterns  
- Understand trends visually  
- Make safer decisions through simple feedback and reminders  


## Key Features

- **Risk Event Logging**  
  Record daily risk events such as skipping meals, sleeping late, or unsafe travel habits.

- **Pattern & Trend Analysis**  
  Uses basic decision logic to detect frequent or increasing risky behaviors.

- **Risk Feedback System**  
  Visual indicators show which habits are becoming problematic.

- **Simple Reminders**  
  Encourages healthier decisions without overwhelming the user.

- **100% Offline Support**  
  No backend, no API, no internet connection required.

## Application Architecture

The app follows a **layered architecture** as required by the course:

- **UI Layer** – Screens, reusable widgets, consistent design system  
- **Logic Layer** – Decision-making rules for risk evaluation  
- **Data Layer** – Local storage (JSON / Shared Preferences / SQLite)  

State is handled using **Stateful Widgets only** (no external state management libraries).


## Screens

Minimum 3 interactive screens:
1. **Home / Dashboard** – Overview of daily risk level  
2. **Add Risk Event** – Log new risk activities  
3. **History & Analysis** – View trends and patterns over time  

UI updates dynamically based on user interactions and stored data.


## Tech Stack

- **Framework:** Flutter  
- **Language:** Dart  
- **Storage:** Local storage 
- **State Management:** Stateful Widgets  
- **Design Tool:** Figma  


## UI / UX Design

- Clean and simple interface  
- Consistent color palette and typography  
- Reusable components for buttons, cards, and inputs  
- Designed for fast daily logging  

**Wireframe & Design:**  [Figma – Everyday Risk Analyzer](https://www.figma.com/design/yLhdCgrvvNoNFB2ZrEdXYD/Everyday-Risk-Analyzer)


## Assets & Credits

All assets used in this project are either self-designed or sourced from free, open-license platforms.

| Asset Type | Source | License |
|-----------|-------|---------|
| Icons | Material Icons (Flutter SDK) | Apache 2.0 |
| Fonts | Google Fonts | Open Source |
| UI References | Figma Community | Free / Attribution |

---

## Installation & Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/sonika-tang/everyday_risk_analyzer.git
   ```
    Open the project in Android Studio or VS Code

2. Install dependencies:
   ```bash
   flutter pub get
   ```
    Run the app on an emulator or physical device
(Internet connection not required)

## Team

This project was developed as a 2-member group project for academic purposes.
- UI / UX Design
- App Logic & Data Handling
- Testing & Refinement

**Team member:**
- Tang Sonika
- Sar Sovannita

## Limitations

- No cloud synchronization
- Rule-based logic (no AI / ML)
- Depends on user consistency when logging data
- Limited to offline storage only

## Future Improvements
- Smarter risk scoring system
- Custom reminders per risk category
- Data export (CSV / PDF)
- Animations and transitions
- Accessibility improvements

## License

This project was developed for educational purposes only as part of the Mobile Development course.