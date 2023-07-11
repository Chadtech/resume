module View.Button exposing
    ( onClick
    , primary
    , secondary
    , toHtml
    )

import Chadtech.Colors as Ct
import Css
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        )
import Html.Styled.Attributes as Attr
import Style
import Svg.Styled.Events as Event



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type alias Button msg =
    { onClick : Maybe msg
    , label : String
    , variant : Variant
    }


type Variant
    = Variant__Primary
    | Variant__Secondary



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


fromLabelAndVariant : String -> Variant -> Button msg
fromLabelAndVariant label variant =
    { onClick = Nothing
    , label = label
    , variant = variant
    }



--------------------------------------------------------------------------------
-- API --
--------------------------------------------------------------------------------


secondary : String -> Button msg
secondary label =
    fromLabelAndVariant label Variant__Secondary


primary : String -> Button msg
primary label =
    fromLabelAndVariant label Variant__Primary


onClick : msg -> Button msg -> Button msg
onClick msg button =
    { button | onClick = Just msg }


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

        baseAttrs : List (Attribute msg)
        baseAttrs =
            let
                variantStyles : List Css.Style
                variantStyles =
                    case button.variant of
                        Variant__Primary ->
                            [ Css.backgroundColor Ct.important1
                            , Css.color Ct.important4
                            , Style.importantOutdent
                            , Css.hover
                                [ Css.color Ct.important5
                                ]
                            , Css.active
                                [ Css.color Ct.important5
                                , Style.importantIndent
                                ]
                            ]

                        Variant__Secondary ->
                            [ Css.backgroundColor Ct.content1
                            , Css.color Ct.content4
                            , Style.outdent
                            , Css.hover
                                [ Css.color Ct.content5
                                ]
                            , Css.active
                                [ Css.color Ct.content5
                                , Style.indent
                                ]
                            ]
            in
            [ Attr.css
                variantStyles
            ]
    in
    Html.button
        (baseAttrs ++ conditionalAttrs)
        [ Html.text button.label ]
