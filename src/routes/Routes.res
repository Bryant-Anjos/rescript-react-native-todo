open ReactNavigation

module StakeParams = {
  type params = {id: int}
}
include Stack.Make(StakeParams)
@react.component
let make = () => {
  <Native.NavigationContainer>
    <Navigator screenOptions={_optionsProps => options(~presentation=#modal, ())}>
      <Screen
        name="Home" component=HomeScreen.make options={props => options(~headerShown=false, ())}
      />
      <ScreenWithCallback name="MyModal">
        {({navigation, route}) =>
          <ModalScreen
            navigation
            route
            id={switch route.params {
            | Some(params) => params.id
            | None => 0
            }}
          />}
      </ScreenWithCallback>
    </Navigator>
  </Native.NavigationContainer>
}
