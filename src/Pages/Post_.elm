module Pages.Post_ exposing (page)

import Html
import View exposing (View)
import Components.NavBar


page : { post : String } -> View msg

page params =
    Components.NavBar.view
    {
        title = "thought",
        body = [ Html.text ("/" ++params.post )]
    }
