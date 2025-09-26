CLAIM_ID="CL001"
POLICY_NUMBER="LIAB-AUTO-001"
curl -sS -X POST "http://127.0.0.1:8000/process-claim"   -H "Content-Type: application/json"   -d "{\"claimId\":\"$CLAIM_ID\",\"policyNumber\":\"$POLICY_NUMBER\"}"