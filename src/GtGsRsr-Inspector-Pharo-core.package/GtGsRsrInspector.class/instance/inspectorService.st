building
inspectorService
	^ self entity ifNotNil: [ :anInspectorProxy |
		anInspectorProxy inspectorService  ]