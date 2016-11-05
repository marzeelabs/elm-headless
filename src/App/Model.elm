module App.Model exposing (emptyModel, headlessServer, Model)

import Article.Model exposing (..)
import ArticleForm.Model exposing (..)
import RemoteData exposing (RemoteData(..), WebData)

type alias Model =
    { articles : WebData Article.Model.Articles
    , articleForm : ArticleForm.Model.Model
    , error : String
    }

emptyModel : Model
emptyModel =
  { articles = Loading
  , articleForm = (ArticleForm.Model.Model "")
  , error = ""
  }

headlessServer : String
headlessServer =
    --"http://campaign.lab/api/node/article?_format=api_json"
    --"http://localhost:4000/db"
    "https://pr-572-72aemkq-tx3mbsqmxtu74.eu.platform.sh/api/node/article?_format=api_json"

