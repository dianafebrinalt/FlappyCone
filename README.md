# FlappyCone 🦉

**FlappyCone** is a classic arcade-style endless runner game built natively for iOS using Apple's **SpriteKit** framework. Players control an owl, navigating through infinite procedurally generated pipe obstacles to achieve the highest score.

This project demonstrates core game development concepts including physics simulation, collision detection, and scene management in Swift.

## 🎮 Features

* **Endless Gameplay:** Procedurally generated obstacles that appear infinitely.
* **Physics Engine:** Real-time gravity and impulse mechanics using `SKPhysicsBody`.
* **Collision Detection:** Precise bitmask collision categories (Bird, Obstacle, Ground, Score Gap).
* **Polished Hitboxes:** Circular physics body for the main character to ensure fair gameplay.
* **Scoring System:** Invisible physics nodes detect when the player successfully passes a pipe.
* **Game States:** Seamless transitions between Start, Playing, and Game Over screens.

## 🛠 Tech Stack

* **Language:** Swift 5
* **Frameworks:** SpriteKit, GameplayKit
* **IDE:** Xcode
* **Platform:** iOS (iPhone/iPad)

## 🚀 How to Run

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/FlappyCone.git](https://github.com/yourusername/FlappyCone.git)
    ```
2.  **Open the project:**
    Double-click `FlappyCone.xcodeproj` to open it in Xcode.
3.  **Build and Run:**
    * Select an iOS Simulator (e.g., iPhone 15 Pro) or connect your physical device.
    * Press `Cmd + R` or click the Play button in Xcode.

## 🕹 How to Play

1.  **Start:** Tap the screen to begin the game.
2.  **Fly:** Tap anywhere on the screen to make the Owl jump/fly upwards.
3.  **Objective:** Navigate through the gaps between the green pipes.
4.  **Score:** Passing a pipe pair awards +1 point.
5.  **Game Over:** The game ends if the owl hits a pipe or the ground. Tap to restart.

## 📂 Project Structure

* `GameScene.swift`: The core logic of the game. Handles the game loop, touch inputs, physics setup (`setupPhysicsWorld`), and node spawning (`spawnPipes`).
* `PhysicsCategory`: An enum defining bitmasks for collision detection logic.

## 🧩 Code Highlight

The game uses bitmasks to efficiently handle collisions without complex logic trees:

```swift
enum PhysicsCategory {
    static let none: UInt32 = 0
    static let bird: UInt32 = 0b1
    static let obstacle: UInt32 = 0b10
    static let ground: UInt32 = 0b100
    static let scoreGap: UInt32 = 0b1000
}
