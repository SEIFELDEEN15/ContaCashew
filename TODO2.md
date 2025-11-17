pagina investments:

- la card total porfolio value e card di lista investments devono avere larghezza e margin e padding giusta , come le altre card hanno
- coingeko non l'hai implemtato in investimenti e yahoo finance non va e da
  Error searching Yahoo Finance: ClientException: Failed to fetch,
  uri=https://query1.finance.yahoo.com/v1/finance/search?q=bitcoin&quotesCount=10
  inoltre in fase di aggiunta del investimento deve esserci la possibilita di linkare con un valore di yahoofinance o coingeko, come in pagina di modifica
- le varie categorie di investimento non devono avere tutte stesa icona, differenziale , nel diagramma a torta hanno tutte stessa icona
- dopo che clicco tasto add investment e csi è creato correttmanete l'investimento deve chiuder ela pagina di aggiunta dell'investimento
- aggiungi le traduzioni mancanti in investments pagina
- selezione periodo da errore: ══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
  The following \_TypeError was thrown building Container(bg: BoxDecoration(color: Color(alpha: 0.0000,
  red: 0.0000, green: 0.0000, blue: 0.0000, colorSpace: ColorSpace.sRGB), border:
  Border.all(BorderSide(color: Color(alpha: 1.0000, red: 0.2667, green: 0.2667, blue: 0.2667,
  colorSpace: ColorSpace.sRGB), width: 2.0)), borderRadius: BorderRadiusDirectional.circular(15.0))):
  TypeError: null: type 'Null' is not a subtype of type 'String'

The relevant error-causing widget was:
AnimatedContainer
AnimatedContainer:file:///C:/Users/zavat/Desktop/Progetti/ContaCashew/budget/lib/widgets/outlinedButtonStacke
d.dart:166:12

When the exception was thrown, this was the stack:
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 274:3 throw_
dart-sdk/lib/\_internal/js_shared/lib/rti.dart 1717:3 \_asString
package:budget/widgets/periodCyclePicker.dart 226:34 initState
package:flutter/src/widgets/framework.dart 5852:55 [_firstBuild]
package:flutter/src/widgets/framework.dart 5699:5 mount
... Normal element mounting (4 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (4 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (179 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (13 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (21 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (18 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (12 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (10 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (329 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (95 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 7169:36 inflateWidget
package:flutter/src/widgets/framework.dart 7185:32 mount
... Normal element mounting (7 frames)
package:flutter/src/widgets/framework.dart 4548:15 inflateWidget
package:flutter/src/widgets/framework.dart 4004:18 updateChild
package:flutter/src/widgets/layout_builder.dart 248:18 updateChildCallback
package:flutter/src/widgets/framework.dart 3046:11 buildScope
package:flutter/src/widgets/layout_builder.dart 271:5 [_rebuildWithConstraints]  
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/widgets/layout_builder.dart 334:28 layoutCallback
package:flutter/src/rendering/object.dart 4156:33 <fn>
package:flutter/src/rendering/object.dart 2881:9 <fn>
package:flutter/src/rendering/object.dart 1206:7
[_enableMutationsToDirtySubtrees]
package:flutter/src/rendering/object.dart 2880:7 invokeLayoutCallback
package:flutter/src/rendering/object.dart 4156:5 runLayoutCallback
package:flutter/src/widgets/layout_builder.dart 448:5 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/shifted_box.dart 243:5 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/layout_helper.dart 62:10 layoutChild
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/rendering/stack.dart 645:43 [_computeSize]
package:flutter/src/rendering/stack.dart 672:12 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/proxy_box.dart 3848:13 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/widgets/overlay.dart 1085:12 layoutChild
package:flutter/src/widgets/overlay.dart 1430:9 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/proxy_box.dart 115:10 <fn>
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/layout_helper.dart 62:10 layoutChild
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/rendering/stack.dart 645:43 [_computeSize]
package:flutter/src/rendering/stack.dart 672:12 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/layout_helper.dart 62:10 layoutChild
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/rendering/flex.dart 1203:26 [_computeSizes]
package:flutter/src/rendering/flex.dart 1257:32 performLayout
package:flutter/src/rendering/object.dart 2762:7 layout
package:flutter/src/rendering/layout_helper.dart 62:10 layoutChild
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/rendering/stack.dart 645:43 [_computeSize]
package:flutter/src/rendering/stack.dart 672:12 performLayout
package:flutter/src/rendering/object.dart 2610:7 [_layoutWithoutResize]  
package:flutter/src/rendering/object.dart 1157:17 flushLayout
package:flutter/src/rendering/object.dart 1170:14 flushLayout
package:flutter/src/rendering/binding.dart 629:5 drawFrame
package:flutter/src/widgets/binding.dart 1261:13 drawFrame
package:flutter/src/rendering/binding.dart 495:5
[_handlePersistentFrameCallback]
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/scheduler/binding.dart 1434:7 [_invokeFrameCallback]  
package:flutter/src/scheduler/binding.dart 1347:9 handleDrawFrame
package:flutter/src/scheduler/binding.dart 1200:5 [_handleDrawFrame]
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
lib/\_engine/engine/platform_dispatcher.dart 1522:5 invoke
lib/\_engine/engine/platform_dispatcher.dart 265:5 invokeOnDrawFrame
lib/\_engine/engine/frame_service.dart 192:32 [_renderFrame]
lib/\_engine/engine/frame_service.dart 99:9 <fn>
dart-sdk/lib/async/zone.dart 1546:13 \_rootRunUnary
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
dart-sdk/lib/async/zone.dart 1429:19 runUnary
dart-sdk/lib/async/zone.dart 1350:26 <fn>
dart-sdk/lib/\_internal/js_dev_runtime/patch/js_allow_interop_patch.dart 224:27 \_callDartFunctionFast1

════════════════════════════════════════════════════════════════════════════════════════════════

- inoltre come collego il login con google , cosa devo creare?
