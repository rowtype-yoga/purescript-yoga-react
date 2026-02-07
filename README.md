# purescript-yoga-react

A thin wrapper over `react-basic-hooks` that provides a simplified API for creating React components without Effect boilerplate.

## Installation

```bash
spago install yoga-react
```

## Usage

```purescript
import Yoga.React (component)

-- Create a component at the top-level
myButton :: { label :: String, onClick :: Effect Unit } -> JSX
myButton = component "MyButton" \props -> React.do
  pure $ button { onClick: props.onClick } [ text props.label ]
```

## API

### `component`

```purescript
component
  :: forall hooks props
   . String
  -> (props -> Hooks.Render Unit hooks JSX)
  -> (props -> JSX)
```

Creates a component using `unsafePerformEffect` internally. This is safe **only** when used at the top-level as a module-level binding.

**⚠️ IMPORTANT:** Never use this inside functions or other components. The `purslint` linter has a rule to catch this mistake.

### Safe usage ✅

```purescript
-- Top-level binding
greeting = component "Greeting" \props -> React.do
  pure $ div {} [ text $ "Hello " <> props.name ]
```

### Unsafe usage ❌

```purescript
-- Inside a function - will break React!
makeComponent name = 
  component name \_ -> pure mempty  -- ERROR: purslint will catch this
```

## Why?

Creating components with `react-basic-hooks` requires wrapping in `Effect`:

```purescript
-- Traditional approach
myComp :: Effect ({ } -> JSX)
myComp = Hooks.component "MyComp" \props -> React.do
  pure $ text "Hello"

-- Then you need to run the Effect somewhere
main = do
  comp <- myComp
  -- ...
```

With `yoga-react`:

```purescript
-- Simplified approach
myComp :: { } -> JSX
myComp = component "MyComp" \props -> React.do
  pure $ text "Hello"

-- Use it directly, no Effect to run
```

This is safe because React components should only be created once at module initialization time anyway.

## License

WTFPL
