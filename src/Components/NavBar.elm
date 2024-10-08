module Components.NavBar exposing (..)

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
            [ nav [ class "navbar" ]
                [ a [ href "/" ] [ text "Home" ]
                , a [ href "/post" ] [ text "Posts" ]
                ]
                , div [ class "page" ] props.body
            ]
        ]
    }