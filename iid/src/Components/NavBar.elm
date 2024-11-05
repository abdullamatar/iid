module Components.NavBar exposing (..)

import Browser.Navigation exposing (load)
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
        [ div [ class "temp" ]
            [ nav [ class "navbar" ]
                [ a [ href "/" ] [ text "Home" ]
                , a [ href "/post", target "_self" ] [ text "Posts" ]
                ]
            , div [ class "post-body" ] props.body
            ]
        ]
    }
