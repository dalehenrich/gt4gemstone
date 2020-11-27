building
compose
	super compose.
	self title: [:anObject | 
		'Gemstone Inspector - RSR - on ', 
		(self printObjectAsAnItem: anObject)].
	self color: (Color blue muchDarker alpha: 0.4). 
	self dynamicActions: [ 
		self inspectorService globalToolbarActions ]