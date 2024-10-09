module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )
{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg
import Lib.Posts as Posts
import Dict exposing (Dict)
import Debug
-- FLAGS


type alias Flags =
    {posts: Dict String String}
-- type alias Flags =
--     {message:}


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.map Flags
        (Json.Decode.field "posts" (Json.Decode.dict Json.Decode.string))



-- INIT


type alias Model =
    Shared.Model.Model

init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    let
        _ =
            Debug.log "FLAGS" flagsResult

    in
        -- ({posts = Dict.empty}, Effect.none)
        case flagsResult of
            Ok flags ->
                ( { posts = flags.posts }
                , Effect.none
                )

            Err _ ->
                ( { posts = Dict.empty }
                , Effect.none
                )


-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.NoOp ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none
