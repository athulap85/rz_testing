Feature: Margin Values

  Scenario: Hedge Efficiency

    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
    | Instance ID | account    | symbol        | hedgeEfficiency |
    | HE_Res1     | TestAcc2   | US912810RQ31  | 1562500.0       |
    | HE_Res2     | TestAcc2   | US912810RQ31  | 3125000.0 	     |
    | HE_Res3     | TestAcc2   | US912810RQ31  | 2343750.0	     |
    | HE_Res4     | TestAcc2   | US912810RQ31  | 45000.0	     |
    | HE_Res5     | TestAcc2   | US912810RQ31  | 65000.0	     |
    | HE_Res6     | TestAcc2   | US912810RQ31  | 75000.0	     |
    | HE_Res7     | TestAcc2   | US912810RQ31  | 65000.0	     |
    | HE_Res8     | TestAcc2   | US912810RQ31  | 60000.0	     |
    | HE_Res9     | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res10    | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res11    | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res12    | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res13    | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res14    | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res15    | TestAcc2   | US912810RQ31  | -40000.0	     |
    | HE_Res16    | TestAcc2   | US912810RQ31  | 3430625.0	     |
