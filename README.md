# SBGTodoListMVC
  A persistent Todo List iOS app in MVC

### Xcode and Swift versions:
  Built in Xcode 9.4.1 with Swift 4.1.

### Screenflow
  App opens to a landing page showing the list of tasks, separated into a section for uncompleted tasks, and another section for completed tasks.

* Tap on the "+" to create a new Todo Task in a modal screen
* If you are on the landing page and already have Todo Tasks:
  * Tap on a Todo Task to view or edit its details
  * Tap on Edit on the landing page to reveal the option to Remove All Todo Tasks as well as options to remove Todo Tasks individually
  * Swipe left on a Todo Task to reveal a Delete option
* If you are editing an existing Todo Task:
  * Tap on Cancel to cancel the current edit and return to the landing page
  * Tap on Save to save current changes and return to the landing page
  * Modify the Title, Type, Priority, and Completion Status of a Todo Task
  * Tap on Delete to delete the Todo Task and return to the landing page

### Persistence
  The app has a set of protocols that define a _DataProvider_, which defines a way to _get_, _add_, and _remove_ entries from an array of a given object type. There is a _CoreData_ version of this kind of _DataProvider_ which acts on _TodoTask_ objects in _CoreData_. There is also a different _DataProvider_ that owns the _CoreData_ _DataProvider_ and uses it along with an adapter to turn the _CoreData_ _TodoTasks_ into regular _TodoTaskInfo_ objects (regular Swift structs). The view controllers don't know about _CoreData_ at all this way, and the new _DataProvider_ could swap out its internal _DataProvider_ for a different type of persistent store like through _NSUserDefaults_ or through RESTful API services, and the consuming view controllers would be unchanged.

### Architecture
  Rather than focusing on building an app with a reactive architecture with MVVM, I chose to build an app that is built on MVC, since that's what I've been working with for the last 2 years, and I wanted to show my ability to produce a fully functional, scalable, and flexible app. The main point I wanted to show was the _TableDataViewController_ class, which is my personal approach to mitigating the inflexibilities of _UITableViews_ and the ugly code that accompanies them in most MVC. One thing I will say is that the version of the _TableDataViewController_ that I used in this codebase is about a year older than the version I maintained in the codebase of my previous employment. It's missing some features and improvements that made it more compact, mainly, but I didn't want to spend time trying to reimplement them with my limited available time.

### Unit Testing
  I have included a small amount of unit testing which covers some, but not all, of the "black box" _DataProvider_ that doesn't tell you what flavor of persistent store it's internally using. While I wanted to implement more unit testing, since that was part of the instructions, I had to cut something out due to time constraints, and a fuller TDD process was what I cut in order to get as much functionality done as possible.

### Missing Features
  I didn't get to all of the features specified in the design document. Notably missing is the difference between a Task List type and a regular Text type, and also being able to sort and filter Todo Tasks. Another requirement not met is the ability to check a Todo Task as complete from the list view.

### Code Refactors I would do next
  The _DataProvider_ protocol doesn't support a _modify_ or _edit_ command, currently. To achieve this functionality in app, I store the Todo Task that you tapped on to edit, and when it gets updated, I delete the old version and save a new copy from the returned version. In order to do a real _edit_, I would've needed to have some way of uniquely identifying the Swift struct objects, as well as probably storing _created_ and _updated_ timestamps.

  Another refactor would've been to add completion handlers to the _DataProvider_ protocol to make it asynchronous. Right now, the operations are synchronous, and wouldn't support a RESTful API service or an asynchronous implementation of _CoreData_.

  I'd also go back and add more unit test coverage around the "black box" _DataProvider_.

