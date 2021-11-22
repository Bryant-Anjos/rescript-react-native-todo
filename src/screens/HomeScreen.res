open ReactNative
open Typography

module Styles = {
  open Style

  let container = style(~flex=1.0, ~paddingTop=30.->dp, ~paddingHorizontal=15.->dp, ())
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
  let inputRef = React.useRef(Js.Nullable.null)

  let (todo, setTodo) = React.useState(_ => "")
  let (todos, setTodos) = React.useState(_ => [])

  let title = React.useMemo1(_ => {
    "Todos" ++
    switch todos {
    | [] => ""
    | _ => " - " ++ todos->Belt.Array.length->Belt.Int.toString
    }
  }, [todos])

  let createTodo = () => {
    if todo != "" {
      let newTodo = {
        id: UUID.v4(),
        value: todo,
      }

      setTodo(_ => "")
      setTodos(_ => [newTodo]->Belt.Array.concat(todos))
      inputRef.current
      ->Js.Nullable.toOption
      ->Belt.Option.map(input => input->TextInput.focus)
      ->ignore
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
    setTodos(_ =>
      todos->Belt.Array.map(item =>
        switch item.id {
        | itemId if itemId == id => updatedTodo
        | _ => item
        }
      )
    )
  }

  <SafeAreaView style=Styles.container>
    <Txt fontSize=#xl style=Styles.title> String(title) </Txt>
    <View style=Styles.row>
      <Paper.TextInput
        ref={ref => inputRef.current = ref}
        mode=#outlined
        value=todo
        onChangeText={text => setTodo(_ => text)}
        onSubmitEditing=createTodo
        style=Styles.input
      />
      <Paper.IconButton
        icon={Paper.Icon.name("plus")} color=Color.blue onPress={_ => createTodo()}
      />
    </View>
    <ScrollView showsVerticalScrollIndicator=false>
      {switch todos {
      | [] => <Txt style=Styles.textInfo> String("No todo created.") </Txt>
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
    </ScrollView>
  </SafeAreaView>
}
