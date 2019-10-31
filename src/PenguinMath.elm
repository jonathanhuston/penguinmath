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
    = Intro
    | Quiz
    | Dancing

init: Model
init = 
    Intro


-- UPDATE

type Msg 
    = Start
    | Next
    | Dance
    | Stop

update : Msg -> Model -> Model
update msg model =
    case msg of
        Start ->
            Quiz
        Next ->
            Quiz
        Dance ->
            Dancing
        Stop ->
            Quiz


-- VIEW

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ h1 [] [ text "Penguin Math" ]
        , displayQuestion model
        , displayButton model
        , section [ id "pengi" , class "container"]
            [ button 
                [ id "pengi", onClick Dance ]
                [ viewPengi model ]
            ]
        ]


displayButton : Model -> Html Msg
displayButton model =
    case model of 
        Intro -> 
            button [ onClick Start ] [ text "Start" ]
        Quiz ->
            button [ onClick Next ] [ text "Next" ]
        Dancing ->
            button [ onClick Stop ] [ text "Stop" ]


displayQuestion : Model -> Html Msg
displayQuestion model =
    case model of
        Intro ->
            p [] [ text "Hi, I'm Pengi the Penguin. Let's do some math. "]
        Quiz ->    
            p [] [ text "5 km and 350 m is how many meters?" ]
        Dancing ->
            p [] [ text "Pengi is happy!!" ]


viewPengi : Model -> Html Msg
viewPengi model =
    let pengiImg = img [ src "resources/pengi.png", height 130 ] []
        pengiVid = video [ src "resources/pengi.mov", height 150, autoplay True, loop True, controls False ] []
    in
    case model of 
        Intro ->
            pengiImg
        Quiz ->
            pengiImg
        Dancing ->
            pengiVid
