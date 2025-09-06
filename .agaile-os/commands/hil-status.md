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

@include shared/hil-patterns.yml#HIL_Framework

## Implementation

### HIL Dashboard Display

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

⚡ RECENT ACTIVITY
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Timestamp               │ Command      │ Operation       │ User Decision   │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ 2025-01-09 14:30:15    │ /typescripter│ Strategy Exec   │ ✅ Approved     │
│ 2025-01-09 12:45:22    │ /fixer       │ Cache Clear     │ ✅ Auto-Execute │
│ 2025-01-09 09:15:07    │ /db-migrate  │ Schema Preview  │ 👁️ Reviewed    │
│ 2025-01-08 16:20:33    │ /ci-cd       │ Rollback Plan   │ 📋 Generated    │
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

🔒 SAFETY STATUS
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Safety Feature          │ Status       │ Environment     │ Last Check      │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ Audit Logging          │ ✅ Enabled   │ All             │ Real-time       │
│ Backup Verification    │ ✅ Enabled   │ Prod/Staging    │ Daily           │
│ Emergency Override     │ ⚠️ Controlled│ Dev Only        │ N/A             │
│ Production Protection  │ ✅ Enabled   │ Production      │ Always          │
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

🎛️ QUICK ACTIONS
1️⃣  **Adjust Risk Tolerance**: `/hil-status --edit-config risk_tolerance`
2️⃣  **Review Pending Approvals**: `/hil-status --pending`
3️⃣  **Check Command Settings**: `/hil-status --command typescripter`
4️⃣  **View Detailed Metrics**: `/hil-status --metrics --verbose`

⚙️ CONFIGURATION PATH: .claude/hil-config.yml
📊 METRICS LOG: .claude/hil-metrics.log
📋 AUDIT TRAIL: .claude/hil-audit.log
```

### Pending Approvals Display

```
⏳ PENDING HIL APPROVALS
========================

🚨 **URGENT** - Production Database Migration
┌─────────────────────────────────────────────────────────────────┐
│ Command: /db-migrate --env prod --from-spec                     │
│ Initiated: 2025-01-09 15:30:22                                │
│ Risk Level: HIGH (82/100)                                     │
│ Operations: CREATE TABLE, ADD CONSTRAINT                       │
│ Approval Required: APPROVE + Manual Confirmation              │
│                                                               │
│ Actions:                                                       │
│ • Approve: /db-migrate --approve-migration --env prod --confirm│
│ • Review: /db-migrate --plan-only --env prod                  │
│ • Reject: /hil-status --reject-pending db-migrate-001         │
└─────────────────────────────────────────────────────────────────┘

⚠️  **MEDIUM** - TypeScript Error Resolution
┌─────────────────────────────────────────────────────────────────┐
│ Command: /typescripter --approve-strategy                      │
│ Initiated: 2025-01-09 14:45:10                                │
│ Risk Level: MEDIUM (45/100)                                   │
│ Strategies: Database sync, Build fixes, Linting               │
│ Confidence: 87% (Database), 78% (Build), 61% (Linting)       │
│                                                               │
│ Actions:                                                       │
│ • Approve All: /typescripter --approve-strategy --confirm      │
│ • Selective: /typescripter --approve-strategy --strategies=db  │
│ • Review Plan: /typescripter --plan                           │
└─────────────────────────────────────────────────────────────────┘

ℹ️  **LOW** - Cache Cleanup
┌─────────────────────────────────────────────────────────────────┐
│ Command: /fixer --type cache --approve-fixes                   │
│ Initiated: 2025-01-09 16:02:15                                │
│ Risk Level: LOW (15/100)                                      │
│ Operations: Clear Next.js cache, Clear node_modules cache     │
│ Confidence: 95% (Very High)                                   │
│                                                               │
│ Actions:                                                       │
│ • Auto-Execute: /fixer --auto-execute --confidence-threshold 90│
│ • Manual Execute: /fixer --approve-fixes --confirm            │
└─────────────────────────────────────────────────────────────────┘

**Total Pending:** 3 operations | **Average Wait Time:** 8 minutes
**Oldest Pending:** 47 minutes | **Requires Immediate Attention:** 1
```

### Configuration Management

#### **Interactive Configuration Editor**
```typescript
interface HILConfigEditor {
  editRiskTolerance(): Promise<void>;
  updateApprovalLevels(): Promise<void>;
  configureCommandSettings(): Promise<void>;
  manageEnvironmentOverrides(): Promise<void>;
  setConfidenceThresholds(): Promise<void>;
}

class HILConfigManager {
  async editConfiguration(section: string): Promise<void> {
    const config = await this.loadConfig();
    
    switch (section) {
      case 'risk_tolerance':
        return this.editRiskTolerance(config);
      case 'approval_levels':
        return this.editApprovalLevels(config);
      case 'thresholds':
        return this.editThresholds(config);
      case 'commands':
        return this.editCommandSettings(config);
    }
  }
  
  async validateConfiguration(): Promise<ValidationResult> {
    const config = await this.loadConfig();
    const issues: ConfigIssue[] = [];
    
    // Validate approval levels
    if (config.production.approval_level !== 'APPROVE') {
      issues.push({
        severity: 'ERROR',
        message: 'Production must require APPROVE level',
        fix: 'Set environment_overrides.production.approval_level to "APPROVE"'
      });
    }
    
    // Validate confidence thresholds
    if (config.confidence_thresholds.auto_execute_threshold < 70) {
      issues.push({
        severity: 'WARNING',
        message: 'Auto-execute threshold below recommended minimum',
        fix: 'Consider raising to 70% or higher'
      });
    }
    
    return {
      valid: issues.filter(i => i.severity === 'ERROR').length === 0,
      issues
    };
  }
}
```

### Command-Specific Status

#### **TypeScripter HIL Status**
```
🔍 /typescripter HIL Configuration
==================================

**Current Mode:** Analyze Only (Default: Safe)
**Auto-Execute:** Disabled (Requires --auto-execute flag)
**Confidence Threshold:** 85% (High)
**Strategy Approval:** Required for all strategies

**Risk Levels:**
• Database Operations: HIGH → Requires APPROVE
• Build Fixes: MEDIUM → Requires CONFIRM  
• Linting: LOW → Requires NOTIFY

**Recent Activity:**
• Last Run: 2 hours ago (Strategy approved, 3/4 phases executed)
• Success Rate: 96% (Last 30 days)
• Average Confidence: 82%
• User Satisfaction: High

**Override Options:**
• Emergency Override: Available (dev environments only)
• Confidence Adjustment: 70-95% range
• Phase Checkpoints: Enabled
```

### Metrics and Analytics

```
📊 HIL PERFORMANCE ANALYTICS
============================

**Decision Quality Metrics**
┌─────────────────────────┬──────────────┬─────────────────┬─────────────────┐
│ Command                 │ Accuracy     │ Precision       │ User Feedback   │
├─────────────────────────┼──────────────┼─────────────────┼─────────────────┤
│ /typescripter          │ 97.2%        │ 94.5%          │ 4.8/5.0         │
│ /fixer                 │ 89.1%        │ 87.3%          │ 4.2/5.0         │
│ /db-migrate            │ 98.9%        │ 96.1%          │ 4.9/5.0         │
│ /ci-cd                 │ 94.7%        │ 92.8%          │ 4.5/5.0         │
└─────────────────────────┴──────────────┴─────────────────┴─────────────────┘

**Confidence Calibration**
• Over-Confident Predictions: 5.3% (Target: <10%)
• Under-Confident Predictions: 12.1% (Target: <15%)
• Calibration Score: 0.87 (Target: >0.85)

**Time Efficiency**
• Average Approval Time: 23 seconds (Down from 31 seconds)
• Auto-Execute Rate: 34% (Target: 30-40%)
• Manual Review Rate: 58% (Target: 50-60%)
• Rejection Rate: 8% (Target: <10%)
```

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

### Configuration Validation
```bash
/hil-status --validate-config
# Checks HIL configuration for issues and provides fixes
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

This HIL Status command provides complete visibility and control over the Human-in-the-Loop system, ensuring users can monitor, configure, and optimize their approval workflows while maintaining security and operational efficiency.