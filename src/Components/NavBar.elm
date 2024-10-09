module Components.NavBar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)
import Components.Md


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

-- viewMarkdown : String -> View msg
-- viewMarkdown markdownContent =
--     view
--         { title = "Markdown Viewer"
--         , body = [ div [class "mdcont"] Components.Md.view markdownContent ]
--         }