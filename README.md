# NicePoster iOS App

This is the native iOS application for NicePoster, built with **SwiftUI** to achieve Apple Design Awards quality interaction and visuals.

## Features

- **Conversational UI**: A ChatGPT-like interface for marketing campaign creation.
- **Haptic Feedback**: Custom haptic engine for immersive tactile responses.
- **Advanced Editor**: CapCut-inspired image editor with AI capabilities.
- **Native Design**: Fully compliant with Apple's Human Interface Guidelines (HIG).

## Project Structure

```
NicePoster/
├── NicePosterApp.swift    # Entry point
├── ContentView.swift      # Main Tab Navigation
├── DesignSystem/
│   ├── ColorSystem.swift      # Semantic Colors & Gradients
│   ├── TypographySystem.swift # Dynamic Type Styles
│   ├── HapticsSystem.swift    # CoreHaptics Manager
│   └── Components.swift       # Reusable UI Components
├── Features/
│   ├── Home/                  # Chat & Creation Flow
│   ├── Editor/                # Image Editor
│   └── Cart/                  # Shopping Cart & Export
├── Models/                    # Data Models
└── Assets.xcassets/           # Asset Catalogs
```

## How to Run

1. Open **Xcode**.
2. Select **Open a project or file**.
3. Select the `NicePoster-iOS/NicePoster.xcodeproj` file (if you have created it).
4. If you have not created an xcodeproj yet:
    - Open Xcode.
    - Create a new Project named `NicePoster`.
    - Ensure it is in `/Users/jerritan/Workspace/NicePoster-iOS/`.
    - Drag the generated folders (`DesignSystem`, `Features`, `Models`) into the project in Xcode.

## Design Highlights

- **Haptics**: Try double-tapping generated images or sliding the editor tools.
- **Animations**: Observe the smooth transitions in the chat bubbles and card carousels.
- **Colors**: Automatically adapts to Light and Dark modes with semantic coloring.
