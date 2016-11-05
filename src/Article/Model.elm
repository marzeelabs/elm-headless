module Article.Model exposing (..)

import Json.Decode as JD exposing ((:=))
import String exposing (toInt, toFloat)

type alias Id =
    Int

type alias Author =
    { id : Id
    , name : String
    }

type alias Article =
    { body : Maybe String
    , id : Id
    , label : String
    , created : Float
    }

type alias Articles =
    List Article

decodeArticle : JD.Decoder Article
decodeArticle =
    let
        -- Cast String to Int.
        number : JD.Decoder Int
        number =
            JD.oneOf [ JD.int, JD.customDecoder JD.string String.toInt ]

        numberFloat : JD.Decoder Float
        numberFloat =
            JD.oneOf [ JD.float, JD.customDecoder JD.string String.toFloat ]

        decodeId =
            JD.at [ "" ]

        decodeAuthor =
            JD.object2 Author
                ("id" := number)
                ("label" := JD.string)

        decodeImage =
            JD.at [ "styles" ]
                ("thumbnail" := JD.string)
    in
        JD.object4 Article
            --(JD.oneOf [ "body" := JD.string, JD.succeed "" ])
            (JD.maybe ("body" := ("value" := JD.string)))
            ("nid" := number)
            --("image" := JD.string)
            --(JD.maybe ("image" := decodeImage))
            ("title" := JD.string)
            ("created" := numberFloat)
