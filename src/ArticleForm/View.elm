module ArticleForm.View exposing (viewForm, viewDebugJson)

import App.Update exposing (..)
import ArticleForm.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onSubmit, onInput)


viewForm : String -> Html Msg
viewForm title =
    Html.form
        [ onSubmit TryPost ]
        [ input
            [ type' "text"
            , placeholder "Title for a new article.."
            , onInput UpdateTitle
            , value title
            ]
            []
        ]

viewDebugJson : ArticleForm.Model.Model -> Html Msg
viewDebugJson data =
    code [] [ text (data |> ArticleForm.Model.dataToJson) ]
