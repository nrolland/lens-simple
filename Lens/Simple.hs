{-# LANGUAGE CPP #-}
{-# LANGUAGE RankNTypes #-}

module Lens.Simple
  ( -- * The fundamental lens operations: @view@, @set@ and @over@
    view,
    set,
    over,

    -- * Stock lenses (@_1@, @_2@) and mere traversals (@_Left@, @_Right@, @_Just@, etc.) for simple Prelude types
    _1,
    _2,
    left_,
    right_,
    just_,
    nothing_,
    both,

    -- * @LensLike@ and important strength-expressing synonyms, from the all-powerful @Lens@ downward
    Lens,
    Traversal,
    Setter,
    Getter,
    Fold,
    FoldLike,
    SetterLike,
    LensLike,

    -- * Support for defining lenses and weaker \'optics\' (see also the TH incantations below )
    lens,
    to,
    setting,
    folding,

    -- * Operator equivalents for common lens-applying operators: particularly @(^.)@, @(.~)@ and @(%~)@ (i.e. @view@, @set@ and @over@)
    (^.),
    (%~),
    (.~),
    (&),
    (??),
    (?~),
    (^..),
    (^?),

    -- * Basic state-related combinators: @zoom@, @use@, @assign\/(.=)@ etc.
    zoom,
    use,
    uses,
    assign,

    -- * Convenient state-related operators
    (%=),
    (.=),
    (%%=),
    (<~),

    -- * Pseudo-imperatives
    (+~),
    (*~),
    (-~),
    (//~),
    (&&~),
    (||~),
    (<>~),

    -- * Corresponding state-related imperatives
    (+=),
    (-=),
    (*=),
    (//=),
    (&&=),
    (||=),
    (<>=),

    -- * More stock lenses
    chosen,
    ix,
    at,
    intAt,
    contains,
    intContains,

    -- * More stock traversals
    ignored,

    -- * More stock setters
    mapped,

    -- * Other combinators
    views,
    toListOf,
    allOf,
    anyOf,
    firstOf,
    lastOf,
    sumOf,
    productOf,
    lengthOf,
    nullOf,
    backwards,
    choosing,
    alongside,
    beside,

    -- * TH incantations
    makeLenses,
    makeTraversals,
    makeLensesBy,
    makeLensesFor,

    -- * Other type synonyms
    LensLike',
    Lens',
    Traversal',
    Getter',
    Setter',
    FoldLike',
    ASetter',
    ASetter,

    -- * Helper classes
    Identical (..),
    Phantom (..),

    -- * Helper types
    AlongsideLeft,
    AlongsideRight,
    Zooming,

    -- * Re-exports
    Constant (..),
    Identity (..),
    Monoid (..),
    (<>),
  )
where

import Control.Monad.State.Strict
import Control.Monad.Trans.State.Strict (StateT (..))
import Data.Functor.Constant
import Data.Functor.Identity
import Data.Monoid
import Lens.Family (ASetter, ASetter', over)
import Lens.Family2.State.Strict
import Lens.Family2.Stock
import Lens.Family2.TH (makeLenses, makeLensesBy, makeLensesFor, makeTraversals)
import Lens.Family2.Unchecked
#if MIN_VERSION_base(4,8,0)
import Data.Function ((&))
import Lens.Family2 hiding ((&), over)
#else
import Lens.Family2 hiding (over)
#endif

infixl 1 ??

-- | Generalized infix flip, replicating @Control.Lens.Lens.??@
--
-- >>>  execStateT ?? (0,"") $ do _1 += 1; _1 += 1; _2 <>= "hello"
-- (2,"hello")
(??) :: (Functor f) => f (a -> b) -> a -> f b
ff ?? a = fmap ($ a) ff
{-# INLINE (??) #-}

type SetterLike a a' b b' = LensLike Identity a a' b b'

(?~) :: Setter a a' b (Maybe b') -> b' -> a -> a'
l ?~ b = set l (Just b)
