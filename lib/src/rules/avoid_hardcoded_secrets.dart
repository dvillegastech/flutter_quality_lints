import 'package:analyzer/dart/ast/ast.dart';

import 'base_lint_rule.dart';

/// A lint rule that detects hardcoded secrets like API keys and passwords
class AvoidHardcodedSecrets extends LintRule {
  const AvoidHardcodedSecrets();

  @override
  String get ruleName => 'avoid_hardcoded_secrets';

  @override
  String get message => 'Potential hardcoded secret detected. Use environment variables or secure storage.';

  @override
  String get description => 'Detects potential hardcoded secrets such as API keys, passwords, tokens, and other sensitive information that should be stored securely.';

  @override
  bool shouldReport(AstNode node) {
    if (node is SimpleStringLiteral) {
      return _containsSensitiveData(node.value);
    } else if (node is VariableDeclaration) {
      return _isSecretVariable(node);
    }
    return false;
  }

  bool _containsSensitiveData(String value) {
    // Skip very short strings or obviously safe values
    if (value.length < 10 || _isSafeValue(value)) {
      return false;
    }
    
    // Check for patterns that suggest secrets
    return _hasSecretPattern(value) || _hasEncodedSecret(value);
  }

  bool _isSafeValue(String value) {
    const safeValues = {
      'localhost', 'example.com', 'test', 'debug', 'development',
      'production', 'staging', 'assets/', 'images/', 'fonts/',
      'packages/', 'lib/', 'android', 'ios', 'web', 'macos', 'windows', 'linux'
    };
    
    final lowerValue = value.toLowerCase();
    return safeValues.any((safe) => lowerValue.contains(safe));
  }

  bool _hasSecretPattern(String value) {
    // API Key patterns
    if (_matchesApiKeyPattern(value)) return true;
    
    // JWT tokens
    if (_matchesJwtPattern(value)) return true;
    
    // OAuth tokens
    if (_matchesOAuthPattern(value)) return true;
    
    // Database connection strings
    if (_matchesDatabasePattern(value)) return true;
    
    // Private keys
    if (_matchesPrivateKeyPattern(value)) return true;
    
    return false;
  }

  bool _matchesApiKeyPattern(String value) {
    // Common API key patterns
    final apiKeyRegexes = [
      RegExp(r'^[A-Za-z0-9]{32,}$'), // Generic long alphanumeric
      RegExp(r'^sk_[a-z]+_[A-Za-z0-9]{24,}$'), // Stripe secret key
      RegExp(r'^pk_[a-z]+_[A-Za-z0-9]{24,}$'), // Stripe public key
      RegExp(r'^AIza[A-Za-z0-9_-]{35}$'), // Google API key
      RegExp(r'^ya29\.[A-Za-z0-9_-]+$'), // Google OAuth2
      RegExp(r'^[A-Fa-f0-9]{40}$'), // GitHub token
      RegExp(r'^ghp_[A-Za-z0-9]{36}$'), // GitHub personal access token
      RegExp(r'^xox[baprs]-[A-Za-z0-9-]+$'), // Slack token
    ];
    
    return apiKeyRegexes.any((regex) => regex.hasMatch(value));
  }

  bool _matchesJwtPattern(String value) {
    // JWT tokens have three base64 parts separated by dots
    final parts = value.split('.');
    if (parts.length != 3) return false;
    
    // Each part should be base64-like
    final base64Pattern = RegExp(r'^[A-Za-z0-9_-]+$');
    return parts.every((part) => part.isNotEmpty && base64Pattern.hasMatch(part));
  }

  bool _matchesOAuthPattern(String value) {
    final oauthRegexes = [
      RegExp(r'^[A-Za-z0-9]{32,128}$'), // Generic OAuth token
      RegExp(r'^[0-9]+-[A-Za-z0-9_-]+\.apps\.googleusercontent\.com$'), // Google OAuth client
    ];
    
    return oauthRegexes.any((regex) => regex.hasMatch(value));
  }

  bool _matchesDatabasePattern(String value) {
    final dbPatterns = [
      RegExp(r'mongodb://.*:.*@'), // MongoDB with credentials
      RegExp(r'mysql://.*:.*@'), // MySQL with credentials
      RegExp(r'postgresql://.*:.*@'), // PostgreSQL with credentials
      RegExp(r'redis://.*:.*@'), // Redis with credentials
    ];
    
    return dbPatterns.any((pattern) => pattern.hasMatch(value));
  }

  bool _matchesPrivateKeyPattern(String value) {
    return value.contains('-----BEGIN PRIVATE KEY-----') ||
           value.contains('-----BEGIN RSA PRIVATE KEY-----') ||
           value.contains('-----BEGIN EC PRIVATE KEY-----');
  }

  bool _hasEncodedSecret(String value) {
    // Check for base64 encoded content that might be secrets
    if (value.length < 40) return false;
    
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+=*$');
    if (base64Pattern.hasMatch(value)) {
      // Additional checks for base64 secrets
      return value.length >= 40 && value.length % 4 == 0;
    }
    
    // Check for hex encoded secrets
    final hexPattern = RegExp(r'^[A-Fa-f0-9]+$');
    return hexPattern.hasMatch(value) && value.length >= 32;
  }

  bool _isSecretVariable(VariableDeclaration variable) {
    final variableName = variable.name.lexeme.toLowerCase();
    
    // Suspicious variable names
    const secretNames = {
      'apikey', 'api_key', 'secret', 'password', 'pwd', 'pass',
      'token', 'auth', 'credential', 'private_key', 'privatekey',
      'client_secret', 'clientsecret', 'access_token', 'accesstoken',
      'refresh_token', 'refreshtoken', 'bearer_token', 'bearertoken'
    };
    
    if (secretNames.contains(variableName)) {
      // Check if the initializer is a string literal
      final initializer = variable.initializer;
      if (initializer is SimpleStringLiteral) {
        return _containsSensitiveData(initializer.value);
      }
    }
    
    return false;
  }
} 