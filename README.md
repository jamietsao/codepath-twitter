## CodePath Spring 2015 - Week 3 Homework: Twitter App (see below for Week 4 Redux)

Inspired by the official Twitter app, this is my version of the Twitter app built on top of the [Twitter API](https://apps.twitter.com/).

Time spent: 20 hours

### Features

#### Required

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [X] User can pull to refresh
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. NOTE: Undo-ing a retweet was not implemented.
- [X] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

#### Other notables

- [X] Implemented gesture recognizers (instead of buttons) for reply/retweet/favorite on both home/detail views
- [X] Displaying action sheet to confirm retweet or cancel (same as official Twitter app)
- [X] When composing a new tweet, "What's happening?" is displayed until the first character is typed (same as official Twitter app)
- [X] When replying to a tweet, focus is immediately put in UITextView via `becomeFirstResponder()`
- [X] App doesn't allow retweeting of own tweets (same as official Twitter app)
- [X] Added "Retweeted by" icon and label in tweet cell and details view that works via Autolayout even when not present
- [X] Compose icon is used in nav bar for composing a tweet

### Walkthrough

#####  OAuth Login Flow & User Persistance Across Restarts
![OAuthLogin](OAuthLogin.gif)

#####  Basic Features (Home Timeline & Tweet Details)
![BasicFeatures](BasicFeatures.gif)

## CodePath Spring 2015 - Week 4 Homework: Twitter Redux

This homework adds on to the Twitter app built in week 3 (above)

Time spent: 15  hours

### Features

- [X] Hamburger menu
  - [X] Dragging anywhere in the view should reveal the menu.
  - [X] The menu should include links to your profile, the home timeline, and the mentions view.
  - [X] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
- [X] Profile page
  - [X] Contains the user header view
  - [X] Contains a section with the users basic stats: # tweets, # following, # followers
  - [] Optional: Implement the paging view for the user description.
  - [] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
  - [] Optional: Pulling down the profile page should blur and resize the header image.
- [X] Home Timeline
  - [X] Tapping on a user image should bring up that user's profile page
- [] Optional: Account switching
  - [] Long press on tab bar to bring up Account view with animation
  - [] Tap account to switch to
  - [] Include a plus button to Add an Account
  - [] Swipe to delete an account

#### Other notables

- [X] Added user's own tweets to profile view
- [X] In addition to pan gesture, added hamburger menu button in nav bar to open/close menu
- [X] Added "Favorites" and "Log Out" to menu
- [X] Downloaded pretty icons for menu items =)

### Walkthrough

#####  Twitter Redux (Hamburger Menu and Profile page)
![TwitterRedux](TwitterRedux.gif)

