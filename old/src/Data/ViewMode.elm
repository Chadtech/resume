module Data.ViewMode exposing
    ( ViewMode(..)
    , flag__pdf
    , flag__web
    , thankYou
    )

--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type ViewMode
    = Pdf
    | Web
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


thankYou : ViewMode
thankYou =
    ThankYou
