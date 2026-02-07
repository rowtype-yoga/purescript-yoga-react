module Yoga.React
  ( component
  ) where

import Prelude

import Effect.Unsafe (unsafePerformEffect)
import React.Basic (JSX)
import React.Basic.Hooks as Hooks

-- | Create a component at the top-level using `unsafePerformEffect`.
-- | This should ONLY be used for top-level component definitions where
-- | the component is defined as a module-level constant.
-- |
-- | IMPORTANT: Using this function inside another function or component
-- | will lead to bugs as the component will be recreated on every call,
-- | breaking React's identity and losing state. The purslint linter
-- | should be configured to error on non-top-level usage.
-- |
-- | Safe usage:
-- | ```
-- | import Yoga.React (component)
-- | 
-- | myComponent :: { label :: String } -> JSX
-- | myComponent = component "MyComponent" \props -> React.do
-- |   pure $ text props.label
-- | ```
-- |
-- | Unsafe usage (will be caught by purslint):
-- | ```
-- | someFunction = do
-- |   let comp = component "Bad" \_ -> pure mempty  -- ERROR!
-- |   pure comp
-- | ```
component
  :: forall hooks props
   . String
  -> (props -> Hooks.Render Unit hooks JSX)
  -> (props -> JSX)
component name renderFn =
  unsafePerformEffect (Hooks.component name renderFn)
