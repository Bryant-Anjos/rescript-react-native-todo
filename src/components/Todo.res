open ReactNative
open Typography

module Styles = {
  open Style

  let stretch = style(~flex=1., ())
  let row = style(
    ~flexDirection=#row,
    ~alignItems=#center,
    ~justifyContent=#center,
    ~paddingVertical=2.->dp,
    (),
  )
}

@react.component
let make = (~todo as t, ~delete, ~update) => {
  let (isUpdate, setIsUpdate) = React.useState(_ => false)
  let (todo, setTodo) = React.useState(_ => t)

  let cancelUpdate = () => {
    setTodo(_ => t)
    setIsUpdate(_ => false)
  }

  let confirmUpdate = () => {
    if todo != "" {
      update(todo)
      setIsUpdate(_ => false)
    }
  }

  <View style=Styles.row>
    {switch isUpdate {
    | true => <>
        <Paper.TextInput
          mode=#outlined value=todo onChangeText={text => setTodo(_ => text)} style=Styles.stretch
        />
        <Paper.IconButton
          icon={Paper.Icon.name("check")} color=Color.green onPress={_ => confirmUpdate()}
        />
        <Paper.IconButton
          icon={Paper.Icon.name("close")} color=Color.red onPress={_ => cancelUpdate()}
        />
      </>
    | false => <>
        <Txt fontSize=#lg style=Styles.stretch> String(t) </Txt>
        <Paper.IconButton
          icon={Paper.Icon.name("pencil")} color=Color.blue onPress={_ => setIsUpdate(_ => true)}
        />
        <Paper.IconButton icon={Paper.Icon.name("delete")} color=Color.red onPress=delete />
      </>
    }}
  </View>
}
