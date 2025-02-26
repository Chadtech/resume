module Ext.Html exposing
    ( col
    , row
    , s
    )

import Css
import Html.Styled as Html exposing (Html)
import Style as S
import Svg.Styled.Attributes as Attr


row : List Css.Style -> List (Html msg) -> Html msg
row styles children =
    Html.div
        [ Attr.css (S.row :: styles) ]
        children


col : List Css.Style -> List (Html msg) -> Html msg
col styles children =
    Html.div
        [ Attr.css (S.col :: styles) ]
        children


s : String -> Html msg
s =
    Html.text
