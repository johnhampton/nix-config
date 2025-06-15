## Iterative Implementation with Review Cycles

**Target Artifact (TA)**: `$ARGUMENTS`  
*(May be a prompt, file path, API spec—anything.)*

---

### 0 · Extended-Thinking Mandate 🚀
All agents—implementer **and** reviewers—must  
1. **Think step-by-step internally**, mapping plans, edge cases, and hidden risks.  
2. **Expose only concise rationales or summaries** in outputs (never raw chain-of-thought).  

---

### 1 · Initial Implementation  
* Engage extended thinking to plan before coding.  
* Produce a working TA that meets every stated requirement.

### 2 · Three Independent Reviews (parallel, separate Task agents)  
Each reviewer uses extended thinking on its focus area, receiving **only** the TA plus its checklist:

| Review | Focus |
|--------|-------|
| **R1 – Coverage & Completeness** | Requirements met, adequate tests, edge cases handled. |
| **R2 – Code Quality** | Correctness, type safety, error handling, idiomatic patterns. |
| **R3 – Business Logic** | Domain rules, invariants, stakeholder goals. |

### 3 · Review Analysis  
* Aggregate findings from R1–R3.  
* Summarize reasoning (no raw chain-of-thought).

### 4 · Fix Phase  
If any review flags issues:  
1. Apply extended thinking to address every finding.  
2. Update the TA.  
3. Loop back to **Step 2** for a full rereview.

### 5 · Completion Criteria  
Declare the TA complete only when the latest R1, R2, and R3 all report **zero issues** and requirements are satisfied.

---

### Operational Rules
* Reviewers remain isolated until Analysis (no note leakage).  
* Repeat 2 → 3 → 4 until all reviews are clean.  
* For phased work, run the full loop on each phase before starting the next.  
* Optional safeguard: escalate to a human after **N = 3** unsuccessful cycles.

### Required Outputs per Cycle
1. **Diff / artifact** of the updated TA.  
2. **Test results** (pass/fail summary).  
3. **Reviewer summaries** (one per review).  
4. **Status JSON**: `{ "cycle": n, "status": "pass" | "rework", "notes": [...] }`.

On the first clean cycle respond: **“✅ Target Artifact complete.”**
