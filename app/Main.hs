module Main (main) where

import Network.Socket
import Network.Socket.ByteString (recv, sendAll)
import Control.Concurrent (forkIO)
import qualified Data.byteString.Char8 as BS 

main :: IO ()
main = do
  sock <- socket AF_INET Stream defaultProtocol
  setSocketOption sock ReuseAddr 1
  bind sock (SockAddrInet 8080 0)
  listen sock 5
  putStr "Listening on port 8080"
  acceptLoop sock

acceptLoop :: Socket -> IO ()
acceptLoop sock = do
  (conn, _addr) <- do
    forkIO (handleConnection conn)
    acceptLoop sock

data Method = GET | POST | PUT | DELETE | UnknownMethod BS.ByteString
  deriving (Show, Eq)

data Request = Request
  { method :: Method
  , path :: BS.ByteString
  , headers :: [(BS.ByteString, BS.ByteString)]
  , body :: BS.ByteString
  } deriving (Show)


parseMethod :: BS.ByteString -> Method
parseMethod "GET" = GET
parseMethod "POST" = POST
parseMethod "PUT" = PUT
parseMethod "DELETE" = DELETE
parseMethod other = UnknownMethod other


parseRequest :: BS.ByteString -> Maybe Request
parseRequest raw = do
  let (headerSection, rest) = splitOn "/r/n/r/n" raw
        ls                    = BS.lines headerSection
  requestLine <- case ls of { (x:_)  -> Just x; _ -> Nothing}
  let parts = BS.words requestLine
  (m, p) <- case parts of { (m:p:_) -> Just (m, p); _ -> Nothing }
  let headerLines = drop 1 ls
      hdrs        = map parseHeader headerLines
  return Request
    { method = parseMethod
    , path   = p
    , headers = hdrs
    , body = rest
    }

parseHeader :: BS.ByteString -> (BS.ByteString, BS.ByteString)
parseHeader line =
  let (k, v) = BS.break (== ':') line
  in (BS.strip k, BS.strip (BS.drop 1 v))

-- helpers

splitOn :: BS.ByteString -> BS.ByteString -> (BS.ByteString, BS.ByteString)
splinOn delim bs =
  case BS.breakSubstring delim bs of
    (before,after)
      | BS.null after -> (before, BS.empty)
      | otherwise     -> (before, BS.drop (BS.length delim) after)



