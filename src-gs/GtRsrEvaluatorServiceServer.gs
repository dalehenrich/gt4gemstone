fileformat 8bit
set sourcestringclass String

set compile_env: 0
! ------------------- Class definition for GtRsrEvaluatorServiceServer
expectvalue /Class
doit
GtRsrEvaluatorService subclass: 'GtRsrEvaluatorServiceServer'
  instVarNames: #()
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: Globals
  options: #()

%
expectvalue /Class
doit
GtRsrEvaluatorServiceServer category: 'GToolkit-GemStone'
%
! ------------------- Remove existing behavior from GtRsrEvaluatorServiceServer
expectvalue /Metaclass3
doit
GtRsrEvaluatorServiceServer removeAllMethods.
GtRsrEvaluatorServiceServer class removeAllMethods.
%
set compile_env: 0
! ------------------- Class methods for GtRsrEvaluatorServiceServer
! ------------------- Instance methods for GtRsrEvaluatorServiceServer
category: '*GToolkit-GemStone-GemStone'
method: GtRsrEvaluatorServiceServer
evaluate: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result"
	| method result receiver symbolDictionary bindings |

	receiver := anObject class == GtRsrProxyServiceServer
		ifTrue: [ anObject object ]
		ifFalse: [ anObject ].
	symbolDictionary := SymbolDictionary new.
	symbolDictionary addAll: aDictionary.
	bindings := GsCurrentSession currentSession symbolList, (Array with: symbolDictionary).

	method := aString _compileInContext: receiver symbolList: bindings.
	result := method _executeInContext: receiver.

	Transcript
		nextPutAll: '1.1: ';
		show: result;
		lf.
	"Answer either an immediate value or a proxy to the object"
	result := (self isRsrImmediate: result)
		ifTrue: [ result ]
		ifFalse: [ GtRsrProxyServiceServer object: result ].
	Transcript
		nextPutAll: '2: ';
		show: result;
		lf.

	^ result
%
category: '*GToolkit-GemStone-GemStone'
method: GtRsrEvaluatorServiceServer
evaluateAndWait: aString for: anObject bindings: aDictionary
	"Evaluate the receiver's script, answering the result.
	 On the server it is always synchronous"

	^ self evaluate: aString for: anObject bindings: aDictionary
%
category: '*GToolkit-GemStone-GemStone'
method: GtRsrEvaluatorServiceServer
isRsrImmediate: anObject
	"Answer a boolean indicating whether the supplied object is considered a primitive type, meaining:
	- it has an RSR service mapping, or
	- it is a service object"

	^ (RsrReference referenceMapping includesKey: anObject class) or:
		[ anObject isKindOf: RsrService ]
%