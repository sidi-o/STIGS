# STIGS

## STIG Remediation Methodology

Each STIG remediation in this repository follows a structured
assessment, remediation, and validation workflow.

### 1. Baseline Assessment

Scan the Windows 11 VM using the applicable Windows 11 STIG Audit Policy.

Review the scan results and select a STIG control to remediate.

### 2. Manual Remediation

Analyze the selected STIG requirement and determine how it can be
implemented manually.

Implement the required configuration on the test VM.

### 3. Initial Validation

Run a new STIG scan to verify that the manual remediation was
successful.

The expected result is a **PASS** for the selected STIG control.

### 4. Reproduce the Initial Failure

After successful validation, revert the manual remediation and run
another STIG scan.

The expected result is a **FAIL**, confirming that the selected
configuration directly affects the STIG check.

Where applicable, registry changes are documented or exported before
being reverted to preserve the configuration details for analysis.

### 5. PowerShell Remediation

Develop a PowerShell-based remediation script that reproduces the
required security configuration.

The implementation may use Microsoft documentation, STIG documentation,
local testing, and AI-assisted analysis where appropriate.

The script is then tested against the same Windows 11 VM.

### 6. Automated Validation

Run the Windows 11 STIG scan again after executing the PowerShell
remediation.

The expected result is a **PASS** for the selected STIG control.

### 7. Documentation

Document the complete remediation process, including:

- STIG ID and security requirement
- Initial audit result
- Manual remediation
- Manual validation
- Reverted/failure validation
- PowerShell remediation
- Final validation
- Relevant screenshots and evidence

### 8. Publication

Publish the tested PowerShell remediation and supporting documentation
to GitHub.

The completed remediation is also recorded in the project's experience
tracking spreadsheet.
