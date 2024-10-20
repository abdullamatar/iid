module Pages.Home_ exposing (page)

import Components.NavBar
import Html exposing (..)
import Html.Attributes exposing (..)
import Shared.Msg exposing (Msg(..))
import View exposing (View)


type Msg
    = NoOp


page : View msg
page =
    -- Components.Asas.view
    Components.NavBar.view
        { title = "APTTMH"
        , body =
            [ div [ class "layout" ]
                [ div [ class "page" ]
                    [ h1 [] [ text "السَّلَامُ عَلَيْكُمْ" ]
                    , p [] [ text "This is the home page of our website." ]
                    , p [] [ text "Feel free to explore the other sections." ]
                    ]
                ]
            ]
        }
