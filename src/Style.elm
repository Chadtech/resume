module Style exposing
    ( borderBottom
    , borderNone
    , center
    , fontSize
    , fontSmoothingNone
    , fullHeight
    , fullWidth
    , globals
    , height
    , hfnss
    , indent
    , letterSize
    , letterWidth
    , margin
    , marginBottom
    , marginLeft
    , marginRight
    , marginTop
    , minWidth
    , noWrap
    , outdent
    , padding
    , paddingBottom
    , paddingLeft
    , paddingRight
    , paddingTop
    , px
    , width
    , zero
    )

import Chadtech.Colors as Ct
import Css
import Css.Global exposing (global)
import Data.ViewMode as ViewMode exposing (ViewMode)
import Html.Styled exposing (Html)


size : Int -> Float
size factor =
    toFloat (2 ^ factor)


zero : Css.Px
zero =
    Css.px 0


px : Int -> Css.Px
px =
    Css.px << size


width : Int -> Css.Style
width =
    Css.width << px


minWidth : Int -> Css.Style
minWidth =
    Css.minWidth << px


marginTop : Int -> Css.Style
marginTop =
    Css.marginTop << px


marginBottom : Int -> Css.Style
marginBottom =
    Css.marginBottom << px


marginLeft : Int -> Css.Style
marginLeft =
    Css.marginLeft << px


noWrap : Css.Style
noWrap =
    Css.whiteSpace Css.noWrap


height : Int -> Css.Style
height =
    Css.height << px


padding : Int -> Css.Style
padding =
    Css.padding << px


paddingBottom : Int -> Css.Style
paddingBottom =
    Css.paddingBottom << px


paddingLeft : Int -> Css.Style
paddingLeft =
    Css.paddingLeft << px


paddingTop : Int -> Css.Style
paddingTop =
    Css.paddingTop << px


paddingRight : Int -> Css.Style
paddingRight =
    Css.paddingRight << px


margin : Int -> Css.Style
margin =
    Css.margin << px


marginRight : Int -> Css.Style
marginRight =
    Css.marginRight << px


fullWidth : Css.Style
fullWidth =
    Css.width (Css.pct 100)


fullHeight : Css.Style
fullHeight =
    Css.height (Css.pct 100)


letterSize : Css.Style
letterSize =
    [ letterWidth
    , Css.height (Css.px 1100)
    ]
        |> Css.batch


letterWidth : Css.Style
letterWidth =
    Css.width (Css.px 850)


globals : ViewMode -> Html msg
globals viewMode =
    let
        webModeStyles : Css.Style
        webModeStyles =
            let
                openBackgroundColor : Css.Style
                openBackgroundColor =
                    Css.backgroundColor Ct.background1
            in
            case viewMode of
                ViewMode.Pdf ->
                    [ letterSize
                    , openBackgroundColor
                    ]
                        |> Css.batch

                ViewMode.Web ->
                    [ Css.backgroundColor Ct.content1
                    , fullHeight
                    ]
                        |> Css.batch

                ViewMode.Twitter ->
                    openBackgroundColor

                ViewMode.ThankYou ->
                    openBackgroundColor
    in
    [ Css.Global.button
        [ hfnss
        , fontSmoothingNone
        , Css.outline Css.none
        , minWidth 6
        , Css.boxSizing Css.borderBox
        , Css.cursor Css.pointer
        , padding 3
        , outdent
        , Css.backgroundColor Ct.content1
        , Css.color Ct.content4
        , Css.hover
            [ Css.color Ct.content5
            ]
        , Css.active
            [ Css.color Ct.content5
            , indent
            ]
        ]
    , Css.Global.body
        [ webModeStyles
        , Css.displayFlex
        , Css.flexDirection Css.column
        ]
    , Css.Global.everything
        [ Css.boxSizing Css.borderBox
        , Css.margin zero
        , Css.padding zero
        , Css.color Ct.content4
        , fontSmoothingNone
        , hfnss
        ]
    ]
        |> global


borderNone : Css.Style
borderNone =
    Css.property "border" "none"


indent : Css.Style
indent =
    [ Css.borderLeft3 (px 1) Css.solid Ct.content0
    , Css.borderTop3 (px 1) Css.solid Ct.content0
    , Css.borderRight3 (px 1) Css.solid Ct.content2
    , borderBottom Ct.content2
    ]
        |> Css.batch


outdent : Css.Style
outdent =
    [ Css.borderLeft3 (px 1) Css.solid Ct.content2
    , Css.borderTop3 (px 1) Css.solid Ct.content2
    , Css.borderRight3 (px 1) Css.solid Ct.content0
    , borderBottom Ct.content0
    ]
        |> Css.batch


borderBottom : Css.Color -> Css.Style
borderBottom =
    Css.borderBottom3 (px 1) Css.solid


hfnss : Css.Style
hfnss =
    [ Css.fontFamilies [ "HFNSS" ]
    , fontSize 5
    ]
        |> Css.batch


fontSize : Int -> Css.Style
fontSize =
    Css.fontSize << px


fontSmoothingNone : Css.Style
fontSmoothingNone =
    Css.property "-webkit-font-smoothing" "none"


center : Css.Style
center =
    Css.margin2 zero Css.auto
