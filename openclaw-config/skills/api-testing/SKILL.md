---
name: api-testing
Description: "API testing strategies and tools. Use when writing API tests, load testing, integration testing, or validating REST/GraphQL endpoints."
metadata:
  {
    "openclaw":
      {
        "emoji": "🧪",
        "requires": {},
        "install": [],
      },
  }
---

# API Testing Skill

API testing strategies and tools for validating REST, GraphQL, and gRPC endpoints.

## When to Use

- Writing API tests
- Load testing
- Integration testing
- Validating endpoints
- API documentation

## Testing Levels

### 1. Unit Tests (Service Layer)

```python
# Python with pytest
import pytest
from myapp import create_app

@pytest.fixture
def client():
    app = create_app(testing=True)
    with app.test_client() as client:
        yield client

def test_get_user(client):
    response = client.get('/api/users/1')
    assert response.status_code == 200
    data = response.get_json()
    assert data['id'] == 1
    assert 'name' in data

def test_create_user_validation(client):
    response = client.post('/api/users', json={})
    assert response.status_code == 400
    assert 'error' in response.get_json()
```

### 2. Integration Tests

```python
# Test with database
def test_user_workflow(client):
    # Create
    create_resp = client.post('/api/users', json={
        'name': 'John',
        'email': 'john@example.com'
    })
    assert create_resp.status_code == 201
    user_id = create_resp.get_json()['id']
    
    # Read
    get_resp = client.get(f'/api/users/{user_id}')
    assert get_resp.status_code == 200
    
    # Update
    update_resp = client.put(f'/api/users/{user_id}', json={
        'name': 'John Updated'
    })
    assert update_resp.status_code == 200
    
    # Delete
    delete_resp = client.delete(f'/api/users/{user_id}')
    assert delete_resp.status_code == 204
```

### 3. Contract Tests

```python
# Validate API schema
def test_api_contract(client):
    response = client.get('/api/users/1')
    data = response.get_json()
    
    # Verify schema
    assert isinstance(data['id'], int)
    assert isinstance(data['name'], str)
    assert isinstance(data['email'], str)
    assert 'created_at' in data
```

## Testing Tools

### curl

```bash
# GET request
curl -X GET http://api.example.com/users \
  -H "Authorization: Bearer TOKEN"

# POST request
curl -X POST http://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com"}'

# With verbose output
curl -v http://api.example.com/health
```

### HTTPie

```bash
# GET
http GET api.example.com/users Authorization:"Bearer TOKEN"

# POST
http POST api.example.com/users name=John email=john@example.com

# With form data
http -f POST api.example.com/upload file@document.pdf
```

### Postman/Newman

```bash
# Run Postman collection
newman run collection.json -e environment.json

# With reporters
newman run collection.json -r cli,json,html
```

### pytest with requests

```python
import requests
import pytest

BASE_URL = "http://localhost:8000"

class TestUsersAPI:
    def setup_method(self):
        self.session = requests.Session()
        self.session.headers.update({
            'Authorization': 'Bearer test-token'
        })
    
    def test_list_users(self):
        response = self.session.get(f"{BASE_URL}/api/users")
        assert response.status_code == 200
        assert isinstance(response.json(), list)
    
    def test_user_pagination(self):
        response = self.session.get(f"{BASE_URL}/api/users?page=1&limit=10")
        data = response.json()
        assert len(data) <= 10
        
    def test_rate_limiting(self):
        # Make multiple requests
        for _ in range(100):
            response = self.session.get(f"{BASE_URL}/api/users")
        
        # Should be rate limited
        assert response.status_code == 429
```

## Load Testing

### k6

```javascript
// load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '2m', target: 100 },
        { duration: '5m', target: 100 },
        { duration: '2m', target: 200 },
        { duration: '5m', target: 200 },
        { duration: '2m', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'],
        http_req_failed: ['rate<0.1'],
    },
};

export default function () {
    const response = http.get('http://api.example.com/users');
    
    check(response, {
        'status is 200': (r) => r.status === 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });
    
    sleep(1);
}
```

Run: `k6 run load-test.js`

### Artillery

```yaml
# artillery.yml
config:
  target: 'http://api.example.com'
  phases:
    - duration: 60
      arrivalRate: 10
    - duration: 120
      arrivalRate: 50
scenarios:
  - name: "Get users"
    requests:
      - get:
          url: "/api/users"
```

Run: `artillery run artillery.yml`

## GraphQL Testing

```python
def test_graphql_query(client):
    query = """
    query GetUser($id: ID!) {
        user(id: $id) {
            id
            name
            email
        }
    }
    """
    
    response = client.post('/graphql', json={
        'query': query,
        'variables': {'id': '1'}
    })
    
    assert response.status_code == 200
    data = response.get_json()
    assert 'data' in data
    assert 'errors' not in data
    assert data['data']['user']['id'] == '1'
```

## Authentication Testing

```python
def test_jwt_auth(client):
    # Login
    login_resp = client.post('/api/auth/login', json={
        'username': 'test',
        'password': 'test'
    })
    token = login_resp.get_json()['token']
    
    # Access protected endpoint
    response = client.get('/api/protected', 
        headers={'Authorization': f'Bearer {token}'}
    )
    assert response.status_code == 200
    
    # Invalid token
    response = client.get('/api/protected',
        headers={'Authorization': 'Bearer invalid'}
    )
    assert response.status_code == 401
```

## Best Practices

1. **Test Happy Path and Edge Cases**
2. **Validate Response Schema**
3. **Check HTTP Status Codes**
4. **Test Authentication/Authorization**
5. **Verify Error Messages**
6. **Test Rate Limiting**
7. **Use Test Data Factories**
8. **Clean Up After Tests**
9. **Mock External Services**
10. **Run Tests in CI/CD**

## CI/CD Integration

```yaml
# .github/workflows/test.yml
name: API Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Start services
        run: docker-compose up -d
      - name: Run tests
        run: pytest tests/api/
      - name: Load test
        run: k6 run load-test.js
```
