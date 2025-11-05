# Design Patterns and Guidelines

## Architectural Patterns

### Monorepo Pattern
- **Yarn Workspaces**: Single repository for all packages
- **Shared Dependencies**: Common dependencies at root
- **Workspace Protocol**: Use `workspace:` for internal deps
- **Turborepo**: Parallel builds with intelligent caching

**Benefits**:
- Atomic cross-package changes
- Consistent tooling and versions
- Simplified dependency management
- Build caching and optimization

### Meteor Framework Patterns

#### DDP (Distributed Data Protocol)
- Real-time data synchronization
- Publications for data control
- Subscriptions on client
- Reactive data updates

```typescript
// Server: Publication
Meteor.publish('messages', function(roomId) {
  return Messages.find({ roomId });
});

// Client: Subscription
Meteor.subscribe('messages', roomId);
```

#### Methods
- Server-side RPC (Remote Procedure Calls)
- Automatic error handling
- Optimistic UI updates

```typescript
// Server
Meteor.methods({
  'sendMessage': function(message) {
    // Server-side logic
  }
});

// Client
Meteor.call('sendMessage', message, (error, result) => {
  // Handle response
});
```

### React Patterns

#### Functional Components with Hooks
**Preferred** over class components.

```typescript
// Good: Functional component with hooks
export const MyComponent: FC<Props> = ({ data }) => {
  const [state, setState] = useState();
  
  useEffect(() => {
    // Side effects
  }, [dependencies]);
  
  return <div>{data}</div>;
};
```

#### Context for Global State
Use React Context for app-wide state.

```typescript
// Create context
export const UserContext = createContext<UserContextValue>(null);

// Provider
export const UserProvider: FC = ({ children }) => {
  const value = useUserData();
  return <UserContext.Provider value={value}>{children}</UserContext.Provider>;
};

// Consumer
export const useUser = () => useContext(UserContext);
```

#### Custom Hooks
Extract reusable logic into custom hooks.

```typescript
export const useMessages = (roomId: string) => {
  const [messages, setMessages] = useState([]);
  
  useEffect(() => {
    const subscription = Messages.subscribe(roomId);
    return () => subscription.stop();
  }, [roomId]);
  
  return messages;
};
```

### Service-Oriented Architecture (Enterprise)

#### Microservices Pattern
- **Independent Services**: Each service has single responsibility
- **Message Broker**: Communication via message queue
- **Service Discovery**: Dynamic service registration
- **Fault Isolation**: Service failures don't cascade

Services in `ee/apps/`:
- Account Service
- Authorization Service
- Presence Service
- Queue Worker
- DDP Streamer
- Stream Hub Service

#### Service Communication
```typescript
// Service registration
broker.createService({
  name: 'account-service',
  actions: {
    create: async (ctx) => { /* ... */ },
    update: async (ctx) => { /* ... */ }
  }
});

// Service call
await broker.call('account-service.create', userData);
```

## Code Organization Patterns

### Feature-Based Organization (Legacy)
```
app/
  feature-name/
    client/
    server/
    lib/
    tests/
```

### Layer-Based Organization (Modern)
```
client/
  components/
  views/
  hooks/
  contexts/
  lib/
```

### Package Organization
Each package should have:
```
package-name/
  src/           # Source code
  dist/          # Built output
  tests/         # Tests
  package.json   # Dependencies and scripts
  tsconfig.json  # TypeScript config
  README.md      # Documentation
```

## TypeScript Patterns

### Strict Type Safety
**Always prefer**:
- Explicit types over `any`
- Interfaces for object shapes
- Type guards for runtime checks
- Generics for reusable types

```typescript
// Good: Explicit types
interface Message {
  id: string;
  text: string;
  userId: string;
  createdAt: Date;
}

function sendMessage(message: Message): Promise<void> {
  // Implementation
}

// Bad: Using any
function sendMessage(message: any): any {
  // Avoid this
}
```

### Type Definitions Organization
- **core-typings**: Core domain types
- **model-typings**: Database model types
- **rest-typings**: API endpoint types

### Union Types for State
```typescript
type LoadingState = 
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: Data }
  | { status: 'error'; error: Error };
```

## Testing Patterns

### Unit Test Structure
```typescript
describe('MessageService', () => {
  describe('sendMessage', () => {
    it('should send message successfully', async () => {
      // Arrange
      const message = createTestMessage();
      
      // Act
      const result = await MessageService.send(message);
      
      // Assert
      expect(result).toBeDefined();
      expect(result.id).toBeTruthy();
    });
    
    it('should handle errors gracefully', async () => {
      // Arrange
      const invalidMessage = {};
      
      // Act & Assert
      await expect(
        MessageService.send(invalidMessage)
      ).rejects.toThrow();
    });
  });
});
```

### E2E Test Pattern (Playwright)
```typescript
test.describe('Login Flow', () => {
  test('user can login with valid credentials', async ({ page }) => {
    await page.goto('/');
    await page.fill('[name=username]', 'testuser');
    await page.fill('[name=password]', 'password');
    await page.click('button[type=submit]');
    
    await expect(page).toHaveURL('/home');
  });
});
```

### Mocking Pattern
```typescript
// Use mock providers from @rocket.chat/mock-providers
import { MockedServerContext } from '@rocket.chat/mock-providers';

test('component with server data', () => {
  render(
    <MockedServerContext.Provider value={mockValue}>
      <Component />
    </MockedServerContext.Provider>
  );
});
```

## Error Handling Patterns

### Try-Catch with Specific Errors
```typescript
try {
  await riskyOperation();
} catch (error) {
  if (error instanceof NetworkError) {
    // Handle network error
  } else if (error instanceof ValidationError) {
    // Handle validation error
  } else {
    // Log unexpected error
    logger.error('Unexpected error', error);
    throw error;
  }
}
```

### Result Type Pattern
```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function operation(): Promise<Result<Data>> {
  try {
    const data = await fetchData();
    return { success: true, data };
  } catch (error) {
    return { success: false, error };
  }
}
```

## Performance Patterns

### Memoization
```typescript
import { useMemo, useCallback } from 'react';

// Expensive computation
const processedData = useMemo(
  () => expensiveComputation(data),
  [data]
);

// Stable callback reference
const handleClick = useCallback(
  () => doSomething(id),
  [id]
);
```

### Code Splitting
```typescript
// Dynamic imports for routes
const AdminPanel = lazy(() => import('./AdminPanel'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <Routes>
        <Route path="/admin" element={<AdminPanel />} />
      </Routes>
    </Suspense>
  );
}
```

### Virtualization for Long Lists
Use virtualization for large datasets in UI.

## Security Patterns

### Input Validation
```typescript
import { check } from 'meteor/check';

Meteor.methods({
  'sendMessage': function(text: string) {
    check(text, String);
    
    if (text.length > 5000) {
      throw new Meteor.Error('message-too-long');
    }
    
    // Process message
  }
});
```

### Authentication & Authorization
```typescript
// Check authentication
if (!this.userId) {
  throw new Meteor.Error('not-authorized');
}

// Check permissions
if (!hasPermission(this.userId, 'send-message')) {
  throw new Meteor.Error('insufficient-permissions');
}
```

### XSS Prevention
- Always sanitize user input
- Use React's automatic escaping
- Validate on server side

## Accessibility Patterns

### Semantic HTML
```typescript
// Good: Semantic elements
<nav aria-label="Main navigation">
  <button aria-expanded={isOpen}>Menu</button>
</nav>

// Bad: Non-semantic
<div onClick={handleClick}>Click me</div>
```

### Keyboard Navigation
```typescript
const handleKeyDown = (e: KeyboardEvent) => {
  if (e.key === 'Enter' || e.key === ' ') {
    handleActivate();
  }
};

<div
  role="button"
  tabIndex={0}
  onKeyDown={handleKeyDown}
  onClick={handleActivate}
>
  Action
</div>
```

### ARIA Labels
```typescript
<button aria-label="Close dialog">
  <Icon name="close" aria-hidden="true" />
</button>
```

## Internationalization (i18n)

### Translation Pattern
```typescript
import { useTranslation } from '@rocket.chat/i18n';

function Component() {
  const { t } = useTranslation();
  
  return <h1>{t('Welcome_message')}</h1>;
}
```

### Translation Files
- Located in `packages/i18n/`
- JSON format
- Key-based structure

## Logging Patterns

```typescript
import { Logger } from '@rocket.chat/logger';

const logger = new Logger('ServiceName');

logger.info('Operation completed', { userId, duration });
logger.warn('Unusual activity detected', { details });
logger.error('Operation failed', { error, context });
```

## Database Patterns

### Model Abstraction
```typescript
// Use models from @rocket.chat/models
import { Users, Messages } from '@rocket.chat/models';

// Query
const user = await Users.findOneById(userId);

// Insert
await Messages.insertOne({
  text: 'Hello',
  userId,
  roomId,
  createdAt: new Date()
});

// Update
await Users.updateOne(
  { _id: userId },
  { $set: { status: 'online' } }
);
```

### Indexes
Ensure proper indexes for query performance.

## API Design Patterns

### REST API
- Versioned endpoints
- Consistent error responses
- Proper HTTP methods
- Type-safe with rest-typings

### Rate Limiting
Implement rate limiting for API endpoints.

## Best Practices Summary

### DO ✅
- Use TypeScript strict mode
- Write tests for new features
- Follow existing patterns
- Use workspace protocol for internal deps
- Leverage Turborepo caching
- Handle errors explicitly
- Consider accessibility
- Use semantic versioning

### DON'T ❌
- Use `any` type without justification
- Skip type checking
- Ignore linting errors
- Commit code that doesn't build
- Bypass pre-commit hooks
- Leave console.log in production code
- Create circular dependencies
- Expose sensitive data
