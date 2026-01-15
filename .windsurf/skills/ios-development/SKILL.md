---
name: ios-development
description: iOS/SwiftUI development best practices following Apple Human Interface Guidelines, with focus on user-friendly interfaces and code quality review
---

# iOS Development Skill for NicePoster

This skill provides guidance for iOS/SwiftUI development following Apple's Human Interface Guidelines (HIG) and best practices for writing high-quality, maintainable code.

## Apple Human Interface Guidelines

### Design Principles
1. **Clarity** - Text is legible at every size, icons are precise and lucid, adornments are subtle and appropriate
2. **Deference** - Fluid motion and crisp interface help users understand and interact with content
3. **Depth** - Visual layers and realistic motion impart vitality and heighten delight and understanding

### Layout & Typography
- Use **Dynamic Type** to support accessibility
- Maintain **44pt minimum touch targets** for interactive elements
- Use **SF Pro** system font for consistency
- Follow safe area insets on all device sizes
- Use semantic spacing (8pt grid system)

### Color Usage
- Support **Light and Dark Mode** using semantic colors
- Ensure **4.5:1 contrast ratio** for text accessibility
- Use **system colors** when possible for automatic adaptation
- Apply brand colors sparingly for emphasis

### Navigation Patterns
- Use **NavigationStack** for hierarchical navigation
- Use **TabView** for flat navigation between sections
- Use **sheet/fullScreenCover** for modal presentations
- Provide clear back navigation and dismiss controls

### Haptic Feedback
- Use **UIImpactFeedbackGenerator** for button taps
- Use **UISelectionFeedbackGenerator** for selections
- Use **UINotificationFeedbackGenerator** for success/error/warning

## SwiftUI Best Practices

### View Structure
```swift
struct ContentView: View {
    // 1. Properties (let/var)
    // 2. @State properties
    // 3. @Binding properties
    // 4. @Environment properties
    // 5. body
    // 6. Computed properties (subviews)
    // 7. Private methods
}
```

### State Management
- Use `@State` for view-local state
- Use `@Binding` for two-way data flow
- Use `@StateObject` for creating ObservableObjects
- Use `@ObservedObject` for injected ObservableObjects
- Use `@EnvironmentObject` for dependency injection

### Performance
- Extract subviews to avoid unnecessary redraws
- Use `@ViewBuilder` for conditional content
- Prefer `LazyVStack/LazyHStack` for large lists
- Use `id()` modifier carefully to avoid view recreation

### Animations
- Use `withAnimation` for state-driven animations
- Prefer `.spring()` for natural motion
- Use `.transition()` for appear/disappear effects
- Keep animations under 350ms for responsiveness

## Code Quality Standards

### Naming Conventions
- Use **camelCase** for variables, functions, properties
- Use **PascalCase** for types, protocols, enums
- Use descriptive names that convey intent
- Prefix private properties with context if needed

### Code Organization
```
Features/
├── FeatureName/
│   ├── FeatureNameView.swift      # Main view
│   ├── Components/                 # Subviews
│   │   ├── ComponentA.swift
│   │   └── ComponentB.swift
│   └── Models/                     # Feature-specific models
DesignSystem/
├── ColorSystem.swift               # NPColors, NPShadow
├── Typography.swift                # Font styles
└── Components/                     # Reusable UI components
```

### MARK Comments
```swift
// MARK: - Properties
// MARK: - Body
// MARK: - Subviews
// MARK: - Private Methods
// MARK: - Preview
```

### Error Handling
- Use `Result` type for async operations
- Provide meaningful error messages
- Handle edge cases gracefully
- Show user-friendly error states

## Design System (NicePoster)

### Colors (NPColors)
- `NPColors.bgPrimary` - Main background
- `NPColors.bgSecondary` - Secondary background
- `NPColors.bgTertiary` - Tertiary background
- `NPColors.textPrimary` - Primary text
- `NPColors.textSecondary` - Secondary text
- `NPColors.textTertiary` - Tertiary text
- `NPColors.brandPrimary` - Brand accent color
- `NPColors.brandGradient` - Brand gradient

### Shadows (NPShadow)
- `NPShadow.shadow1` - Subtle shadow (cards)
- `NPShadow.shadow2` - Medium shadow (elevated elements)
- `NPShadow.shadow3` - Strong shadow (modals)

### Spacing
- Use 4pt increments (4, 8, 12, 16, 20, 24, 32, 40, 48)
- Standard padding: 16-20pt horizontal
- Header padding: 14-16pt vertical

### Corner Radius (NPRadius)
- `NPRadius.small` - 6pt (tags, badges)
- `NPRadius.medium` - 12pt (buttons, inputs)
- `NPRadius.large` - 16pt (cards)
- `NPRadius.full` - 9999pt (pills, circles)

## Code Review Checklist

### UI/UX
- [ ] Follows Apple HIG guidelines
- [ ] Supports both light and dark mode
- [ ] Touch targets are at least 44pt
- [ ] Appropriate haptic feedback
- [ ] Smooth animations (spring-based)
- [ ] Proper safe area handling

### Code Quality
- [ ] Follows naming conventions
- [ ] Proper use of MARK comments
- [ ] No hardcoded colors/values (use design system)
- [ ] State management is appropriate
- [ ] No memory leaks (weak references where needed)
- [ ] Proper error handling

### Performance
- [ ] Views are properly extracted
- [ ] Lazy loading where appropriate
- [ ] No unnecessary state updates
- [ ] Efficient use of modifiers

### Accessibility
- [ ] VoiceOver labels where needed
- [ ] Dynamic Type support
- [ ] Sufficient color contrast
- [ ] Clear focus indicators

## Common Patterns

### Button with Haptic Feedback
```swift
Button(action: {
    HapticManager.shared.lightTap()
    // action
}) {
    // label
}
```

### Card Component
```swift
VStack {
    // content
}
.padding(16)
.background(NPColors.bgSecondary)
.cornerRadius(NPRadius.large)
.shadow(color: NPShadow.shadow2.color, radius: NPShadow.shadow2.radius, x: 0, y: NPShadow.shadow2.y)
```

### Modal Presentation
```swift
.fullScreenCover(isPresented: $showModal) {
    ModalView(onDismiss: { showModal = false })
}
```

### Keyboard Dismissal
```swift
@FocusState private var isFocused: Bool

TextField("Placeholder", text: $text)
    .focused($isFocused)
    .onTapGesture {
        isFocused = true
    }
```
