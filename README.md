# TrackMe

by Manuel Meyer

## Description

TrackMe is an example app that allows the user to track time spent on projects.  
It is written with focus on the architecture.

## Architectural Design

The code follows the [SOLID Principles][solid], most notably the [Single Responsibility][srp]
and the [Dependency inversion principle][dip].

### Creating Table View Controllers

The ViewControllers in this app are created through a creator that will use specific factories.
The creator hold the common dependencies (in this case an instance of `ProjectController`) which the
specific factories can access and pass forward. The factories are instantiated with any specific
dependency. This makes sure that all needed decencies are present and easily to pass on.
On the other hand it limits the use of storyboards, as the programmer wont get hold on them
during creation.  
This app only uses two UIViewController subclasses as the project list overview and the project
detail view controller are of the same subclass (`PopulatedTableViewController`) with different
populators assigned.

### Populating Table Views

For populating the table views it uses a framework written by me: [TaCoPopulator][taco].
It's goal is to create table and collection view datasources in a more solid fashion by
defining a set of objects that fulfill a single task:

* `SectionDataProviders` are responsible to provide the data for a section
* `SectionCellsFactories` connect the provided data with the view's cells and allow to trigger
cell selection
* a `ViewPopulator` is instantiated with it's view and the section cell factories

### Dealing with Projects

Project are dealt with through a `ProjectController`. It offers the interface to list all
projects, add a project, update project and start pause time tracking for a project. It uses a
persister to persist and retrieve projects. In this case the app uses a persister that writes to
disk (`ProjectDiskPersister`). A persister must conform the `ProjectPersisterType` protocol. This
allows easy mocking. Protocol conformance is used all over the code for the same reason. Actually
I even use extensions to allow the mocking of apple provided classes (`FileManagerType`,
`FileManagerMock`). The disk persister also takes a `ProjectDataWriter` to encapsulate the writing
through apple's `(NS)Data` and make it easily mockable (`ProjectDataWriterMock`).

`ProjectController's` architecture also allows to swap different persisting methods without
enforcing any modification in other areas of the app. Also a compound of different persisters
could be used, i.e. for synchronizing with a network api. Persister's methods use callback to
allow asynchronous fetching. To not enforce this king of method signature throughout the app, a
simple observing is used (`Observable` & `ObserverType`).

### Testing

Although the code is highly testable, I wrote only very few tests — due to the limited time.
But I think, these are sufficient to illustrate the testing.  

TaCoPopulator as it [own set of tests][ofatests].

[solid]: https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)
[srp]: https://en.wikipedia.org/wiki/Single_responsibility_principle
[dip]: https://en.wikipedia.org/wiki/Dependency_inversion_principle
[taco]: https://github.com/vikingosegundo/TaCoPopulator/
[ofatests]: https://github.com/vikingosegundo/TaCoPopulator/blob/master/Example/Tests/Tests.swift
