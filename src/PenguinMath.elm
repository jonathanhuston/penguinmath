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
    | WrongTwice
    | SadPengi
    | HappyPengi

type alias Model =
    { quizHeaders : List QuizHeader
    , quiz : Quiz
    , page : Page
    , right : Int
    , wrong : Int
    , count : Int
    , question : String
    , answer : String
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
    , question = ""
    , answer = ""
    , myAnswer = ""
    , lastWrong = False
    }


fetchQuizHeaders : Cmd Msg
fetchQuizHeaders =
    Http.get
        { url = baseUrl ++ "quizzes"
        , expect = Http.expectJson LoadQuizHeaders headersDecoder
        } 


fetchQuiz : Model -> String -> Cmd Msg
fetchQuiz model name =
    Http.get
        { url = baseUrl ++ "quizzes/" ++ name
        , expect = Http.expectJson LoadQuiz quizDecoder
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchQuizHeaders )



-- UPDATE

type Msg 
    = Go
    | Input String
    | Enter
    | Next
    | StartOver
    | LoadQuizHeaders (Result Http.Error (List QuizHeader))
    | SelectQuiz String
    | LoadQuiz (Result Http.Error Quiz)


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Go ->
            ( { model | page = AskQuestion
              , myAnswer = "" 
              }
            , fetchQuiz model model.quiz.name
            )
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
              , question = ""
              , answer = ""
              , myAnswer = ""
              , lastWrong = False
              }
            , fetchQuizHeaders
            )
        LoadQuizHeaders (Ok quizHeaders) ->
            let quizName = case List.head quizHeaders of
                            Just qh ->
                                qh.name
                            Nothing ->
                                ""
                oldQuiz = model.quiz
                newQuiz = { oldQuiz | name = quizName
                          , total = 0 
                          }
            in  
            ( { model | quizHeaders = quizHeaders
              , quiz = newQuiz 
              }
            , Cmd.none 
            )
        LoadQuizHeaders (Err _) ->
            ( model
            , Cmd.none
            )
        SelectQuiz quizName ->
            let
                oldQuiz = model.quiz
                newQuiz = { oldQuiz | name = quizName }
            in
            ( { model | quiz = newQuiz }
            , Cmd.none
            )
        LoadQuiz (Ok quiz) ->
            ( { model | quiz = quiz
              , question = getQuestion { model | quiz = quiz }
              , answer = getAnswer { model | quiz = quiz }
              }
            , Cmd.none 
            )
        LoadQuiz (Err _) ->
            ( model
            , Cmd.none
            )


getQuestion : Model -> String
getQuestion model =
    case Array.get model.count model.quiz.questions of
        Just q ->
            q
        Nothing ->
            "I don't know what to ask."


getAnswer : Model -> String
getAnswer model =
    case Array.get model.count model.quiz.answers of
        Just a ->
            a
        Nothing ->
            "I have no idea."


rightOrWrong : Model -> Model
rightOrWrong model =
    if String.trim model.myAnswer == model.answer then 
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
            { model | page = WrongTwice
            , count = model.count + 1
            , lastWrong = False }
        else
            { model | page = WrongAnswer
            , wrong = model.wrong + 1
            , lastWrong = True }


getNextPage : Model -> Model
getNextPage model =
    if model.count < model.quiz.total then
        { model | page = AskQuestion
        , question = getQuestion model
        , answer = getAnswer model
        , myAnswer = ""
        }
    else if model.right >= model.quiz.goal then
        { model | page = HappyPengi }
    else
        { model | page = SadPengi }


-- VIEW

view : Model -> Html Msg
view model =
    div [ id "content" ]
        [ h1 [] [ text "Penguin Math" ]
        , displayHeader model
        , displayCaption model
        , displayButton model
        , section [ id "pengi" , class "container"]
            [ displayPengi model ]
        , p [] [ text ("Right: " ++ String.fromInt model.right) ]
        , p [] [ text ("Wrong: " ++ String.fromInt model.wrong) ]
        , p [] [ text ("Questions left: " ++ String.fromInt (model.quiz.total - model.right - model.wrong)) ]
        ]


displayHeader : Model -> Html Msg
displayHeader model =
    if model.page == Intro then 
        h2 [] [ text "(and other quizzes)"]
    else if model.page == WrongTwice then
        h2 [ id "wrong" ] [ text model.question ]
    else
        h2 [] [ text model.quiz.title ]


displayCaption : Model -> Html Msg
displayCaption model =
    let 
        score = String.fromInt model.right ++ " out of " ++ String.fromInt model.quiz.total
    in
    case model.page of
        Intro ->
            p [] [ text "Hi, I'm Pengi the Penguin. Let's choose a quiz."]
        AskQuestion ->    
            p [] [ text model.question ]
        RightAnswer ->
            p [] [ text "That's the right answer!" ]
        WrongAnswer ->
            p [] [ text "Oops. Try again." ]
        WrongTwice ->
            p [] [ text ("Double oops. The right answer  is " ++ model.answer ++ ".") ]
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
                , button [ onClick Go ] [ text "Go" ]
                ]
        AskQuestion ->
            input [ value model.myAnswer, onInput Input, onEnter Enter ] []
        RightAnswer ->
            button [ onClick Next ] [ text "Next" ]
        WrongAnswer ->
            button [ onClick Next ] [ text "Try again" ]
        WrongTwice ->
            button [ onClick Next ] [ text "Next"]
        SadPengi ->
            button [ onClick StartOver ] [ text "New quiz" ]
        HappyPengi ->
            button [ onClick StartOver ] [ text "New quiz" ]


displayDropdown : Model -> List (Html Msg)
displayDropdown model =
   List.map (\qz -> option [ value qz.name ] [ text qz.title ]) model.quizHeaders


displayPengi : Model -> Html Msg
displayPengi model =
    let pengiImg = img [ src "resources/pengi.png"
                       , height 130 
                       ] []

        deadImg = img [ src "resources/dead penguin.png"
                      , height 130
                      ] []

        pengiVid = video [ src "resources/pengi.mov"
                         , height 150
                         , autoplay True
                         , attribute "playsinline" "playsinline"
                         , loop True
                         , controls False 
                         ] []
    in
    if model.page == HappyPengi then
        pengiVid
    else if model.page == SadPengi then
        deadImg
    else
        pengiImg


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
