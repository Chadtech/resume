port module Main exposing (..)

import Browser exposing (Document)
import Css
import Css.Global
import Ext.Html as H
import Html as Unstyled
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr
import Json.Decode as JD
import Style as S
import View.Button as Button
import ViewFormat


port downloadPdf : () -> Cmd msg



----------------------------------------------------------------
-- TYPES --
----------------------------------------------------------------


type alias Model =
    {}


type Msg
    = ClickeDownloadAsPdf


type Project
    = Roc
    | Radler
    | CtPaint
    | ListExtra
    | ElmCanvas
    | Himesama
    | Orbiter13
    | SolafideForbesNashMachine


type Job
    = SuperFocus
    | StructionSite
    | MackeyRMS
    | Humio
    | Shore
    | LocalMotors
    | Chadtech


type Talk
    = HashMaps
    | ElmOnlineMeetup
    | ElmEurope
    | MunichFrontend
    | DesertCodeCamp
    | QueensJs
    | X29C3


type Meetups
    = RustPhilaDelphia
    | ElmMunich
    | ElmNYC
    | CoffeeAndCode
    | PhxReactJS
    | NodeAZ


type Award
    = ArduinoWearables
    | HtmlGameHackathon



----------------------------------------------------------------
-- INIT --
----------------------------------------------------------------


type alias Flags =
    {}


flagsDecoder : JD.Decoder Flags
flagsDecoder =
    JD.succeed {}


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model, Cmd.none )



----------------------------------------------------------------
-- HELPERS --
----------------------------------------------------------------


allTalks : List Talk
allTalks =
    [ HashMaps
    , ElmOnlineMeetup
    , ElmEurope
    , MunichFrontend
    , DesertCodeCamp
    , QueensJs
    , X29C3
    ]


allMeetups : List Meetups
allMeetups =
    [ RustPhilaDelphia
    , ElmMunich
    , ElmNYC
    , CoffeeAndCode
    , PhxReactJS
    , NodeAZ
    ]


allAwards : List Award
allAwards =
    [ ArduinoWearables
    , HtmlGameHackathon
    ]


allProjects : List Project
allProjects =
    [ Roc
    , Radler
    , CtPaint
    , ListExtra
    , Orbiter13
    , ElmCanvas
    , Himesama
    , SolafideForbesNashMachine
    ]


allJobs : List Job
allJobs =
    [ SuperFocus
    , StructionSite
    , MackeyRMS
    , Humio
    , Shore
    , LocalMotors
    , Chadtech
    ]



----------------------------------------------------------------
-- UPDATE --
----------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickeDownloadAsPdf ->
            ( model, downloadPdf () )



----------------------------------------------------------------
-- VIEW --
----------------------------------------------------------------


view : Model -> List (Html Msg)
view _ =
    globalStyles
        :: (case ViewFormat.viewFormat of
                ViewFormat.Web ->
                    [ H.row
                        [ S.minH0
                        , Css.property "flex" "1 1 100%"
                        , S.justifyCenter
                        ]
                        [ H.col
                            [ letterWidth
                            , S.bgNightwood1
                            , S.overflowAuto
                            , S.indent
                            , S.g2
                            ]
                            resume
                        ]
                    , H.row
                        [ S.justifyCenter ]
                        [ H.row
                            [ letterWidth
                            , S.justifyEnd
                            ]
                            [ Button.primary "Download as PDF"
                                |> Button.onClick ClickeDownloadAsPdf
                                |> Button.toHtml
                            ]
                        ]
                    ]

                ViewFormat.Pdf ->
                    resume

                ViewFormat.ThankYou record ->
                    thankYou record
           )


thankYou : { recipient : String, message : String } -> List (Html Msg)
thankYou args =
    let
        textColor : Css.Style
        textColor =
            S.textGray5

        greeting : List (Html Msg)
        greeting =
            [ H.row
                []
                [ H.s <| "Dear " ++ args.recipient ++ "," ]
            ]

        messageView : String -> Html Msg
        messageView message =
            H.row
                []
                [ H.s message ]

        signature : List (Html Msg)
        signature =
            [ H.col
                []
                [ H.row
                    []
                    [ H.s "Best," ]
                , H.row
                    []
                    [ H.s "Chad Stearns" ]
                ]
            ]
    in
    [ H.col
        [ S.border
        , S.bgGray1
        , S.outdent
        , S.w196
        , S.justifyCenter
        , S.p4
        , S.g4
        , textColor
        ]
        (List.concat
            [ greeting
            , args.message
                |> String.split "\n\n"
                |> List.map messageView
            , signature
            ]
        )
    ]


resume : List (Html Msg)
resume =
    [ nameAndInfo
    , H.col
        [ S.px2
        , S.pb2
        , S.g2
        ]
        [ jobs
        , projects
        , talks
        , awards
        , educationAndVolunteering
        ]
    ]


educationAndVolunteering : Html Msg
educationAndVolunteering =
    H.row
        [ S.g2
        ]
        [ education, volunteering ]


education : Html Msg
education =
    H.col
        [ S.textGray4
        , S.flex1
        ]
        [ H.row
            [ S.textYellow4 ]
            [ H.s "education" ]
        , H.row [ S.textGray5 ] [ H.s "Arizona State University" ]
        , H.row [] [ H.s "Bachelor of Science in Economics" ]
        , H.row [] [ H.s "Graduated 2013" ]
        ]


volunteering : Html Msg
volunteering =
    H.col
        [ S.textGray4
        , S.flex1
        ]
        [ H.row
            [ S.textYellow4 ]
            [ H.s "volunteering" ]
        , H.row [ S.textGray5 ] [ H.s "HeatSync Labs, 501(c)(3) non-profit" ]
        , H.row [] [ H.s "Treasurer and active member" ]
        , H.row [] [ H.s "2012 to 2014" ]
        ]


awards : Html Msg
awards =
    H.col
        []
        (H.row
            [ S.textYellow4 ]
            [ H.s "awards" ]
            :: List.map awardView allAwards
        )


awardView : Award -> Html Msg
awardView award =
    let
        name : String
        name =
            case award of
                ArduinoWearables ->
                    "Arduino Wearables"

                HtmlGameHackathon ->
                    "HTML5 Game"

        year : String
        year =
            case award of
                ArduinoWearables ->
                    "2014"

                HtmlGameHackathon ->
                    "2012"

        url : String
        url =
            case award of
                ArduinoWearables ->
                    "https://imgur.com/QfDKg7P"

                HtmlGameHackathon ->
                    "https://hackphx.com/html5games_winter2012/"
    in
    H.col
        []
        [ H.row
            [ S.justifySpaceBetween
            , S.textGray4
            ]
            [ Html.div
                []
                [ H.s "Winner of jury prize at "
                , Html.a
                    [ Attr.href url ]
                    [ H.s name ]
                , H.s " hackathon"
                ]
            , H.s year
            ]
        ]


jobs : Html Msg
jobs =
    H.col
        [ S.g2
        ]
        (H.row
            [ S.textYellow4 ]
            [ H.s "jobs" ]
            :: List.map jobView allJobs
        )


jobView : Job -> Html Msg
jobView job =
    let
        name : String
        name =
            case job of
                SuperFocus ->
                    "SuperFocus.ai"

                StructionSite ->
                    "StructionSite"

                MackeyRMS ->
                    "MackeyRMS"

                Humio ->
                    "Humio"

                Shore ->
                    "Shore"

                LocalMotors ->
                    "LocalMotors"

                Chadtech ->
                    "Chadtech"

        role : String
        role =
            case job of
                SuperFocus ->
                    "Senior Software Engineer"

                StructionSite ->
                    "Lead Software Engineer"

                MackeyRMS ->
                    "Principal Software Engineer"

                Humio ->
                    "Senior Software Engineer"

                Shore ->
                    "Senior Software Engineer"

                LocalMotors ->
                    "Lab Manager"

                Chadtech ->
                    "Programming Freelancer"

        acquisition : Maybe String
        acquisition =
            case job of
                SuperFocus ->
                    Nothing

                StructionSite ->
                    Just "DroneDeploy"

                MackeyRMS ->
                    Just "InsiderScore"

                Humio ->
                    Just "CrowdStrike"

                Shore ->
                    Nothing

                LocalMotors ->
                    Nothing

                Chadtech ->
                    Nothing

        acquisitionStr : String
        acquisitionStr =
            case acquisition of
                Just acquiringCompany ->
                    let
                        acquisitionText : String
                        acquisitionText =
                            if job == MackeyRMS then
                                "merged with "

                            else
                                "acquired by "

                        partyPopperEmoji : Char
                        partyPopperEmoji =
                            Char.fromCode 0x0001F389
                    in
                    String.concat
                        [ ", "
                        , acquisitionText
                        , acquiringCompany
                        , " "
                        , String.fromChar partyPopperEmoji
                        ]

                Nothing ->
                    ""

        startDate : String
        startDate =
            case job of
                SuperFocus ->
                    "July 2023"

                StructionSite ->
                    "May 2021"

                MackeyRMS ->
                    "June 2022"

                Humio ->
                    "November 2018"

                Shore ->
                    "August 2017"

                LocalMotors ->
                    "February 2015"

                Chadtech ->
                    "October 2013"

        endDate : String
        endDate =
            case job of
                SuperFocus ->
                    "present"

                StructionSite ->
                    "July 2023"

                MackeyRMS ->
                    "April 2021"

                Humio ->
                    "April 2020"

                Shore ->
                    "November 2018"

                LocalMotors ->
                    "September 2015"

                Chadtech ->
                    "July 2017"

        timeFrameStr : String
        timeFrameStr =
            startDate ++ " to " ++ endDate

        jobTech : List String
        jobTech =
            case job of
                SuperFocus ->
                    [ "Elm"
                    , "Rust"
                    , "Python"
                    , "LLMs"
                    , "Voice AI"
                    , "GRPC"
                    , "Axum"
                    , "TypeScript"
                    , "Next.js"
                    , "React"
                    , "Postgres"
                    , "Websockets"
                    , "Tailwind"
                    , "Sqlx"
                    ]

                StructionSite ->
                    [ "Rust"
                    , "Elm"
                    , "WASM"
                    , "Bevy"
                    , "GraphQL"
                    , "React"
                    , "Warp"
                    , "Postgres"
                    , "Tailwind"
                    , "Sqlx"
                    ]

                MackeyRMS ->
                    [ "Elm"
                    , "Haskell"
                    , "JavaScript"
                    , "Angular"
                    , "Servant"
                    , "Web Components"
                    ]

                Humio ->
                    [ "Elm"
                    , "Scala"
                    , "GraphQL"
                    , "Highcharts"
                    , "Web Components"
                    ]

                Shore ->
                    [ "Elm"
                    , "TypeScript"
                    , "React"
                    , "Algolia"
                    , "Web Components"
                    ]

                LocalMotors ->
                    [ "React"
                    , "JavaScript"
                    , "CAD"
                    , "CNC Water Jet"
                    , "Electronics"
                    , "FireBase"
                    ]

                Chadtech ->
                    [ "Elm"
                    , "React"
                    , "Hardware"
                    , "Go"
                    , "C++"
                    ]

        description : String
        description =
            case job of
                SuperFocus ->
                    """SuperFocus makes superhuman AI
customer service agents, by solving the LLM hallucination problem, ensuring
reliability and accuracy"""

                StructionSite ->
                    """StructionSite served the largest construction
companies by providing them with ML powered weekly "google street views" of
construction sites so that project managers can remotely track material progress."""

                MackeyRMS ->
                    "MackeyRMS is a tool for investors to collect, retrieve, and discuss their market research."

                Humio ->
                    """Humio provides high performance data querying to large enterprise customers.
                    On a 25 node system, Humio can query 2.2m events per second and ingest 100TB of data a day."""

                Shore ->
                    "Shore provides scheduling and appointment software for small businesses and their customers."

                LocalMotors ->
                    "Local Motors was an experimental car manufacturer that pioneered crowd sourced engineering and made the world's first 3D printed car"

                Chadtech ->
                    "Consultancy for various clients, including programming, hardware, and graphic design."

        bulletPoints : List String
        bulletPoints =
            case job of
                SuperFocus ->
                    [ """Consolidated ~10 independent AI codebases into a single database-configurable
application, streamlining the deployment and development of AI agents.
                    """
                    , """Lead the research and prototyping of a system that allowed dynamic rearrangement of core AI components, optimizing code reuse and scalability.
                     """
                    , """Acted as a liaison between management and the engineering team, proactively coordinating
the efforts of individual developers. Fostering trust and ensuring project clarity through communication and understanding."""
                    ]

                StructionSite ->
                    [ """Actively contributed to the development of a data-intensive construction project tracking system.
Along with my team, we utilized techniques such as asynchronous task queues, event sourcing, and the
architecture of a video game engine.
                    """
                    , """Ran our weekly sprint meetings, collaborating closely with the product and design teams, and worked
closely with engineers to ensure our team had a good mutual understanding of the project, and that we stayed on track.
                     """
                    ]

                MackeyRMS ->
                    [ "Lead team through delicate overhaul of entire frontend, both in terms of design and code architecture." ]

                Humio ->
                    [ """Engineered through small iterative pieces, an advanced infinite scroll system, for time-based and
                    unbounded data by dynamically measuring irregularly sized DOM elements to accurately adjust scroll position. This system was bi-directional, and could
focus on specific elements despite a continuous high volume flow of data."""
                    , """Set the standards for code reviews by consistently providing clear and detailed pull requests,
that were recognized by leadership, elevating our code review process.
                             """
                    , """Designed and implemented broad architecture of large frontend code base, through 
research, discussion, and experimentation."""
                    ]

                Shore ->
                    [ """Took full ownership of implementing core frontend application for customers to edit and create appointments."""
                    , """Maintained and fixed bugs for a large calendar user interface and skeleton "App Shell" architecture,
                    that loaded and ran smaller frontend applications in designated slots in the page layout."""
                    , """Mentored fellow engineers in Elm programming, guiding team members towards adopting best practices
                    through code review, pairing sessions, and hosting Elm workshops."""
                    ]

                LocalMotors ->
                    [ """Taught regular classes on CNC milling and 3D printing, enabling members from the general public to visit
                    and use our machinery."""
                    , """Leveraged my years of makerspace experience to enhance lab operations and foster a creative productive environment."""
                    , """Ran tech events almost nightly, building a network of makers and engineers."""
                    ]

                Chadtech ->
                    [ """For Carvana, a website for buying and selling used cars, I wrote high performance audio processing
                    code as part of a larger project of generating immersive online video car reports."""
                    , """For an early stage Fintech startup, I made a authenticated frontend application with custom RSA encryption that
                    depicts stock and investment options in a network graph."""
                    ]

        bulletPointView : String -> Html msg
        bulletPointView bulletPoint =
            H.row
                [ descriptionColor ]
                [ H.s <| "- " ++ bulletPoint ]
    in
    H.col
        []
        [ H.row
            [ S.justifySpaceBetween ]
            [ H.row
                [ S.textYellow5 ]
                [ H.s name ]
            , H.row
                [ S.textYellow5 ]
                [ H.s role ]
            ]
        , H.row
            [ S.g2
            , S.textGray3
            ]
            [ H.s <| timeFrameStr ++ acquisitionStr
            ]
        , Html.div
            [ Attr.css [ techColor ] ]
            [ Html.span
                [ Attr.css [ S.textGray4 ] ]
                [ H.s "tech: " ]
            , H.s <| String.join ", " jobTech
            ]
        , H.row
            [ descriptionColor
            , S.textSm
            , S.fontItalic
            ]
            [ H.s description ]
        , H.col
            []
            (List.map bulletPointView bulletPoints)
        ]


descriptionColor : Css.Style
descriptionColor =
    S.textGray5


techColor : Css.Style
techColor =
    S.textRed1


talks : Html Msg
talks =
    H.col
        [ S.g2
        ]
        (H.row
            [ S.textYellow4 ]
            [ H.s "talks" ]
            :: List.map talkView allTalks
        )


talkView : Talk -> Html Msg
talkView talk =
    let
        title : String
        title =
            case talk of
                HashMaps ->
                    "Hash Maps"

                ElmOnlineMeetup ->
                    "Analytics and Architecture in Elm"

                ElmEurope ->
                    "What has excited me about Audio Synthesis Theory"

                MunichFrontend ->
                    "Using Elm at Shore"

                DesertCodeCamp ->
                    "How React works under the hood"

                QueensJs ->
                    "CtPaint"

                X29C3 ->
                    "Lightning Talk on Audio Synthesizer"

        maybeEvent : Maybe String
        maybeEvent =
            case talk of
                HashMaps ->
                    Nothing

                ElmOnlineMeetup ->
                    Just "Elm Online Meetup"

                ElmEurope ->
                    Just "Elm Europe"

                MunichFrontend ->
                    Just "Munich Frontend"

                DesertCodeCamp ->
                    Just "Desert Code Camp"

                QueensJs ->
                    Just "QueensJs"

                X29C3 ->
                    Just "29C3"

        maybeUrl : Maybe String
        maybeUrl =
            case talk of
                HashMaps ->
                    Just "https://www.youtube.com/watch?v=mJFoGR1w28Q"

                ElmOnlineMeetup ->
                    Just "https://youtu.be/XlJuICG2kFU"

                ElmEurope ->
                    Just "https://www.youtube.com/watch?v=RFCPAw5C5hQ"

                MunichFrontend ->
                    Nothing

                DesertCodeCamp ->
                    Just "https://youtu.be/e6jzkoGeDEs"

                QueensJs ->
                    Nothing

                X29C3 ->
                    Nothing

        year : String
        year =
            case talk of
                HashMaps ->
                    "2022"

                ElmOnlineMeetup ->
                    "2021"

                ElmEurope ->
                    "2019"

                MunichFrontend ->
                    "2018"

                DesertCodeCamp ->
                    "2016"

                QueensJs ->
                    "2016"

                X29C3 ->
                    "2012"

        titleView : Html Msg
        titleView =
            let
                withQuotes : String
                withQuotes =
                    "\"" ++ title ++ "\""
            in
            case maybeUrl of
                Just url ->
                    Html.a
                        [ Attr.href url ]
                        [ H.s withQuotes ]

                Nothing ->
                    H.s withQuotes

        eventView : Html Msg
        eventView =
            case maybeEvent of
                Just event ->
                    H.s <| " at " ++ event

                Nothing ->
                    H.s ""

        maybeSummary : Maybe String
        maybeSummary =
            case talk of
                HashMaps ->
                    Just """How Hashmaps work, as well as summarizing what
                    I learned working on Roc's HashMap"""

                ElmOnlineMeetup ->
                    Just """In this talk I detail how I do frontend analytics
                    in Elm, utilizing some tricks in Elm's type system to remind developers where they need to
                    make changes."""

                ElmEurope ->
                    Just """I demonstrate how to synthesize various instrument sounds in terms of the theories of
                    additive synthesis and granular synthesis."""

                MunichFrontend ->
                    Just """Shore's frontend lead engineer and I summarized what our experience has been
                    with Elm."""

                DesertCodeCamp ->
                    Just """My audience and I make React from scratch through incremental and small steps."""

                QueensJs ->
                    Nothing

                X29C3 ->
                    Nothing

        summaryView : Html Msg
        summaryView =
            case maybeSummary of
                Just summary ->
                    H.row
                        [ descriptionColor ]
                        [ H.s summary ]

                Nothing ->
                    H.s ""
    in
    H.col
        [ S.textGray4 ]
        [ H.row
            [ S.justifySpaceBetween ]
            [ Html.div
                []
                [ titleView
                , eventView
                ]
            , H.row [] [ H.s year ]
            ]
        , summaryView
        ]


projects : Html Msg
projects =
    H.col
        [ S.g2
        ]
        (H.row
            [ S.textYellow4 ]
            [ H.s "projects" ]
            :: List.map projectView allProjects
        )


projectView : Project -> Html Msg
projectView project =
    let
        projectName : String
        projectName =
            case project of
                Roc ->
                    "Roc"

                Radler ->
                    "Radler"

                CtPaint ->
                    "CtPaint"

                ListExtra ->
                    "elm-community/list-extra"

                ElmCanvas ->
                    "elm-canvas"

                Himesama ->
                    "Himesama"

                Orbiter13 ->
                    "Orbiter13"

                SolafideForbesNashMachine ->
                    "Solafide Forbes Nash Machine"

        url : String
        url =
            case project of
                Roc ->
                    "https://www.roc-lang.org/"

                Radler ->
                    "https://github.com/Chadtech/Radler-ui"

                CtPaint ->
                    "https://ctpaint.org/app"

                ListExtra ->
                    "https://package.elm-lang.org/packages/elm-community/list-extra/latest/"

                ElmCanvas ->
                    "https://github.com/Elm-Canvas/elm-canvas"

                Himesama ->
                    "https://github.com/Chadtech/Himesama"

                Orbiter13 ->
                    "https://www.chadtech.us/orbiter-13/"

                SolafideForbesNashMachine ->
                    "https://hackaday.com/2014/05/20/the-solafide-forbes-nash-organ/"

        description : String
        description =
            case project of
                Roc ->
                    """During my weekends from 2019 to 2021, I
contributed to the Roc programming language.
"""

                Radler ->
                    """I made Radler myself to make music with. The user
interface is for writing a musical score, and the backend generates audio of the music
and efficiently updates the audio as the user makes changes to the musical score."""

                CtPaint ->
                    """In 2016 I ran an (unsuccessful) kickstarter campaign for online
pixel art software. I made the software anyway, with not only the complete
functionality of drawing images, but also connectivity features to import any image from
the web, and tiered access granting bonus features like uploading images."""

                ListExtra ->
                    """List.Extra is one of the most downloaded Elm packages. It provides helper functions for
                    working with lists. Most of my impact on this project is not so much writing code,
but refereeing submissions from others. I make sure every submission
is truly useful, and implemented in a performant way. Every major version
update risks disrupting the wider Elm community, and every
contribution risks confusing developers if not carefully thought through."""

                ElmCanvas ->
                    """To make CtPaint (listed above), I needed to use HTML Canvas. Elm Canvas
                    is a library that
brings the canvas HTML element into Elm, and provides an api for drawing on HTML canvases through JavaScript FFI.
The main challenge was how to use the mutable
canvas element in an immutable functional programming language.
"""

                Himesama ->
                    """A reimplementation of React from scratch with my own attempt
at state management. Incidentally, Himesama has a much smaller bundle size than React, which
is a significant performance bottleneck for many large React projects.
                    """

                Orbiter13 ->
                    "A difficult videogame based on orbital mechanics."

                SolafideForbesNashMachine ->
                    """To explore my interest in unusual music tuning systems,
I designed and built 3 audio synthesizers. With help, I designed a sine wave oscillator
circuit, etched 48 of these oscillators onto circuit boards, and then put them into
wooden enclosures I designed and laser cut."""

        tech : List String
        tech =
            case project of
                Roc ->
                    [ "Rust", "Zig", "LLVM" ]

                Radler ->
                    [ "Haskell", "Elm", "Electron" ]

                CtPaint ->
                    [ "Elm", "Html Canvas", "Node", "AWS Lambda" ]

                ListExtra ->
                    [ "Elm" ]

                ElmCanvas ->
                    [ "Elm, JavaScript", "Html Canvas" ]

                Himesama ->
                    [ "CoffeeScript" ]

                Orbiter13 ->
                    [ "Elm", "CoffeeScript", "Express" ]

                SolafideForbesNashMachine ->
                    [ "Circuitry", "Laser Cutting" ]

        bulletPoints : List String
        bulletPoints =
            case project of
                Roc ->
                    [ """wrote a large majority of the Roc code formatter, which
                    takes an abstract syntax tree,
                    and converts it into textual code."""
                    , """Wrote the first implementation of the
                    core List functions compilation down to LLVM machine code."""
                    , """Designed Roc's HashMaps."""
                    , """Made the code that generates html files rendering Roc
                    module documentation."""
                    ]

                _ ->
                    []

        bulletPointsView : Html msg
        bulletPointsView =
            if List.isEmpty bulletPoints then
                H.s ""

            else
                let
                    bulletPointView : String -> Html msg
                    bulletPointView bulletPoint =
                        H.row
                            [ descriptionColor ]
                            [ H.s <| "- " ++ bulletPoint ]
                in
                H.col
                    []
                    (List.map bulletPointView bulletPoints)
    in
    H.col
        [ S.textGray4 ]
        [ H.row
            [ S.justifySpaceBetween ]
            [ Html.a
                [ Attr.href url ]
                [ H.s projectName ]
            ]
        , Html.div
            [ Attr.css [ techColor ] ]
            [ Html.span
                [ Attr.css [ S.textGray4 ] ]
                [ H.s "tech: " ]
            , H.s <| String.join ", " tech
            ]
        , H.row
            [ descriptionColor
            , S.textSm
            , S.fontItalic
            ]
            [ H.s description ]
        , bulletPointsView
        ]


nameAndInfo : Html Msg
nameAndInfo =
    H.row
        [ S.bgGray4
        , S.textGray0
        , S.p2
        , S.g4
        ]
        [ chadStearnsName
        , resumeLinks
        , contactInfo
        ]


chadStearnsName : Html Msg
chadStearnsName =
    H.col
        [ Css.fontFamilies [ "HFNSS" ]
        , Css.fontSize <| Css.rem 4
        , Css.property "-webkit-font-smoothing" "none"
        , S.pre
        ]
        [ H.s "Chad Stearns" ]


resumeLinks : Html Msg
resumeLinks =
    H.col
        []
        [ Html.a
            [ Attr.href "https://www.github.com/chadtech/resume" ]
            [ H.s "github.com/chadtech/resume" ]
        , Html.a
            [ Attr.href "https://chad-stearns-resume.netlify.app/" ]
            [ H.s "View this resume online" ]
        ]


contactInfo : Html Msg
contactInfo =
    H.col
        [ S.pre ]
        [ H.row
            []
            [ H.s "phone: +1 480 450 6514" ]
        , H.row
            []
            [ H.s "email: chadtech0@gmail.com" ]
        ]


letterWidth : Css.Style
letterWidth =
    Css.width (Css.px 850)


globalStyles : Html Msg
globalStyles =
    let
        bg : Css.Style
        bg =
            case ViewFormat.viewFormat of
                ViewFormat.Web ->
                    S.bgGray1

                ViewFormat.Pdf ->
                    S.bgNightwood1

                ViewFormat.ThankYou _ ->
                    S.bgNightwood1

        viewFormatStyles : List Css.Style
        viewFormatStyles =
            case ViewFormat.viewFormat of
                ViewFormat.Web ->
                    [ S.p4
                    ]

                ViewFormat.Pdf ->
                    [ Css.width (Css.px 850)
                    , S.g2
                    ]

                ViewFormat.ThankYou record ->
                    [ S.justifyCenter
                    , S.itemsCenter
                    ]
    in
    Css.Global.global
        [ Css.Global.everything
            [ Css.boxSizing Css.borderBox ]
        , Css.Global.html
            [ bg ]
        , Css.Global.body
            [ S.batch viewFormatStyles
            , Css.fontFamilies
                [ "'JetBrains Mono'"
                , "inter"
                , "monospace"
                , "sans-serif"
                ]
            , S.col
            , S.m0
            , bg
            , S.g2
            , S.hFull
            ]
        , Css.Global.a
            [ S.textBlue0
            ]
        ]



----------------------------------------------------------------
-- SUBSCRIPTIONS --
----------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



----------------------------------------------------------------
-- MAIN --
----------------------------------------------------------------


type State
    = State__Loaded Model
    | State__Failed JD.Error


main : Program JD.Value State Msg
main =
    let
        init_ : JD.Value -> ( State, Cmd Msg )
        init_ json =
            case JD.decodeValue flagsDecoder json of
                Ok flags ->
                    let
                        ( model, cmd ) =
                            init flags

                        state : State
                        state =
                            State__Loaded model
                    in
                    ( state
                    , cmd
                    )

                Err err ->
                    ( State__Failed err
                    , Cmd.none
                    )

        update_ : Msg -> State -> ( State, Cmd Msg )
        update_ msg state =
            case state of
                State__Loaded model ->
                    let
                        ( newModel, cmd ) =
                            update msg model

                        newState : State
                        newState =
                            State__Loaded newModel
                    in
                    ( newState
                    , cmd
                    )

                State__Failed _ ->
                    ( state, Cmd.none )

        view_ : State -> Document Msg
        view_ state =
            { body =
                case state of
                    State__Loaded model ->
                        view model
                            |> List.map Html.toUnstyled

                    State__Failed error ->
                        [ Unstyled.text (JD.errorToString error) ]
            , title = "Chad Stearns Resume"
            }

        subscriptions_ : State -> Sub Msg
        subscriptions_ state =
            case state of
                State__Loaded model ->
                    subscriptions model

                State__Failed _ ->
                    Sub.none
    in
    Browser.document
        { init = init_
        , update = update_
        , subscriptions = subscriptions_
        , view = view_
        }
