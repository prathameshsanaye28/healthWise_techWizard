// Dart imports:
import 'dart:math' as math;

const int yourAppID = 402685065;
const String yourAppSign =
    "48d097f84d5c48a0cc30a58d08c4aca04303d8508e4f42db7a1d6d513958efef";

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

/// Users who use the same callID can in the same call.
const String callID = 'group_call_id';
