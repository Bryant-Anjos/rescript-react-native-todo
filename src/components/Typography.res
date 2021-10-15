open ReactNative

type sizes = [
  | #sm
  | #md
  | #lg
  | #xl
]

module TypographyStyles = {
  open Style

  let text = (sizes: sizes) =>
    switch sizes {
    | #sm => textStyle(~fontSize=12., ())
    | #md => textStyle(~fontSize=14., ())
    | #lg => textStyle(~fontSize=18., ())
    | #xl => textStyle(~fontSize=22., ())
    }
}

type children =
  | Int(int)
  | Float(float)
  | String(string)

module Txt = {
  @react.component
  let make = (~children, ~style=?, ~fontSize=?) => {
    let size = switch fontSize {
    | Some(value) => TypographyStyles.text(value)
    | None => TypographyStyles.text(#md)
    }

    let style = Style.array([Style.arrayOption([style]), size])

    switch children {
    | Int(value) => <Text style> {value->React.int} </Text>
    | Float(value) => <Text style> {value->React.float} </Text>
    | String(value) => <Text style> {value->React.string} </Text>
    }
  }
}
