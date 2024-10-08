module Components.Asas exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)

view :
    { title : String
    , body : List (Html msg)
    }
    -> View msg

view props =
    { title = props.title
    , body =
        [ div [ class "layout" ]
            [  div [ class "page" ]
                [ h1 [] [ text "Welcome to the Home Page" ]
                , p [] [ text "This is the home page of our website." ]
                , p [] [ text "Feel free to explore the other sections." ]
                ]
            ]
        ]
    }