port module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Chadtech.Colors as Ct
import Css
import Data.ViewMode as ViewMode exposing (ViewMode)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Json.Decode as Decode
import Json.Encode as Encode
import Route exposing (Route)
import Style
import Url exposing (Url)
import View.Button as Button



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type alias Model =
    { viewMode : ViewMode }


type Msg
    = DownloadAsPdfClicked
    | RouteChanged Route
    | UrlRequested UrlRequest



--------------------------------------------------------------------------------
-- MAIN --
--------------------------------------------------------------------------------


main : Program Decode.Value Model Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , onUrlRequest = UrlRequested
    , onUrlChange = Route.parse >> RouteChanged
    }
        |> Browser.application


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init json url _ =
    ( { viewMode =
            Decode.decodeValue
                (Decode.field "viewMode" ViewMode.decoder)
                json
                |> Result.withDefault ViewMode.web
      }
    , Cmd.none
    )



--------------------------------------------------------------------------------
-- UPDATE --
--------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DownloadAsPdfClicked ->
            ( model
            , downloadAsPdf
                { url = "http://chad-stearns-resume.surge.sh/chad_stearns_resume.pdf" }
            )

        RouteChanged route ->
            ( model, Cmd.none )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.External url ->
                    ( model, Nav.load url )

                Browser.Internal _ ->
                    ( model, Cmd.none )



--------------------------------------------------------------------------------
-- VIEW --
--------------------------------------------------------------------------------


view : Model -> Browser.Document Msg
view model =
    { title = "Resume"
    , body =
        let
            body : List (Html Msg)
            body =
                case model.viewMode of
                    ViewMode.Web ->
                        webBody

                    ViewMode.Pdf ->
                        resume
        in
        Style.globals model.viewMode
            :: body
            |> List.map Html.toUnstyled
    }


webBody : List (Html Msg)
webBody =
    [ Grid.row
        [ Css.flex (Css.int 1)
        , Style.padding 5
        , Style.paddingBottom 3
        , Css.justifyContent Css.center
        , Css.minHeight (Css.px 0)
        ]
        [ Grid.column
            [ Style.letterWidth
            , Css.flex (Css.int 0)
            , Css.flexBasis Css.initial
            , Css.backgroundColor Ct.background1
            , Css.overflow Css.auto
            , Css.flexDirection Css.column
            , Style.indent
            ]
            resume
        ]
    , Grid.row
        [ Style.padding 5
        , Style.paddingTop 3
        , Css.justifyContent Css.center
        ]
        [ Grid.column
            [ Style.letterWidth
            , Css.flex (Css.int 0)
            , Css.flexBasis Css.initial
            , Css.justifyContent Css.flexEnd
            ]
            [ Button.config
                { onClick = DownloadAsPdfClicked
                , label = "Download as PDF"
                }
                |> Button.toHtml
            ]
        ]
    ]


resume : List (Html msg)
resume =
    let
        leftColumn : List (Html msg)
        leftColumn =
            [ contacts
            , talks
            , education
            , meetUps
            , competitions
            ]
                |> List.concat

        career : List (Html msg)
        career =
            [ humio
            , shore
            , chadtech
            , localMotors
            ]
                |> List.concat
                |> (::) (header [] "career")

        projects : List (Html msg)
        projects =
            [ roc
            , radler
            , ctPaint
            , listExtra
            , elmCanvas
            ]
                |> List.concat
                |> (::) (header [] "projects")

        resumeGithubLink : Html msg
        resumeGithubLink =
            let
                url : String
                url =
                    "github.com/chadtech/resume"
            in
            Html.a
                [ Attrs.href url
                , Attrs.css
                    [ Css.color Ct.content0 ]
                ]
                [ Html.text url ]
    in
    [ Grid.row
        [ Style.padding small
        , Css.borderBottom3 (Style.px 0) Css.solid Ct.content4
        , Css.backgroundColor Ct.content4
        ]
        [ Grid.column
            [ Style.fontSize 6
            , Css.color Ct.content0
            ]
            [ Html.text "Chad Stearns" ]
        , Grid.column
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.justifyContent Css.center
            , Css.textAlign Css.right
            , Style.paddingRight medium
            , Css.color Ct.content0
            ]
            [ resumeGithubLink ]
        ]
    , Grid.row
        [ Style.padding small
        , Css.borderBottom3 (Style.px 0) Css.solid Ct.content4
        ]
        [ Grid.column
            [ Css.flexDirection Css.column ]
            projects
        ]
    , Grid.row
        [ Css.flex (Css.int 1) ]
        [ Grid.column
            [ Css.flex (Css.int 0)
            , Css.flexBasis Css.initial
            , Css.borderRight3 (Style.px 0) Css.solid Ct.content4
            , Css.flexDirection Css.column
            , Style.padding small
            ]
            leftColumn
        , Grid.column
            [ Style.padding small
            , Css.flexDirection Css.column
            ]
            career
        ]
    ]


roc : List (Html msg)
roc =
    [ projectTitle
        { name = "<project in stealth mode>"
        , url = Nothing
        , description = "a functional programming language that compiles to machine code."
        }
    , tech "Rust, LLVM"
    ]


projectTitle :
    { name : String
    , url : Maybe String
    , description : String
    }
    -> Html msg
projectTitle params =
    let
        nameView : Html msg
        nameView =
            case params.url of
                Just url ->
                    Html.a
                        [ Attrs.css [ Css.color Ct.content5 ]
                        , Attrs.href url
                        ]
                        [ Html.text params.name ]

                Nothing ->
                    Html.span
                        [ Attrs.css
                            [ Css.color Ct.content5
                            , Css.whiteSpace Css.noWrap
                            ]
                        ]
                        [ Html.text params.name ]
    in
    Grid.row
        [ Style.marginTop small ]
        [ Grid.column
            []
            [ Html.span
                []
                [ nameView
                , Html.text (", " ++ params.description)
                ]
            ]
        ]


radler : List (Html msg)
radler =
    [ projectTitle
        { name = "Radler"
        , url = Just "https://github.com/Chadtech/Radler-ui"
        , description = "a music composition and audio generation application."
        }
    , tech "Haskell, Elm, Electron"
    ]


ctPaint : List (Html msg)
ctPaint =
    [ projectTitle
        { name = "CtPaint"
        , url = Just "https://www.ctpaint.org/app"
        , description = "pixel art sofware in the browser."
        }
    , tech "Elm, AWS Lambda"
    ]


listExtra : List (Html msg)
listExtra =
    [ projectTitle
        { name = "elm/list-extra"
        , url = Just "https://package.elm-lang.org/packages/elm-community/list-extra/latest/"
        , description = "list helper functions; one of the most used Elm packages."
        }
    ]


elmCanvas : List (Html msg)
elmCanvas =
    [ projectTitle
        { name = "elm-canvas"
        , url = Just "https://github.com/Elm-Canvas/elm-canvas"
        , description = "html canvas in the Elm programming language."
        }
    ]


humio : List (Html msg)
humio =
    [ jobTitle [] "Humio, Senior Software Engineer"
    , jobDuration "November 2018" "April 2020"
    , tech "Elm, Scala, GraphQL"
    , textRow
        [ Style.marginTop small ]
        []
        "High speed data querying of enormous volumes of log data for enterprise customers."
    , jobDetail
        "Lead development for key functionality of large technical user interface."
    ]


jobTitle : List Css.Style -> String -> Html msg
jobTitle extraStyles =
    textRow [] (Css.color Ct.important1 :: extraStyles)


shore : List (Html msg)
shore =
    [ jobTitle [ Style.marginTop medium ] "Shore GmbH, Senior Software Developer"
    , jobDuration "August 2017" "November 2018"
    , tech "Elm, JavaScript, React, TypeScript"
    , textRow
        [ Style.marginTop small ]
        []
        "Scheduling and appointment software for small businesses and their customers."
    , jobDetail
        "Created core application that was served to thousands of users."
    ]


chadtech : List (Html msg)
chadtech =
    [ jobTitle [ Style.marginTop medium ] "Chadtech Co, CEO"
    , jobDuration "October 2013" "present"
    , tech "Hardware, Elm, JavaScript, React, Go, C++"
    , jobDetail "Primarily front end client work for start ups"
    , jobDetail "Ambitious kickstarter for software project."
    , jobDetail "High performance audio processing code for immersive online car advertisements."
    ]


localMotors : List (Html msg)
localMotors =
    [ jobTitle [ Style.marginTop medium ] "Local Motors, Lab Manager"
    , jobDuration "February 2015" "Sept 2015"
    , tech "3D printing, CAD, CNC machining, Electronics, JavaScript, React"
    , textRow
        [ Style.marginTop small ]
        []
        "Experimental car manufacturer using crowd sourced engineering work and maker of the world's first 3D printed car."
    , jobDetail
        "Built eletronic and computer components for automotive engineering initiatives."
    , jobDetail
        "Taught classes on CNC milling and 3D Printing"
    , jobDetail
        "Ambassador to local community and governance"
    ]


tech : String -> Html msg
tech =
    keyValueText "tech:"


jobDuration : String -> String -> Html msg
jobDuration from to =
    textRow
        [ Style.marginTop small ]
        [ Css.color Ct.content3 ]
        (String.join " " [ from, "-", to ])


jobDetail : String -> Html msg
jobDetail content =
    textRow
        [ Style.marginTop small ]
        [ Css.color Ct.content4 ]
        ("- " ++ content)


keyValueText : String -> String -> Html msg
keyValueText key value =
    Grid.row
        [ Style.marginTop small ]
        [ textColumn
            [ Style.marginRight medium
            , Css.flex Css.initial
            , Css.color Ct.content3
            ]
            key
        , textColumn
            [ Css.color Ct.content3
            ]
            value
        ]


talks : List (Html msg)
talks =
    let
        linkRow : String -> String -> Html msg
        linkRow name url =
            Grid.row
                [ Style.marginTop small ]
                [ Grid.column
                    []
                    [ Html.a
                        [ Attrs.href url ]
                        [ Html.text name ]
                    ]
                ]
    in
    [ header [ Style.marginTop 3 ] "talks"
    , linkRow "Elm Europe 2019" "https://www.youtube.com/watch?v=RFCPAw5C5hQ"
    , linkRow "Desert Code Camp 2016" "https://youtu.be/e6jzkoGeDEs"
    , textRow [ Style.marginTop small ] [] "QueensJS 2016"
    , textRow [ Style.marginTop small ] [] "29C3 2012"
    ]


competitions : List (Html msg)
competitions =
    let
        won : Grid.Column msg
        won =
            textColumn
                [ Css.color Ct.content3
                , Css.flex (Css.int 0)
                ]
                "won"
    in
    [ header [ Style.marginTop 3 ] "competitions"
    , Grid.row
        [ Style.marginTop small ]
        [ Grid.column
            []
            [ Html.a
                [ Attrs.href "https://imgur.com/QfDKg7P" ]
                [ Html.text "Arduino Wearables" ]
            ]
        , won
        ]
    , Grid.row
        [ Style.marginTop small ]
        [ textColumn [] "Html Game Hackathon"
        , won
        ]
    ]


meetUps : List (Html msg)
meetUps =
    let
        nameAndRole : String -> String -> Html msg
        nameAndRole name role =
            Grid.row
                [ Style.marginTop small ]
                [ textColumn
                    [ Css.flex (Css.int 0)
                    , Style.noWrap
                    ]
                    name
                , textColumn
                    [ Css.color Ct.content3
                    , Style.marginLeft 3
                    ]
                    role
                ]
    in
    [ header [ Style.marginTop 3 ] "meet ups"
    , nameAndRole "Rust Philadelphia" ""
    , nameAndRole "Elm |> Munich" "organizer"
    , nameAndRole "Elm NYC" "regular speaker"
    , nameAndRole "Coffee & Code" "host"
    , nameAndRole "Phoenix ReactJS" "organizer"
    , nameAndRole "3D printing night" "organizer"
    , nameAndRole "LM Labs" "organizer"
    , nameAndRole "NodeAZ" "regular speaker"
    ]


education : List (Html msg)
education =
    let
        row : String -> Html msg
        row text =
            textRow [ Style.marginBottom 2 ] [] text
    in
    [ "B.S. Economics"
    , "Arizona State University"
    , "Dec 2013"
    ]
        |> List.map row
        |> (::)
            (header [ Style.marginTop 3 ] "education")


contacts : List (Html msg)
contacts =
    let
        contact : ( String, String ) -> Html msg
        contact ( method, value ) =
            Grid.row
                [ Style.fullWidth
                , Style.marginBottom small
                ]
                [ textColumn
                    [ Style.marginRight medium
                    , Style.width 6
                    , Css.flex Css.initial
                    ]
                    method
                , textColumn
                    [ Style.noWrap
                    , Css.justifyContent Css.flexEnd
                    , Css.color Ct.content5
                    ]
                    value
                ]
    in
    [ ( "phone", "480 450 6514" )
    , ( "twitter", "@TheRealChadtech" )
    , ( "email", "chadtech0@gmail.com" )
    ]
        |> List.map contact
        |> (::) (header [] "contact info")


header : List Css.Style -> String -> Html msg
header extraStyles text =
    textRow
        extraStyles
        [ Css.color Ct.important0 ]
        text


textColumn : List Css.Style -> String -> Grid.Column msg
textColumn styles text =
    Grid.column styles [ Html.text text ]


textRow : List Css.Style -> List Css.Style -> String -> Html msg
textRow rowStyles columnStyles text =
    Grid.row rowStyles [ textColumn columnStyles text ]


small : Int
small =
    2


medium : Int
medium =
    4



--------------------------------------------------------------------------------
-- Ports --
--------------------------------------------------------------------------------


downloadAsPdf : { url : String } -> Cmd msg
downloadAsPdf params =
    Encode.object
        [ ( "url", Encode.string params.url ) ]
        |> downloadAsPdfInternal


port downloadAsPdfInternal : Encode.Value -> Cmd msg
