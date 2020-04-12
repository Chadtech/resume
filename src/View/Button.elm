module View.Button exposing
    ( config
    , toHtml
    )

import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        )
import Svg.Styled.Events as Event



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type alias Button msg =
    { onClick : Maybe msg
    , label : String
    }



--------------------------------------------------------------------------------
-- Public Helpers --
--------------------------------------------------------------------------------


config : { onClick : msg, label : String } -> Button msg
config params =
    { onClick = Just params.onClick
    , label = params.label
    }


toHtml : Button msg -> Html msg
toHtml button =
    let
        conditionalAttrs : List (Attribute msg)
        conditionalAttrs =
            [ Maybe.map
                Event.onClick
                button.onClick
            ]
                |> List.filterMap identity

        attrs : List (Attribute msg)
        attrs =
            conditionalAttrs
    in
    Html.button
        attrs
        [ Html.text button.label ]
