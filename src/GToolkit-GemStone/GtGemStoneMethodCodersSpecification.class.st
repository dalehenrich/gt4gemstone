Class {
	#name : #GtGemStoneMethodCodersSpecification,
	#superclass : #GtGemStoneCoderSpecification,
	#instVars : [
		'methodCoderSpecifications'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneMethodCodersSpecification class >> forGsMethods: aCollection [ 
	^ self new 
		initializeForGsMethods: aCollection 
]

{ #category : #accessing }
GtGemStoneMethodCodersSpecification >> asDictionaryForExport [

	^ super asDictionaryForExport
		at: #methodCoderSpecifications put: (methodCoderSpecifications
			collect: [ :aMethodCoderSpecification |
				aMethodCoderSpecification asDictionaryForExport]);
		yourself
]

{ #category : #accessing }
GtGemStoneMethodCodersSpecification >> initializeForGsMethods: aCollectionOfGsMethods [
	methodCoderSpecifications := aCollectionOfGsMethods asArray 
		collect: [ :aGsMethod |
			GtGemStoneMethodCoderSpecification forGsMethod: aGsMethod ]
]

{ #category : #accessing }
GtGemStoneMethodCodersSpecification >> initializeFromJSONDictionary: aDictionary [
	methodCoderSpecifications := (aDictionary at: #methodCoderSpecifications)
		collect: [ :aMethodCoderJsonData  |
			GtGemStoneMethodCoderSpecification  fromJSONDictionary: aMethodCoderJsonData]
]

{ #category : #accessing }
GtGemStoneMethodCodersSpecification >> methodCoderSpecifications [
	^ methodCoderSpecifications
]