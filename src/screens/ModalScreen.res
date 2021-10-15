open ReactNative

@react.component
let make = (~navigation as _, ~route as _, ~id) => {
  <Text> {j`Hello From ${id->Belt.Int.toString}`->React.string} </Text>
}
