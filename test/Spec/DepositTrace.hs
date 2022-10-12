{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE NumericUnderscores    #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}

module Spec.DepositTrace where

import           Control.Lens
import           Data.Default                 (def)
import qualified Data.Map                     as Map
import qualified Ledger.Ada                   as Ada
import           Plutus.Contract.Test
import           Plutus.Trace
import           Plutus.V1.Ledger.Value
import           PlutusTx.Prelude             hiding (Semigroup (..), unless)
import           Test.Tasty
import           Prelude

tests :: TestTree
tests = testGroup "Token deposit tests"
    [ depositTokenTest
    ]

depositTokenTest :: TestTree
depositTokenTest = checkPredicateOptions
    (defaultCheckOptions & emulatorConfig .~ emCfg)
    "Can deposit token into contract"
    (walletFundsChange w1 (Ada.lovelaceValueOf (-2_000_000))
    .&&. walletFundsChange w2 (Ada.lovelaceValueOf 0)
    )
    myTrace

emCfg :: EmulatorConfig
emCfg = EmulatorConfig (Left dist) def
  where
    adaInitAmount = 100_000_000
    dist = Map.fromList [ (knownWallet 1, Ada.lovelaceValueOf adaInitAmount
                            <> assetClassValue tokenAssetClass 20000
                          )
                        , (knownWallet 2, Ada.lovelaceValueOf adaInitAmount)
                        ]

tokenAssetClass :: AssetClass
tokenAssetClass =
  assetClass
    (currencySymbol "5cb39e252088575b32ab13f235b18c0297b1e987185e2b27d9975999")
    (tokenName "TokenName")

myTrace :: EmulatorTrace ()
myTrace = Prelude.undefined
