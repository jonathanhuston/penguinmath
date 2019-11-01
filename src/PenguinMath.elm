module PenguinMath exposing (main)
{-- Penguin figure, jingle, and animation courtesy of Scratch,
    in which the first version of Penguin Math was programmed: 
    https://scratch.mit.edu --}

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra exposing (onEnter)


-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }
    

-- MODEL

type Page
    = Intro
    | AskQuestion
    | RightAnswer
    | WrongAnswer
    | SadPengi
    | HappyPengi

type alias Model =
    { page : Page
    , total : Int
    , goal : Int
    , right : Int
    , wrong : Int
    , myAnswer : String
    , lastWrong : Bool
    }

init: Model
init = 
    { page = Intro 
    , total = 10
    , goal = 8
    , right = 0
    , wrong = 0
    , myAnswer = ""
    , lastWrong = False
    }


-- UPDATE

type Msg 
    = Start
    | Input String
    | Enter
    | Next
    | StartOver

update : Msg -> Model -> Model
update msg model =
    case msg of
        Start ->
            { model | page = AskQuestion }
        Input myAnswer ->
            { model | myAnswer = myAnswer }
        Enter ->
            rightOrWrong model
        Next ->
            getNextPage model
        StartOver ->
            { model | page = Intro
            , right = 0
            , wrong = 0
            , myAnswer = ""
            , lastWrong = False
            }


rightOrWrong : Model -> Model
rightOrWrong model =
    if model.myAnswer == "5350" then 
        if model.lastWrong then
            { model | page = RightAnswer
            , lastWrong = False } 
        else
            { model | page = RightAnswer
            , right = model.right + 1
            , lastWrong = False } 
    else if model.lastWrong then
            { model | page = WrongAnswer }
        else
            { model | page = WrongAnswer
            , wrong = model.wrong + 1
            , lastWrong = True }

getNextPage : Model -> Model
getNextPage model =
    if model.right + model.wrong < model.total then
        { model | page = AskQuestion
        , myAnswer = ""
        }
    else if model.right >= model.goal then
        { model | page = HappyPengi }
    else
        { model | page = SadPengi }


-- VIEW

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ h1 [] [ text "Penguin Math" ]
        , displayQuestion model
        , displayButton model
        , section [ id "pengi" , class "container"]
            [ viewPengi model ]
        , p [] [ text ("Right: " ++ String.fromInt model.right) ]
        , p [] [ text ("Wrong: " ++ String.fromInt model.wrong) ]
        , p [] [ text ("Questions left: " ++ String.fromInt (model.total - model.right - model.wrong)) ]
        ]


displayButton : Model -> Html Msg
displayButton model =
    case model.page of 
        Intro -> 
            button [ onClick Start ] [ text "Start" ]
        AskQuestion ->
            input [ value model.myAnswer, onInput Input, onEnter Enter ] []
        RightAnswer ->
            button [ onClick Next ] [ text "Next" ]
        WrongAnswer ->
            button [ onClick Next ] [ text "Next" ]
        SadPengi ->
            button [ onClick StartOver ] [ text "Start over" ]
        HappyPengi ->
            button [ onClick StartOver ] [ text "Start over" ]


displayQuestion : Model -> Html Msg
displayQuestion model =
    case model.page of
        Intro ->
            p [] [ text "Hi, I'm Pengi the Penguin. Let's do some math. "]
        AskQuestion ->    
            p [] [ text "5 km and 350 m is how many meters?" ]
        RightAnswer ->
            p [] [ text "That's the right answer!" ]
        WrongAnswer ->
            p [] [ text "Oops. Try again." ]
        SadPengi ->
            p [] [ text ("You answered " ++ String.fromInt model.right ++ " correctly. Pengi is a bit sad.") ]
        HappyPengi ->
            p [] [ text ("Yay! You answered " ++ String.fromInt model.right ++ " correctly! Pengi is very happy!") ]


viewPengi : Model -> Html Msg
viewPengi model =
    let pengiImg = img [ src "resources/pengi.png"
                       , height 130 
                       ] []

        pengiVid = video [ src "resources/pengi.mov"
                         , height 150
                         , autoplay True
                         , loop True
                         , controls False 
                         ] []
    in
    case model.page of 
        Intro ->
            pengiImg
        AskQuestion ->
            pengiImg        
        RightAnswer ->
            pengiImg        
        WrongAnswer ->
            pengiImg        
        SadPengi ->
            pengiImg
        HappyPengi ->
            pengiVid
