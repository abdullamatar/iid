module Components.Md exposing (..)

import Html exposing (div, text, Html)
import Html.Attributes exposing (class)
import View exposing (View)
-- import MdParser exposing (parseMd)
-- import MdParser exposing (Model, Msg, fetchMarkdown, view, update)
import MdParser exposing (Model, Msg )



-- View function to display the parsed Markdown content
view : String -> Html msg
view model =
    div [ class "markdown-content" ]
        [ view model ]