---
name: python-best-practices
Description: "Python best practices and patterns. Use when writing Python code, structuring projects, handling errors, or optimizing performance."
metadata:
  {
    "openclaw":
      {
        "emoji": "🐍",
        "requires": {},
        "install": [],
      },
  }
---

# Python Best Practices Skill

Python best practices for writing clean, efficient, and maintainable code.

## When to Use

- Writing Python code
- Structuring projects
- Handling errors
- Optimizing performance
- Code reviews

## Project Structure

### Standard Layout

```
myproject/
├── src/
│   └── myproject/
│       ├── __init__.py
│       ├── core.py
│       └── utils.py
├── tests/
│   ├── __init__.py
│   ├── test_core.py
│   └── test_utils.py
├── docs/
├── scripts/
├── .gitignore
├── README.md
├── LICENSE
├── pyproject.toml
└── requirements.txt
```

### Package Structure

```python
# myproject/__init__.py
"""MyProject - A Python package."""

__version__ = "1.0.0"
__author__ = "Your Name"

from .core import main_function
from .utils import helper

__all__ = ["main_function", "helper"]
```

## Code Style

### PEP 8 Guidelines

```python
# Naming conventions
module_name          # lowercase
package_name         # lowercase
ClassName           # CapWords
method_name         # lowercase_with_underscores
function_name       # lowercase_with_underscores
GLOBAL_CONSTANT     # UPPERCASE_WITH_UNDERSCORES
instance_variable   # lowercase_with_underscores
local_variable      # lowercase_with_underscores
```

### Docstrings

```python
def calculate_total(items, tax_rate=0.0):
    """Calculate the total cost including tax.
    
    Args:
        items (list): List of items with 'price' and 'quantity' keys.
        tax_rate (float): Tax rate as a decimal (e.g., 0.08 for 8%).
    
    Returns:
        float: Total cost including tax.
    
    Raises:
        ValueError: If tax_rate is negative.
    
    Example:
        >>> items = [{'price': 10.0, 'quantity': 2}]
        >>> calculate_total(items, tax_rate=0.08)
        21.6
    """
    if tax_rate < 0:
        raise ValueError("Tax rate cannot be negative")
    
    subtotal = sum(item['price'] * item['quantity'] for item in items)
    return subtotal * (1 + tax_rate)
```

### Type Hints

```python
from typing import List, Dict, Optional, Union

def process_users(
    users: List[Dict[str, Union[str, int]]],
    active_only: bool = True
) -> List[Dict[str, str]]:
    """Process user data and return formatted results."""
    result: List[Dict[str, str]] = []
    
    for user in users:
        if active_only and not user.get('is_active'):
            continue
        
        result.append({
            'name': f"{user['first_name']} {user['last_name']}",
            'email': user['email']
        })
    
    return result

# Optional and Union
def find_user(user_id: int) -> Optional[Dict[str, str]]:
    """Find user by ID. Returns None if not found."""
    # Implementation
    pass
```

## Error Handling

### Exception Hierarchy

```python
# Custom exceptions
class BusinessError(Exception):
    """Base class for business logic errors."""
    pass

class ValidationError(BusinessError):
    """Raised when input validation fails."""
    pass

class NotFoundError(BusinessError):
    """Raised when a resource is not found."""
    pass

# Usage
def get_user(user_id: int) -> dict:
    user = database.find_user(user_id)
    if not user:
        raise NotFoundError(f"User {user_id} not found")
    return user
```

### Try-Except Patterns

```python
# Good: Catch specific exceptions
try:
    result = divide_numbers(a, b)
except ZeroDivisionError:
    logger.error("Cannot divide by zero")
    result = None
except TypeError as e:
    logger.error(f"Invalid type: {e}")
    raise

# Good: Use context managers
with open('file.txt', 'r') as f:
    content = f.read()

# Good: Cleanup with finally
lock = threading.Lock()
lock.acquire()
try:
    process_data()
finally:
    lock.release()

# Better: Use context manager for locks
with lock:
    process_data()
```

## List/Dict Comprehensions

```python
# Good: List comprehension
squares = [x**2 for x in range(10)]

# Good: Dict comprehension
square_dict = {x: x**2 for x in range(10)}

# Good: Set comprehension
square_set = {x**2 for x in range(100)}

# Good: Generator expression for large data
sum_of_squares = sum(x**2 for x in range(1000000))

# Good: Filter with condition
evens = [x for x in range(20) if x % 2 == 0]

# Bad: Nested comprehensions (hard to read)
# flatten = [x for sublist in matrix for x in sublist]
# Better: Use explicit loops for nested logic
```

## Context Managers

```python
from contextlib import contextmanager

@contextmanager
def managed_resource():
    """Context manager for resource management."""
    resource = acquire_resource()
    try:
        yield resource
    finally:
        resource.release()

# Usage
with managed_resource() as res:
    res.do_something()

# Multiple context managers
with open('input.txt') as infile, open('output.txt', 'w') as outfile:
    outfile.write(infile.read())
```

## Decorators

```python
import functools
import time

def timing_decorator(func):
    """Decorator to measure function execution time."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        elapsed = time.time() - start
        print(f"{func.__name__} took {elapsed:.2f} seconds")
        return result
    return wrapper

def retry(max_attempts=3, delay=1):
    """Decorator to retry function on failure."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    time.sleep(delay)
            return None
        return wrapper
    return decorator

# Usage
@timing_decorator
@retry(max_attempts=3)
def fetch_data():
    """Fetch data from API."""
    pass
```

## Testing

```python
import pytest
from unittest.mock import Mock, patch

class TestUserService:
    def setup_method(self):
        """Set up test fixtures."""
        self.service = UserService()
    
    def test_create_user_success(self):
        """Test successful user creation."""
        user = self.service.create_user("test@example.com", "password123")
        assert user.email == "test@example.com"
        assert user.id is not None
    
    def test_create_user_duplicate_email(self):
        """Test user creation with duplicate email."""
        with pytest.raises(DuplicateError):
            self.service.create_user("existing@example.com", "password123")
    
    @patch('myproject.services.email_service.send_email')
    def test_send_welcome_email(self, mock_send):
        """Test welcome email is sent."""
        self.service.create_user("test@example.com", "password123")
        mock_send.assert_called_once()
```

## Performance

### Efficient Patterns

```python
# Good: Use join for string concatenation
result = ''.join(string_list)

# Good: Use generators for large data
def read_large_file(filepath):
    with open(filepath) as f:
        for line in f:
            yield line.strip()

# Good: Use sets for membership testing
if item in set_collection:  # O(1)

# Good: Use defaultdict
default_dict = defaultdict(list)
default_dict['key'].append('value')

# Good: Use collections.Counter
from collections import Counter
counts = Counter(word_list)
```

### Profiling

```python
import cProfile
import pstats

# Profile function
cProfile.run('my_function()', 'profile_stats')

# View stats
stats = pstats.Stats('profile_stats')
stats.sort_stats('cumulative')
stats.print_stats(20)
```

## Best Practices

1. **Explicit is better than implicit**
2. **Readability counts**
3. **Use virtual environments**
4. **Pin dependencies**
5. **Write tests**
6. **Use linters** (flake8, pylint, black)
7. **Document your code**
8. **Handle errors gracefully**
9. **Don't repeat yourself (DRY)**
10. **Keep it simple (KISS)**
