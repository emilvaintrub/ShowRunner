# Inquiry Bank

The domains Forge must cover in `discovery`, and the core questions for each
new initiative at `roadmap`. Every domain lists what it is for, the core
questions, what a usable answer looks like, and how to run it in each owner
mode ([../discovery.md](../discovery.md) section 2).

Questions are asked in plain language, a few at a time
(`questions.max_per_round`), each with a short "why this matters" line. The
bank is a coverage map, not a script: follow the owner's thread, but do not
close `discovery` until every domain is covered.

## Coverage States

Each domain ends in one of:

- `answered`: the owner gave a specific, usable answer.
- `researched`: the owner did not know; Forge found cited evidence
  ([../../core/evidence.md](../../core/evidence.md)) and the owner confirmed
  it applies.
- `open - to validate`: nobody knows yet; it becomes a named assumption and a
  validation question in the assessment.
- `deferred by owner`: the owner chose to decide later, in their own words,
  with the trigger for returning to it.

"I don't know" is a valid answer and starts research or becomes an open
assumption; it never ends the domain.

## Specificity Probes

A vague answer gets a follow-up before it is recorded. Common triggers:

| Owner says | Probe |
| --- | --- |
| "Everyone" / "all small businesses" | "If you could only win one kind of customer first, who would it be - and where would you find ten of them next week?" |
| "It's better / easier / cheaper" | "Better than what, exactly, and how would a customer notice in the first five minutes?" |
| "People will love it" | "What have you seen or heard that tells you so? Who said it, and did they pay or commit anything?" |
| "We'll go viral / use social media" | "Which channel, which first 100 customers, and what would it cost to reach them?" |
| "There's no competition" | "What do people do today instead? Even doing nothing or using a spreadsheet counts." |
| "We'll figure out pricing later" | "What is the most a first customer would pay, and what would you need to charge to cover costs?" |
| A number with no source | "Where does that number come from?" - then cite it, research it, or record it as an assumption. |

## Domains

### D1. Owner Goals And Constraints

For: knowing what success means to this owner, and what they can invest.

- What do you want this to become in 1 year and in 3 years? (side income,
  sustainable business, venture-scale company, internal tool, other)
- How much money, time per week, and help can you put in, and for how long?
- What would make you stop?
- What must never be compromised (values, people, brand, ethics)?

Usable answer: a goal type, a budget range, a time commitment, a stop rule.
Guide: explain that these choices change everything downstream (a side
project and a venture-backed startup need different plans) and offer the
options. Challenge: test consistency ("a venture-scale goal with a
5-hour-a-week budget - which gives?").

### D2. Problem

For: making sure there is a real, painful, frequent problem.

- Describe the problem in one or two sentences, without mentioning your
  solution.
- Who has it, how often, and what does it cost them (money, time, stress,
  risk)?
- How do you know? Your own experience, conversations, data?
- Why hasn't it been solved already?

Usable answer: a specific person, a specific moment, a cost, and evidence.
Guide: explain "problem first, solution second" with a short example.
Challenge: ask for the last three real people who had this problem and what
they did about it; separate the owner's own pain from market pain.

### D3. Customers And Users

For: a first customer segment specific enough to reach.

- Who is the first customer, as specifically as possible?
- Who uses it, who pays, and who decides? Are they the same person?
- Where do these people gather (online and offline)?
- How many of them are there, and in which geography? (research candidate)

Usable answer: one primary segment, the buyer/user split, a reach channel.
Guide: introduce "beachhead segment" in one line and help narrow down.
Challenge: probe whether the segment can pay and can be reached cheaply.

### D4. Current Alternatives And Competition

For: understanding what the product must beat, including doing nothing.

- What do people use or do today to handle this?
- Which products or services have you seen that come close?
- What do those alternatives get wrong, specifically?
- Why would someone switch, and what does switching cost them?

Usable answer: named alternatives and a concrete switching reason. Forge
always researches this domain ([../discovery.md](../discovery.md) section 4);
owner knowledge is a starting point, not the finding.
Guide: explain that "no competition" usually means "no market" or "not looked
yet". Challenge: present the strongest competitor found and ask why a
customer would choose the owner instead.

### D5. Solution And Value Proposition

For: what the product does and why it wins.

- What is the smallest version that would solve the core problem?
- What is the one thing it must do brilliantly?
- What will it deliberately not do?
- What is hard to copy about it (data, network, expertise, relationships,
  brand, regulation)?

Usable answer: a minimal core, a "must be brilliant" item, exclusions, a moat
hypothesis or an honest "none yet".
Guide: help cut scope to a first version and explain why smaller is faster to
learn from. Challenge: test whether the moat is real or a feature a
competitor could ship next quarter.

### D6. Business Model And Pricing

For: how money flows.

- Who pays, for what, how often, and roughly how much?
- What are the main costs to deliver it (people, infrastructure, content,
  support, payment fees, compliance)?
- Are there alternative models (subscription, one-time, usage, marketplace
  fee, advertising, licensing, services)?

Usable answer: a model choice, a price hypothesis, a cost list. Prices and
cost benchmarks are researched and cited.
Guide: lay out 2-3 models that fit, with plain pros and cons and a
recommendation. Challenge: run rough unit economics with labeled assumptions
and show the owner what has to be true to break even.

### D7. Go-To-Market And Distribution

For: how the first customers will actually arrive.

- How will the first 10, 100, and 1,000 customers find it?
- Which channel is cheapest and most repeatable?
- What does acquiring one customer cost (estimate, researched benchmark, or
  assumption)?
- Are there partners, communities, or marketplaces that already reach them?

Usable answer: a first channel with a cost estimate and a first-100 plan.
Guide: explain that distribution kills more products than technology does,
and suggest concrete first steps. Challenge: compare the likely acquisition
cost with the price and lifetime value.

### D8. Legal, Regulatory, And Trust

For: surfacing roadblocks early.

- Does it handle personal, health, financial, children's, or location data?
- Is the activity regulated (payments, lending, health advice, alcohol,
  gambling, employment, insurance, education, transport)?
- Which countries or states will it operate in?
- Are there IP, licensing, or platform-policy risks (app stores, APIs,
  scraping, content rights)?

Usable answer: a list of applicable regimes, each researched and cited, or a
cited "none found" with the search log. Always recommend a qualified
professional for binding advice.
Guide: explain each flagged area in one plain sentence. Challenge: name the
specific rule most likely to block or delay the plan.

### D9. Operations And Delivery

For: what it takes to run, beyond code.

- Who handles support, onboarding, content, payments, disputes, and refunds?
- What happens at 10x the users?
- Which suppliers, platforms, or APIs does it depend on, and what if one
  disappears or raises prices?

Usable answer: owners for each operation, key dependencies and a fallback.

### D10. Team, Skills, And Resources

For: what is missing to realize the idea.

- Which skills do you and your team have, and which are missing (product,
  design, engineering, marketing, sales, legal, finance)?
- What will ShowRunner cover, and what needs a person?
- What is the budget for hiring, contractors, tools, and marketing?

Usable answer: a skills gap list and a plan for each gap.
Guide: explain what the agent can build and what still needs humans (sales,
legal sign-off, customer relationships, fundraising).

### D11. Risks And Unknowns

For: naming what could kill the idea.

- What is the biggest risk you already worry about?
- Imagine it is a year from now and this failed. What most likely happened?
  (pre-mortem)
- What would you need to see to be confident enough to invest more?

Usable answer: top risks with a validation idea for each.
Challenge: add the risks the owner did not name, from research and the other
domains.

### D12. Success Measures And Milestones

For: agreeing what "working" looks like.

- What number, reached by when, would tell you this is working?
- What would tell you it is not?
- What are the first three milestones?

Usable answer: a leading metric, a target with a date, a kill threshold.

## Initiative Inquiry (Roadmap Stage)

Every new initiative, however small, answers these before `roadmap` closes.
Small changes get short answers, not skipped questions.

1. What problem does this solve, for whom, and how do we know it matters?
2. What happens if we do not do it?
3. How will we know it worked? Name the metric, the target (works / does
   not), the source of the number, and when to review it
   ([../../core/outcomes.md](../../core/outcomes.md)); for changes with no
   measurable outcome, the observable result.
4. What is the smallest version that proves it?
5. Does it change pricing, positioning, costs, legal exposure, or anything a
   business document relies on?
6. What could go wrong, and what is the cheapest way to find out first?

In challenge mode, add: "Is this the most valuable thing to build next, given
the roadmap?" and present the alternative ShowRunner would rank higher, if
any.
