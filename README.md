# Chameleon
A set of Frameworks for interacting with Slack APIs and building bots in Swift

![Swift](https://camo.githubusercontent.com/0727f3687a1e263cac101c5387df41048641339c/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d332e302d6f72616e67652e7376673f7374796c653d666c6174)

## Features
Chameleon provides frameworks for:
- [x] Web API
- [x] Real time messaging API
- [x] Bot: Uses Web/RTM and provides an API for custom services (i.e. karma)

Using Chameleon you are able to interact with these an a type-safe manner.

## Preparing to use Chameleon
### Swift 3
You need Swift 3 installed to use or contribute to Chameleon, I recommend using [swiftenv](https://github.com/kylef/swiftenv).

```
swiftenv install DEVELOPMENT-SNAPSHOT-2016-05-09-a
swiftenv global DEVELOPMENT-SNAPSHOT-2016-05-09-a
```

This will install the snapshot and set it as the default installation of Swift 3.

### Slack
You will need to [configure](https://my.slack.com/services/new/bot) a new bot user for your team. 
Copy the token, you will need it.

### Heroku
If you plan to run a bot on Heroku you will need a [Heroku](https://www.heroku.com/) account (free is fine!) 
and also have the [Heroku Toolbelt](https://toolbelt.heroku.com/) installed. 

## Running locally on OSX
* Download the latest Chameleon source and extract it
* Open a terminal window and go to the directory containing `Package.swift`
* Type `swift build`
* Type `.build/debug/app --token="<your-bot-token>"`
* Go into a default channel in your slack and say "hey @yourBot" - it should respond.

## Deploy to Heroku
* Download the latest Chameleon source and extract it
* Open a terminal window and go to the directory containing `Package.swift`
* Using the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-command) login and create a new app.
* Set the buildpack `heroku buildpacks:set https://github.com/oarrabi/heroku-buildpack-swift`
* Create a file called `Procfile` and add the text: `worker: App --token="<your-bot-token>"`
* Deploy to Heroku by typing:
```
git add .
git commit -am 'depoy to heroku'
git push heroku master
```
* Once that has completed type: `heroku ps:scale worker=1`
* Go into a default channel in your slack and say "hey @yourBot" - it should respond.

## ⚠️ Work in Progress
This is a work in progress so expect improvements as well as breaking changes!

Chameleon *is* functional however there is still a lot to do before it is *complete*
* Currently the 'persistence layer' is _memory_ :(
* The Web and Real time messaging APIs can do _a lot_ - 
I have built support for the core/most common features but they are incomplete. 
I will add more over time until they are complete.
* Once stable and the API is 'firmer' the individual frameworks will be broken out. 
They all live here for now for ease of development, however, separation should be considered when contributing.

#Acknowledgement
This was my first dive into 'Server Side Swift'; 
95% of this code was done over a total of a few days but getting working in the terminal 
and then deployed to Heroku took far longer... This project would likely have ended up as 
mostly useless OSX app if it hadn't been for the teams from [Vapor](http://qutheory.io/) and [Zewo](http://www.zewo.io/)
pioneering the server side Swift movement. I am especially thankful for the help and patience of 
[Logan Wright](https://twitter.com/LogMaestro), [Tanner Nelson](https://twitter.com/tanner0101) and [Dan Appel](https://twitter.com/Dan_Appel)

# Contact
Feel free to open an issue or PR, 
if you wanna chat you can find me on Twitter ([@IanKay](https://twitter.com/IanKay)) 
or on [iOS Developers](http://ios-developers.io)
