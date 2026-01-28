---
name: documenting-with-diataxis
description: Use when writing documentation, tutorials, guides, or technical references. Covers the Diataxis framework's four documentation types and helps identify which type to write.
---

# Documenting with Diataxis

## Overview

Diataxis organizes documentation into four types based on user needs, not author convenience. Each type serves a distinct purpose and requires a different writing approach. Mixing types creates documentation that fails at all purposes. This skill helps identify which type to write and how to write it well.

## When to Use

- Writing documentation for a feature, API, or system
- Creating tutorials or learning materials
- Writing how-to guides for specific tasks
- Drafting technical reference material
- Reviewing documentation for structure issues
- Deciding what kind of documentation a topic needs

## The Four Types

| Type | Orientation | User Need | Key Question |
|------|-------------|-----------|--------------|
| **Tutorial** | Learning | Acquiring skills | "Help me learn" |
| **How-to Guide** | Task | Accomplishing goals | "Help me do X" |
| **Reference** | Information | Looking up facts | "Help me find Y" |
| **Explanation** | Understanding | Gaining insight | "Help me understand why" |

## Core Pattern: Recommend and Confirm the Type

Before writing any documentation:

**Step 1: Analyze the request** using these signals:

| Signal | Suggests |
|--------|----------|
| "How do I...", "I need to...", specific task mentioned | How-to Guide |
| Audience is beginners, learning new concepts | Tutorial |
| "What is...", "What does X do", API/config details | Reference |
| "Why does...", design decisions, background context | Explanation |

**Step 2: Confirm with user** via `AskUserQuestion`:

> "Based on [brief analysis], this sounds like a **[recommended type]** - [one-line description of that type]. Is that right?"
>
> - **[Recommended type]** (Recommended): [Why this fits]
> - **Tutorial**: Teaching someone new through hands-on steps
> - **How-to Guide**: Helping a competent user accomplish a specific task
> - **Reference**: Providing technical details for lookup
> - **Explanation**: Providing context, history, or rationale

If the topic spans multiple types, note this and ask which to write first.

One topic often needs multiple documents of different types. That's correct - write them separately, don't combine them.

## Tutorial Guidelines

**Purpose**: Guide a learner through a concrete experience that builds skills.

**Orientation**: Learning-oriented. The reader is a student; you are the tutor.

**Voice**: Use "we" language. "Now we'll create a configuration file."

**Structure**:
1. Show the end goal upfront
2. Deliver visible results early and often
3. Every step must produce an observable outcome
4. Prepare readers for what they'll see next
5. Point out what readers should notice

**Include**:
- Concrete, particular steps (not abstractions)
- Reversible tasks where possible (for practice)
- Confirmation of expected results at each step

**Exclude**:
- Explanations (link to them instead)
- Choices or alternatives
- Information beyond what's needed for this step

**Quality check**: Could a beginner follow this without getting stuck? Every step must work exactly as described.

## How-to Guide Guidelines

**Purpose**: Help a competent user accomplish a specific real-world task.

**Orientation**: Task-oriented. The reader knows what they want; you show the path.

**Voice**: Direct, action-focused. "To configure SSL, update the config file."

**Structure**:
1. State the goal/problem being solved
2. List prerequisites (briefly)
3. Provide logical sequence of actions
4. Focus on the specific task, not related topics

**Include**:
- Real-world problem framing
- Adaptability for variations ("If using X instead, do Y")
- Just enough context to orient the reader

**Exclude**:
- Teaching fundamentals (that's a tutorial)
- Complete reference information (link to it)
- Explanation of why things work (link to explanation)

**Quality check**: Can someone who knows the domain follow this to solve their problem?

## Reference Guidelines

**Purpose**: Provide accurate, complete technical descriptions for lookup.

**Orientation**: Information-oriented. The reader is consulting; you are the authority.

**Voice**: Neutral, austere, factual. "The `--verbose` flag enables detailed output."

**Structure**:
1. Mirror the product's actual structure
2. Use consistent patterns throughout
3. Organize so users find information where expected

**Include**:
- Complete coverage of the subject
- Accurate technical descriptions
- Examples illustrating usage (without explanation)
- Constraints and warnings ("You must X before Y")

**Exclude**:
- Instructions on how to use the information
- Explanations of why things are designed this way
- Opinions or recommendations

**Quality check**: Is every fact accurate? Is the coverage complete? Can users find what they need quickly?

## Explanation Guidelines

**Purpose**: Provide context, background, and rationale that deepens understanding.

**Orientation**: Understanding-oriented. The reader is reflecting; you are discussing.

**Voice**: Discursive, thoughtful. "The reason this approach was chosen..."

**Structure**:
1. Frame with an implicit "About X" title
2. Bound the topic with a "why" question
3. Connect to related concepts and the bigger picture

**Include**:
- Historical context and design rationale
- Alternatives and tradeoffs
- Multiple perspectives where relevant
- Connections to broader concepts

**Exclude**:
- Step-by-step instructions
- Technical reference details
- Teaching through exercises

**Quality check**: Does this help someone understand *why*, not just *what* or *how*?

## Quick Reference

| Writing... | Do | Don't |
|------------|------|-------|
| **Tutorial** | Use "we", show results, be concrete | Explain, offer choices, assume knowledge |
| **How-to** | Be direct, assume competence, solve the problem | Teach, be exhaustive, explain why |
| **Reference** | Be complete, accurate, consistent | Instruct, explain, opine |
| **Explanation** | Discuss why, provide context, acknowledge perspectives | Give instructions, include reference details |

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|--------------|------------------|
| Mixing tutorial with explanation | Learner gets lost in context instead of doing | Link to explanations, keep tutorial focused on action |
| How-to that teaches basics | Competent users get frustrated by fundamentals | Assume competence, link to tutorials for beginners |
| Reference with opinions | Users can't trust what's fact vs preference | Describe neutrally; put recommendations in how-to guides |
| Explanation that instructs | Readers expecting reflection get tasks instead | Move instructions to how-to guides |
| One doc trying to serve all needs | Fails all audiences | Write separate documents for each type |

## Anti-Rationalizations

- "Users need all the context" — Not in a tutorial. Link to explanations; keep the learning path clear.
- "I should explain why here" — Is this reference or explanation? If reference, describe only. If how-to, solve the problem.
- "Beginners might read this how-to" — Write a tutorial for beginners. How-to guides assume competence.
- "This reference should help users get started" — That's a tutorial's job. Reference is for lookup, not learning.
- "I'll combine them to avoid duplication" — Duplication is better than documentation that fails all purposes.

## Summary

1. **Identify the type first.** Tutorial, how-to, reference, or explanation - pick one before writing.
2. **Keep types separate.** One document, one purpose. Link between them instead of combining.
3. **Match voice to type.** "We" for tutorials, direct for how-to, neutral for reference, discursive for explanation.
4. **Exclude what doesn't belong.** Each type has things it must not contain. Removing the wrong content improves the right content.
