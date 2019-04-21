module StreetRun.Effect.Audio where

import qualified SDL.Exception as SDL
import qualified SDL.Mixer as Mixer
import Control.Monad.Reader
import Control.Exception.Safe (MonadThrow, MonadCatch, catch)

import StreetRun.Config

class Monad m => Audio m where
  playGameMusic :: m ()
  stopGameMusic :: m ()
  playJumpSfx :: m ()
  playDuckSfx :: m ()
  playPointSfx :: m ()
  playBirdSfx :: m ()
  playHurtSfx :: m ()
  playLavaSfx :: m ()
  playRockSfx :: m ()
  playQuakeSfx :: m ()
  playDeathSfx :: m ()
  playRecoverSfx :: m ()
  playStockSfx :: m ()
  lowerGameMusic :: m ()
  raiseGameMusic :: m ()

playGameMusic' :: (MonadReader Config m, MonadIO m) => m ()
playGameMusic' = asks (rGameMusic . cResources) >>= Mixer.playMusic Mixer.Forever --plays the music on loop for ever 

stopGameMusic' :: MonadIO m => m ()
stopGameMusic' = Mixer.haltMusic --stops playing music 

lowerGameMusic' :: MonadIO m => m () 
lowerGameMusic' = Mixer.setMusicVolume 16 

raiseGameMusic' :: MonadIO m => m ()
raiseGameMusic' = Mixer.setMusicVolume 128 -- default value of music is 128 

playChunk :: (MonadReader Config m, MonadIO m, MonadThrow m, MonadCatch m) => (Resources -> Mixer.Chunk) -> m ()
playChunk sfx = flip catch ignore $ asks (sfx . cResources) >>= Mixer.play
  where
    ignore :: Monad m => SDL.SDLException -> m ()
    ignore _ = return ()

playJumpSfx',
  playDuckSfx',
  playPointSfx',
  playBirdSfx',
  playHurtSfx',
  playLavaSfx',
  playRockSfx',
  playQuakeSfx',
  playDeathSfx',
  playRecoverSfx',
  playStockSfx' :: (MonadReader Config m, MonadIO m, MonadThrow m, MonadCatch m) => m ()
playJumpSfx' = playChunk rJumpSfx  --these music resources are loaded in Resources file 
playDuckSfx' = playChunk rDuckSfx
playPointSfx' = playChunk rPointSfx
playBirdSfx' = playChunk rBirdSfx
playHurtSfx' = playChunk rHurtSfx
playLavaSfx' = playChunk rLavaSfx
playRockSfx' = playChunk rRockSfx
playQuakeSfx' = playChunk rQuakeSfx
playDeathSfx' = playChunk rDeathSfx
playRecoverSfx' = playChunk rRecoverSfx
playStockSfx' = playChunk rStockSfx
