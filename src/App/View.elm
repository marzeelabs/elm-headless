module App.View exposing (view)

import App.Model exposing (Model)
import App.Update exposing (..)
import Article.Model exposing (..)
import ArticleForm.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onSubmit, onInput)
import RemoteData exposing (RemoteData(..), WebData)
import Date exposing (..)
import Date.Format

view : App.Model.Model -> Html Msg
view model =
    div [ ]
        [ h2 [ class "ui dividing header" ] [ text "Add new article" ]
        , viewForm model.articleForm.title
        , viewDebugJson model.articleForm
        , div [ class "error" ] [ text model.error ]
        , h2 [ class "ui dividing header" ] [ text "Latest articles" ]
        , viewArticles model.articles
        ]


viewArticles : WebData Article.Model.Articles -> Html Msg
viewArticles articles =
    case articles of
        Success articles ->
            div [ class "ui list" ] (List.map viewArticle articles)

        Failure error ->
            div [] [ text ("Error loading data. Tip: make sure to run 'npm run api'. Message: " ++ (toString error)) ]

        NotAsked ->
            div [] [ text "Not asked yet" ]

        Loading ->
            div [ class "ui active centered inline loader" ] []


viewArticle : Article -> Html Msg
viewArticle article =
    let
        body =
            case article.body of
                Nothing -> text "..."
                Just val -> text val
    in
        --div []
        --    [ div [ class "title" ]
        --        [ i [ class "dropdown icon" ] []
        --        , i [ class "calendar outline icon" ] []
        --        , text (article.created |> formatDate)
        --        , text " - "
        --        , text article.label
        --        ]
        --    , div [ class "content" ] [ body ]
        --    ]
        div [ class "item" ]
            [ div [ class "header" ] [ text article.label ]
            , i [ class "calendar outline icon" ] []
            , div [ class "content" ] [ text (article.created |> formatDate) ]
            , body
            ]

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

formatDate : Float -> String
formatDate timestamp =
    timestamp * 1000 |> Date.fromTime |> Date.Format.format "%A, %e %B"
