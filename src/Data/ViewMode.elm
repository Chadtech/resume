module Data.ViewMode exposing
    ( ViewMode(..)
    , decoder
    , flag__pdf
    , flag__web
    )

import Json.Decode as Decode exposing (Decoder)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type ViewMode
    = Pdf
    | Web



--------------------------------------------------------------------------------
-- Public Helpers --
--------------------------------------------------------------------------------


flag__pdf : ViewMode
flag__pdf =
    Pdf


flag__web : ViewMode
flag__web =
    Web


decoder : Decoder ViewMode
decoder =
    let
        fromString : String -> Decoder ViewMode
        fromString str =
            case str of
                "pdf" ->
                    Decode.succeed Pdf

                "web" ->
                    Decode.succeed Web

                _ ->
                    Decode.fail ("Unrecognized view mode: " ++ str)
    in
    Decode.string
        |> Decode.andThen fromString
