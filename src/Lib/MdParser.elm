module MdParser exposing (..)
import Html exposing (Html)
import Markdown.Block exposing (Block)
-- import Markdown.Html exposing (render)
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (render, Renderer, defaultHtmlRenderer)

-- port receiveFileContent : (String -> msg) -> Sub msg

-- parseMd : String -> List Block -> Result String (List view)
-- parseMd markdownContent =
--     let
--         parsedContent : List Block
--         parsedContent =
--             parse markdownContent
--     in
--     render parsedContent

parseMd : String -> Result String (List (Html msg))
parseMd markdownContent =
    let
        parsedContent =
            parse markdownContent

        renderer : Renderer (Html msg)
        renderer =
            defaultHtmlRenderer
    in
        case parsedContent of
        Ok blocks ->
            case render renderer blocks of
                Ok html ->
                    Ok html

                Err errMsg ->
                    Err errMsg

        Err _ ->
            Err "Failed to parse markdown content"