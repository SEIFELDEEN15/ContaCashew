> [🌎 Easy Localization] [WARNING] Localization key [portfolio-performance] not found
> [🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-performance] not found
> ══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
> The following assertion was thrown while finalizing the widget tree:
> Duplicate GlobalKeys detected in widget tree.
> The following GlobalKeys were specified multiple times in the widget tree. This will lead to parts
> of the widget tree being truncated unexpectedly, because the second time a key is seen, the previous
> instance is moved to the new location. The keys were:

- [LabeledGlobalKey<_OverlayEntryWidgetState>#14f47]
  [LabeledGlobalKey<_OverlayEntryWidgetState>#8b306]
  This was determined by noticing that after widgets with the above global keys were moved out of
  their previous parent, that previous parent never updated during this frame, meaning that it either
  did not update at all or updated before the widgets were moved, in either case implying that it
  still thinks that it should have a child with those global keys.
  The specific parent that did not update after having one or more children forcibly removed due to
  GlobalKey reparenting is:
- \_Theater(skipCount: 0, dependencies: [Directionality], renderObject: \_RenderTheater#49ad6
  NEEDS-LAYOUT NEEDS-COMPOSITING-BITS-UPDATE DETACHED)
  A GlobalKey can only be specified on one widget at a time in the widget tree.

When the exception was thrown, this was the stack:
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 274:3 throw_
package:flutter/src/widgets/framework.dart 3354:15 <fn>
package:flutter/src/widgets/framework.dart 3378:16 finalizeTree
package:flutter/src/widgets/binding.dart 1266:7 drawFrame
package:flutter/src/rendering/binding.dart 495:5 [_handlePersistentFrameCallback]
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
package:flutter/src/scheduler/binding.dart 1434:7 [_invokeFrameCallback]
package:flutter/src/scheduler/binding.dart 1347:9 handleDrawFrame
package:flutter/src/scheduler/binding.dart 1057:9 <fn>
lib/\_engine/engine/frame_service.dart 145:9 <fn>
dart-sdk/lib/async/zone.dart 1517:47 \_rootRun
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
dart-sdk/lib/async/zone.dart 1422:19 run
dart-sdk/lib/async/zone.dart 1321:7 runGuarded
dart-sdk/lib/async/zone.dart 1362:23 <fn>
dart-sdk/lib/async/zone.dart 1525:13 \_rootRun
dart-sdk/lib/\_internal/js_dev_runtime/private/ddc_runtime/operations.dart 118:77 tear
dart-sdk/lib/async/zone.dart 1422:19 run
dart-sdk/lib/async/zone.dart 1345:23 <fn>
dart-sdk/lib/\_internal/js_dev_runtime/private/isolate_helper.dart 47:11 internalCallback
════════════════════════════════════════════════════════════════════════════════════════════════════
Performing hot reload... 17,7s
Reloaded application in 17.741ms.
Another exception was thrown: Assertion failed: file:///C:/flutter/packages/flutter/lib/src/widgets/framework.dart:6322:14
Starting application from main method in: org-dartlang-app:/web_entrypoint.dart.
[🌎 Easy Localization] [DEBUG] Localization initialized
Found user settings on file
App settings loaded: if logging is enabled, logs will now be captured
[🌎 Easy Localization] [DEBUG] Start
[🌎 Easy Localization] [DEBUG] Init state
[🌎 Easy Localization] [DEBUG] Build
[🌎 Easy Localization] [DEBUG] Init Localization Delegate
[🌎 Easy Localization] [DEBUG] Init provider
Rebuilt Material App
[🌎 Easy Localization] [DEBUG] Load Localization Delegate
Initial Locale: it
App Settings Locale: System
Set Locale: it
[🌎 Easy Localization] [DEBUG] Load asset from assets/translations/generated
Initial Locale: en
App Settings Locale: System
Set Locale: en
[🌎 Easy Localization] [DEBUG] Load asset from assets/translations/generated
[🌎 Easy Localization] [DEBUG] Build
[🌎 Easy Localization] [DEBUG] Init Localization Delegate
[🌎 Easy Localization] [DEBUG] Init provider
Rebuilt Material App
Notification payload: null
Initializing local months: [gennaio, febbraio, marzo, aprile, maggio, giugno, luglio, agosto, settembre, ottobre, novembre, dicembre]
Running All Cloud Functions
Getting exchange rates for current wallets
Automatically paid subscriptions with iteration: null
Automatically paid upcoming transactions
Entire app loaded
[🌎 Easy Localization] [WARNING] Localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Localization key [no-investment-data] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [no-investment-data] not found
[�� Easy Localization] [WARNING] Localization key [investment-type-stock] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [investment-type-stock] not found
[🌎 Easy Localization] [WARNING] Localization key [investment-type-etf] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [investment-type-etf] not found
[�� Easy Localization] [WARNING] Localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Localization key [no-investment-data] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [no-investment-data] not found
[🌎 Easy Localization] [WARNING] Localization key [investment-type-stock] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [investment-type-stock] not found
[🌎 Easy Localization] [WARNING] Localization key [investment-type-etf] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [investment-type-etf] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[�� Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-weight] not found
[🌎 Easy Localization] [WARNING] Localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Localization key [no-investment-data] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [no-investment-data] not found
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following \_TypeError was thrown building Container(bg: BoxDecoration(color: Color(alpha: 0.2000,
red: 0.7412, green: 0.7804, blue: 0.8627, colorSpace: ColorSpace.sRGB), border:
Border.all(BorderSide(color: Color(alpha: 1.0000, red: 0.2667, green: 0.2667, blue: 0.2667,
colorSpace: ColorSpace.sRGB), width: 2.0)), borderRadius: BorderRadiusDirectional.circular(15.0))):
TypeError: null: type 'Null' is not a subtype of type 'String'

The relevant error-causing widget was:
AnimatedContainer
AnimatedContainer:file:///C:/Users/zavat/Desktop/Progetti/ContaCashew/budget/lib/widgets/outlinedButtonStacked.dart:166:12

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
package:flutter/src/rendering/object.dart 1206:7 [_enableMutationsToDirtySubtrees]
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
package:flutter/src/rendering/binding.dart 495:5 [_handlePersistentFrameCallback]
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

════════════════════════════════════════════════════════════════════════════════════════════════════
[🌎 Easy Localization] [WARNING] Localization key [portfolio-performance] not found
[🌎 Easy Localization] [WARNING] Fallback localization key [portfolio-performance] not found
Another exception was thrown: Assertion failed: file:///C:/flutter/packages/flutter/lib/src/widgets/framework.dart:6171:14

● Ci sono ancora problemi. Il principale è che le traduzioni aggiunte al CSV non sono state rigenerate nei file JSON. Inoltre c'è un errore TypeError. Risolviamo:

● Bash(cd "C:\Users\zavat\Desktop\Progetti\ContaCashew\budget\assets\translations" && ls -la)
⎿ total 2260
drwxr-xr-x 1 zavat 197609 0 nov 15 12:49 .
drwxr-xr-x 1 zavat 197609 0 nov 15 12:49 ..
… +3 lines (ctrl+o to expand)

● Bash(cd "C:\Users\zavat\Desktop\Progetti\ContaCashew\budget\assets\translations" && python generate-translations.py) timeout: 30s
⎿ Error: Exit code 1
Traceback (most recent call last):
File "C:\Users\zavat\Desktop\Progetti\ContaCashew\budget\assets\translations\generate-translations.py", line 4, in <module>
import requests
ModuleNotFoundError: No module named 'requests'

● Bash(pip install requests 2>&1 | head -20) timeout: 1m 0s
⎿ Defaulting to user installation because normal site-packages is not writeable
Collecting requests
Downloading requests-2.32.5-py3-none-any.whl.metadata (4.9 kB)
… +20 lines (ctrl+o to expand)

● Bash(cat >> "C:\Users\zavat\Desktop\Progetti\ContaCashew\budget\assets\translations\translations.csv" << 'EOF'
"portfolio-weight","Portfolio Weight","","","","","","…)
⎿ (No content)

● Bash(cd "C:\Users\zavat\Desktop\Progetti\ContaCashew\budget\assets\translations" && python generate-translations.py 2>&1 | head -50) timeout: 1m 0s
⎿ Downloading CSV...
CSV file downloaded successfully
Reading C:\Users\zavat\Desktop\Progetti\ContaCashew\budget\assets\translations\translations.csv
… +47 lines (ctrl+o to expand)
⎿ Session limit reached ∙ resets 7am
/upgrade to increase your usage limit.
