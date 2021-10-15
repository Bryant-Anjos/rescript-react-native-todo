type t
@module("@react-navigation/native") external useNavigation: unit => t = "useNavigation"
@send external navigate: (t, string) => unit = "navigate"
@send external navigateWithParams: (t, string, {..}) => unit = "navigate"
