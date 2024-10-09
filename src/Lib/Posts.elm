module Lib.Posts exposing (..)
import Dict exposing (Dict)

posts : Dict String String
posts =
    Dict.fromList
        [ ( "post1", """
# Post 1

Content of post 1.
""" )
        ]
