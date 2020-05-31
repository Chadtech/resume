port module Main exposing (main)

import Browser exposing (UrlRequest)
import Chadtech.Colors as Ct
import Css
import Data.ViewMode as ViewMode exposing (ViewMode)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Json.Decode as Decode
import Json.Encode as Encode
import Style
import View.Button as Button
import View.Card as Card



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type alias Model =
    { viewMode : ViewMode }


type Msg
    = DownloadAsPdfClicked



--------------------------------------------------------------------------------
-- MAIN --
--------------------------------------------------------------------------------


main : Program Decode.Value Model Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
        |> Browser.document


init : Decode.Value -> ( Model, Cmd Msg )
init _ =
    ( { viewMode = ViewMode.twitter }
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

                    ViewMode.Twitter ->
                        twitter

                    ViewMode.ThankYou ->
                        thankYou
        in
        Style.globals model.viewMode
            :: body
            |> List.map Html.toUnstyled
    }


thankYou : List (Html msg)
thankYou =
    let
        greetingNames : List (Html msg)
        greetingNames =
            [ "Dear "
            , String.join ", " []
            , ", "
            ]
                |> String.concat
                |> textRow [ Style.marginBottom medium ] []
                |> List.singleton

        body : List (Html msg)
        body =
            []
                |> List.map (textRow [ Style.marginBottom medium ] [])

        signature : List (Html msg)
        signature =
            [ textRow [ Style.marginBottom medium ] [] "Best,"
            , textRow [] [] "-Chad"
            ]
    in
    [ greetingNames
    , body
    , signature
    ]
        |> List.concat
        |> solitaryCard


twitter : List (Html msg)
twitter =
    let
        row : String -> Html msg
        row =
            textRow [ Style.marginTop 3 ] []

        goodAt : List (Html msg)
        goodAt =
            [ "- Frontend development, especially large complex architecture"
            , "- Clean, maintainable, bug free code"
            , "- Functional programming (Elm, Haskell)"
            , "- \"Soft skills\", mentoring, sharing ideas, experimenting"
            , "- Working towards the customer value"
            ]
                |> List.map row
                |> (::)
                    (textRow [] [ Css.color Ct.important0 ] "What I am good at:")

        lookingFor : List (Html msg)
        lookingFor =
            [ "- Full time, preferably remote work"
            , "- New domains and personal growth, (backend code, lead roles)"
            ]
                |> List.map row
                |> (::)
                    (textRow [ Style.marginTop 3 ] [ Css.color Ct.important0 ] "What I am looking for:")
    in
    solitaryCard (goodAt ++ lookingFor)


solitaryCard : List (Html msg) -> List (Html msg)
solitaryCard body =
    [ Grid.row
        [ Css.flex (Css.int 1)
        , Css.justifyContent Css.center
        , Style.fullWidth
        ]
        [ Grid.column
            [ Css.flex (Css.int 0)
            , Css.flexDirection Css.column
            , Css.justifyContent Css.center
            ]
            [ Card.view
                [ Style.width 9 ]
                [ Card.body
                    [ Style.padding 3 ]
                    body
                ]
            ]
        ]
    ]


webBody : List (Html Msg)
webBody =
    [ Grid.row
        [ Css.flex (Css.int 1)
        , Style.padding (large + 1)
        , Style.paddingBottom medium
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
        [ Style.padding (large + 1)
        , Style.paddingTop medium
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
            [ talks
            , meetUps
            , awards
            , volunteer
            , education
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
            , forbesNashMachine
            ]
                |> List.concat
                |> (::) (header [] "projects")

        resumeGithubLink : Html msg
        resumeGithubLink =
            Html.a
                [ Attrs.href "https://www.github.com/chadtech/resume"
                , Attrs.css
                    [ Css.color Ct.content0 ]
                ]
                [ Html.text "github.com/chadtech/resume" ]

        contact : ( String, String ) -> Html msg
        contact ( method, value ) =
            textRow
                [ Style.paddingBottom 1 ]
                [ Css.color Ct.content0
                , Css.whiteSpace Css.noWrap
                ]
                (method ++ ": " ++ value)

        name : Html msg
        name =
            Grid.row
                [ Style.padding small
                , Css.backgroundColor Ct.content4
                , safariBugFix
                ]
                [ Grid.column
                    [ Css.flexDirection Css.column ]
                    [ textRow
                        []
                        [ Style.fontSize 6
                        , Css.color Ct.content0
                        ]
                        "Chad Stearns"
                    , Grid.row
                        [ Style.padding small
                        , Css.paddingTop Style.zero
                        , Css.backgroundColor Ct.content4
                        , safariBugFix
                        ]
                        [ Grid.column
                            [ Css.color Ct.content0 ]
                            [ resumeGithubLink ]
                        ]
                    ]
                , Grid.column
                    [ Css.flexDirection Css.column
                    , Css.flex (Css.int 0)
                    ]
                    (List.map contact
                        [ ( "phone", "+1 480 450 6514" )
                        , ( "email", "chadtech0@gmail.com" )
                        ]
                    )
                ]
    in
    [ name
    , Grid.row
        [ Style.padding small
        , Css.borderBottom3 (Style.px 1) Css.solid Ct.content4
        , safariBugFix
        ]
        [ Grid.column
            [ Css.flexDirection Css.column ]
            projects
        ]
    , Grid.row
        [ Css.flex (Css.int 1)
        , safariBugFix
        ]
        [ Grid.column
            [ Css.flex (Css.int 0)
            , Css.flexBasis Css.initial
            , Css.borderRight3 (Style.px 1) Css.solid Ct.content4
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
        textColor : Css.Style
        textColor =
            Css.color Ct.content4

        nameView : Html msg
        nameView =
            case params.url of
                Just url ->
                    Html.a
                        [ Attrs.css [ textColor ]
                        , Attrs.href url
                        ]
                        [ Html.text params.name ]

                Nothing ->
                    Html.span
                        [ Attrs.css
                            [ textColor
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
        { name = "elm-community/list-extra"
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


forbesNashMachine : List (Html msg)
forbesNashMachine =
    [ projectTitle
        { name = "Solafide Forbes Nash Machine"
        , url = Just "https://hackaday.com/2014/05/20/the-solafide-forbes-nash-organ/"
        , description = "48 key analog synthesizer."
        }
    , tech "Electronics"
    ]


humio : List (Html msg)
humio =
    [ jobTitle [] "Humio, Senior Software Engineer"
    , jobDuration "November 2018" "April 2020"
    , tech "Elm, Scala, GraphQL"
    , textRow
        [ Style.marginTop small ]
        []
        """
        Humio provides high performance data querying to large enterprise customers (Bloomberg, Netlify).
        On a 25 node system, Humio can query 2.2 million events per second and ingest 100 TB of data a day.
        """
    , jobDetail
        "Responsible for key functionality such as complex infinite scrolling and plugin system."
    , jobDetail
        "Exemplified team standard for code review and pull request descriptions."
    , jobDetail
        "Designed and implemented broad architecture of large front end code base."
    ]


jobTitle : List Css.Style -> String -> Html msg
jobTitle extraStyles =
    let
        color : Css.Color
        color =
            Ct.important1
    in
    textRow
        [ Style.borderBottom color
        ]
        (Css.color color :: extraStyles)


shore : List (Html msg)
shore =
    [ jobTitle [ Style.marginTop large ] "Shore GmbH, Senior Software Developer"
    , jobDuration "August 2017" "November 2018"
    , tech "Elm, JavaScript, React, TypeScript"
    , textRow
        [ Style.marginTop small ]
        []
        "Shore is scheduling and appointment software for small businesses and their customers."
    , jobDetail
        "Created core appointment application that was served to thousands of users."
    , jobDetail
        "Maintained large calendar user interface and skeleton \"app shell\" architecture."
    ]


chadtech : List (Html msg)
chadtech =
    [ jobTitle [ Style.marginTop large ] "Chadtech Co, CEO"
    , jobDuration "October 2013" "present"
    , tech "Hardware, Elm, JavaScript, React, Go, C++"
    , textRow
        [ Style.marginTop small ]
        []
        "My consulting business entity. My primary service was front end client work for start ups."
    , jobDetail "Ran ambitious kickstarter for own software product."
    , jobDetail "Wrote high performance audio processing code for immersive video online car reports."
    ]


localMotors : List (Html msg)
localMotors =
    [ jobTitle [ Style.marginTop large ] "Local Motors, Lab Manager"
    , jobDuration "February 2015" "Sept 2015"
    , tech "3D printing, CAD, CNC machining, Electronics, JavaScript, React"
    , textRow
        [ Style.marginTop small ]
        []
        "Local Motors is an experimental car manufacturer that pioneered crowd sourced engineering and made the world's first 3D printed car."
    , jobDetail
        "Built electronic and computer components for automotive engineering initiatives."
    , jobDetail
        "Taught classes on CNC milling and 3D Printing."
    , jobDetail
        "Ambassador to local community and governance."
    ]


tech : String -> Html msg
tech techItems =
    Grid.row
        [ Style.marginTop small
        , Css.flexBasis Css.auto
        , Css.flexShrink (Css.int 0)
        ]
        [ textColumn
            [ Style.marginRight large
            , Css.flex Css.initial
            , Css.color Ct.content3
            ]
            "tech:"
        , textColumn
            [ Css.color Ct.problem1
            ]
            techItems
        ]


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


talks : List (Html msg)
talks =
    let
        link : String -> String -> Html msg
        link name url =
            Html.a
                [ Attrs.href url ]
                [ Html.text name ]

        row :
            { name : String
            , url : Maybe String
            , year : String
            }
            -> Html msg
        row params =
            let
                name : Html msg
                name =
                    case params.url of
                        Just url ->
                            link params.name url

                        Nothing ->
                            Html.text params.name
            in
            Grid.row
                [ Style.marginTop small
                , safariBugFix
                ]
                [ Grid.column
                    [ Css.flex (Css.int 0)
                    , Style.noWrap
                    ]
                    [ name ]
                , textColumn
                    [ Css.color Ct.content3
                    , Css.justifyContent Css.flexEnd
                    ]
                    params.year
                ]
    in
    [ { name = "Elm Europe"
      , url = Just "https://www.youtube.com/watch?v=RFCPAw5C5hQ"
      , year = "2019"
      }
    , { name = "Munich Frontend"
      , url = Nothing
      , year = "2018"
      }
    , { name = "Desert Code Camp"
      , url = Just "https://youtu.be/e6jzkoGeDEs"
      , year = "2016"
      }
    , { name = "QueensJS", url = Nothing, year = "2016" }
    , { name = "29C3", url = Nothing, year = "2012" }
    ]
        |> List.map row
        |> (::) (header [] "talks")


awards : List (Html msg)
awards =
    let
        award :
            { name : String
            , year : String
            , url : Maybe String
            }
            -> Html msg
        award params =
            let
                name : Html msg
                name =
                    case params.url of
                        Just url ->
                            Html.a
                                [ Attrs.href url ]
                                [ Html.text params.name ]

                        Nothing ->
                            Html.text params.name
            in
            Grid.row
                [ Style.marginTop small
                , safariBugFix
                ]
                [ Grid.column [] [ name ]
                , textColumn
                    [ Css.color Ct.content3
                    , Css.flex (Css.int 0)
                    ]
                    params.year
                ]
    in
    [ { name = "Arduino Wearables"
      , year = "2014"
      , url = Just "https://imgur.com/QfDKg7P"
      }
    , { name = "Html Game Hackathon"
      , year = "2012"
      , url = Nothing
      }
    ]
        |> List.map award
        |> (::) (header [ Style.marginTop medium ] "awards")


volunteer : List (Html msg)
volunteer =
    let
        row : ( Css.Color, String ) -> Html msg
        row ( color, text ) =
            textRow
                [ Style.marginTop small ]
                [ Css.color color
                , Style.width 0
                ]
                text

        detailsRow : String -> Html msg
        detailsRow text =
            row ( Ct.content3, text )
    in
    [ header [ Style.marginTop medium ] "volunteering"
    , row ( Ct.content4, "HeatSync Labs" )
    , detailsRow "May 2012 - April 2014"
    , detailsRow "501(c)3 non-profit"
    , detailsRow "treasurer"
    , detailsRow "~$30k in annual revenue"
    ]


meetUps : List (Html msg)
meetUps =
    let
        nameAndRole : String -> String -> Html msg
        nameAndRole name role =
            Grid.row
                [ Style.marginTop small
                , safariBugFix
                ]
                [ textColumn
                    [ Css.flex (Css.int 0)
                    , Style.noWrap
                    ]
                    name
                , textColumn
                    [ Css.color Ct.content3
                    , Css.justifyContent Css.flexEnd
                    ]
                    role
                ]
    in
    [ header [ Style.marginTop medium ] "meet ups"
    , nameAndRole "Rust Philadelphia" ""
    , nameAndRole "Elm |> Munich" "organizer"
    , nameAndRole "Elm NYC" "regular speaker"
    , nameAndRole "Coffee & Code" "host"
    , nameAndRole "Phx ReactJS" "organizer"
    , nameAndRole "LM Labs" "organizer"
    , nameAndRole "NodeAZ" "regular speaker"
    ]


education : List (Html msg)
education =
    let
        row : ( Css.Color, String ) -> Html msg
        row ( color, text ) =
            textRow
                [ Style.marginTop small ]
                [ Css.color color ]
                text
    in
    [ ( Ct.content4, "B.S. Economics" )
    , ( Ct.content3, "Arizona State University" )
    , ( Ct.content3, "Dec 2013" )
    ]
        |> List.map row
        |> (::) (header [ Style.marginTop medium ] "education")


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
    Grid.row
        (safariBugFix :: rowStyles)
        [ textColumn columnStyles text ]


safariBugFix : Css.Style
safariBugFix =
    [ Css.flexBasis Css.auto
    , Css.flexShrink (Css.int 0)
    ]
        |> Css.batch


small : Int
small =
    2


medium : Int
medium =
    3


large : Int
large =
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
