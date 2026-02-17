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
