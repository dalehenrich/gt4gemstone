Class {
	#name : #GtGemstoneEvaluationWithExceptionResult,
	#superclass : #GtGemstoneEvaluationResult,
	#instVars : [
		'evaluationContext'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #testing }
GtGemstoneEvaluationWithExceptionResult >> canHandleSpecificDebugger [
	^ true
]

{ #category : #accessing }
GtGemstoneEvaluationWithExceptionResult >> computedResult [
	^ self evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationWithExceptionResult >> evaluationContext [
	^ evaluationContext
]

{ #category : #accessing }
GtGemstoneEvaluationWithExceptionResult >> evaluationContext: aGemStoneEvaluationContext [
	evaluationContext := aGemStoneEvaluationContext
]

{ #category : #'initialization ' }
GtGemstoneEvaluationWithExceptionResult >> gtPharoProxyInitializeWithSession: aGemStoneSession [
	evaluationContext gtPharoProxyInitializeWithSession: aGemStoneSession
]

{ #category : #testing }
GtGemstoneEvaluationWithExceptionResult >> hasEvaluationException [
	^ true
]

{ #category : #'initialization ' }
GtGemstoneEvaluationWithExceptionResult >> initializeFromJSONDictionary: aDictionary [
	super initializeFromJSONDictionary: aDictionary.
	
	aDictionary 
		at: 'evaluationContextProxy' 
		ifPresent: [ :anObject |
			evaluationContext := anObject ]
]