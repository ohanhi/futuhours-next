module Util exposing (formatDate, formatMonth, httpErrToString, maybeOr, monthToInt, toEnglishMonth, toEnglishWeekday)

import Date
import Http exposing (Error(..))
import Iso8601 as Iso
import Parser
import Time exposing (Month(..), Weekday(..))
import Types as T


toEnglishMonth : Time.Month -> String
toEnglishMonth month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"


monthToInt : Time.Month -> Int
monthToInt month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


formatMonth : T.Month -> String
formatMonth month =
    case Iso.toTime <| month ++ "-01" of
        Ok posix ->
            (toEnglishMonth <| Time.toMonth Time.utc posix)
                ++ " "
                ++ (String.fromInt <| Time.toYear Time.utc posix)

        Err debug ->
            Parser.deadEndsToString debug


toEnglishWeekday : Time.Weekday -> String
toEnglishWeekday weekday =
    case weekday of
        Mon ->
            "Mon"

        Tue ->
            "Tue"

        Wed ->
            "Wed"

        Thu ->
            "Thu"

        Fri ->
            "Fri"

        Sat ->
            "Sat"

        Sun ->
            "Sun"


formatDate : T.Day -> String
formatDate day =
    case Iso.toTime day of
        Ok posix ->
            (Time.toWeekday Time.utc posix |> toEnglishWeekday)
                ++ " "
                ++ (Time.toDay Time.utc posix |> String.fromInt)
                ++ "."
                ++ (Time.toMonth Time.utc posix |> monthToInt |> String.fromInt)
                ++ "."

        Err debug ->
            Parser.deadEndsToString debug


maybeOr : Maybe a -> Maybe a -> Maybe a
maybeOr l r =
    case l of
        Just _ ->
            l

        Nothing ->
            r


httpErrToString : Http.Error -> String
httpErrToString err =
    case err of
        BadUrl str ->
            "Bad URL: " ++ str

        Timeout ->
            "The request timed out"

        NetworkError ->
            "Network error"

        BadStatus int ->
            "Request returned bad status: " ++ String.fromInt int

        BadBody str ->
            "Error parsing request body: " ++ str
