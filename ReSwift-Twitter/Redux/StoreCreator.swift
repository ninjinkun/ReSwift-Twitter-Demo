import ReSwift

let loggingMiddleware: Middleware = { dispatch, getState in
    return { dispatch in
        return { action in
            debugPrint("\(action)")
            return dispatch(action)
        }
    }
}

let reducers = CombinedReducer([
    AuthSessionState.Reducer(),
    TimelineState.Reducer(),
    LikedTweetsState.Reducer()
])

let store = Store<AppState>(reducer: reducers, state: nil, middleware: [loggingMiddleware])
