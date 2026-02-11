---
name: ml-pipeline
Description: "Machine Learning pipeline best practices. Use when building ML workflows, data preprocessing, model training, evaluation, and deployment."
metadata:
  {
    "openclaw":
      {
        "emoji": "🤖",
        "requires": {},
        "install": [],
      },
  }
---

# ML Pipeline Skill

Machine Learning pipeline best practices for building end-to-end ML workflows.

## When to Use

- Designing ML pipelines
- Data preprocessing
- Model training
- Model evaluation
- ML deployment (MLOps)

## Pipeline Stages

### 1. Data Collection

```python
# Fetch data from various sources
def collect_data():
    # Database
    df = pd.read_sql(query, connection)
    
    # APIs
    data = requests.get(api_url).json()
    
    # Files
    df = pd.read_csv('data.csv')
    
    return df
```

### 2. Data Preprocessing

```python
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split

def preprocess_data(df):
    # Handle missing values
    df = df.fillna(df.mean())
    
    # Encode categorical variables
    le = LabelEncoder()
    df['category'] = le.fit_transform(df['category'])
    
    # Feature scaling
    scaler = StandardScaler()
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    df[numeric_cols] = scaler.fit_transform(df[numeric_cols])
    
    # Split data
    X = df.drop('target', axis=1)
    y = df['target']
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )
    
    return X_train, X_test, y_train, y_test
```

### 3. Feature Engineering

```python
def engineer_features(df):
    # Create new features
    df['feature_ratio'] = df['feature_a'] / df['feature_b']
    df['feature_sum'] = df['feature_a'] + df['feature_b']
    
    # Time-based features
    df['hour'] = pd.to_datetime(df['timestamp']).dt.hour
    df['day_of_week'] = pd.to_datetime(df['timestamp']).dt.dayofweek
    
    # Interaction features
    df['interaction'] = df['feature_a'] * df['feature_b']
    
    return df
```

### 4. Model Training

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report

def train_model(X_train, y_train, X_test, y_test):
    # Initialize model
    model = RandomForestClassifier(
        n_estimators=100,
        max_depth=10,
        random_state=42
    )
    
    # Train
    model.fit(X_train, y_train)
    
    # Evaluate
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    
    print(f"Accuracy: {accuracy:.4f}")
    print(classification_report(y_test, y_pred))
    
    return model
```

### 5. Model Evaluation

```python
def evaluate_model(model, X_test, y_test):
    from sklearn.metrics import confusion_matrix, roc_auc_score, roc_curve
    
    # Predictions
    y_pred = model.predict(X_test)
    y_pred_proba = model.predict_proba(X_test)[:, 1]
    
    # Metrics
    print("Confusion Matrix:")
    print(confusion_matrix(y_test, y_pred))
    
    print(f"\nROC-AUC Score: {roc_auc_score(y_test, y_pred_proba):.4f}")
    
    # Feature importance
    if hasattr(model, 'feature_importances_'):
        importances = model.feature_importances_
        print("\nFeature Importances:")
        for feat, imp in zip(X_test.columns, importances):
            print(f"  {feat}: {imp:.4f}")
```

### 6. Model Deployment

```python
import joblib

def save_model(model, filepath='model.pkl'):
    """Save model to disk"""
    joblib.dump(model, filepath)
    print(f"Model saved to {filepath}")

def load_model(filepath='model.pkl'):
    """Load model from disk"""
    return joblib.load(filepath)

# Flask API for model serving
from flask import Flask, request, jsonify

app = Flask(__name__)
model = load_model()

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    features = np.array(data['features']).reshape(1, -1)
    prediction = model.predict(features)
    return jsonify({'prediction': prediction.tolist()})
```

## Common ML Patterns

### Cross-Validation

```python
from sklearn.model_selection import cross_val_score

scores = cross_val_score(model, X, y, cv=5)
print(f"CV Accuracy: {scores.mean():.4f} (+/- {scores.std() * 2:.4f})")
```

### Hyperparameter Tuning

```python
from sklearn.model_selection import GridSearchCV

param_grid = {
    'n_estimators': [50, 100, 200],
    'max_depth': [5, 10, 15]
}

grid_search = GridSearchCV(
    RandomForestClassifier(),
    param_grid,
    cv=5,
    scoring='accuracy'
)

grid_search.fit(X_train, y_train)
print(f"Best parameters: {grid_search.best_params_}")
```

### Model Comparison

```python
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.ensemble import GradientBoostingClassifier

models = {
    'Logistic Regression': LogisticRegression(),
    'Random Forest': RandomForestClassifier(),
    'SVM': SVC(),
    'Gradient Boosting': GradientBoostingClassifier()
}

for name, model in models.items():
    model.fit(X_train, y_train)
    score = model.score(X_test, y_test)
    print(f"{name}: {score:.4f}")
```

## MLOps Best Practices

1. **Version Control**: Track data, code, and models
2. **Experiment Tracking**: Use MLflow, Weights & Biases
3. **Data Validation**: Check data quality before training
4. **Model Monitoring**: Track performance in production
5. **A/B Testing**: Compare model versions
6. **Feature Store**: Centralize feature definitions

## Tools

- **Pandas**: Data manipulation
- **Scikit-learn**: Traditional ML
- **TensorFlow/PyTorch**: Deep learning
- **MLflow**: Experiment tracking
- **DVC**: Data version control
- **Docker**: Containerization
- **Kubernetes**: Orchestration
