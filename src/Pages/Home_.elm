module Pages.Home_ exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)
import Components.NavBar
import Components.Asas
import Shared.Msg exposing (Msg(..))

type Msg = NoOp

page : View msg

page =
    -- Components.Asas.view
    Components.NavBar.view
    { title = "APTTMH"
    , body =[ div [ class "layout" ]
            [  div [ class "page" ]
                [ h1 [] [ text "Welcome to the Home Page" ]
                , p [] [ text "This is the home page of our website." ]
                , p [] [ text "Feel free to explore the other sections." ]
                ]
            ],
            fimph
        ]
    }

fimph: Html msg
fimph = div [] [ text "umm" ]