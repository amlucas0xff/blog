# TDD Cycle: LlamaIndex Workflow Development

## Test-Driven Development for Multi-Agent Workflows

### TDD Cycle Overview
```
Red → Green → Refactor → Document
 ↑                         ↓
 ←←←←←← Validate ←←←←←←←←←←←←
```

### Phase 1: Red (Write Failing Tests)

#### 1.1 Workflow Integration Test
```python
# Test the complete workflow end-to-end
async def test_research_workflow_complete():
    workflow = ResearchWorkflow()
    result = await workflow.run("AI trends 2024")
    
    assert result.status == "completed"
    assert len(result.content) > 1000  # Substantial content
    assert "AI" in result.content.lower()
    assert result.sources is not None
```

#### 1.2 Agent Unit Tests
```python
# Test individual agent behavior
async def test_research_agent_search():
    agent = ResearchAgent()
    result = await agent.process("machine learning trends")
    
    assert result.data is not None
    assert len(result.sources) > 0
    assert result.confidence > 0.7

async def test_writer_agent_synthesis():
    agent = WriterAgent()
    research_data = MockResearchData()
    result = await agent.process(research_data)
    
    assert len(result.content) > 500
    assert result.structure.has_introduction
    assert result.structure.has_conclusion
```

#### 1.3 Tool Integration Tests
```python
# Test external tool integrations
async def test_tavily_search_tool():
    tool = TavilySearchTool()
    results = await tool.search("LlamaIndex workflows")
    
    assert len(results) > 0
    assert all(r.url for r in results)
    assert all(r.content for r in results)
```

### Phase 2: Green (Make Tests Pass)

#### 2.1 Implement Minimal Agent Logic
```python
class ResearchAgent(BaseAgent):
    async def process(self, task: str) -> AgentResult:
        # Minimal implementation to pass tests
        search_results = await self.search_tool.search(task)
        return AgentResult(
            data=search_results,
            sources=[r.url for r in search_results],
            confidence=0.8
        )
```

#### 2.2 Implement Workflow Orchestration
```python
class ResearchWorkflow(BaseWorkflow):
    async def run(self, query: str) -> WorkflowResult:
        # Basic workflow to pass integration test
        research = await self.research_agent.process(query)
        content = await self.writer_agent.process(research.data)
        
        return WorkflowResult(
            status="completed",
            content=content.text,
            sources=research.sources
        )
```

#### 2.3 Implement Tool Integrations
```python
class TavilySearchTool:
    async def search(self, query: str) -> List[SearchResult]:
        # Basic implementation
        response = await self.client.search(query)
        return [SearchResult(url=r['url'], content=r['content']) 
                for r in response['results']]
```

### Phase 3: Refactor (Improve Design)

#### 3.1 Extract Common Patterns
```python
# Base classes for reusability
class BaseAgent(ABC):
    @abstractmethod
    async def process(self, input_data: Any) -> AgentResult:
        pass

class BaseWorkflow(ABC):
    @abstractmethod
    async def run(self, input_data: str) -> WorkflowResult:
        pass
```

#### 3.2 Add Error Handling
```python
class ResearchAgent(BaseAgent):
    async def process(self, task: str) -> AgentResult:
        try:
            search_results = await self.search_tool.search(task)
            return AgentResult(data=search_results, ...)
        except SearchError as e:
            logger.error(f"Search failed: {e}")
            return AgentResult(error=str(e), confidence=0.0)
```

#### 3.3 Optimize Performance
```python
class CachedSearchTool(TavilySearchTool):
    def __init__(self):
        super().__init__()
        self.cache = {}
    
    async def search(self, query: str) -> List[SearchResult]:
        if query in self.cache:
            return self.cache[query]
        
        results = await super().search(query)
        self.cache[query] = results
        return results
```

### Phase 4: Document (Update Documentation)

#### 4.1 Update API Documentation
```python
class ResearchAgent(BaseAgent):
    """
    Researches topics using web search and data analysis.
    
    Example:
        >>> agent = ResearchAgent()
        >>> result = await agent.process("AI trends")
        >>> print(result.confidence)  # 0.8
    """
    
    async def process(self, task: str) -> AgentResult:
        """
        Process a research task.
        
        Args:
            task: Research query or topic description
            
        Returns:
            AgentResult with research data and confidence score
            
        Raises:
            SearchError: If search service is unavailable
        """
```

#### 4.2 Update Workflow Documentation
```markdown
## Research Workflow

### Purpose
Generate comprehensive research reports on any topic.

### Agents
1. **Research Agent**: Gathers information from web sources
2. **Writer Agent**: Synthesizes findings into coherent report
3. **Review Agent**: Validates accuracy and completeness

### Usage
```bash
llamaindex-labs run research-report "Topic to research"
```

### Performance
- Typical execution: 90-120 seconds
- Memory usage: ~200MB
- API calls: 5-10 search requests
```

### Phase 5: Validate (Continuous Testing)

#### 5.1 Regression Test Suite
```python
# Run full test suite after each change
pytest tests/ -v --cov=src/llamaindex_labs --cov-report=html
```

#### 5.2 Performance Validation
```python
async def test_workflow_performance():
    start_time = time.time()
    workflow = ResearchWorkflow()
    await workflow.run("test query")
    execution_time = time.time() - start_time
    
    assert execution_time < 120  # Under 2 minutes
```

#### 5.3 Integration Validation
```python
async def test_cli_integration():
    result = subprocess.run([
        "llamaindex-labs", "run", "research-report", "test"
    ], capture_output=True, text=True)
    
    assert result.returncode == 0
    assert "completed" in result.stdout
```

### TDD Best Practices for Workflows

#### Test Categories Priority
1. **Integration Tests**: Full workflow functionality
2. **Agent Tests**: Individual agent behavior  
3. **Tool Tests**: External service integrations
4. **Performance Tests**: Speed and resource usage
5. **Error Tests**: Failure handling and recovery

#### Mock Strategy
```python
# Mock external services for fast testing
@pytest.fixture
def mock_search_tool():
    tool = Mock()
    tool.search.return_value = [
        SearchResult(url="test.com", content="test content")
    ]
    return tool
```

#### Continuous Integration
```bash
# Pre-commit hooks
python -m pytest tests/ --tb=short
python -m black --check src/
python -m mypy src/
```

This TDD approach ensures robust, well-tested LlamaIndex workflows.