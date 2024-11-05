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
    Components.NavBar.view
        { title = "APTTMH"
        , body =
            [ div [ class "layout" ]
                [ div [ class "page" ]
                    [ div [ class "overlay-container" ]
                        [ div [ class "welcome-text" ]
                            [ h1 [] [ text "السَّلَامُ عَلَيْكُمْ" ]
                            , p [] [ text "This website is under development and will be a place where I share things I find interesting." ]
                            , p []
                                [ text "Please take a look at the "
                                , a [ href "/post" ] [ text "posts" ]
                                , text ", and share any thoughts or feedback "
                                , a [ href "https://github.com/abdullamatar/iid/issues/new", target "_blank" ] [ text "here." ]
                                ]
                            ]
                        , Html.node "forest-demo" [] []
                        ]
                    ]
                ]
            ]
        }
