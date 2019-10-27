module PenguinMath exposing (main)
{-- Penguin figure, jingle, and animation courtesy of Scratch,
    in which the first version of Penguin Math was programmed: 
    https://scratch.mit.edu --}

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


view model =
    div [ class "content" ]
        [ h1 [] [ text "Penguin Math" ]
        , a [ href "https://lunamintpop.neocities.org" ]
            [ img 
                [ src "resources/pengi.png"
                , height 130
                ] []
            ]
        , video 
            [ src "resources/pengi.mov"
            , height 150
            , autoplay True
            , loop True
            , controls True
            ] []
        ]


main =
    view "no model yet"
