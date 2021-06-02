--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "pages/*/commentary/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/chapter.html" defaultContext
            >>= relativizeUrls

    match "pages/**" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "CONTRIBUTE.markdown" $ do
      route $ setExtension ".html"
      compile $ pandocCompiler
          >>= loadAndApplyTemplate "templates/page.html" defaultContext
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    match "blame/commentary.html" $ do
      route idRoute
      compile $ do
        chapters <- loadAll "commentary/*"
        let indexCtx =
                listField "chapters" defaultContext (return chapters) <>
                defaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= loadAndApplyTemplate "templates/commentary.html" indexCtx
          >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            mangas <- loadAll "pages/*"
            let indexCtx =
                    listField "mangas" defaultContext (return mangas) `mappend`
                    constField "title" "Home" `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

