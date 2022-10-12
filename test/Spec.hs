import qualified Spec.DepositTrace as DepositTrace
import           Test.Tasty

main :: IO ()
main = do
  defaultMain $ testGroup "Test"
    [ DepositTrace.tests
    ]
