module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Browser.Navigation as Navigation
import Html as H exposing (Html)
import Json.Decode as D
import Json.Encode as E
import Url exposing (Url)



-- MAIN


main : Program Flags AppState Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = updateApp
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest r =
    Empty


onUrlChange : Url.Url -> Msg
onUrlChange {} =
    Empty


subscriptions : AppState -> Sub Msg
subscriptions _ =
    Sub.batch
        []



-- MODEL


type alias AppState =
    {}


type alias Flags =
    {}


init : Flags -> Url -> Navigation.Key -> ( AppState, Cmd Msg )
init {} {} _ =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = Empty


updateApp : Msg -> AppState -> ( AppState, Cmd Msg )
updateApp msg state =
    ( state, Cmd.none )



-- VIEW


view : AppState -> Browser.Document Msg
view model =
    { title = "Bingo"
    , body = [ renderApp model ]
    }


renderApp : AppState -> H.Html Msg
renderApp state =
    H.div [] [ H.text "Bingo" ]
