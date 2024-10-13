module MdParser exposing (..)
import Browser
import File exposing (File)
import Task
import Html exposing (div, text, Html)
import Platform.Cmd exposing (Cmd, batch)
import Http

--MD
import Markdown.Parser exposing (parse)
import Markdown.Block exposing (Block)
import Markdown.Renderer exposing (render, Renderer, defaultHtmlRenderer)

-- parseMd : String -> List Block -> Result String (List view)
-- parseMd markdownContent =
--     let
--         parsedContent : List Block
--         parsedContent =
--             parse markdownContent
--     in
--     render parsedContent

type Msg
    = MarkdownLoaded (Result Http.Error String)
    --| FetchMarkdown String

type alias Model =
    { markdownContent : String }

parseAndRenderMd : String -> Html msg
parseAndRenderMd markdownContent =
    case parseMd markdownContent of
        Ok htmlContent ->
            div [] htmlContent

        Err errMsg ->
            div [] [ text ("Failed to parse markdown: " ++ errMsg) ]



-- Parse Markdown content to a list of HTML blocks
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