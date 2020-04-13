module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Browser.Navigation as Navigation
import Debug
import Dict exposing (Dict)
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as Events
import Json.Decode as D
import Json.Encode as E
import Url exposing (Url)



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        []


defCell : ( String, Bool )
defCell =
    ( "★", False )



-- MODEL


type alias Model =
    { width : Int
    , height : Int
    , texts : Dict ( Int, Int ) ( String, Bool )
    }


type alias Flags =
    {}


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init {} {} _ =
    ( { width = 5, height = 5, texts = Dict.empty }, Cmd.none )



-- UPDATE


type Msg
    = Empty
    | EditCell ( Int, Int ) String
    | Cross ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditCell key txt ->
            ( { model | texts = Dict.update key (Maybe.withDefault defCell >> Tuple.mapFirst (always txt) >> Just) model.texts }, Cmd.none )

        Cross loc ->
            ( { model | texts = Dict.update loc (Maybe.withDefault defCell >> Tuple.mapSecond not >> Just) model.texts }, Cmd.none )

        Empty ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Bingo"
    , body = [ H.div [] [ renderApp model ] ]
    }


renderApp : Model -> H.Html Msg
renderApp ({ width } as model) =
    H.div [ A.class "cards" ]
        [ H.div
            [ A.class "card-holder"
            , A.style "width" ((String.fromInt <| width * 100) ++ "px")
            ]
            [ H.div []
                [ H.h1 [ A.class "header" ] [ H.text "- BINGO -" ]
                , renderBingoCard True model
                ]
            ]
        , H.div
            [ A.class "card-holder"
            , A.style "width" ((String.fromInt <| width * 100) ++ "px")
            ]
            [ H.div []
                [ H.h1 [ A.class "header" ] [ H.text "- BINGO -" ]
                , renderBingoCard False model
                ]
            ]
        ]


renderBingoCard : Bool -> Model -> H.Html Msg
renderBingoCard editable { width, height, texts } =
    H.div ([ A.class "card" ] ++ buildCardStyles width height) <|
        List.concat <|
            List.map
                (\row ->
                    List.map
                        (\col ->
                            let
                                ( txt, crossed ) =
                                    Maybe.withDefault defCell <| Dict.get ( row, col ) texts
                            in
                            (if editable then
                                H.textarea

                             else
                                H.div
                            )
                                ([ A.class "cell"
                                 , A.style "font-size" (calcFontSize txt)
                                 , Events.onInput (EditCell ( row, col ))
                                 ]
                                    ++ (if not editable then
                                            [ Events.onClick (Cross ( row, col )) ]

                                        else
                                            []
                                       )
                                )
                                [ H.div [ A.class "cross" ]
                                    (if crossed then
                                        [ H.text "✗" ]

                                     else
                                        []
                                    )
                                , H.text txt
                                ]
                        )
                        (List.range 1 width)
                )
                (List.range 1 height)


buildCardStyles : Int -> Int -> List (H.Attribute m)
buildCardStyles width height =
    [ A.style "grid-template-columns" (String.join " " (List.repeat width "1fr"))
    , A.style "grid-template-rows" (String.join " " (List.repeat height "1fr"))
    , A.style "width" (String.fromInt (width * 100) ++ "px")
    , A.style "height" (String.fromInt (height * 100) ++ "px")
    ]



-- Magical text sizing algorithm


calcFontSize : String -> String
calcFontSize txt =
    let
        txtSize =
            toFloat <| String.length txt

        calced =
            22 / max (logBase 10 txtSize) 1
    in
    String.fromFloat calced ++ "px"
