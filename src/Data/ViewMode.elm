module Data.ViewMode exposing
    ( ViewMode(..)
    , decoder
    , pdf
    , web
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


pdf : ViewMode
pdf =
    Pdf


web : ViewMode
web =
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
