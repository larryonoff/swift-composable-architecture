#if canImport(SwiftUI)
  import ComposableArchitecture
  import SwiftUI
  import XCTest

  @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
  final class EnumScopeBindingTests: BaseTCATestCase {
    @MainActor
    func testCaseScope_DismissPresentedCase() {
      @SwiftUI.Bindable var store = Store(
        initialState: EnumScopeParent.State(destination: .first(EnumScopeChild.State()))
      ) {
        EnumScopeParent()
      }

      $store.scope(\.$destination, action: \.destination).first.wrappedValue = nil

      XCTAssertNil(store.destination)
    }

    @MainActor
    func testCaseScope_DismissOtherCase() {
      @SwiftUI.Bindable var store = Store(
        initialState: EnumScopeParent.State(destination: .second(EnumScopeChild.State()))
      ) {
        EnumScopeParent()
      }

      $store.scope(\.$destination, action: \.destination).first.wrappedValue = nil

      XCTAssertNotNil(store.destination?.second)
    }
  }

  @Reducer
  private struct EnumScopeChild {}

  @Reducer
  private enum EnumScopeDestination {
    case first(EnumScopeChild)
    case second(EnumScopeChild)
  }

  @Reducer
  private struct EnumScopeParent {
    @ObservableState
    struct State {
      @Presents var destination: EnumScopeDestination.State?
    }
    enum Action {
      case destination(PresentationAction<EnumScopeDestination.Action>)
    }
    var body: some ReducerOf<Self> {
      EmptyReducer()
        .ifLet(\.$destination, action: \.destination)
    }
  }
#endif
