# SwiftUIDrawer

This mostly SwiftUI-based customizable drawer component offers functionality similar to the standard sheet modifier, but with additional fixed positions and extensive customization options. Ideal for displaying expandable and scrollable content over a background view, akin to the drawer behavior seen in Apple and Google map applications.

This project is currently a work in progress, being developed sporadically. Future updates may include additional documentation and a license file to transition it to an open-source project.

## Examples

### Minimal setup

![image](https://github.com/user-attachments/assets/5c4c22e8-db86-4beb-9a44-ee43f2486d40)

```
struct MinimalContentView: View {
    @State private var drawerState = DrawerState.init(case: .partiallyOpened)
    
    var body: some View {
        AppleLogo()
            .padding(.top, 8)
            .drawerOverlay(
                state: $drawerState,
                content: {
                    VStack(spacing: 16) {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                        }
                    }
                    .padding(.top, 8)
                }
            )
    }
}
```

### [With sticky header and changing alignments](https://github.com/aswinter90/SwiftUIDrawer/blob/main/SwiftUIDrawer-Demo/SwiftUIDrawer-Demo/ContentView.swift)

As shown in the video the drawer can be modified with a sticky header, which stays on top of the tab bar if required. The default drag handle can also be replaced with any other view.
Finally the `DrawerState` is mutable and changing it from the outside will update the drawer position automatically. 

https://github.com/user-attachments/assets/daf244f4-a09f-4272-9095-8aa4669a4b26

