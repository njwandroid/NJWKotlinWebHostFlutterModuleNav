# Timeboxed 7-Hour Focused Demo Sprint Plan

**Overall Goal:** Achieve demonstrable progress on three key areas: a simple Maestro UI test, core
navigation patterns (including native-Flutter interplay, deep links, and backstack for Android &
Web), and a basic JNIgen example for native Kotlin API calls, all within a 7-hour focused effort. *
*This plan assumes preparatory research is complete, and focuses on execution.**

**Your Mindset (Life Coach Corner!):** You've got this! With research done, it's all about focused
execution. Embrace the sprint: intensity, quick wins, and tangible results. "Good enough" for the
demo is the immediate win; we'll lay tracks for "excellent" as we go. Stay energized with those
planned breaks!

---

## Time Allocation & Structure:

* **Total Time:** 7 hours
* **Day 1 (Today):** 2 hours (approx. 105 mins work + 15 min break)
* **Day 2 (Tomorrow):** 5 hours (approx. 210 mins work + 60 min lunch + 2x 15 min breaks)

---

## Day 1 Plan: Quick Wins & Setups (Today - 2 Hours Total)

### 🎯 **Focus: Rapid Implementation & Foundation**

* **(50 min) Task 1: Maestro - The Quick Smoke Test**
    * **Objective:** Get Maestro running with a basic passing test. Leverage
      `github_tickets/story_maestro_00_setup_and_demo.md`.
    * **Activities:**
        * (10 min) Verify/Install Maestro CLI.
        * (10 min) Run the existing sample test (expect failure initially).
        * (30 min) Identify a simple flow (e.g., app launch, one tap, one assertion) and make it
          pass. Add a simple accessibility ID.
    * **Deliverable (MVD):** Maestro installed, one simple test flow passing and recorded (
      screenshots/short video clip).

* **(15 min) WALK BREAK & RECHARGE**

* **(30 min) Task 2: JNIgen - The Kotlin Connection (Initial Steps)**
    * **Objective:** Define the native Kotlin side of the JNIgen demo.
    * **Activities:**
        * (5 min) Quick check of JNIgen project setup (if not already 100% ready).
        * (25 min) Define a *very simple* "pretend API call" in a Kotlin file (e.g.,
          `fun greet(name: String): String { return "Hello, $name from Kotlin!" }`).
    * **Deliverable (MVD):** A Kotlin file with the basic function for the JNIgen demo.

* **(25 min) Task 3: Navigation - Flutter Scaffolding**
    * **Objective:** Set up basic Flutter navigation structure.
    * **Activities:**
        * (25 min) In your Flutter app, ensure `MaterialApp` is set up and create 2-3 placeholder
          screen widgets for upcoming navigation demos (e.g., `HomeScreen`, `NativeDemoScreen`,
          `DeepLinkTargetScreen`). Set up basic named routes if not already present.
    * **Deliverable (MVD):** Basic Flutter app structure with placeholder screens and routes ready
      for navigation logic.

---

## Day 2 Plan: Deep Dive & Integration (Tomorrow - 5 Hours Total)

### 🎯 **Focus: Connecting Components & Demonstrating Flow**

* **(Approx. 70 min) Work Block 1: Android Native <-> Flutter Navigation**
    * **Task 4 (Part 1):**
        * **Objective:** Demonstrate basic navigation between a native Android Activity and a
          Flutter screen, and vice versa.
        * **Activities:**
            * (30 min) Implement launching a specific Flutter route/screen (e.g.,
              `NativeDemoScreen`) from a new, simple native Android Activity.
            * (30 min) Implement calling a simple native Android action (e.g., show a Toast or log a
              message) from a button on the `NativeDemoScreen` in Flutter, likely via a
              MethodChannel.
            * (10 min) Quick test of back button behavior from Flutter screen back to native, and
              vice versa.
        * **Deliverable (MVD):** Working demo of Android native launching a specific Flutter screen,
          and that Flutter screen triggering a simple native action. Basic backstack flow observed.

* **(15 min) WALK BREAK & RECHARGE**

* **(Approx. 70 min) Work Block 2: Advanced Navigation & Initial JNIgen Bridging**
    * **Task 5: Deep Links & Web Preview**
        * **Objective:** Implement a simple Android deep link and briefly get the app running on
          Web.
        * **Activities:**
            * (30 min) Android: Implement one simple deep link (e.g., `myapp://deeplink`) that
              navigates to your `DeepLinkTargetScreen` in Flutter. Test it.
            * (20 min) Flutter Web: Get the app running on Web. Test basic navigation between your
              existing Flutter screens. Note any immediate differences from mobile.
            * (10 min) Briefly test backstack with deep link and web navigation.
        * **Deliverable (MVD):** A working Android deep link to a Flutter screen. Flutter app
          running on Web with basic navigation observed.
    * **Task 6 (Part 1): JNIgen - Generate Bindings**
        * **Objective:** Generate Dart bindings for the Kotlin function.
        * **Activity:** (10 min) Run JNIgen to generate the Dart bindings for your Kotlin `greet`
          function.
        * **Deliverable (MVD):** Generated Dart files for JNIgen.

* **(60 min) LUNCH BREAK**

* **(Approx. 70 min) Work Block 3: Completing JNIgen & Wrap-up**
    * **Task 6 (Part 2): JNIgen - Call from Dart & Test**
        * **Objective:** Complete the JNIgen demo.
        * **Activities:**
            * (20 min) Call the generated Dart function from your Flutter UI (e.g., on a button
              press on `HomeScreen`, display the result from Kotlin in a `Text` widget).
            * (10 min) Test and confirm the JNIgen call works end-to-end.
        * **Deliverable (MVD):** Working demo of a Flutter app calling the Kotlin function via
          JNIgen and displaying the result.
    * **Task 7: Review, Polish MVDs & Document Next Steps**
        * **Objective:** Consolidate learnings, ensure MVDs are runnable, and capture notes for
          future.
        * **Activities:**
            * (15 min) Quickly run through all three MVDs (Maestro, Navigation, JNIgen).
            * (15 min) For each MVD, jot down key talking points for a quick demo. Crucially, in
              your code, comments, or a separate notes file for each, start filling in the "Future
              Polish & Content Blueprint" (see section below).
            * (10 min) Identify any critical immediate next steps or major "aha!" moments from the
              sprint.
        * **Deliverable:** Smoothly runnable MVDs. Initial notes for "Future Polish" captured for
          each demo area.

---

## ⭐ Managing GitHub Issues & PRs: From Quick Wins to Lasting Excellence ⭐

This sprint is about speed and MVDs. But we want to build towards excellence. Here's how to manage
your Git workflow and use an LLM like Claude effectively:

**A. For You (The Human Developer) - During the Sprint:**

1. **Issue per Task/MVD:** Create a simple GitHub issue for each major task (e.g., "MVD: Maestro
   Simple Demo," "MVD: Android <-> Flutter Nav").
    * **Checklist for MVD:** Clearly list the 2-3 absolute minimum criteria for the demo to be "
      done" for this sprint.
2. **Small, Focused PRs for MVDs:**
    * Branch for each issue (e.g., `feature/mvd-maestro-demo`).
    * Submit a PR when the MVD checklist for that issue is met.
    * **PR Title:** `[DEMO-SPRINT-MVD] Maestro: Simple passing test`.
3. **The "Future Polish & Content Blueprint" Section (CRITICAL):**
    * In the **description of your PR** (or as a dedicated `NOTES.md` committed with the PR), create
      a section:
      ```markdown
      ## 🚀 Future Polish & Content Blueprint 🚀

      **1. Elevating to "Excellent" Demo:**
      *   [ ] *e.g., Add assertions for all tab elements in Maestro.*
      *   [ ] *e.g., Implement robust error handling for the native call.*

      **2. Blog Post/Training Material Ideas:**
      *   *e.g., Deep dive into AndroidManifest for deep link setup.*
      *   *e.g., Explain MethodChannel argument types and return values.*
      *   *e.g., Common pitfalls in JNIgen setup.*

      **3. Code Refinements/Tech Debt Noted:**
      *   *e.g., Refactor Flutter navigation service for better testability.*
      *   *e.g., Kotlin function could be made more generic.*

      **4. Open Questions/Explorations Deferred:**
      *   *e.g., How does iOS handle this Flutter-to-native pattern?*
      *   *e.g., Explore performance implications of FlutterFragment vs FlutterActivity.*
      ```
    * **Jot down notes here as you go or during Task 7.** This is how you capture brilliance without
      slowing down the MVD.

**B. For Claude (or other LLM) - Post-Sprint or for Asynchronous Assistance:**

1. **Processing MVD PRs for Next Steps:**
    * **Prompt:** "Claude, review PR `[link to MVD PR]` which achieved its Minimum Viable Demo.
      Extract all items from its '🚀 Future Polish & Content Blueprint 🚀' section. Categorize them
      and create a new GitHub issue titled 'Polish & Extend: [Original Feature Name]' with these
      items as a checklist."
2. **Drafting Content Outlines:**
    * **Prompt:** "Claude, using the MVD code from PR `[link]` and the 'Blog Post/Training Material
      Ideas' from its 'Future Polish' section, draft a detailed outline for a blog post titled '
      Quick Start: [Feature Name] with Flutter & Native Integration'. Include sections for
      introduction, prerequisites, MVD walkthrough, and a 'Going Further' section based on the noted
      ideas."
3. **Identifying Refactoring Tasks:**
    * **Prompt:** "Claude, analyze the code in PR `[link]` and the 'Code Refinements' noted in its '
      Future Polish' section. Suggest 3 specific refactoring tasks, explain their benefits, and
      provide a skeletal code structure for one of them."
4. **Generating Follow-up Stories/Tasks:**
    * **Prompt:** "Claude, based on the 'Open Questions/Explorations Deferred' in these completed
      MVD issues/PRs `[list links]`, generate a list of potential follow-up research spikes or
      technical stories for our backlog."

**This dual approach (MVD focus now, structured notes for later) allows for high-speed, focused work
in the timebox, while ensuring that valuable insights and next steps towards higher quality and
content creation are not lost.**

---

Let's crush this 7-hour sprint! I'm ready to assist as you move through these tasks.