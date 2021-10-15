open ReactNative
open Typography

module Styles = {
  open Style

  let container = style(~flex=1.0, ~paddingVertical=30.->dp, ~paddingHorizontal=15.->dp, ())
  let row = style(~flexDirection=#row, ~alignItems=#center, ~justifyContent=#center, ())
  let title = textStyle(~alignSelf=#center, ~marginVertical=5.->dp, ~fontWeight=#bold, ())
  let input = style(~flex=1., ())
  let textInfo = textStyle(~marginVertical=15.->dp, ())
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
      <Txt fontSize=#xl style=Styles.title> String("Todos") </Txt>
      <View style=Styles.row>
        <Paper.TextInput
          mode=#outlined value=todo onChangeText={text => setTodo(_ => text)} style=Styles.input
        />
        <Paper.IconButton icon={Paper.Icon.name("plus")} onPress={_ => createTodo()} />
      </View>
      {switch todos->Belt.Array.length {
      | 0 => <Txt style=Styles.textInfo> String("No todo created.") </Txt>
      | _ =>
        todos
        ->Belt.Array.map(value =>
          <Todo
            key={value.id}
            todo=value.value
            delete={_ => deleteTodo(value.id)}
            update={text => updateTodo(text, value.id)}
          />
        )
        ->React.array
      }}
    </SafeAreaView>
  </TouchableWithoutFeedback>
}
