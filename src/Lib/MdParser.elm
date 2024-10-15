module MdParser exposing (..)

-- import Browser
-- import Task
-- import Platform.Cmd exposing (Cmd, batch)
-- import Dict exposing (Dict)
--MD

import Browser
import Dict exposing (Dict)
import File exposing (File)
import Html exposing (Html, div, text)
import Http
import Markdown.Block exposing (Block)
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (Renderer, defaultHtmlRenderer, render)
import Platform.Cmd exposing (Cmd, batch)
import Task



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


parseAndRenderMd : Dict String String -> Html msg
parseAndRenderMd markdownDict =
    let
        renderMarkdown ( filename, markdownContent ) =
            case parseMd markdownContent of
                Ok htmlContent ->
                    div [] htmlContent

                Err errMsg ->
                    div [] [ text ("Failed to parse markdown for " ++ filename ++ ": " ++ errMsg) ]

        renderedMarkdowns =
            Dict.toList markdownDict
                |> List.map renderMarkdown
    in
    div [] renderedMarkdowns



-- parseAndRenderMd : Dict String String -> Html msg
-- parseAndRenderMd markdownDict =
--     let
--         renderMarkdown (filename, markdownContent) =
--             case parseMd markdownContent of
--                 Ok htmlContent ->
--                     div [] htmlContent
--                 Err errMsg ->
--                     div [] [ text ("Failed to parse markdown for " ++ filename ++ ": " ++ errMsg) ]
--         renderedMarkdowns =
--             Dict.toList markdownDict
--                 |> List.map renderMarkdown
--     in
--     div [] renderedMarkdowns
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
