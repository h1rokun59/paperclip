# Skill: Cloud Detection

## Purpose

Design detection logic for cloud control plane and identity telemetry across AWS, GCP, and Azure. Focus on credential abuse, lateral movement between CI/CD and cloud, anomalous API activity, and artifact tampering — particularly as downstream consequences of supply chain compromise on developer machines or CI runners.

## Key Principle: Cloud Detection Starts at the Endpoint

In supply chain attacks, cloud credential abuse is a *downstream* event. The detection chain is:

```
install-script execution → secrets present in environment → exfil → cloud API abuse
```

Design cloud detections to join with endpoint signals when possible. A CloudTrail event alone may look benign; the same event correlated with a suspicious npm install 60 seconds earlier is high-confidence.

## Telemetry Sources by Platform

### AWS
- **CloudTrail**: All API calls — focus on IAM, STS, S3, ECR, Secrets Manager, SSM, Lambda, CodeBuild, CodePipeline
- **GuardDuty**: Anomaly-based findings (credential exfiltration, unusual API callers, impossible travel)
- **S3 Access Logs**: Object-level access to sensitive buckets
- **VPC Flow Logs**: Unusual outbound connections from EC2/ECS/Lambda
- **CloudWatch Logs**: Application and CI/CD logs
- **AWS Config**: Configuration change history

### GCP
- **Cloud Audit Logs** (Admin Activity + Data Access): IAM, GCS, Artifact Registry, Cloud Build, Secret Manager
- **Security Command Center**: Threat findings
- **VPC Flow Logs**: Unusual egress

### Azure
- **Azure Activity Log**: Subscription-level control plane
- **Microsoft Entra ID (AAD) Sign-in Logs**: Anomalous sign-ins, service principal activity
- **Azure Monitor / Diagnostic Logs**: Resource-specific activity
- **Microsoft Defender for Cloud**: Threat findings
- **Azure DevOps Audit Log**: Pipeline and repo changes

## Detection Patterns: Post-Supply Chain Cloud Abuse

### Pattern 1: CI/CD Identity Making Unusual API Calls
The most valuable pattern. CI runner credentials are scoped and predictable — deviation is high-signal.

```
actor:    CI service account / IAM role used by GitHub Actions / CodeBuild / Cloud Build
anomaly:  API call to IAM (CreateUser, AttachUserPolicy, CreateAccessKey)
        | API call to STS (AssumeRole to unexpected role)
        | API call to Secrets Manager / SSM GetParameter for secrets not used in normal pipeline
        | API call to ECR / Artifact Registry PutImage outside normal deploy window
baseline: compare against last 30 days of same identity's API call distribution
```

### Pattern 2: Credential Use from Unexpected Source IP
```
actor:    known CI service account or developer IAM identity
anomaly:  API call from IP not in known CI/CD infrastructure ranges
        | API call from IP in threat intel feed (actor C2)
        | API call from foreign country/ASN inconsistent with team location
```

### Pattern 3: Secrets Access Spike After Install Event
```
sequence:
  1. npm install executes on CI runner (endpoint signal)
  2. Within 5 minutes: Secrets Manager / SSM GetParameter spikes for that runner's identity
  3. Within 10 minutes: unusual outbound connection or artifact push
```

### Pattern 4: Artifact Tampering
```
actor:    CI identity
anomaly:  ECR PutImage | S3 PutObject to release bucket | npm publish
        at unexpected time | by unexpected identity | without corresponding pipeline execution
```

### Pattern 5: IAM Persistence
```
events:   CreateUser | CreateAccessKey | AttachUserPolicy | PutUserPolicy
        | AddUserToGroup (admin group) | CreateRole with trust policy change
actor:    CI identity (should never do this in normal operation)
```

## Query Pseudo-Logic Examples

### CloudTrail: CI identity making IAM calls (KQL / Athena SQL)
```sql
SELECT eventTime, userIdentity.arn, eventName, sourceIPAddress
FROM cloudtrail_logs
WHERE userIdentity.arn LIKE '%github-actions%'
  AND eventSource = 'iam.amazonaws.com'
  AND eventName IN ('CreateUser','CreateAccessKey','AttachUserPolicy','PutUserPolicy')
ORDER BY eventTime DESC
```

### CloudTrail: Secrets Manager access spike
```sql
SELECT DATE_TRUNC('minute', eventTime) AS minute,
       userIdentity.arn,
       COUNT(*) AS api_calls
FROM cloudtrail_logs
WHERE eventSource = 'secretsmanager.amazonaws.com'
  AND eventName = 'GetSecretValue'
GROUP BY 1, 2
HAVING COUNT(*) > (SELECT AVG(daily_calls) * 3 FROM baseline_table)
```

## Cross-Cloud Consistency Rule

When a CI pipeline has credentials for multiple cloud providers (common in multi-cloud shops), design detections for all providers present. An attacker exfiltrating CI environment variables gets all cloud credentials simultaneously — a detection that only covers AWS misses GCP and Azure abuse from the same initial access.

## Joining Cloud and Endpoint Signals

Always note when a cloud detection should be joined with an endpoint signal for higher confidence:

| Cloud Signal | Join With | Uplift |
|---|---|---|
| Unusual Secrets Manager access | npm install on CI runner at same time | Low-confidence → High |
| ECR push outside deploy window | Suspicious process chain on build host | Medium → Confirmed |
| IAM CreateAccessKey by CI identity | C2 network callout from CI runner | High → Incident |
