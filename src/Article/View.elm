module Article.View exposing (viewArticles)

import App.Update exposing (..)
import Article.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Date exposing (..)
import Date.Format

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

formatDate : Float -> String
formatDate timestamp =
    timestamp * 1000 |> Date.fromTime |> Date.Format.format "%A, %e %B"
