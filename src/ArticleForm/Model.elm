module ArticleForm.Model exposing (..)

import Json.Encode as JE exposing (string, int)

type alias Model =
    { title : String }

dataToJson : Model -> String
dataToJson data =
    JE.encode 0
        <| JE.object
            [ ("data", encodeData <| data)
            ]

encodeData data =
    JE.object
        [ ("type", string "node--article")
        , ("attributes", encodeAttributes <| data)
        ]

encodeAttributes data =
    JE.object
        [ ("title", string data.title)
        , ("status", int 1)
        ]
