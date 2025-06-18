//    1.    @State: “SwiftUI, watch this variable for changes.”
//    2.    private: “This is only for this view’s use — no peeking from outside.”

//When to Use Which?

//    •    ✅ Use if let when:
//    •    You need to use the value more than once
//    •    You want a non-optional to work with
//    •    You have a block of logic tied to the presence of a value

//    •    ✅ Use ?. when:
//    •    You only need to do one thing if it’s not nil
//    •    You want a quick and clean syntax
//    •    You don’t care about the result
