module View.Card exposing
    ( Model
    , Msg
    , Payload
    , body
    , closeButton
    , decoder
    , encode
    , header
    , headerContent
    , headerMouseEvents
    , headerTitle
    , initFromPosition
    , positioningStyle
    , subscriptions
    , unfocusedHeader
    , update
    , view
    )

import Browser.Events exposing (onMouseMove, onMouseUp)
import Chadtech.Colors as Ct
import Css
import Css.Animations as Animations
import Data.Position as Position exposing (Position)
import Html.Events.Extra.Mouse as Mouse
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Style as Style
import View.Button as Button



-- TYPES --


type Msg
    = MouseDown ( Float, Float )
    | MouseMove Position
    | MouseUp Position


type MouseState
    = ReadyForClick
    | ClickAt Float Float


type alias Model =
    { x : Float
    , y : Float
    , mouseState : MouseState
    }


setMouseState : MouseState -> Model -> Model
setMouseState mouseState model =
    { model | mouseState = mouseState }


subtractPosition : Position -> Model -> Model
subtractPosition position model =
    case model.mouseState of
        ClickAt clickAtX clickAtY ->
            { model
                | x = position.x - clickAtX
                , y = position.y - clickAtY
            }

        _ ->
            model


initFromPosition : Position -> Model
initFromPosition position =
    { x = position.x
    , y = position.y
    , mouseState = ReadyForClick
    }


type alias Payload msg =
    { title : String
    , closeClickHandler : Maybe msg
    , positioning : Maybe ( Msg -> msg, Model )
    }



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.mouseState of
        ReadyForClick ->
            Sub.none

        ClickAt _ _ ->
            [ onMouseMove (mouseCtor MouseMove)
            , onMouseUp (mouseCtor MouseUp)
            ]
                |> Sub.batch


mouseCtor : (Position -> Msg) -> Decoder Msg
mouseCtor ctor =
    Decode.map ctor Position.browserDecoder



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseDown ( x, y ) ->
            setMouseState
                (ClickAt (x + 40) (y + 71))
                model

        MouseMove mousePosition ->
            model
                |> subtractPosition mousePosition

        MouseUp mousePosition ->
            model
                |> subtractPosition mousePosition
                |> setMouseState ReadyForClick



-- VIEW --


view : List Css.Style -> List (Html msg) -> Html msg
view styles =
    Html.node "card"
        [ Attrs.css
            [ Css.batch styles
            , containerStyle
            ]
        ]


containerStyle : Css.Style
containerStyle =
    [ Style.outdent
    , Css.backgroundColor Ct.content1
    , Css.displayFlex
    , Css.flexDirection Css.column
    , Css.property "animation-duration" "150ms"
    , [ ( 0, [ Animations.transform [ Css.scale 0 ] ] )
      , ( 100, [ Animations.transform [ Css.scale 1 ] ] )
      ]
        |> Animations.keyframes
        |> Css.animationName
    ]
        |> Css.batch


positioningStyle : Model -> Css.Style
positioningStyle model =
    [ Css.position Css.absolute
    , Css.left (Css.px model.x)
    , Css.top (Css.px model.y)
    ]
        |> Css.batch


header : List Css.Style -> List (Html msg) -> Html msg
header styles children =
    Grid.row
        []
        [ Grid.column
            [ Style.padding 1
            , Css.displayFlex
            , Css.backgroundColor Ct.content3
            , Style.margin 0
            , Css.batch styles
            ]
            children
        ]


unfocusedHeader : Css.Style
unfocusedHeader =
    Css.backgroundColor Ct.content2


headerContent : List (Attribute msg) -> List (Html msg) -> Html msg
headerContent attrs =
    Html.node "card-header"
        (Attrs.css [ headerStyle ] :: attrs)


headerMouseEvents : List (Attribute Msg)
headerMouseEvents =
    [ Mouse.onDown (MouseDown << .offsetPos)
        |> Attrs.fromUnstyled
    ]


headerTitle : String -> Html msg
headerTitle str =
    Html.p
        [ Attrs.css [ headerTextStyle ] ]
        [ Html.text str ]


closeButton : msg -> Html msg
closeButton msg =
    Button.view
        [ Attrs.css
            [ Style.width 4
            , Style.minWidth 4
            , Css.padding Css.zero
            , Css.paddingBottom (Css.px 2)
            ]
        , Events.onClick msg
        ]
        "x"


headerCloseButton : Html msg
headerCloseButton =
    Html.button
        [ Attrs.css [ headerCloseButtonStyle ] ]
        [ Html.text "x" ]


headerCloseButtonStyle : Css.Style
headerCloseButtonStyle =
    [ Css.position Css.absolute
    , Style.width 4
    , Style.height 4
    , Css.padding Css.zero
    , Css.paddingBottom (Css.px 2)
    , Style.indent
    , Css.backgroundColor Ct.content2
    , Css.active [ Css.backgroundColor Ct.content0 ]
    , Css.lineHeight (Css.px 14)
    ]
        |> Css.batch


headerTextStyle : Css.Style
headerTextStyle =
    [ Css.color Ct.content0
    , Css.lineHeight (Style.px 4)
    , Css.textAlign Css.center
    ]
        |> Css.batch


headerStyle : Css.Style
headerStyle =
    [ Style.height 4
    , Css.flex (Css.int 1)
    , Css.position Css.relative
    ]
        |> Css.batch


body : List Css.Style -> List (Html msg) -> Html msg
body styles children =
    Grid.row
        [ Css.flex (Css.int 1)
        , Css.height (Css.pct 100)
        , Css.batch styles
        ]
        [ Grid.column
            [ Style.padding 1
            , Css.flexDirection Css.column
            ]
            [ Html.node "card-body"
                [ Attrs.css
                    [ Css.backgroundColor Ct.content1
                    , Css.flex2 (Css.int 0) (Css.int 1)
                    , Css.flexBasis Css.auto
                    , Css.displayFlex
                    , Css.flexDirection Css.column
                    , Css.height (Css.pct 100)
                    , Css.justifyContent Css.spaceBetween
                    ]
                ]
                children
            ]
        ]


encode : Model -> Encode.Value
encode model =
    [ ( "x", Encode.float model.x )
    , ( "y", Encode.float model.y )
    ]
        |> Encode.object


decoder : Decoder Model
decoder =
    Decode.map3 Model
        (Decode.field "x" Decode.float)
        (Decode.field "y" Decode.float)
        (Decode.succeed ReadyForClick)
