# HIL Status - Human-in-the-Loop Control Center

## Description
Comprehensive dashboard and configuration management for Human-in-the-Loop controls across all commands. Provides visibility into approval settings, pending operations, and HIL system health.

## Usage
```
/hil-status [options]
```

## Options

### Status and Monitoring
- `--dashboard` - **DEFAULT**: Show comprehensive HIL control dashboard
- `--pending` - Show pending approvals and their status
- `--history` - Display recent approval history and decisions
- `--metrics` - Show HIL performance metrics and success rates

### Configuration Management
- `--config` - Display current HIL configuration settings
- `--edit-config` - Interactive configuration editor
- `--validate-config` - Validate HIL configuration file
- `--reset-config` - Reset to default HIL settings

### Command-Specific Status
- `--command <command>` - Show HIL status for specific command
- `--thresholds` - Display all confidence and risk thresholds
- `--overrides` - Show active environment and operation overrides

## HIL Dashboard Display

```
🛡️ HIL (Human-in-the-Loop) Control Center
======================================================

🎯 CURRENT CONFIGURATION
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Setting                 │ Current      │ Environment     │ Status          │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ Default Approval Level  │ CONFIRM      │ Development     │ 🟢 Active       │
│ Risk Tolerance          │ Medium       │ Global          │ 🟢 Active       │
│ Auto-Execute Enabled    │ Yes          │ Dev Only        │ ⚠️ Restricted   │
│ Emergency Override      │ Enabled      │ Dev/Staging     │ 🔴 Disabled Prod│
└─────────────────────────┴──────────────┴─────────────────┴─────────────────┘

📊 COMMAND STATUS OVERVIEW
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Command                 │ HIL Mode     │ Confidence Min  │ Last Activity   │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ /typescripter          │ Analyze Only │ 85% (Auto)      │ 2 hours ago     │
│ /fixer                 │ Interactive  │ 70% (Approve)   │ 45 minutes ago  │
│ /db-migrate            │ Preview Only │ N/A (Manual)    │ 1 day ago       │
│ /ci-cd                 │ Plan Only    │ N/A (Manual)    │ 6 hours ago     │
└─────────────────────────┴──────────────┴─────────────────┴─────────────────┘

🎚️ CONFIDENCE THRESHOLDS
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Operation Type          │ Auto-Execute │ Manual Review   │ Reject Below    │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ Pattern Matching        │ ≥85%         │ 30-84%         │ <30%            │
│ Strategy Selection      │ ≥80%         │ 50-79%         │ <50%            │
│ Success Probability     │ ≥85%         │ 45-84%         │ <45%            │
│ Database Operations     │ Never        │ Always          │ <70%            │
└─────────────────────────┴──────────────┴─────────────────┴─────────────────┘

📈 PERFORMANCE METRICS (Last 30 Days)
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Metric                  │ Value        │ Trend           │ Target          │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ Approval Success Rate   │ 94.2%        │ 📈 +2.1%       │ >90%            │
│ Auto-Execute Accuracy   │ 97.8%        │ 📊 Stable      │ >95%            │
│ Average Decision Time   │ 23 seconds   │ 📉 -5s         │ <30s            │
│ Emergency Overrides     │ 2            │ 📊 Stable      │ <5/month        │
└─────────────────────────┴──────────────┴─────────────────┴─────────────────┘
```

## Pending Approvals Display

Shows all operations waiting for approval with:
- Command details and initiation time
- Risk level assessment
- Required operations and confidence scores
- Action options for approval, review, or rejection

## Configuration Management

### Interactive Configuration Editor
- Edit risk tolerance settings
- Update approval levels per command
- Configure command-specific settings
- Manage environment overrides
- Set confidence thresholds

### Configuration Validation
- Validates approval levels for production
- Checks confidence thresholds
- Identifies configuration issues
- Provides recommended fixes

## Command-Specific Status

Displays detailed HIL configuration for individual commands:
- Current mode and settings
- Auto-execute status
- Confidence thresholds
- Risk levels per operation type
- Recent activity and success rates
- Override options available

## Metrics and Analytics

### Decision Quality Metrics
- Command accuracy and precision
- User feedback scores
- Confidence calibration tracking

### Time Efficiency
- Average approval time
- Auto-execute rate
- Manual review rate
- Rejection rate

## Usage Examples

### Basic Status Check
```bash
/hil-status
# Shows comprehensive dashboard with all current settings
```

### Review Pending Operations
```bash  
/hil-status --pending
# Lists all operations waiting for approval with action options
```

### Configure Risk Tolerance
```bash
/hil-status --edit-config risk_tolerance
# Interactive editor for adjusting risk settings
```

### Command-Specific Analysis
```bash
/hil-status --command typescripter --metrics
# Detailed analysis of typescripter HIL performance
```

## Integration Features

### Audit Trail Management
- Comprehensive logging of all HIL decisions
- Approval history with user attribution
- Emergency override tracking and justification
- Performance metrics collection

### Learning Integration
- Success rate tracking per operation type
- User feedback collection and analysis
- Confidence threshold adjustment recommendations
- Pattern recognition improvement suggestions

### Team Collaboration
- Shared configuration management
- Approval delegation rules
- Knowledge base of successful patterns
- Incident response procedures