# iOS-Swift-GameOfThronesArticlesApp

- App displaying articles from gameofthrones.fandom.com api.
- iOS 13. MVC architecture.
- User can add them to favorites and filter them. 
- No Xib files or Storyboards, only AutoLayout.  
- Networking written by myself and injected into controllers. No networking Frameworks. 
- Unit Tests Included. 
- Supports all iPhone orientations.

The main view is meant to display the most viewed articles about characters of Game Of
Thrones Wiki using API which you can find information about at:
http://gameofthrones.wikia.com/api/v1/#!/Articles/getTopExpanded_get_10

Main View: articles list with abstract - shortened to 2 lines of description, however, the user is able to extend
the visible description by a long-press gesture. The visible area enables the user to
see whole description. Performing the long press gesture again collapses that entry
to previous height.

Detail view is meant to display all the above information about the selected Wiki and enables
the user to go to that wiki article in Safari using a button. Users also can see if a wiki is added
to their favorites list or not.

