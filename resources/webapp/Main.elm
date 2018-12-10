import Browser
import Html exposing (Html, button, div, text, pre)
import Html.Events exposing (onClick)
import Http
import RemoteData exposing (..)

import Debug exposing (toString)


-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model
  = WebData String


init : () -> (Model, Cmd Msg)
init _ =
  ( NotAsked
  , Cmd.none
  )



-- UPDATE


type Msg
  = GotResponse (WebData String)
  | Get


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Get -> (Loading, Http.get { url = "/"
                            , expect = Http.expectString (RemoteData.fromResult >> GotResponse)
                            })
    GotResponse result -> (result, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Get ] [ text "GET" ]
    , div [] [ viewStatus model ]
    ]

viewStatus : Model -> Html Msg
viewStatus model =
  case model of
    NotAsked ->
      text "not asked"

    Failure err ->
      text ("Error: " ++ toString err)

    Loading ->
      text "* LOADING *"

    Success fullText ->
      pre [] [ text fullText ]
