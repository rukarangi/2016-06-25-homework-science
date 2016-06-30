{-# LANGUAGE RecordWildCards #-}

import System.Environment (getArgs)
import Data.List (find, intercalate)
import Text.Regex.PCRE
import Text.Regex.PCRE.String

type Line = String

main :: IO ()
main = do
    args <- getArgs 
    case args of
        cmd:[] -> interact (unlines . process cmd . lines)
        _ -> error "Please provide a command name"

type Command = String

process :: Command -> [Line] -> [Line]
process cmd = go [] 
  where 
    go :: [Line] -> [Line] -> [Line]
    go rl [] = showRecord $ makeRecord cmd $ reverse rl  
    go [] (l:ls) = ["time,command,mem,cpu"] ++ go [l] ls
    go rl (l:ls) = 
        if l =~ "^top"
            then (showRecord $ makeRecord cmd $ reverse rl) ++ (go [l] ls)
            else go (l:rl) ls


data Record 
  = Record 
    { time     :: String 
    , command  :: String
    , mem      :: String
    , cpu      :: String }
    deriving (Eq, Show)

makeRecord :: Command -> [Line] -> Record
makeRecord cmd (l:ls) = 
  let Just t = get "^top - ([0-9][0-9]:[0-9][0-9]:[0-9][0-9])" l
      selected = find (=~ cmd) ls
      cpu = get ("([0-9]{1,3}.[0-9]) {1,}[0-9]{1,3}.[0-9] {1,}[0-9]{1,2}:[0-9]{2}.[0-9]{2} {1,}" ++ cmd) =<< selected
      mem = get ("[0-9]{1,3}.[0-9] {1,}([0-9]{1,3}.[0-9]) {1,}[0-9]{1,2}:[0-9]{2}.[0-9]{2} {1,}" ++ cmd) =<< selected
  in  Record t cmd (maybe "0.0" id mem) (maybe "0.0" id cpu)

get :: String -> Line -> Maybe String
get pattern l =
  let m = l =~ pattern
  in case m of
        [[_, t]] -> Just t
        _        -> Nothing

showRecord :: Record -> [Line]
showRecord r@Record {..} =
    [intercalate "," [time, command, mem, cpu]]









