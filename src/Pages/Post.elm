module Pages.Post exposing (Model, Msg, page)

-- import String
-- iid
-- import Route exposing (Route)
-- import Url exposing (Url)

import Browser.Navigation exposing (load)
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



-- arg w fname...


fetchMarkdown_ : String -> Cmd Msg
fetchMarkdown_ fname =
    Api.fetchMarkdown fname { onResponse = MdPresent fname }



-- arg w fname...
-- Http err helper


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


getShortDescription : String -> String
getShortDescription mdContent =
    -- remove hashtag
    mdContent
        |> String.lines
        |> List.map (String.replace "#" "")
        |> List.head
        |> Maybe.withDefault ""
        |> String.left 100


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
    Components.NavBar.view
        { title = "Post"
        , body =
            case model.selectedPost of
                Nothing ->
                    [ div [ class "post-grid" ]
                        (model.mdData
                            |> Dict.toList
                            |> List.map
                                (\( fname, data ) ->
                                    case data of
                                        Api.Loading ->
                                            div [] [ text ("Loading " ++ fname ++ "...") ]

                                        Api.Success mdContent ->
                                            div [ class "post-preview" ]
                                                [ h2 [] [ text fname ]
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
                                , h2 [] [ text fname ]
                                , MdParser.parseAndRenderMd mdContent
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
subscriptions model =
    Sub.none



{- shared – Stores any data you want to share across all your pages.

   In the Shared section, you'll learn how to customize what data should be available.
   route – Stores URL information, including things like route.params or route.query.

   In the Route section, you'll learn more about the other values on the route field.
-}
-- page : Page Model Msg
-- page =
--     Page.element
--         { init = init
--         , update = update
--         , subscriptions = subscriptions
--         , view = view
--         }
-- page : Shared.Model -> Route { a7a : String } -> Page Model Msg


page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
