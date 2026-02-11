---
name: javascript-typescript
Description: "JavaScript and TypeScript best practices. Use when writing frontend/backend JS/TS code, React components, or Node.js applications."
metadata:
  {
    "openclaw":
      {
        "emoji": "📜",
        "requires": {},
        "install": [],
      },
  }
---

# JavaScript/TypeScript Skill

JavaScript and TypeScript best practices for modern web development.

## When to Use

- Writing JavaScript/TypeScript
- React/Next.js development
- Node.js backend
- API development
- Frontend optimization

## Modern JavaScript (ES6+)

### Variable Declarations

```javascript
// Good: Use const by default
const PI = 3.14159;
const user = { name: 'John' };

// Good: Use let when reassignment needed
let count = 0;
count++;

// Bad: Avoid var
var oldStyle = 'deprecated';
```

### Arrow Functions

```javascript
// Good: Arrow functions for callbacks
const doubled = numbers.map(n => n * 2);

// Good: Implicit return for simple functions
const add = (a, b) => a + b;

// Good: Block body for complex logic
const processUser = user => {
  const fullName = `${user.firstName} ${user.lastName}`;
  return { ...user, fullName };
};

// Good: Arrow functions preserve 'this'
class Counter {
  constructor() {
    this.count = 0;
  }
  
  start() {
    setInterval(() => {
      this.count++; // 'this' refers to Counter instance
    }, 1000);
  }
}
```

### Destructuring

```javascript
// Object destructuring
const user = { name: 'John', age: 30, email: 'john@example.com' };
const { name, age } = user;

// With default values
const { role = 'user' } = user;

// Nested destructuring
const { address: { city } } = user;

// Array destructuring
const [first, second, ...rest] = [1, 2, 3, 4, 5];

// Function parameters
def createUser({ name, email, role = 'user' }) {
  return { name, email, role, createdAt: new Date() };
}

// Renaming
const { name: userName, age: userAge } = user;
```

### Spread/Rest Operators

```javascript
// Spread for arrays
const arr1 = [1, 2, 3];
const arr2 = [...arr1, 4, 5];

// Spread for objects
const defaults = { theme: 'dark', lang: 'en' };
const settings = { ...defaults, theme: 'light' };

// Rest parameters
function sum(...numbers) {
  return numbers.reduce((a, b) => a + b, 0);
}

// Rest with destructuring
const [first, ...others] = [1, 2, 3, 4];
```

### Async/Await

```javascript
// Good: Use async/await over callbacks
async function fetchUserData(userId) {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch user:', error);
    throw error;
  }
}

// Good: Parallel execution with Promise.all
async function fetchDashboardData() {
  const [users, orders, products] = await Promise.all([
    fetchUsers(),
    fetchOrders(),
    fetchProducts()
  ]);
  
  return { users, orders, products };
}

// Good: Sequential execution when needed
async function processUsers(userIds) {
  const results = [];
  for (const id of userIds) {
    const user = await fetchUser(id); // Sequential
    results.push(user);
  }
  return results;
}
```

## TypeScript Best Practices

### Type Definitions

```typescript
// Interfaces for object shapes
interface User {
  id: number;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
  createdAt: Date;
}

// Type aliases for unions/complex types
type Status = 'idle' | 'loading' | 'success' | 'error';
type ApiResponse<T> = { data: T; status: number } | { error: string; status: number };

// Function types
interface UserService {
  findById(id: number): Promise<User | null>;
  create(user: CreateUserDto): Promise<User>;
  update(id: number, data: Partial<User>): Promise<User>;
  delete(id: number): Promise<void>;
}
```

### Generic Patterns

```typescript
// Generic functions
function identity<T>(arg: T): T {
  return arg;
}

// Generic constraints
interface HasLength {
  length: number;
}

function logLength<T extends HasLength>(arg: T): T {
  console.log(arg.length);
  return arg;
}

// Generic classes
class Queue<T> {
  private items: T[] = [];
  
  enqueue(item: T): void {
    this.items.push(item);
  }
  
  dequeue(): T | undefined {
    return this.items.shift();
  }
}

// Generic React component
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
}

function List<T>({ items, renderItem }: ListProps<T>) {
  return <ul>{items.map(renderItem)}</ul>;
}
```

### Utility Types

```typescript
// Partial - all properties optional
type PartialUser = Partial<User>;

// Pick - select specific properties
type UserCredentials = Pick<User, 'email' | 'password'>;

// Omit - exclude specific properties
type PublicUser = Omit<User, 'password' | 'internalNotes'>;

// Required - all properties required
type RequiredConfig = Required<Config>;

// Record - dictionary type
type UserDictionary = Record<string, User>;

// ReturnType - extract return type
type UserResponse = ReturnType<typeof fetchUser>;

// Parameters - extract parameter types
type UserParams = Parameters<typeof createUser>;
```

## React Patterns

### Functional Components

```tsx
// Good: Explicit props type
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export function Button({ 
  label, 
  onClick, 
  variant = 'primary',
  disabled = false 
}: ButtonProps) {
  return (
    <button 
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {label}
    </button>
  );
}

// Good: Custom hooks
function useUser(userId: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetchUser(userId)
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [userId]);

  return { user, loading, error };
}

// Usage
function UserProfile({ userId }: { userId: string }) {
  const { user, loading, error } = useUser(userId);
  
  if (loading) return <Spinner />;
  if (error) return <Error message={error.message} />;
  if (!user) return <NotFound />;
  
  return <div>{user.name}</div>;
}
```

### State Management

```tsx
// Good: useReducer for complex state
interface State {
  items: Item[];
  loading: boolean;
  error: string | null;
}

type Action =
  | { type: 'FETCH_START' }
  | { type: 'FETCH_SUCCESS'; payload: Item[] }
  | { type: 'FETCH_ERROR'; payload: string }
  | { type: 'ADD_ITEM'; payload: Item }
  | { type: 'REMOVE_ITEM'; payload: string };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'FETCH_START':
      return { ...state, loading: true, error: null };
    case 'FETCH_SUCCESS':
      return { ...state, loading: false, items: action.payload };
    case 'FETCH_ERROR':
      return { ...state, loading: false, error: action.payload };
    case 'ADD_ITEM':
      return { ...state, items: [...state.items, action.payload] };
    case 'REMOVE_ITEM':
      return { 
        ...state, 
        items: state.items.filter(item => item.id !== action.payload) 
      };
    default:
      return state;
  }
}
```

## Node.js Backend

### Express Patterns

```typescript
import express, { Request, Response, NextFunction } from 'express';

// Middleware
const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  // Verify token...
  next();
};

// Route handlers
app.get('/api/users/:id', async (req: Request, res: Response) => {
  try {
    const user = await userService.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Error handling middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});
```

## Error Handling

```javascript
// Good: Custom error classes
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

class NotFoundError extends Error {
  constructor(resource, id) {
    super(`${resource} with id ${id} not found`);
    this.name = 'NotFoundError';
    this.resource = resource;
    this.id = id;
  }
}

// Good: Global error handler
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  // Application specific logging, throwing an error, or other logic here
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  process.exit(1);
});
```

## Best Practices

1. **Use TypeScript** for type safety
2. **Prefer const/let** over var
3. **Use async/await** over callbacks
4. **Handle errors** properly
5. **Write tests** for all code
6. **Use linters** (ESLint, Prettier)
7. **Document** with JSDoc
8. **Keep functions small** and focused
9. **Avoid mutation** when possible
10. **Use modern features** (ES6+)
