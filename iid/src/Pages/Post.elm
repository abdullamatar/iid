module Pages.Post exposing (Model, Msg, page)

import Browser.Navigation exposing (Key, load, pushUrl)
import Components.NavBar
import Dict exposing (Dict)
import Effect exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Lib.Api as Api exposing (..)
import MdParser
import Page exposing (Page)
import Regex exposing (Regex, find)
import Shared exposing (..)
import View exposing (View)


type alias Model =
    { mdData : Dict String (Api.Data String)
    , selectedPost : Maybe String
    }


type Msg
    = MdPresent String (Result Http.Error String)
    | SelectPost String
    | BackToList


tempFNAMEs : List String
tempFNAMEs =
    [ "1.md", "2.md", "3.md", "4.md", "init.md" ]


fetchMarkdown_ : String -> Cmd Msg
fetchMarkdown_ fname =
    Api.fetchMarkdown fname { onResponse = MdPresent fname }


httpErrorMatcher : Http.Error -> String
httpErrorMatcher httpError =
    case httpError of
        Http.BadUrl url ->
            "The URL " ++ url ++ " was invalid."

        Http.Timeout ->
            "The request timed out. Please try again."

        Http.NetworkError ->
            "Network error. Please check your internet connection."

        Http.BadStatus statusCode ->
            "Server returned status code: " ++ String.fromInt statusCode

        Http.BadBody body ->
            "Failed to parse response: " ++ body



-- !This would search the entire file
-- getShortDescription : String -> String
-- getShortDescription mdContent =
--     let
--         commentRegex : Maybe Regex
--         commentRegex =
--             Regex.fromString "<!--(.*?)-->"
--         extractComment : String -> Maybe String
--         extractComment content =
--             case find (Maybe.withDefault Regex.never commentRegex) content of
--                 [] ->
--                     Nothing
--                 match :: _ ->
--                     match.submatches |> List.head |> Maybe.andThen identity
--     in
--     mdContent
--         |> extractComment
--         |> Maybe.withDefault ""
--         |> String.trim
--         |> String.left 100


getShortDescription : String -> String
getShortDescription mdContent =
    -- * This is lazy
    let
        commentRegex : Maybe Regex
        commentRegex =
            Regex.fromString "<!--(.*?)-->"

        -- "yield" lines in file
        findFirstComment : List String -> Maybe String
        findFirstComment lines =
            case lines of
                [] ->
                    Nothing

                x :: xs ->
                    case find (Maybe.withDefault Regex.never commentRegex) x of
                        [] ->
                            findFirstComment xs

                        match :: _ ->
                            match.submatches
                                |> List.head
                                |> Maybe.andThen identity

        ----------------------  -- Monad mentioned ^ :O
    in
    mdContent
        |> String.lines
        |> findFirstComment
        |> Maybe.withDefault ""
        |> String.trim
        |> (\s -> String.left 100 s ++ "...")


addTargetBlank : String -> String
addTargetBlank content =
    -- TODO: Why isnt this working
    -- Insert target="_blank" after each <a href="..."> tag
    String.replace "<a href=" "<a target=\"_blank\" href=" content


init : ( Model, Cmd Msg )
init =
    ( { mdData = Dict.fromList (List.map (\fname -> ( fname, Api.Loading )) tempFNAMEs)
      , selectedPost = Nothing
      }
    , List.map fetchMarkdown_ tempFNAMEs |> Cmd.batch
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MdPresent fname (Ok mdContent) ->
            let
                newMdData =
                    Dict.insert fname (Api.Success mdContent) model.mdData
            in
            ( { model | mdData = newMdData }, Cmd.none )

        MdPresent fname (Err httpError) ->
            let
                newMdData =
                    Dict.insert fname (Api.Failure httpError) model.mdData
            in
            ( { model | mdData = newMdData }, Cmd.none )

        SelectPost fname ->
            ( { model | selectedPost = Just fname }, Cmd.none )

        BackToList ->
            ( { model | selectedPost = Nothing }, Cmd.none )


view : Model -> View Msg
view model =
    let
        title : String -> String
        title fname =
            Maybe.withDefault "NoTitle" (List.head (String.split "." fname))
    in
    Components.NavBar.view
        { title = "Post"
        , body =
            case model.selectedPost of
                Nothing ->
                    [ div [ class "post-container post-grid" ]
                        (model.mdData
                            |> Dict.toList
                            |> List.map
                                (\( fname, data ) ->
                                    case data of
                                        Api.Loading ->
                                            div [] [ text ("Loading " ++ fname ++ "...") ]

                                        Api.Success mdContent ->
                                            div [ class "post-preview" ]
                                                [ h2 [] [ text (title fname) ]
                                                , p [] [ text (getShortDescription mdContent) ]
                                                , button [ onClick (SelectPost fname) ] [ text "Read more" ]
                                                ]

                                        Api.Failure httpError ->
                                            div []
                                                [ text ("Failed to load " ++ fname ++ ": " ++ httpErrorMatcher httpError) ]
                                )
                        )
                    ]

                Just fname ->
                    case Dict.get fname model.mdData of
                        Just (Api.Success mdContent) ->
                            [ div [ class "post-content" ]
                                [ button [ onClick BackToList ] [ text "Back to posts" ]
                                , h2 [] [ text (Maybe.withDefault "title" (List.head (String.split "." fname))) ]

                                -- Maybe.withDefault "title" (List.head (String.split "." fname))
                                , MdParser.parseAndRenderMd (addTargetBlank mdContent)
                                ]
                            ]

                        Just Api.Loading ->
                            [ text ("Loading " ++ fname ++ "...") ]

                        Just (Api.Failure httpError) ->
                            [ text ("Failed to load " ++ fname ++ ": " ++ httpErrorMatcher httpError) ]

                        Nothing ->
                            [ text ("Post not found: " ++ fname) ]
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



{- shared – Stores any data you want to share across all your pages.

   In the Shared section, you'll learn how to customize what data should be available.
   route – Stores URL information, including things like route.params or route.query.

   In the Route section, you'll learn more about the other values on the route field.
-}


page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
