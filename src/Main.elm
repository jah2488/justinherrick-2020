module Main exposing (Direction(..), Flags, Model, Msg(..), Page(..), Post, State(..), Talk, aboutSection, allPosts, allTalks, bio, currentSection, headerSection, init, main, mobileSize, notFoundSection, pageFromUrl, pageView, postSection, postView, previousSection, talkView, talksSection, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, article, div, em, h1, h2, h3, header, main_, p, span, text)
import Html.Attributes exposing (class, datetime, href, rel, target)
import Url
import Utils exposing (Content(..), date, dynamicStyle, section)


type Direction
    = Opening
    | Closing


type State
    = Open
    | Closed
    | Transitioning Direction


type Page
    = Home
    | About
    | Projects
    | Posts
    | Talks
    | NotFound


type alias Talk =
    { title : String
    , date : String
    , description : List (Content Msg)
    }


type alias Post =
    { title : String
    , date : String
    , body : List String
    }


type alias Flags =
    { width : Float
    , seeds : ( Float, Float, Float )
    }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , about : State
    , seeds : ( Float, Float, Float )
    , page : Page
    }


mobileSize : Float
mobileSize =
    550


pageFromUrl : String -> Page
pageFromUrl path =
    case path of
        "/" ->
            Home

        "/about" ->
            About

        "/projects" ->
            Projects

        "/posts" ->
            Posts

        "/talks" ->
            Talks

        _ ->
            NotFound


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , url = url
      , seeds = flags.seeds
      , page = pageFromUrl url.path
      , about = Open
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest
    | Toggle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url, page = pageFromUrl url.path }
            , Cmd.none
            )

        Toggle ->
            ( { model
                | about =
                    if model.about == Open then
                        Closed

                    else
                        Open
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


headerSection : Model -> Html Msg
headerSection model =
    header [] [ h1 [] [ a [ href "/" ] [ text "Justin Herrick" ] ], bio ]


bio : Html Msg
bio =
    div [ class "bio-wrapper" ]
        [ div [ class "bio-short flex" ]
            [ div [ class "bio-avatar" ] []
            , div [ class "bio-about" ]
                [ p []
                    [ text "Hey 👋🏻, "
                    , a [ href "/about" ] [ text "I'm Justin." ]
                    , text " I am a Project Director, Software Consultant, Educator, "
                    , a [ href "/talks" ] [ text " Speaker" ]
                    , text ", Entreprenuer, Home Chef, and Cat Parent, currently living in "
                    , a [ href "" ] [ text "Chicago, IL" ]
                    , text ". "
                    ]
                , p [] [ text "You can get in touch with me at: ", a [] [ span [] [ text "justin" ], em [] [ text "@" ], span [] [ text "justinherrick.com" ] ] ]
                , p [] [ text "You can also find me on ", a [ href "https://twitter.com/jah2488", target "_blank", rel "noreferrer noopener" ] [ text "Twitter" ], text " and on ", a [ href "https://instagram.com/jah2488", target "_blank", rel "noopener noreferrer" ] [ text "Instagram" ], text "." ]
                ]
            ]
        ]


currentSection : Html Msg
currentSection =
    section "Currently"
        [ Markup
            [ text "I left "
            , a [ href "https://github.com" ] [ text "GitHub" ]
            , text " in July of 2025 and I am currently doing contracting and consulting, returning to my roots to help people and companies succeed in the world of AI, big corporations, and ever shifting demands."
            ]
        , Text "I am spending lots of time renovating my Chicago style bungalow house that I have recently purchased, and spending time learning pottery."
        ]


previousSection : Html Msg
previousSection =
    section "Previously"
        [ Markup
            [ text "I spent several years at "
            , a [ href "https://github.com" ] [ text "GitHub" ]
            , text ", first as a staff manager of the entire pull request team, and eventually as a staff engineer on the much larger Pull Requests department. I worked on and was instrumental to the success of projects such as Merge Queue and Copilot Code Review for PRs."
            ]
        , Text "I was writing a book! After the story of Lunar Collective came to a close, it was time to write down all of the ups, downs, and learning experiences that came out of that process. It was going to be the book I wish I had before I started. Unfortunately, the book was never written due to all the happenings of 2020 and the years after."
        , Markup
            [ text "Previously, I was a Project Director for the "
            , a [ href "https://8thlight.com/locations/austin/" ] [ text "8th Light Austin" ]
            , text " office. I helped companies and teams get projects to market and provided expert help."
            ]
        , Markup [ text "I founded ", a [ href "https://lunarcollective.co" ] [ text "Lunar Collective" ], text " in 2016 to see what a modern Software Consultancy could be when it focused on education and empathy with its clients and with its team members.", text "I spent 4 years building a consultancy that would go on to have half a dozen amazing employees, deliver quality software used by millions of people, and have a pretty cool office as well." ]
        , Text "I spent several years teaching full time at a bootcamp called The Iron Yard as a lead instructor, helping to shape curriculum and processes for the company as a whole while teaching students and helping them to achieve their goals. I played a small part in helping nearly a hundred students navigate their first steps into the tech industry and I'll be forever grateful for that experience."
        ]


talksSection : List Talk -> Html Msg
talksSection talks =
    div [ class "section" ] [ h2 [] [ text "Talks, Podcasts, Etc" ], div [] <| List.map talkView talks ]


talkView : Talk -> Html Msg
talkView post =
    article []
        [ header []
            [ h3 [] [ text post.title, date [ datetime post.date ] [ text post.date ] ] ]
        , div
            []
          <|
            List.map
                (\paragraph ->
                    p []
                        [ case paragraph of
                            Text str ->
                                text str

                            Markup html ->
                                div [] html
                        ]
                )
                post.description
        ]


postSection : List Post -> Html Msg
postSection posts =
    div [ class "section posts" ] [ h2 [] [ text "Writings" ], div [] <| List.map postView posts ]


postView : Post -> Html Msg
postView post =
    article []
        [ header []
            [ h3 [] [ text post.title ]
            , date [ datetime post.date ] [ text post.date ]
            ]
        , div
            []
          <|
            List.map (\paragraph -> p [] [ text paragraph ]) post.body
        ]


aboutSection : Html Msg
aboutSection =
    section "About" [ Text "hi" ]


notFoundSection : Html Msg
notFoundSection =
    section "Nothing here" []


pageView : Page -> List (Html Msg)
pageView page =
    case page of
        Home ->
            [ currentSection
            , previousSection
            , postSection allPosts
            ]

        About ->
            [ aboutSection
            , currentSection
            , previousSection
            , talksSection allTalks
            ]

        Projects ->
            [ currentSection
            , previousSection
            ]

        Posts ->
            [ postSection allPosts
            , currentSection
            ]

        Talks ->
            [ talksSection allTalks
            , previousSection
            , currentSection
            ]

        NotFound ->
            [ notFoundSection
            , postSection allPosts
            ]


view : Model -> Browser.Document Msg
view model =
    { title = "Justin Herrick"
    , body =
        [ div [ class "frame" ] []
        , div [ class "wrapper" ]
            [ div [ class "content" ] <|
                [ headerSection model
                , if model.url.path /= "/" then
                    a [ href "/" ] [ text "⬅" ]

                  else
                    text ""
                , main_ [] <| pageView model.page
                ]
            ]
        , dynamicStyle model
        ]
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


allPosts : List Post
allPosts =
    [ Post "The Journey Is The Point: Why Its Better To Set Goals Than To Make Resolutions"
        "2020-03-07"
        [ "I have never been a huge fan of New Years resolutions for all the reasons most people dislike them. They rarely ever work being chief among them. However, over the last few years I've spent a lot more time thinking about why they don't work and what could be put in their place. Companies and projects have goals and deadlines, why wouldn't something like that work for me as a person?"
        , "So..."
        ]
    ]


allTalks : List Talk
allTalks =
    [ Talk "Dev Empathy Book Club" "2016-2019" [ Markup [ a [ href "https://devempathybook.club" ] [ text "https://devempathybook.club" ] ] ]
    , Talk "Ruby on Rails on Types" "May 2019" []
    , Talk "EILI5: Build Your Rails App For Beginners" "Sept 2018" []
    , Talk "Better Teams Through Better Communication" "April 2017" []
    , Talk "Lets talk about Testing" "Oct 2016" []
    , Talk "Care and Feeding Of Your Junior Developers" "April 2016" []
    , Talk "Testing And You" "2014" []
    , Talk "Teaching vs Mentoring" "2014" []
    , Talk "Tour of Enumerable" "2013" []
    ]
