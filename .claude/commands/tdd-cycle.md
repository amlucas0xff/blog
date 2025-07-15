# TDD Cycle Command

Execute TDD cycle for: $ARGUMENTS

## Mandatory TDD Process

### Phase 1: RED (Write Failing Test)
1. **THINK HARD** about test requirements
2. Write failing test that describes expected behavior
3. Verify test fails with clear error message
4. Document test purpose and expected outcome

### Phase 2: GREEN (Make Test Pass)
1. Write minimal code to make test pass
2. Avoid over-engineering - focus on passing test
3. Verify test passes
4. Verify all existing tests still pass

### Phase 3: REFACTOR (Improve Code)
1. **THINK** about code improvements
2. Refactor while maintaining test coverage
3. Verify all tests still pass
4. Improve code readability and maintainability

### Phase 4: COMMIT (Atomic Commit)
1. Stage changes: `git add .`
2. Commit with descriptive message
3. Push to feature branch
4. Update task tracking

## Success Criteria
- Test coverage maintained above 90%
- All tests pass
- Code follows style guidelines
- Commit message describes changes clearly

Execute this cycle for EVERY feature, no exceptions.
