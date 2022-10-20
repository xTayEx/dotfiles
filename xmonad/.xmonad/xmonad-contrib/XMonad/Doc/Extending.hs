{-# LANGUAGE CPP #-}
-- We need to link to the current version of xmonad-docs, but both
-- CURRENT_PACKAGE_VERSION and VERSION_xmonad_contrib contain quotation marks
-- that we can't get rid of using CPP, so as a workaround we define the
-- components separately in cpp-options and check that they're still in sync.
#if !__HLINT__ && \
    !( MIN_VERSION_xmonad_contrib(XMONAD_CONTRIB_VERSION_MAJOR, XMONAD_CONTRIB_VERSION_MINOR, XMONAD_CONTRIB_VERSION_PATCH) \
    && !MIN_VERSION_xmonad_contrib(XMONAD_CONTRIB_VERSION_MAJOR, XMONAD_CONTRIB_VERSION_MINOR, XMONAD_CONTRIB_VERSION_PATCH + 1) \
    )
#error "Please update XMONAD_CONTRIB_VERSION_* in xmonad-contrib.cabal"
#endif

-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Doc.Extending
-- Description :  A module to document the xmonad-contrib library.
-- Copyright   :  (C) 2007 Andrea Rossato
-- License     :  BSD3
--
-- Maintainer  :  andrea.rossato@unibz.it
-- Stability   :  unstable
-- Portability :  portable
--
-- This module documents the xmonad-contrib library and guides you
-- through some more advanced parts of extending the capabilities of
-- xmonad.  If you're new to xmonad, you should first check out the
-- <https://xmonad.org/TUTORIAL.html tutorial> and treat this document
-- as supplemental reading.
--
-- Knowing Haskell is by no means a prerequisite for configuring xmonad
-- and the tutorial emphasizes this.  This document, however, does
-- assume a basic familiarity with the language.  This is so that we can
-- dive a bit deeper into what the different hooks do, or how to write
-- our own little functions to configure xmonad.
--
-- Those wishing to be totally hardcore and develop their own xmonad
-- extensions (it's easier than it sounds, we promise!) should read the
-- documentation in "XMonad.Doc.Developing".
--
-- More configuration examples can be found
-- <https://xmonad.org/TUTORIAL.html#closing-thoughts here>.
--
-----------------------------------------------------------------------------

module XMonad.Doc.Extending
    (
    -- * The xmonad-contrib library
    -- $library

    -- ** Actions
    -- $actions

    -- ** Hooks
    -- $hooks

    -- ** Layouts
    -- $layouts

    -- ** Prompts
    -- $prompts

    -- ** Utilities
    -- $utils

    -- * Extending xmonad
    -- $extending

    -- ** Adding key bindings
    -- $keys

    -- *** Removing key bindings
    -- $keyDel

    -- ** Editing mouse bindings
    -- $mouse

    -- ** Editing the layout hook #LayoutHook#
    -- $layoutHook

    -- ** Editing the manage hook #ManageHook#
    -- $manageHook

    ) where

--------------------------------------------------------------------------------
--
--  The XmonadContrib Library
--
--------------------------------------------------------------------------------

{- $library

The xmonad-contrib library is a set of extension modules contributed
by xmonad hackers and users that provide additional features to
xmonad.  Examples include various layout modes (tabbed, spiral,
three-column...), prompts, program launchers, the ability to
manipulate windows and workspaces in various ways, alternate
navigation modes, and much more.  There are also \"meta-modules\"
which make it easier to write new modules and extensions.

This is a description of the different namespaces in xmonad-contrib.
For more information about any particular module, go to the root of
the documentation and just click on its name to view its Haddock
documentation; each module should come with extensive documentation.
If you find a module that could be better documented, or has incorrect
documentation, please
<https://github.com/xmonad/xmonad-contrib/issues report it as a bug>!

First and foremost, xmonad defines its own prelude for commonly used
functions, as well as re-exports from @base@.

* "XMonad.Prelude":
    Utility functions and re-exports for a more ergonomic developing
    experience.

There are also other documentation modules, showing you around
individual parts of xmonad:

* "XMonad.Doc.Configuring":
    Brief tutorial that will teach you how to create a basic
    xmonad configuration.

* "XMonad.Doc.Developing":
    A brief overview of xmonad's internals.

A list of the contrib modules can be found at
<https://xmonad.github.io/xmonad-docs/xmonad-contrib-XMONAD_CONTRIB_VERSION_MAJOR.XMONAD_CONTRIB_VERSION_MINOR.XMONAD_CONTRIB_VERSION_PATCH/>
-}

{- $actions

In the @XMonad.Actions@ namespace you can find modules exporting
various functions that are usually intended to be bound to key
combinations or mouse actions, in order to provide functionality
beyond the standard keybindings offered by xmonad.

-}

{- $hooks

In the @XMonad.Hooks@ namespace you can find modules exporting
hooks—actions that xmonad performs when certain events occur.
The three most important hooks are:

* 'XMonad.Core.manageHook': this hook is called when a new window that
  xmonad must take care of is created. This is a very powerful hook,
  since it lets us examine the new window's properties and act
  accordingly. For instance, we can configure xmonad to put windows
  belonging to a given application in the float layer, not to manage
  dock applications, or open them in a given workspace. See [Editing the
  manage hook](#g:Editing_the_manage_hook) for more information on
  customizing 'XMonad.Core.manageHook'.

* 'XMonad.Core.logHook': this hook is called when the stack of windows
  managed by xmonad changes; for example, this is invoked at the end of
  the 'XMonad.Operations.windows' function. A big application for this
  is to display some information about xmonad in a status bar. The aptly
  named "XMonad.Hooks.StatusBar" will produce a string (whose format can
  be configured) to be written, for example, to an X11 property.

* 'XMonad.Core.handleEventHook': this hook is called on all events handled
  by xmonad, thus it is extremely powerful. See "Graphics.X11.Xlib.Extras"
  and xmonad source and development documentation for more details.

-}

{- $layouts

In the @XMonad.Layout@ namespace you can find modules exporting
contributed layout algorithms, such as a tabbed layout, a circle, a spiral,
three columns, and so on.

You will also find modules which provide facilities for combining
different layouts, such as "XMonad.Layout.Combo", "XMonad.Layout.ComboP",
"XMonad.Layout.LayoutBuilder", "XMonad.Layout.SubLayouts", or
"XMonad.Layout.LayoutCombinators".

Layouts can be also modified with layout modifiers. A general
interface for writing layout modifiers is implemented in
"XMonad.Layout.LayoutModifier".

For more information on using those modules for customizing your
'XMonad.Core.layoutHook' see [Editing the layout hook](#g:LayoutHook).

-}

{- $prompts

In the @XMonad.Prompt@ namespace you can find modules providing
graphical prompts for getting user input and using it to perform
various actions.

The "XMonad.Prompt" module provides a library for easily writing new
prompts.

-}

{- $utils

In the @XMonad.Util@ namespace you can find modules exporting various
utility functions that are used by the other modules of the
@xmonad-contrib@ library.

There are also utilities for helping in configuring xmonad or using
external utilities.

-}

--------------------------------------------------------------------------------
--
--  Extending Xmonad
--
--------------------------------------------------------------------------------

{- $extending
#Extending_xmonad#

Since the @xmonad.hs@ file is just another Haskell program, you may
import and use any Haskell code or libraries you wish, such as
extensions from the xmonad-contrib library, or other code you write
yourself.

-}

{- $keys

In the
<https://github.com/xmonad/xmonad/blob/master/TUTORIAL.md#customizing-xmonad customization section>
of the tutorial we have seen how to add new keys to xmonad with the help
of the 'XMonad.Util.EZConfig.additionalKeysP' function.  But how does
that work?  Assuming that library didn't exist yet, could we write it
ourselves?

Let's concentrate on the easier case of trying to write our own
'XMonad.Util.EZConfig.additionalKeys'.  This works exactly like its
almost-namesake, but requires you to specify the keys in the "default"
style—that is:

> main :: IO ()
> main = xmonad $ def
>   `additionalKeys`
>     [ ((mod1Mask, xK_m        ), spawn "echo 'Hi, mom!' | dzen2 -p 4")
>     , ((mod1Mask, xK_BackSpace), spawn "xterm")
>     ]

The extra work that 'XMonad.Util.EZConfig.additionalKeysP' does is only
in parsing the input string (turning @"M1-m"@ into @(mod1Mask, xK_m)@).
As we have seen in the tutorial, is also allows one to write @M@ and
have xmonad pick up on the correct modifier key to use—something which
'XMonad.Util.EZConfig.additionalKeys' can't do.

Editing key bindings means changing the 'XMonad.Core.keys' field of the
'XMonad.Core.XConfig' record used by xmonad.  For example, to override
/all/ of the default bindings with our own, we would write

> import XMonad
> import Data.Map (Map)
> import qualified Data.Map as Map
>
> main :: IO ()
> main = xmonad $ def { keys = myKeys }
>  where
>   myKeys :: XConfig l -> Map (ButtonMask, KeySym) (X ())
>   myKeys conf = Map.fromList
>     [ ((mod1Mask    , xK_m        ), spawn "echo 'Hi, mom!' | dzen2 -p 4")
>     , ((modMask conf, xK_BackSpace), spawn "xterm")
>     ]

Now, obviously we don't want to do that; we only want to add to existing
bindings (or, perhaps, override some of them with our own).  Let's break
@myKeys@ down a little.  You can think of the type signature of @myKeys@
(and hence also of @keys@) like this:

>    myKeys :: UserConfig -> Map KeyPress Action

It takes some user config and, from that, produces a map that associates
certain keypresses with actions to execute.  The reason why it might
take the user config may seem a bit mysterious at first, but it is for
the simple reason that some keybindings (like the workspace switching
ones) need access to the user config.  We have already seen this above
when we queried @modMask conf@.  If it helps, think of this as a
@Reader@ monad with the config being the read-only state.

This means that, as a first guess, the type signature of our version of
'XMonad.Util.EZConfig.additionalKeys' might look like

> myAdditionalKeys :: XConfig l
>                     -- ^ Base config with xmonad's default keybindings
>                  -> (XConfig l -> Map (ButtonMask, KeySym) (X ()))
>                     -- ^ User supplied keybindings
>                  -> XConfig l
>                     -- ^ Resulting config with everything merged together

However, even assuming a correct implementation, using this is not very
ergonomic:

> main = xmonad $ def
>  `myAdditionalKeys`
>    (\conf -> Map.fromList
>      [ ((mod1Mask    , xK_m        ), spawn "echo 'Hi, mom!' | dzen2 -p 4")
>      , ((modMask conf, xK_BackSpace), spawn "xterm")
>      ])

Having to specify a lambda with parentheses and call
'Data.Map.Strict.fromList' does not make for a good user experience.
Since one /always/ has to call that function anyways, we may well just
accept a list from the user and transform it to a map ourselves.  As an
additional simplification, how about we don't care about the config
argument at all and simply ask the user for a list?  The resulting
signature

> myAdditionalKeys :: XConfig l
>                  -> [(ButtonMask, KeySym), (X ())]
>                  -> XConfig l

looks exactly like what we want!  Note that this is also the time we
lose the ability to automagically fill in the correct modifier key,
since the input to @myAdditionalKeys@ is already structured data (as
opposed to just some strings that need to be parsed).

Now that we know what kind of data structure—that is, maps—we are
dealing with, the implementation of this function simply merges the two
together, preferring the user config to xmonad's defaults in case of any
conflicts.  Thankfully, someone else has already done the hard work and
written the merging function for us; it's called
'Data.Map.Strict.union'.

What's left is essentially playing "type tetris":

> myAdditionalKeys baseConf keyList =
>   let mergeKeylist conf = Map.fromList keyList `Map.union` (keys baseConf) conf
>    in baseConf { keys = mergeKeylist }

The function @mergeKeyList@ take some user config, transforms the custom
keybindings into a map (@Map.fromList keyList@), gets the keys from the
base config (remember @keys baseConf@ is again a function, morally of
type @UserConfig -> Map KeyPress Action@, and so we have to apply @conf@
to it in order to get a map!), and then merges these two maps together.
Since @mergeKeylist@ now has exactly the right type signature, we can
just set that as the keys.

If you like operators, 'Data.Monoid.<>' (or xmonad's alias for it,
'XMonad.ManageHook.<+>') does exactly the same as the explicit usage of
'Data.Map.Strict.union' because that's the specified binary operation in
the 'Data.Monoid.Monoid' instance for 'Data.Map.Strict.Map'.  Note that
the function works as expected (preferring user defined keys) because
'Data.Map.union' is /left biased/, which means that if the same key is
present in both maps it will prefer the associated value of the left
map.

Our function now works as expected:

> main :: IO ()
> main = xmonad $ def
>   `myAdditionalKeys`
>     [ ((mod1Mask, xK_m        ), spawn "echo 'Hi, mom!' | dzen2 -p 4")
>     , ((mod1Mask, xK_BackSpace), spawn "xterm")
>     ]

Lastly, if you want you can also emulate the automatic modifier
detection by 'XMonad.Util.EZConfig.additionalKeysP' by defining the bulk
of your config as a separate function

> myConfig = def { modMask = mod4Mask }

and then using that information

> main :: IO ()
> main = xmonad $ myConfig
>   `myAdditionalKeys`
>     [ ((mod, xK_m        ), spawn "echo 'Hi, mom!' | dzen2 -p 4")
>     , ((mod, xK_BackSpace), spawn "xterm")
>     ]
>  where mod = modMask myConfig

Hopefully you now feel well equipped to write some small functions that
extend xmonad an scratch a particular itch!

 -}

{- $keyDel
#Removing_key_bindings#

As we've learned, XMonad stores keybindings inside of a
'Data.Map.Strict.Map', which means that removing keybindings requires
modifying it.  This can be done with 'Data.Map.difference' or with
'Data.Map.Strict.delete'.

For example, suppose you want to entirely rid yourself of @"M-q"@ and
@"M-s-q"@ (you just want to leave xmonad running forever).  To do this
with bare @xmonad@, you need to define @newKeys@ as a
'Data.Map.Strict.difference' between the default map and the map of the
key bindings you want to remove.  Like so:

> newKeys :: XConfig l -> Map (KeyMask, KeySym) (X ())
> newKeys x = keys def x `M.difference` keysToRemove x
>
> keysToRemove :: XConfig l -> Map (KeyMask, KeySym) (X ())
> keysToRemove x = M.fromList
>          [ ((modm              , xK_q ), return ())
>          , ((modm .|. shiftMask, xK_q ), return ())
>          ]

As you can see, it doesn't matter what actions we associate with the
keys listed in @keysToRemove@, so we just use @return ()@ (the \"null\"
action).  Since @newKeys@ contains all of the default keys, you can
simply pass it to 'XMonad.Core.XConfig' as your map of keybindings:

> main :: IO ()
> main = xmonad $ def { keys = newKeys }

However, having to manually type @return ()@ every time seems like a
drag, doesn't it?  And this approach isn't at all compatible with adding
custom keybindings via 'XMonad.Util.EZConfig.additionalKeysP'!  Well,
good thing "XMonad.Util.EZConfig" also sports
'XMonad.Util.EZConfig.removeKeysP'.  You can use it as you would expect.

> main :: IO ()
> main = xmonad $ def
>   { … }
>  `removeKeysP` ["M-q", "M-S-q"]

Can you guess how 'XMonad.Util.EZConfig.removeKeysP' works?  It's almost
the same code we wrote above, just accepting a list of keybindings.  Try
to see if you can come up with an implementation of

> removeKeysP :: XConfig l -> [String] -> XConfig l

If you're done, just click on @# Source@ when viewing the
'XMonad.Util.EZConfig.removeKeysP' documentation (did you know that
Haddock lets you do that for every function?) and compare.

By the way, one can conveniently combine
'XMonad.Util.EZConfig.additionalKeysP' and
'XMonad.Util.EZConfig.removeKeysP' by just intuitively chaining them:

> main :: IO ()
> main = xmonad $ def
>   { … }
>  `additionalKeysP myKeys
>  `removeKeysP`    ["M-q", "M-S-q"]

If you don't use the @P@ alternatives of EZConfig, there is also an
aptly named 'XMonad.Util.EZConfig.removeKeys'.  Again, can you try to
come up with an implementation yourself that has the correct signature?

> removeKeys :: XConfig a -> [(KeyMask, KeySym)] -> XConfig a

In addition to 'Data.Map.Strict.delete', you will probably need to use
'foldr'.

-}

{- $mouse
#Editing_mouse_bindings#

Most of the previous discussion of key bindings applies to mouse
bindings as well.  For example, you could configure button4 to close
the window you click on like so:

>    import qualified Data.Map as M
>
>    myMouse x  = [ (0, button4), (\w -> focus w >> kill) ]
>
>    newMouse x = M.union (mouseBindings def x) (M.fromList (myMouse x))
>
>    main = xmonad $ def { ..., mouseBindings = newMouse, ... }

Overriding or deleting mouse bindings works similarly.  You can also
configure mouse bindings much more easily using the
'XMonad.Util.EZConfig.additionalMouseBindings' and
'XMonad.Util.EZConfig.removeMouseBindings' functions from the
"XMonad.Util.EZConfig" module.

-}

{- $layoutHook
#Editing_the_layout_hook#

When you start an application that opens a new window, when you change
the focused window, or move it to another workspace, or change that
workspace's layout, xmonad will use the 'XMonad.Core.layoutHook' for
reordering the visible windows on the visible workspace(s).

Since different layouts may be attached to different workspaces, and
you can change them, xmonad needs to know which one to use. In this
sense the layoutHook may be thought as the list of layouts that
xmonad will use for laying out windows on the screen(s).

The problem is that the layout subsystem is implemented with an
advanced feature of the Haskell programming language: type classes.
This allows us to very easily write new layouts, combine or modify
existing layouts, create layouts with internal state, etc. This
means that we cannot simply have a list of layouts: a list requires
every member to belong to the same type!

Instead the combination of layouts to be used by xmonad is created
with a specific layout combinator: 'XMonad.Layout.|||'.

Suppose we want a list with the 'XMonad.Layout.Full',
'XMonad.Layout.Tabbed.tabbed' and
'XMonad.Layout.Accordion.Accordion' layouts. First we import, in our
@~\/.xmonad\/xmonad.hs@, all the needed modules:

>    import XMonad
>
>    import XMonad.Layout.Tabbed
>    import XMonad.Layout.Accordion

Then we create the combination of layouts we need:

>    mylayoutHook = Full ||| tabbed shrinkText def ||| Accordion


Now, all we need to do is change the 'XMonad.Core.layoutHook'
field of the 'XMonad.Core.XConfig' record, like so:

>    main = xmonad $ def { layoutHook = mylayoutHook }

Thanks to the new combinator, we can apply a layout modifier to a
whole combination of layouts, instead of applying it to each one. For
example, suppose we want to use the
'XMonad.Layout.NoBorders.noBorders' layout modifier, from the
"XMonad.Layout.NoBorders" module (which must be imported):

>    mylayoutHook = noBorders (Full ||| tabbed shrinkText def ||| Accordion)

If we want only the tabbed layout without borders, then we may write:

>    mylayoutHook = Full ||| noBorders (tabbed shrinkText def) ||| Accordion

Our @~\/.xmonad\/xmonad.hs@ will now look like this:

>    import XMonad
>
>    import XMonad.Layout.Tabbed
>    import XMonad.Layout.Accordion
>    import XMonad.Layout.NoBorders
>
>    mylayoutHook = Full ||| noBorders (tabbed shrinkText def) ||| Accordion
>
>    main = xmonad $ def { layoutHook = mylayoutHook }

That's it!

-}

{- $manageHook
#Editing_the_manage_hook#

The 'XMonad.Core.manageHook' is a very powerful tool for customizing
the behavior of xmonad with regard to new windows.  Whenever a new
window is created, xmonad calls the 'XMonad.Core.manageHook', which
can thus be used to perform certain actions on the new window, such as
placing it in a specific workspace, ignoring it, or placing it in the
float layer.

The default 'XMonad.Core.manageHook' causes xmonad to float MPlayer
and Gimp, and to ignore gnome-panel, desktop_window, kicker, and
kdesktop.

The "XMonad.ManageHook" module provides some simple combinators that
can be used to alter the 'XMonad.Core.manageHook' by replacing or adding
to the default actions.

Let's start by analyzing the default 'XMonad.Config.manageHook', defined
in "XMonad.Config":


>    manageHook :: ManageHook
>    manageHook = composeAll
>                    [ className =? "MPlayer"        --> doFloat
>                    , className =? "Gimp"           --> doFloat
>                    , resource  =? "desktop_window" --> doIgnore
>                    , resource  =? "kdesktop"       --> doIgnore ]

'XMonad.ManageHook.composeAll' can be used to compose a list of
different 'XMonad.Config.ManageHook's. In this example we have a list
of 'XMonad.Config.ManageHook's formed by the following commands: the
Mplayer's and the Gimp's windows, whose 'XMonad.ManageHook.className'
are, respectively \"Mplayer\" and \"Gimp\", are to be placed in the
float layer with the 'XMonad.ManageHook.doFloat' function; the windows
whose resource names are respectively \"desktop_window\" and
\kdesktop\" are to be ignored with the 'XMonad.ManageHook.doIgnore'
function.

This is another example of 'XMonad.Config.manageHook', taken from
"XMonad.Config.Arossato":

>    myManageHook  = composeAll [ resource =? "realplay.bin" --> doFloat
>                               , resource =? "win"          --> doF (W.shift "doc") -- xpdf
>                               , resource =? "firefox-bin"  --> doF (W.shift "web")
>                               ]
>    newManageHook = myManageHook <> manageHook def


Again we use 'XMonad.ManageHook.composeAll' to compose a list of
different 'XMonad.Config.ManageHook's. The first one will put
RealPlayer on the float layer, the second one will put the xpdf
windows in the workspace named \"doc\", with 'XMonad.ManageHook.doF'
and 'XMonad.StackSet.shift' functions, and the third one will put all
firefox windows on the workspace called "web". Then we use the
'<>' combinator to compose @myManageHook@ with the
default 'XMonad.Config.manageHook' to form @newManageHook@.

Each 'XMonad.Config.ManageHook' has the form:

>    property =? match --> action

Where @property@ can be:

* 'XMonad.ManageHook.title': the window's title

* 'XMonad.ManageHook.resource': the resource name

* 'XMonad.ManageHook.className': the resource class name.

* 'XMonad.ManageHook.stringProperty' @somestring@: the contents of the
  property @somestring@.

(You can retrieve the needed information using the X utility named
@xprop@; for example, to find the resource class name, you can type

> xprop | grep WM_CLASS

at a prompt, then click on the window whose resource class you want to
know.)

@match@ is the string that will match the property value (for instance
the one you retrieved with @xprop@).

An  @action@ can be:

* 'XMonad.ManageHook.doFloat': to place the window in the float layer;

* 'XMonad.ManageHook.doIgnore': to ignore the window;

* 'XMonad.ManageHook.doF': to execute a function with the window as
  argument.

For example, suppose we want to add a 'XMonad.Config.manageHook' to
float RealPlayer, which usually has a 'XMonad.ManageHook.resource'
name of \"realplay.bin\".

First we need to import "XMonad.ManageHook":

>    import XMonad.ManageHook

Then we create our own 'XMonad.Config.manageHook':

>    myManageHook = resource =? "realplay.bin" --> doFloat

We can now use the '<>' combinator to add our
'XMonad.Config.manageHook' to the default one:

>    newManageHook = myManageHook <> manageHook def

(Of course, if we wanted to completely replace the default
'XMonad.Config.manageHook', this step would not be necessary.) Now,
all we need to do is change the 'XMonad.Core.manageHook' field of the
'XMonad.Core.XConfig' record, like so:

>    main = xmonad def { ..., manageHook = newManageHook, ... }

And we are done.

Obviously, we may wish to add more then one
'XMonad.Config.manageHook'. In this case we can use a list of hooks,
compose them all with 'XMonad.ManageHook.composeAll', and add the
composed to the default one.

For instance, if we want RealPlayer to float and thunderbird always
opened in the workspace named "mail", we can do so like this:

>    myManageHook = composeAll [ resource =? "realplay.bin"    --> doFloat
>                              , resource =? "thunderbird-bin" --> doF (W.shift "mail")
>                              ]

Remember to import the module that defines the 'XMonad.StackSet.shift'
function, "XMonad.StackSet", like this:

>    import qualified XMonad.StackSet as W

And then we can add @myManageHook@ to the default one to create
@newManageHook@ as we did in the previous example.

One more thing to note about this system is that if
a window matches multiple rules in a 'XMonad.Config.manageHook', /all/
of the corresponding actions will be run (in the order in which they
are defined).  An alternative version where only the first rule that
matches is run is available as 'XMonad.Hooks.ManageHelpers.composeOne'.

For additional rules and actions you can use in your manageHook, check
out the contrib module "XMonad.Hooks.ManageHelpers".

-}
