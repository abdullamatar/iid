module Pages.Post_ exposing (page, Model, Msg)

import View exposing (View)
import Components.NavBar
import Components.Md
import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)
import Components.NavBar
import Components.Md
import Shared exposing (..)
import Effect exposing (..)
import Route exposing (Route)
import Page exposing (Page)
import Dict


type alias Model =
    {}

type alias Msg = Shared.Msg
init : () -> ( Model, Effect Msg )
init _ = ({}, Effect.none)

update : Msg -> Model -> ( Model, Effect Msg )
update msg model =(model, Effect.none)

view : Shared.Model -> Route {post: String} -> Model -> View Msg
view shared route model =
    let
        postId =
            route.params.post

        postContent =
            Dict.get postId shared.posts
                |> Maybe.withDefault "Post Not Found "

        markdownView =
            Components.Md.view postContent
    in
    Components.NavBar.view
        { title = "Post"
        , body =
            [ div [ class "layout" ]
                [ div [ class "page" ]
                    [ h1 [] [ text postId ]
                    , div [] markdownView.body
                    ]
                ]
            ]
        }

subscriptions : Model -> Sub Msg
subscriptions model =Sub.none


{- shared – Stores any data you want to share across all your pages.

In the Shared section, you'll learn how to customize what data should be available.
route – Stores URL information, including things like route.params or route.query.

In the Route section, you'll learn more about the other values on the route field. -}

page : Shared.Model -> Route {post: String} -> Page Model Msg

page shared route =
    Page.new
        { init = init
        , update = update
        , view = view shared route
        , subscriptions = subscriptions
        }