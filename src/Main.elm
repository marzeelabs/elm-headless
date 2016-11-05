module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import App.Model exposing (Model)
import App.Update exposing (init, update, Msg(..))
import App.View exposing (view)

main =
    Html.program
        { init = App.Update.init
        , view = App.View.view
        , update = App.Update.update
        , subscriptions = subscriptions
        }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
