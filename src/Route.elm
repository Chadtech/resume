module Route exposing
    ( Route(..)
    , parse
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type Route
    = Pdf
    | Web



--------------------------------------------------------------------------------
-- Public Helpers --
--------------------------------------------------------------------------------


pdf : Route
pdf =
    Pdf


web : Route
web =
    Web


parse : Url -> Route
parse url =
    Parser.parse parser url
        |> Maybe.withDefault Web


parser : Parser (Route -> c) c
parser =
    let
        parseFragment : Maybe String -> Route
        parseFragment maybeFragment =
            case maybeFragment of
                Just "pdf" ->
                    Pdf

                _ ->
                    Web
    in
    Parser.oneOf
        [ Parser.fragment parseFragment
        , Parser.map Web Parser.top
        ]
