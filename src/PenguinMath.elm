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
import Http
import Json.Decode exposing (Decoder, at, array, list, int, string, succeed)
import Json.Decode.Pipeline exposing (required)



-- MAIN

main =
    Browser.element 
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions 
        }
    


-- MODEL


type alias QuizHeader = 
    { name : String
    , title : String
    }

type alias Quiz =
    { name : String
    , title : String        
    , total : Int
    , goal : Int
    , questions : Array String
    , answers : Array String
    }

type Page
    = Intro
    | AskQuestion
    | RightAnswer
    | WrongAnswer
    | SadPengi
    | HappyPengi

type alias Model =
    { quizHeaders : List QuizHeader
    , quiz : Quiz
    , page : Page
    , right : Int
    , wrong : Int
    , count : Int
    , myAnswer : String
    , lastWrong : Bool
    }


headerDecoder : Decoder QuizHeader
headerDecoder =
    succeed QuizHeader
        |> required "name" string
        |> required "title" string


headersDecoder : Decoder (List QuizHeader)
headersDecoder =
    at ["quizzes"] (list headerDecoder)


quizDecoder : Decoder Quiz
quizDecoder =
    succeed Quiz
        |> required "name" string
        |> required "title" string
        |> required "total" int
        |> required "goal" int
        |> required "questions" (array string)
        |> required "answers" (array string)


baseUrl : String
baseUrl =
--    "https://slatescript.pythonanywhere.com/penguinmath/api/"
    "http://localhost:5000/penguinmath/api/"


initialModel : Model
initialModel = 
    let
        emptyQuiz =
            { name = ""
            , title = ""
            , total = 0
            , goal = 0
            , questions = Array.fromList []
            , answers = Array.fromList []
            }
    in
    { quizHeaders = []
    , quiz = emptyQuiz
    , page = Intro 
    , right = 0
    , wrong = 0
    , count = 0
    , myAnswer = ""
    , lastWrong = False
    }


fetchQuizHeaders : Cmd Msg
fetchQuizHeaders =
    Http.get
        { url = baseUrl ++ "quizzes"
        , expect = Http.expectJson LoadQuizHeaders headersDecoder
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchQuizHeaders )



-- UPDATE

type Msg 
    = Input String
    | Enter
    | Next
    | StartOver
    | LoadQuizHeaders (Result Http.Error (List QuizHeader))
    | SelectQuiz String
    | LoadQuiz (Result Http.Error Quiz)


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Input myAnswer ->
            ( { model | myAnswer = myAnswer }
            , Cmd.none
            )
        Enter ->
            ( rightOrWrong model
            , Cmd.none
            )
        Next ->
            ( getNextPage model
            , Cmd.none
            )
        StartOver ->
            ( { model | page = Intro
              , right = 0
              , wrong = 0
              , count = 0
              , myAnswer = ""
              , lastWrong = False
              }
            , fetchQuizHeaders
            )
        LoadQuizHeaders (Ok quizHeaders) ->
            ( { model | quizHeaders = quizHeaders }
            , Cmd.none 
            )
        LoadQuizHeaders (Err _) ->
            ( model
            , Cmd.none
            )
        SelectQuiz quizName ->
            ( model
            , fetchQuiz model quizName
            )
        LoadQuiz (Ok quiz) ->
            ( { model | quiz = quiz }
            , Cmd.none 
            )
        LoadQuiz (Err _) ->
            ( model
            , Cmd.none
            )


rightOrWrong : Model -> Model
rightOrWrong model =
    let answer = case Array.get model.count model.quiz.answers of
                    Just a ->
                        a
                    Nothing ->
                        ""
    in
    if model.myAnswer == answer then 
        if model.lastWrong then
            { model | page = RightAnswer
            , count = model.count + 1
            , lastWrong = False } 
        else
            { model | page = RightAnswer
            , right = model.right + 1
            , count = model.count + 1
            , lastWrong = False } 
    else if model.lastWrong then
            { model | page = WrongAnswer }
        else
            { model | page = WrongAnswer
            , wrong = model.wrong + 1
            , lastWrong = True }


getNextPage : Model -> Model
getNextPage model =
    if model.count < model.quiz.total then
        { model | page = AskQuestion
        , myAnswer = ""
        }
    else if model.right >= model.quiz.goal then
        { model | page = HappyPengi }
    else
        { model | page = SadPengi }


fetchQuiz : Model -> String -> Cmd Msg
fetchQuiz model name =
    Http.get
        { url = baseUrl ++ "quizzes/" ++ name
        , expect = Http.expectJson LoadQuiz quizDecoder
        }


-- VIEW

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ h1 [] [ text "Penguin Math" ]
        , displayCaption model
        , displayButton model
        , section [ id "pengi" , class "container"]
            [ viewPengi model ]
        , p [] [ text ("Right: " ++ String.fromInt model.right) ]
        , p [] [ text ("Wrong: " ++ String.fromInt model.wrong) ]
        , p [] [ text ("Questions left: " ++ String.fromInt (model.quiz.total - model.right - model.wrong)) ]
        ]


displayCaption : Model -> Html Msg
displayCaption model =
    let question = case Array.get model.count model.quiz.questions of
                        Just q ->
                            q
                        Nothing ->
                            "I'm at a loss"
        score = String.fromInt model.right ++ " out of " ++ String.fromInt model.quiz.total
    in
    case model.page of
        Intro ->
            p [] [ text "Hi, I'm Pengi the Penguin. Let's do some math. "]
        AskQuestion ->    
            p [] [ text question ]
        RightAnswer ->
            p [] [ text "That's the right answer!" ]
        WrongAnswer ->
            p [] [ text "Oops. Try again." ]
        SadPengi ->
            p [] [ text ("You answered " ++ score ++ " correctly. Pengi is a bit sad.") ]
        HappyPengi ->
            p [] [ text ("Yay! You answered " ++ score ++ " correctly! Pengi is very happy!") ]


displayButton : Model -> Html Msg
displayButton model =
    case model.page of 
        Intro -> 
            section [ id "select quiz" ]
                [ select [ class "dropbtn", name "quizzes", onInput SelectQuiz ]
                    (displayDropdown model)
                , button [ onClick Next ] [ text "Go" ]
                ]
        AskQuestion ->
            input [ value model.myAnswer, onInput Input, onEnter Enter ] []
        RightAnswer ->
            button [ onClick Next ] [ text "Next" ]
        WrongAnswer ->
            button [ onClick Next ] [ text "Try again" ]
        SadPengi ->
            button [ onClick StartOver ] [ text "Start over" ]
        HappyPengi ->
            button [ onClick StartOver ] [ text "Start over" ]


displayDropdown : Model -> List (Html Msg)
displayDropdown model =
   List.map (\qz -> option [ value qz.name] [ text qz.title ]) model.quizHeaders


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



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
