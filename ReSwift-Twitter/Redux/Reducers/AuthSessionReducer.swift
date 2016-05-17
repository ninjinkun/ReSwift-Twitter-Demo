import ReSwift

extension AuthSessionState {
    struct Reducer: ReSwift.Reducer {
        typealias ReducerStateType = AppState
        func handleAction(action: Action, state: ReducerStateType?) -> ReducerStateType {
            let prevState = state ?? AppState()

            var nextState = prevState
            var nextSessionState = nextState.session

            switch action {
            case let action as LoadAuthSessionAction:
                nextSessionState.session = action.session
            case let action as ErrorAuthSessionAction:
                nextSessionState.error = action.error
            default:
                break
            }

            nextState.session = nextSessionState
            return nextState
        }
    }
}