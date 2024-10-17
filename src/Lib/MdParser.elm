module MdParser exposing (..)

-- import Browser
-- import Task
-- import Platform.Cmd exposing (Cmd, batch)
-- import Dict exposing (Dict)
-- import Markdown.Block exposing (Block)
-- import Platform.Cmd exposing (Cmd, batch)

import Html exposing (Html, div, text)
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (Renderer, defaultHtmlRenderer, render)



-- type Msg
--     = MarkdownLoaded (Result Http.Error String)


type alias Model =
    { markdownContent : String }


parseAndRenderMd : String -> Html msg
parseAndRenderMd markdownContent =
    case parseMd markdownContent of
        Ok htmlContent ->
            div [] htmlContent

        Err errMsg ->
            div [] [ text ("Failed to parse markdown: " ++ errMsg) ]



-- parseAndRenderMd : Dict String String -> Html msg
-- parseAndRenderMd markdownDict =
--     let
--         renderMarkdown ( filename, markdownContent ) =
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
