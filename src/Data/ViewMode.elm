module Data.ViewMode exposing
    ( ViewMode(..)
    , flag__pdf
    , flag__web
    , thankYou
    , twitter
    )

--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type ViewMode
    = Pdf
    | Web
    | Twitter
    | ThankYou



--------------------------------------------------------------------------------
-- Public Helpers --
--------------------------------------------------------------------------------


flag__pdf : ViewMode
flag__pdf =
    Pdf


flag__web : ViewMode
flag__web =
    Web


twitter : ViewMode
twitter =
    Twitter


thankYou : ViewMode
thankYou =
    ThankYou
