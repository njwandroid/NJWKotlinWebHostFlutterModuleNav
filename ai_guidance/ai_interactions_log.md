# AI Interactions Log

## Project: Flutter-Kotlin Hybrid Navigation App

### Session: 2023-06-17

#### 14:15:23 - Initial Project Request

**User:** Make me a github ticket for a kotlin host app that has tabs My,Billing, Dashboard, Items
and ThTif and the bottom navbar is flutter and the home view is kotlin (the host app) and the
Billing, Items and ThTif view is flutter. ThTif view should be a flutter view that says To Host Then
Inner Flutter for the title with a button that says "To Host" that goes to a Kotlin/android view and
a "To Inner Flutter View" button that goes back to a flutter view

**AI:** Created a GitHub ticket with hybrid app requirements, tab structure, and navigation
patterns.

#### 14:18:45 - README Request

**User:** Please give me readme I can copy/paste into github

**AI:** Created a comprehensive README.md with project overview, features, technical overview, and
setup instructions.

#### 14:22:10 - GitHub Issue Format Request

**User:** Can I please have some markdown I can copy/paste for the github issue

**AI:** Created concise markdown formatted specifically for a GitHub issue with requirements,
technical considerations, and acceptance criteria.

#### 14:25:30 - Navigation Pattern Enhancement

**User:** Modify to make some tabs show navigating backstack within the navigationbar and some show
navigating "out" where the navigation bar does not show. Show each of these within Flutter and Host
so that it is clearly demonstrated the backstack will "work" as expected regardless of tab and
technology used

**AI:** Updated the ticket to include detailed navigation patterns, showing both in-tab and
full-screen navigation scenarios across both technology stacks.

#### 14:30:15 - Epic Story Format Request

**User:** Please make me a github_epic_description.md file with this info plus an AI section that
contains the LOE with Firebender with Claude Sonnet 3.7 and/or Gemini 2.5 Pro, as well as on a scale
of 1 to 10 the likelihood of success, likelihood of frustration, likelihood of manual steps and an
estimate of number of hours it will take

**AI:** Created a comprehensive epic description with detailed subtasks, metrics for AI assistance,
and time estimates.

#### 14:35:40 - Detailed Navigation Requirements

**User:** This will be a story/epic with subtasks so please make items be a listview in this plan
where items will be a flutter listview and item7 will go to a flutter item detail page that can be
deep linked to and that billing will be a Kotlin Item Detail Page for a bill that goes to a Kotlin
view than can be deeplinked to and Dashboard will have a "Request Service" button that goes to a
Flutter with no navigation bar and "My" Will be a Kotlin view that has a "Review Contact Info" CtA
Button that goes to a Flutter view that is still in the bottom navigation bar and an add person view
that goes to a flutter page that shows a spinner and feels like a new section of the app that does
not have the navigation bar

**AI:** Enhanced the epic with detailed navigation requirements for each tab, including specific UI
elements and navigation patterns.

#### 14:42:12 - Project Structure Request

**User:** Please make an ai_guidance folder and a github tickets folder and put the epic ticket in
it. Then please create a file in the ai folder general_strategy.md with general advice on how to be
effective with AI/LLMS especially as it relates to how to choose between 3.7 Sonnet and Gemini, but
note that this advice is from Sonnet. Then create github stories under the epic for appropriate
stories for a reasonable plan where the first is the "skeleton". Make them all copy/pasteable md
files for github ticket description also with AI section that contains the LOE with Firebender with
Claude Sonnet 3.7 and/or Gemini 2.5 Pro, as well as on a scale of 1 to 10 the likelihood of success,
likelihood of frustration, likelihood of manual steps and an estimate of number of hours it will
take

**AI:** Created the requested folder structure, AI guidance document, and individual story tickets
with detailed metrics.

#### 14:50:33 - Developer Profile Update

**User:** Change all the project metrics and time estimates to consider that a senior Flutter
Developer is working on it with Kotlin background 5 years past

**AI:** Updated all metrics and time estimates across all tickets to reflect the experience level of
the developer.

#### 15:00:27 - Second Epic Request

**User:** Make the description for the first epic be epic1_navigation and make a second epic be web
and do the same plan with the same pattern and metrics but taking into account 1) The flutter dev
will have minimal web knowledge 2) The flutter code should need almost no modifications for
navigation demo and 3) Initial demo is with index.html and flutter_run_chrome. Make a ticket for the
demo with good steps to demo, and make a ticket for deploy to github pages with good steps to do
that.

**AI:** Created a second epic for web deployment with 5 detailed stories, considering the
developer's minimal web knowledge.

#### 15:10:15 - Final Documentation Request

**User:** Add an ai_interactions_log file with the timestamp for all of these prompts and the
record/history of prompts and create a firebender.json file to maintain the prompt history. Also
update the demo environment to take into account that flutter_run_chrome should be corrected to
whatever the simplest way to run locally on mac is such as open -a web/index.html or similar, with
some notes on running/debugging from IDE if feasible

**AI:** Creating the AI interactions log, firebender.json file, and updating the demo environment
story with correct Mac-specific instructions.

#### 15:25:30 - Platform Communication Epic Request

**User:** Update interaction log and create an epic with stories for demonstrating 1) Demonstrating
pigeon usage with 2 examples and 2) Demonstrating converting one of those two JNIGen. Use some
reasonable simple easy to understand possibilities such as updating the app bar from flutter even if
it's and Android route or vice versa, possibly using the default battery level method channel,
possibly hello world or adding two numbers and gettting a sum or a fake api call- optimize for
understandable first, real-world simulation second, speed of implementation third and ease of
implementation fourth.

**AI:** Updated the interaction log and created a new epic focusing on platform communication using
Pigeon and JNIGen with stories for simple, understandable examples prioritized by clarity and
real-world applicability.

#### 15:40:15 - TLDR Request

**User:** awesome! Give each story a summary/TLDR section at the top for people reviewing to just
skim a few lines and understand the purpose and genral idea. (also update ai interaations for this
prompt)

**AI:** Added a concise TLDR section to each story ticket to allow reviewers to quickly understand
the purpose and general idea without reading the entire ticket, and updated the AI interactions log.

#### 15:50:20 - Summary Section Enhancement

**User:** call the TLDR sections Summary (TLDR) and do it for every single github, optimize each
TLDR for readability, quick skimming, bullet points, bold or highlight, in particular the epics. Do
this for every github issue in the project so far and add this interaction to the ai interactions
log

**AI:** Renamed all TLDR sections to "Summary (TLDR)" and enhanced them with bullet points, bold
text, and improved formatting for better skimming. Updated every GitHub issue in the project
including epics and stories for consistent presentation.

#### 16:05:45 - iOS Version Request

**User:** now create another epic to do all of this for a new project with the host app as iOS. Keep
in mind the flutter developer has limited swift/ios experience, but include metrics in case a dev
more experienced in ios/swt takes on the epic. Optimize for demo on the simulator but include an
optional/stretch goal story to deploy to firebase app distribution

**AI:** Created a comprehensive iOS-Flutter hybrid navigation epic with adjusted metrics for both
developers with limited iOS experience and experienced iOS developers. Included two detailed
stories - one for initial infrastructure setup and one for the optional Firebase App Distribution
deployment as a stretch goal. The epic focuses on iOS simulator demonstration while maintaining
parallel navigation patterns to the Android version.