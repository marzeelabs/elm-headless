module App.View exposing (view)

import App.Model exposing (Model)
import App.Update exposing (..)
import Article.Model exposing (..)
import Article.View exposing (..)
import ArticleForm.Model exposing (..)
import ArticleForm.View exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

view : App.Model.Model -> Html Msg
view model =
    div [ ]
        [ h2 [ class "ui dividing header" ] [ text "Add new article" ]
        , ArticleForm.View.viewForm model.articleForm.title
        , ArticleForm.View.viewDebugJson model.articleForm
        , div [ class "error" ] [ text model.error ]
        , h2 [ class "ui dividing header" ] [ text "Latest articles" ]
        , Article.View.viewArticles model.articles
        ]




