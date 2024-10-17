module Components.NavBar exposing (..)

import Browser.Navigation exposing (load)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
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



-- type alias Model msg =
--     { title : String
--     , body: List (Html msg)
--     , onPostsClick : msg
--     }
-- view : Model msg -> View msg
-- view model =
-- { title = model.title
-- ,body=
--     nav [ class "navbar" ]
--         [ a [ href "#", onClick model.onPostsClick ] [ text "Posts" ]
--         , a [ href "#about" ] [ text "About" ]
--         -- Add other links as needed
--         ]
-- }
