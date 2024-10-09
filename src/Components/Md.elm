module Components.Md exposing (..)

import Html exposing (div, text)
import Html.Attributes exposing (class)
import View exposing (View)
import MdParser exposing (parseMd)


view :
      String -> View msg
view markdownContent =
    let
        parsedContent =
            parseMd markdownContent

        contentHtml =
            case parsedContent of
                Ok htmlList ->
                    htmlList

                Err errMsg ->
                    [ div [ class "error" ] [ text errMsg ] ]
    in
    { title = "Markdown Viewer"
    , body = [ div [ class "markdown-content" ] contentHtml ]
    }
-- view : String -> Html msg
-- view markdownContent =
--     let
--         parsedContent : List Block
--         parsedContent =
--             parse markdownContent
--     in
--     div [ class "markdown-content" ]
--         [ render parsedContent ]