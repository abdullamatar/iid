module Pages.Post exposing (page, Model, Msg)

-- 'std' lib
import View exposing (View)
import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (..)
import Effect exposing (..)
import Route exposing (Route)
import Page exposing (Page)
import Http
import Dict exposing (Dict)
-- import Http exposing (Error(..))
-- import String

-- iid
import Components.NavBar
import Components.Md exposing (view)
import Lib.Api as Api
import MdParser


type alias Model = {mdData : Api.Data (String)}

type Msg
    = MdPresent (Result Http.Error (String))


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

init :  ( Model, Cmd Msg )
init  =
    ( { mdData = Api.Loading }, Api.fetchMarkdown "init.md"  { onResponse = MdPresent})

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MdPresent (Ok mdData) ->
            ( { model | mdData = Api.Success mdData }, Cmd.none )
        MdPresent (Err httpError) ->
            ( { model | mdData = Api.Failure httpError }, Cmd.none )


view : Model -> View Msg
view model =
    Components.NavBar.view
        { title = "Post"
        , body =
        case model.mdData of
            Api.Loading ->
                [ text "Loading..." ]
            Api.Success mdData ->
                [MdParser.parseAndRenderMd mdData]
            Api.Failure httpError ->
                [ text ("Failed to load content: " ++ httpErrorMatcher httpError) ]

                -- case httpError of
                --     Http.BadUrl url ->
                --         [text ("The URL " ++ url ++ " was invalid")]
                --     Http.Timeout ->
                --         [text "Unable to reach the server, try again"]
                --     Http.NetworkError ->
                --         [text "Unable to reach the server, check your network connection"]
                --     Http.BadStatus 500 ->
                --         [text "The server had a problem, try again later"]
                --     Http.BadStatus 400 ->
                --         [text "Verify your information and try again"]
                --     Http.BadStatus _ ->
                --         [text "Unknown error"]
                --     Http.BadBody httpErrorMatcher ->
                --         [text httpErrorMatcher]
                -- Debug.log (httpError)
                -- [ text ("Failed to load Markdown content: ") ]
        }


-- mdView : String -> List (Html Msg)
-- We need to getch the list of markdown files from /static/kalam and put the title as the file name and display the content
subscriptions : Model -> Sub Msg
subscriptions model =Sub.none


{- shared – Stores any data you want to share across all your pages.

In the Shared section, you'll learn how to customize what data should be available.
route – Stores URL information, including things like route.params or route.query.

In the Route section, you'll learn more about the other values on the route field. -}

-- page : Shared.Model -> Route {post: String} -> Page Model Msg

-- page: {post: String} ->  View Msg
-- page : () -> Page Model Msg
page :  Page Model Msg

page   =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }