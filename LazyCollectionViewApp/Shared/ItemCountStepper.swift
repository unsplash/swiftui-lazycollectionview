import SwiftUI

struct ItemCountStepper: View {
    @Binding var value: Int

    @State private(set) var currentStep = 0
    let steps: [Int] = [10, 100, 1_000, 10_000, 1_000_000]

    func incrementStep() {
        currentStep += 1
        if currentStep >= steps.count { currentStep = 0 }
        value = steps[currentStep]
    }

    func decrementStep() {
        currentStep -= 1
        if currentStep < 0 { currentStep = steps.count - 1 }
        value = steps[currentStep]
    }

    var body: some View {
        Stepper {
            Text("Items: ") +
            Text("\(value)")
                .foregroundColor(.secondary)
        } onIncrement: {
            incrementStep()
        } onDecrement: {
            decrementStep()
        }
    }
}

struct ItemCountStepper_Previews: PreviewProvider {
    @State static var value = 100
    static var previews: some View {
        ItemCountStepper(value: $value)
    }
}
