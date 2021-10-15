open ReactNative

module Styles = {
  open Style

  let container = style(~flex=1.0, ())
  let text = textStyle(~color=Color.teal, ())
  let row = style(~flexDirection=#row, ~alignItems=#center, ~justifyContent=#center, ())
}

type todo = {
  id: string,
  value: string,
}

@react.component
let make = (~navigation as _, ~route as _) => {
  let (todo, setTodo) = React.useState(_ => "")
  let (todos, setTodos) = React.useState(_ => [])

  let createTodo = () => {
    if todo != "" {
      let newTodo = {
        id: UUID.v4(),
        value: todo,
      }
      Js.log(newTodo)

      setTodo(_ => "")
      setTodos(_ => [newTodo]->Belt.Array.concat(todos))
    }
  }

  let deleteTodo = id => {
    setTodos(_ => todos->Belt.Array.keep(item => item.id != id))
  }

  let updateTodo = (value, id) => {
    let updatedTodo = {
      id: id,
      value: value,
    }
    setTodos(_ => todos->Belt.Array.map(item => item.id == id ? updatedTodo : item))
  }

  <TouchableWithoutFeedback onPress={_ => Keyboard.dismiss()}>
    <SafeAreaView style=Styles.container>
      <View style=Styles.row>
        <Paper.TextInput mode=#outlined value=todo onChangeText={text => setTodo(_ => text)} />
        <Paper.IconButton icon={Paper.Icon.name("plus")} onPress={_ => createTodo()} />
      </View>
      {todos
      ->Belt.Array.map(value =>
        <Todo
          key={value.id}
          todo=value.value
          delete={_ => deleteTodo(value.id)}
          update={text => updateTodo(text, value.id)}
        />
      )
      ->React.array}
    </SafeAreaView>
  </TouchableWithoutFeedback>
}
