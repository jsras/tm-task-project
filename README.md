## TM-TASK-PROJECT ##

A small app that fetches and displays current offers available from the backend, while highligting implemenation details between UIKit as we know it and SwiftUI and some of the new ideas born from a more declarative way of building UI.

 **Navigation** is isolated inside a **Coordinator**-pattern for solid separation while also maintaining a level of simplicity and easy overview of the moving parts. The `Coordinator` has two specific subclasses for different usecases: `FlowCoordinator` covers 
 what most usecases for a `Coordinator` needs with a linear flow and `CompositionCoordinator` is better suited to flows that has multiple active child coordinators (Think `UITabBarController`).

**UIKit** part is based on most people's favorite: **MVVM.** It is kept very simple, uses **Combine** with **Async/Await** for data fetching in a very traditional setup with a `FeatureAPI` running ontop of a `NetworkService`. The view is unaware of any navigation and only binds to the view-model, 
the view-model knows what it can handle internally and what it can pass on as output to whoever instantiated it, relaying any needed action to a `TypeClosure<T>` that allows for a detached action handling. It might seems overkill in a small app like this, 
however with scale this separation quickly ensures proper overview when working with a more complex setup. Both the view-model and the view itself has no direct knowledge of the coordinator controlling the flow. 
All UI is programatically organized out as this gives more precision, and most importantly, works a lot better with changes over time as every change is commited, readable and traceable.

**SwiftUI** part is the more experimental side of this project as it is very quick to iterate over layouts, it also gives the possiblity to challenge other classics that we know, such as **MVVM.** 
I've worked with SwiftUI+MVVM before, and in a traditional setup you end up with quite a few things ontop if you'd like to use never things such as `@Observable`, `@Environment` and `@EnvironmentObject`. 
I read about a simpler approach and decided to give it a go here, the concept is pretty simple, you add an `@Observable` Store-model (`FeatureStore` in this project) for acting intermediate between your SwiftUI view and your API. Then you push most of the VM logic into the SwiftUI View - as this can still be kept very clean and simple. 
And it also mirrors other declarative UI layouts such as ReactNative. As you'll notice, even with three different view structs for creating the same list as in UIKit, and having the async task in there, it is still very compact, organized and easy to read and understand. It utilises the same onOutput typeclosure as in UIKit, now it is just inside the view we can output our desired actions directly to the coordinator, without knowing the coordinator.
Naturally this utilizes the same API underneath, so this is also utilizing **Combine** with **Async/Await.**

Before this would be used by millions of users, I'd definitely decide on either UIKit or SwiftUI, and depending on minimum supported OS-version I'd opt for one or the other (17+ would be SwiftUI, as it is mostly on par with UIKit at that point, limiting the hoops you'd have to jump through to make the more complex implementations.)
Coordinators scales well with # of users, MVVM scales decently with complexity, with the caveat that you risk having a lot of view-models. SwiftUI I'd be tempted to test out the more simple pattern as it borrows quite a bit from React, it could be viable also when complexity grows. I would definitely split the app into feature modules, and maybe even feature modules with api modules inside of them, since some modules could potentially benefit from the same API and separation of UI from Data has always aided in keeping things clearer and scalable.
