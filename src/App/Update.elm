module App.Update exposing (init, update, Msg(..))

import App.Model exposing (Model, emptyModel)
import Article.Model exposing (..)
import ArticleForm.Model exposing (..)
import Http
import RemoteData exposing (RemoteData(..), WebData)
import Json.Decode as JD exposing ((:=))
import Task

type Msg
    = FetchResponse (WebData Articles)
    | TryPost
    | UpdateTitle String
    | FetchFail Http.Error
    | FetchSucceed Articles

init : ( App.Model.Model, Cmd Msg )
init =
  ( emptyModel, fetch )
--emptyModel ! []
    --( Model Loading (ArticleForm "") "", fetch )


update : Msg -> App.Model.Model -> ( App.Model.Model, Cmd Msg )
update msg model =
    case msg of
        FetchResponse response ->
            ({model | articles = response}, Cmd.none)
        TryPost ->
            (model, post model.articleForm)
        UpdateTitle title ->
            let
                form = ArticleForm.Model.Model title
            in
                ({model | articleForm = form}, Cmd.none)
        FetchSucceed reply ->
            --({model | articles = reply}, Cmd.none)
            ({model | articleForm = (ArticleForm.Model.Model "success")}, Cmd.none)
        FetchFail error ->
            ({model | error = (toString error), articleForm = (ArticleForm.Model.Model "bllllll")}, Cmd.none)
            --(model, Cmd.none)

fetch : Cmd Msg
fetch =
    Http.get decodeData App.Model.headlessServer
        |> RemoteData.asCmd
        |> Cmd.map FetchResponse

-- A custom POST request so we can pass in headers as required by Drupal 8
postRequest : ArticleForm.Model.Model -> Http.Request
postRequest data =
    { verb = "POST"
    , headers =
        [
        --("Origin", "http://localhost:3000")
        ("Content-Type", "application/vnd.api+json")
        --, ("Access-Control-Request-Method", "POST")
        , ("Access-Control-Allow-Origin", "*")
        --, ("Access-Control-Request-Headers", "X-Custom-Header")
        --, ("Authorization", "Basic YWRtaW46YWRtaW4=")
        ]
    , url = App.Model.headlessServer
    , body = (Http.string (ArticleForm.Model.dataToJson data))
    }

post : ArticleForm.Model.Model -> Cmd Msg
post data =
    Http.send Http.defaultSettings (postRequest data)
        |> Http.fromJson decodeData
        |> Task.perform FetchFail FetchSucceed

decodeData : JD.Decoder Article.Model.Articles
decodeData =
    JD.at [ "data" ] <| JD.list <| JD.at [ "attributes" ] <| Article.Model.decodeArticle

