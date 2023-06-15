Class {
	#name : #GtGemStoneSessionsCardWidget,
	#superclass : #BrVerticalPane,
	#instVars : [
		'registry',
		'sessionList'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'instance creation' }
GtGemStoneSessionsCardWidget class >> addToHomeSectionCardsContainer: cardsContainer in: aGtHomeSection [

	cardsContainer
		addChild: (BrFrame new
			background: Color white;
			aptitude: BrShadowAptitude new beLarge;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
			padding: (BlInsets top: 0 bottom: 10 left: 10 right: 10);
			margin: (BlInsets
				top: aGtHomeSection spaceGap
				left: 2 * aGtHomeSection spaceGap
				bottom: 2 * aGtHomeSection spaceGap
				right: 2 * aGtHomeSection spaceGap);
			size: 310 @ 150;
			addChild: (self new
				matchParent;
				constraintsDo: [ :c | 
					c frame horizontal alignLeft.
					c frame vertical alignCenter ]))
]

{ #category : #private }
GtGemStoneSessionsCardWidget >> activeMark [

	^ BlElement new
		layout: BlLinearLayout horizontal alignCenter;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: (BrGlamorousVectorIcons accept asElement)
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> buildUI [

	self 
		addChild: (sessionList := self createList);
		addChild: self createToolbar.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createInspectButton [

	^ BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons inspect;
			action: [ :aButton | self inspectRegistryFrom: aButton ];
			yourself.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createList [
	| newList |

	newList := BrColumnedList new.
	newList
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
		padding: (BlInsets top: 5);
		matchParent.
	newList column
		title: 'Session';
		width: 100;
		cellStencil:
			[ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent ];
		dataBinder: [ :aLabel :aSession |
			aLabel parent addAptitude: 
				(BrGlamorousWithContextMenuAptitude content: 
						(self sessionActionsFor: aSession)).
			aLabel text: aSession name ].
	newList column
		"Connected"
		title: 'Connected';
		width: 70;
		stencil: [ :aSession |
			aSession isRunning
				ifTrue: [ self activeMark ]
				ifFalse: [ BlElement new size: 0@0 ] ].
	newList column
		"Clean (needsCommit not)"
		title: 'Changed';
		width: 60;
		stencil: [ :aSession |
			aSession needsCommit
				ifTrue: [ self activeMark ]
				ifFalse: [ BlElement new size: 0@0 ] ].
	newList column
		"Default"
		title: 'Default';
		width: 50;
		stencil: [ :aSession |
			aSession isDefaultSession
				ifTrue: [ self activeMark ]
				ifFalse: [ BlElement new size: 0@0 ] ].
	newList
		when: BrSelectionDoubleClicked
		do: [ :anEvent | self doDoubleClicked: anEvent ].
	newList
		when: BrSelectionChanged 
		do: [ :anEvent | self doSelectionChanged: anEvent ].
	newList addAptitude: BrColumnedListHeaderAptitude.
	"newList contextMenuStencil: self contextMenuStencilFromSessionActions."
	^ newList.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createRefreshButton [

	^ BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons refresh;
			action: [ :aButton | self updateContent ];
			yourself.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> createTitleLabel [

	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		hMatchParent;
		vFitContent;
		text: 'GemStone Sessions' asRopedText bold.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> createToolbar [

	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		layout: BlLinearLayout horizontal alignTopRight;
		addChild: self createTitleLabel;
		addChild: (self createRefreshButton margin: (BlInsets right: 5));
		addChild: self createInspectButton;
		yourself.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> doDoubleClicked: anEvent [ 
	| session |

	session := anEvent currentTarget items at: anEvent selection first.
	session class = GtGemStoneCardWidgetNoSessions ifTrue: [ ^ self ].

	self openPlaygroundOn: session
		from: anEvent currentTarget.
]

{ #category : #'private - children' }
GtGemStoneSessionsCardWidget >> doSelectionChanged: anEvent [ 
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> initialize [

	super initialize.
	self buildUI.
	self updateContent.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> inspectRegistryFrom: aButton [ 

	GtPager
		openWrappedOn: (GtInspector newOn: registry)
		title: 'GemStone Registry'
		from: aButton.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> inspectSession: aSession from: anElement [

	GtPager
		openWrappedOn: (GtInspector newOn: aSession)
		title: aSession name
		from: anElement.
]

{ #category : #'private - hooks' }
GtGemStoneSessionsCardWidget >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self updateContent
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> openPlaygroundOn: aSession from: anElement [
	| page |

	page := LePage unnamedPage.
	page addSnippet: (LeGemStoneSnippet new sessionName: aSession name).
	LeDatabasesRegistry default defaultLogicalDatabase playgroundDB addPage: page.
	GtWorldUtility
		showSpaceWithTitle: aSession name
		inPagerWith: [ page asLepiterPagePhlowTool asElementDo: [ :e | e ] ]
				asStencil
		from: anElement
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> registry [

	registry ifNil: [ self registry: GtGemStoneSessionRegistry default ].
	^ registry
]

{ #category : #accessing }
GtGemStoneSessionsCardWidget >> registry: aGtGemStoneSessionRegistry [

	registry ifNotNil: [ registry unsubscribe: self ].
	registry := aGtGemStoneSessionRegistry.
	registry
		when: GtGemStoneSessionAnnouncement
		send: #updateContent
		to: self.
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> sessionActionsFor: aSession [

	aSession class = GtGemStoneCardWidgetNoSessions ifTrue: [ ^ BrGlamorousSimpleContextMenuContent new ].

	^ BrGlamorousSimpleContextMenuContent new items: {
		'Playground' -> [ :aStatusLineElement | self openPlaygroundOn: aSession from: aStatusLineElement ].
		'Commit' -> [ :aStatusLineElement | aSession commitTransaction ].
		'Abort' -> [ :aStatusLineElement | aSession abortTransaction ].
		'Reconnect' -> [ :aStatusLineElement | aSession reconnect ].
		'Be Default' -> [ :aStatusLineElement | aSession beDefaultSession ].
		'Inspect' -> [ :aStatusLineElement | self inspectSession: aSession from: aStatusLineElement ].
	}
]

{ #category : #'private - ui' }
GtGemStoneSessionsCardWidget >> updateContent [

	sessionList items: (self registry activeSessions ifEmpty:
		[ { GtGemStoneCardWidgetNoSessions new } ]).
]