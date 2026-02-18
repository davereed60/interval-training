# Interval Training iOS App

## Project Overview
**Platform:** iOS
**Language:** Swift
**Target iOS Version:**
**Development Start:**

## Description
[Brief description of the app's purpose and target audience]

## Core Features
- [ ] scale type and root input
- [ ] input scale
- [ ] input interval note
- [ ] play results screen

## Technical Stack
- **UI Framework:** (SwiftUI / UIKit)
- **Data Persistence:** (Core Data / SwiftData / UserDefaults)
- **Audio:** AVFoundation
- **Background Modes:**
- **Third-party Libraries:**

## App Architecture
- **Pattern:** (MVVM / MVC / Clean Architecture)
- **Key Components:**
  - Models:
  - Views:
  - ViewModels/Controllers:
  - Services:

## Data Models
### Workout
```swift
// Define workout structure
```

### Interval
```swift
// Define interval structure
```

## User Interface
### Screens
1. **Input Screen/**
   - Input screen
   - scale type buttons
   - root buttons
   - Start button
   - Exit button to end program

2. **Scake Screen**
   - input fields
   - note buttons
   - stop button
   - in progress results
   - Exit button to end program

3. ** results Screen**
  s- show results, number of fails, number of correct
   - "new session" button to go to input screen
   - Exit button to end program
   
## Core Functionality
### how bass clef works:
- Line Notes (Bottom to Top)
- 1st Line (Bottom): G
- 2nd Line: B
- 3rd Line: D
- 4th Line: F
- 5th Line (Top): A
- Spaces Between Lines: The four spaces between the lines represent the notes A-C-E-G (from bottom to top). A popular mnemonic for this is "All Cows Eat Grass".
- Ledger Lines: When notes go above or below the five-line staff, small, temporary lines called ledger lines are used. For instance, Middle C (C4) sits on a ledger line just above the staff.
Sequential Order: Notes move alphabetically from line to space to line (G-A-B-C-D-E-F-A). As notes move higher on the staff, their pitch becomes higher
- Drawing notes:
-   note should start as low as possible on the staff; the lowest note that can be drawn is an E
-   as notes are drawn in a scale, make sure the note is always higher in the scale than the previos notes
-   if a note is flat draw in the normal position, but preceed it "b"; if sharp, proceed the note with a "#"
### Identify notes
- input screen:
-   Choice of the following:
-   input scale type (Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aolian & Locrian)
-   input root (C, C#/Db, D, D#/Eb, E, F, F#/Gb, G, G#/Ab, A, A#/Bb, B)
-   have two buttons scale and interval which take the user to the scale screen or interval screen
- scale screen:
-   for scale top, show not separation as W or H, for example Ionian is W-W-H-W-W-W-H
-   show session seconds
-   have the user input the scale in order from the root by selecting one of the displayed notes: (C, C#/Db, D, D#/Eb, E, F, F#/Gb, G, G#/Ab, A, A#/Bb, B, hi C)
-   verify each note input is the next note in the scale type.  maintain green if correct, red if not, counting errors.  
-   play a sound for each note selected.
-   display a bass clef staff and display the note when selected on the staff.  do not show a note on the staff if the note is incorrect.
-   stop the session when the user selects stop. go to results screen
- interval screen
-   show session seconds
-   randomly ask for an interval of one of the following: Minor 2nd, Major 2nd, Minor 3rd, Major 3rd, Fourth, Aug Forth/Dim Fifth, Fifth, Minor 6th,Major 6th, Minor 7th, Major 7th)
-   Have the user input interval one of the displayed notes: (C, C#/Db, D, D#/Eb, E, F, F#/Gb, G, G#/Ab, A, A#/Bb, B)
-   play a sound for each note selected.
-   verify note input is correct for the scale and the interval
-   display a bass clef staff and display the note when selected on the staff.  When another selection is made, clear the note and draw the new one.  This applies to scale as well as interval input.
-   stop the session when the user selects stop. go to results screen
- results screen:
-   number of errors
-   session length in seconds
-   "new session" button to got back to the input screen


## Implementation Phases
### Phase 1: MVP
- [ ] Basic timer functionality
- [ ] Input screen
- [ ] Play screen
- [ ] Start/stop controls
- [ ] show results output after stop, number of correct, number of failrues

## Design Notes
- Color scheme:
- Typography:
- Icon style:
- Animations:

## Resources & References
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Timer Best Practices](https://developer.apple.com/documentation/foundation/timer)
-

## Notes
[Additional thoughts, decisions, and reminders]
- [ ] TODO: fix scale (right now displaying note as treble clef
- [ ] TODO: separate scale training from interval training into separate functions
- [ ] TODO: when choosing interval - show root and selected interval; also play root then interval for sound
- [ ] TODO: display error rate, avg responce seconds in stats; create lift time values
- [ ] TODO: extend to 9th and 11th intervals, etc.
- [ ] TODO: show scale, e.g. W-W-H-W-W-W-H, for each scale type




