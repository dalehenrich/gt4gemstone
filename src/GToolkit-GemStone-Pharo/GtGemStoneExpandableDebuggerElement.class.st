Class {
	#name : #GtGemStoneExpandableDebuggerElement,
	#superclass : #GtGemStoneDebuggerElement,
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement class >> registerToolsOn: registry [
	"self register"
	registry registerDebugger: self withRank: 901.
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> actOnSelectedContextChangedFor: aContext [
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildLeftPane [
	| leftPane |
	leftPane := BrVerticalPane new
			matchParent;
			constraintsDo: [ :c | c linear weight: 1.0 ].
	callFramesList := self buildStackElement.
	leftPane
		addChild: callFramesList.
	^ leftPane
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtGemStoneExpandableStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateCallFrame [
	
	callFramesList updateForSession: debuggingSession
]

{ #category : #accessing }
GtGemStoneExpandableDebuggerElement >> updateDisplay [ 

	self updateCallFrame.
	self updateVariables.
	self updateStdout.
]