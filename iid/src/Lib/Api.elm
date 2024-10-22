module Lib.Api exposing (..)

import Http



-- import Json.Decode
-- import Dict exposing (Dict)


type Data value
    = Loading
    | Success value
    | Failure Http.Error


fetchMarkdown : String -> { onResponse : Result Http.Error String -> msg } -> Cmd msg
fetchMarkdown filename { onResponse } =
    let
        url =
            "./kalam/" ++ filename
    in
    Http.get
        { url = url
        , expect = Http.expectString onResponse
        }
