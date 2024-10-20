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

-- import Debug
-- import Lib.Api as Api
-- import Route.Path

import Dict exposing (Dict)
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Shared.Model
import Shared.Msg



-- FLAGS


type alias Flags =
    { posts : Dict String String }


type alias Model =
    Shared.Model.Model


type alias Msg =
    Shared.Msg.Msg


decoder : Json.Decode.Decoder Flags
decoder =
    -- read json entry retruned by interop.js
    Json.Decode.map Flags
        (Json.Decode.field "posts" (Json.Decode.dict Json.Decode.string))



-- INIT


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    let
        _ =
            ()

        -- Debug.log "FLAGS" flagsResult
    in
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
