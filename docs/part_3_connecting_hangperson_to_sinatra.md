-----------------

You've already met Sinatra.  Here's what's new in the Sinatra app skeleton [`app.rb`](../app.rb) that we provide for Hangperson:

* `before do...end` is a block of code executed *before* every SaaS request

* `after do...end` is executed *after* every SaaS request

* The calls  `erb :` *action* cause Sinatra to look for the file `views/`*action*`.erb` and run them through the Embedded Ruby processor, which looks for constructions `<%= like this %>`, executes the Ruby code inside, and substitutes the result.  The code is executed in the same context as the call to `erb`, so the code can "see" any instance variables set up in the `get` or `post` blocks.

#### Self Check Question

<details><summary><code>@game</code> in this context is an instance variable of what
class?  (Careful-- tricky!)</summary><p><blockquote>It's an instance variable of the <code>HangpersonApp</code> class in the app.rb file.  Remember we are dealing with two Ruby classes here: the <code>HangpersonGame</code> class encapsulates the game logic itself (that is, the Model in model-view-controller), whereas <code>HangpersonApp</code> encapsulates the logic that lets us deliver the game as SaaS (you can roughly think of it as the Controller logic plus the ability to render the views via <code>erb</code>).</blockquote></p></details>

The Session
-----------

We've already identified the items necessary to maintain game state, and encapsulated them in the game class.  Since HTTP is stateless, when a new HTTP request comes in, there is no notion of the "current game".  What we need to do, therefore, is save the game object in some way between requests.

If the game object were large, we'd probably store it in a database on the server, and place an identifier to the correct database record into the cookie.  (In fact, as we'll see, this is exactly what Rails apps do.)  But since our game state is small, we can just put the whole thing in the cookie.  Sinatra's `session` library lets us do this: in the context of the Sinatra app, anything we place into the special "magic" hash `session[]` is preserved across requests.  In fact, objects placed there are *serialized* into a text-friendly form that is preserved for us.  This behavior is switched on by the Sinatra call `enable :sessions` in `app.rb`.

There is one other session-like object we will use.  In some cases above, one action will perform some state change and then redirect to another action, such as when the Guess action (triggered by `POST /guess`) redirects to the Show action (`GET /show`) to redisplay the game state after each guess.  But what if the Guess action wants to display a message to the player, such as to inform them that they have erroneously repeated a guess?  The problem is that since every request is stateless, we need to get that message "across" the redirect, just as we need to preserve game state "across" HTTP requests.

To do this, we use the `sinatra-flash` gem, which you can see in the Gemfile.  `flash[]` is a hash for remembering short messages that persist until the *very next* request (usually a redirect), and are then erased.

#### Self Check Question

<details><summary>Why does this save work compared to just storing those
messages in the <code>session[]</code> hash?</summary><p><blockquote>When we put something in <code>session[]</code> it stays there until we delete it.  The common case for a message that must survive a redirect is that it should only be shown once; <code>flash[]</code> includes the extra functionality of erasing the messages after the next request.</blockquote></p></details>

Running the Sinatra app
-----------------------

As before, run the shell command `bundle exec rackup --host 0.0.0.0` to start the app, or `bundle exec rerun -- rackup` if you want to rerun the app each time you make a code change.

#### Self Check Question

<details><summary>Based on the output from running this command, what is the full URL you need to visit in order to visit the New Game page?</summary><p><blockquote>The Ruby code <code>get '/new' do...</code> in <code>app.rb</code> renders the New Game page, so the full URL is in the form <code>http://localhost:9292/new</code></p></details>
<br />

Visit this URL and verify that the Start New Game page appears.

#### Self Check Question

<details><summary>Where is the HTML code for this page?</summary><p><blockquote>It's in <code>views/new.erb</code>, which is processed into HTML by the <code>erb :new</code> directive.</blockquote></p></details>
<br />

Verify that when you click the New Game button, you get an error.  This is because we've deliberately left the `<form>` that encloses this button incomplete: we haven't specified where the form should post to. We'll do that next, but we'll do it in a test-driven way.

But first, let's get our app onto Google Cloud.  This is actually a critical step.  We need to ensure that our app will run on GCloud **before** we start making significant changes.

* First, run `bundle install` to make sure our Gemfile and Gemfile.lock are in sync.
* Next, type `git add .` to stage all changed files (including Gemfile.lock)
* Then type `git commit -m "Ready for Deployment!"` to commit all local changes.
* Since this is the first time we're telling Google App Engine about the Hangperson app, we must type `gcloud projects create hw-hangperson --set-as-default` to create the project.
* Go to [Cloud Build Settings page](https://console.cloud.google.com/cloud-build/settings) and make sure that *Cloud Run Admin* role is set to ENABLED.

This time, we will put up our build and run options into a YAML file called `cloudbuild.yaml`. Make sure you have this file in your app root directory.

```
steps:
# Build the container image
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/PROJECT-ID/IMAGE', '.']
# Push the container image to Container Registry
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/PROJECT-ID/IMAGE']
# Deploy container image to Cloud Run
- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  entrypoint: gcloud
  args: ['run', 'deploy', 'SERVICE-NAME', '--image', 'gcr.io/PROJECT-ID/IMAGE', '--region', 'asia-southeast1', '--platform', 'managed']
images:
- gcr.io/PROJECT-ID/IMAGE
```

You need to modify the value of `PROJECT-ID` to your project id. You can use the following command to get your project id.

```
gcloud config get-value project
```

You need to specify also the `IMAGE` name and the `SERVICE-NAME`. For example, you can set the `IMAGE` name to be `hangperson_img` and `SERVICE-NAME` to be `hangperson-service`.

* Then, type ` gcloud builds submit` to build the container image and upload it to Container Registry as well as deploying it to Cloud Run. Notice that the last line of `cloudbuild.yaml` actually gives an instruction to execute `gcloud run deploy --image` which we manually did in Part 0. 
* When you want to update Google Cloud Run later, you only need to commit your changes to git locally, build the container image and submit to Container Registry, and then deploy to Cloud Run as in the last step.

You can try to access your service by clicking the URL given in the output after running `gcloud builds submit`. If you encounter a Forbidden Error shown in the image below, follow the steps given below.
![](https://www.dropbox.com/s/coq01txguzk8lac/Error_Forbidden_CloudRun.png?raw=1)
* Go to Google Console **Cloud Run**. [Click here](https://console.cloud.google.com/run). Make sure you select the current project you have created.
* Click the SERVICE-NAME in the list and then click on the tab PERMISSION. 
* Add "allUsers" to Members and add the Role "Cloud Run Invoker". See the image below.
![](https://www.dropbox.com/s/5ger78n61itvkhh/Enable_AllUser_CloudRunInvoker.png?raw=1)

Once you have done all these, you can try again and see if the service is accessible.
* Verify that the deployed Hangperson behaves the same as your development version before continuing. 
* Verify the broken functionality by clicking the new game button.
