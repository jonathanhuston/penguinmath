module PenguinMath exposing (main)
{-- Penguin figure, jingle, and animation courtesy of Scratch,
    in which the first version of Penguin Math was programmed: 
    https://scratch.mit.edu --}

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }
    

-- MODEL

type Model
    = Stand
    | Dance

init: Model
init = 
    Stand


-- UPDATE

type Msg 
    = Switch

update : Msg -> Model -> Model
update msg model =
    case msg of
        Switch ->
            case model of
                Stand ->
                    Dance

                Dance ->
                    Stand


-- VIEW

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ h1 [] [ text "Penguin Math" ]
        , p [] [ text "Hi, I'm Pengi the Penguin. Let's do some math."]
        , section [ id "pengi" , class "container"]
            [ button 
                [ onClick Switch ]
                [ viewPengi model ]
            ]
        ]


viewPengi : Model -> Html Msg
viewPengi model =
    case model of 
        Stand ->
            img 
                [ src "resources/pengi.png"
                , height 130
                ] []

        Dance ->
            video 
                [ src "resources/pengi.mov"
                , height 150
                , autoplay True
                , loop True
                , controls False
                ] []
