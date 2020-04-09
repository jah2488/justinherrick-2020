module Utils exposing (Content(..), date, dynamicStyle, randomColor, section, style)

import Html exposing (Html, div, h2, node, p, text)
import Html.Attributes exposing (class)


type Content msg
    = Text String
    | Markup (List (Html msg))


dynamicStyle : { a | seeds : ( Float, Float, Float ) } -> Html msg
dynamicStyle model =
    let
        pieces =
            [ ":root {--main:"
            , randomColor model "1"
            , "; --main-faded:"
            , randomColor model "0.15"
            , "};"
            ]
    in
    style [] [ text <| String.join " " pieces ]


randomColor : { a | seeds : ( Float, Float, Float ) } -> String -> String
randomColor { seeds } alpha =
    let
        ( rs, gs, bs ) =
            seeds

        r =
            String.fromInt <| floor <| rs * 256

        g =
            String.fromInt <| floor <| gs * 256

        b =
            String.fromInt <| floor <| bs * 256
    in
    "rgba(" ++ r ++ "," ++ g ++ "," ++ b ++ "," ++ alpha ++ ");"


section : String -> List (Content msg) -> Html msg
section title points =
    div [ class "section" ]
        [ h2 [] [ text title ]
        , div [] <|
            List.map
                (\point ->
                    case point of
                        Text str ->
                            p [] [ text str ]

                        Markup html ->
                            p [] html
                )
                points
        ]


style : List (Html.Attribute msg) -> List (Html msg) -> Html msg
style =
    node "style"


date : List (Html.Attribute msg) -> List (Html msg) -> Html msg
date =
    node "time"
