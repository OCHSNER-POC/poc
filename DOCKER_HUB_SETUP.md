# Docker Hub Integration Setup

This guide explains how to set up automatic Docker image building and pushing to Docker Hub using GitHub Actions.

## Prerequisites

1. **Docker Hub Account**: You need a Docker Hub account
2. **GitHub Repository**: Your code must be in a GitHub repository
3. **GitHub Actions**: Enabled on your repository

## Step 1: Create Docker Hub Access Token

1. **Login to Docker Hub** at [hub.docker.com](https://hub.docker.com)
2. **Go to Account Settings** → **Security**
3. **Click "New Access Token"**
4. **Set Token Name**: `github-actions-ochsner-poc`
5. **Set Permissions**: 
   - ✅ Read & Write
   - ✅ Read, Write & Delete (if you want to delete images)
6. **Copy the token** (you won't see it again!)

## Step 2: Add GitHub Secrets

1. **Go to your GitHub repository**
2. **Click Settings** → **Secrets and variables** → **Actions**
3. **Click "New repository secret"**
4. **Add these secrets**:

### Required Secrets

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `DOCKERHUB_USERNAME` | `dwachholderesa` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | `your-access-token` | The access token from Step 1 |

## Step 3: Verify Workflow Files

Ensure these files exist in your repository:

- `.github/workflows/docker-image.yml` - Main CI/CD workflow
- `.github/workflows/docker-build.yml` - PR build workflow
- `Dockerfile` - Docker image definition

## Step 4: Test the Integration

### Automatic Triggers

The workflow automatically runs when:

1. **Push to main branch** → Builds and pushes `latest` tag
2. **Create a tag** (e.g., `v1.0.0`) → Builds and pushes versioned tag
3. **Pull request** → Builds only (no push)

### Manual Testing

1. **Push a commit to main**:
   ```bash
   git add .
   git commit -m "Test Docker Hub integration"
   git push origin main
   ```

2. **Create a version tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Check GitHub Actions**:
   - Go to Actions tab in your repository
   - Monitor the workflow execution

## Step 5: Verify Docker Hub

1. **Check Docker Hub** at [hub.docker.com](https://hub.docker.com)
2. **Look for your repository**: `dwachholderesa/ochsner-poc`
3. **Verify tags**: `latest`, `main-<sha>`, `v1.0.0` (if you created tags)

## Image Tags Generated

The workflow automatically creates these tags:

- **`latest`** - Latest commit on main branch
- **`main-<sha>`** - Specific commit SHA (e.g., `main-a1b2c3d`)
- **`v1.0.0`** - Semantic version tags
- **`v1.0`** - Major.minor version tags

## Troubleshooting

### Common Issues

1. **Authentication Failed**:
   - Verify `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets
   - Check token permissions and expiration

2. **Build Failed**:
   - Check Dockerfile syntax
   - Verify all required files are present

3. **Push Failed**:
   - Ensure repository exists on Docker Hub
   - Check token has write permissions

### Debug Steps

1. **Check GitHub Actions logs** for detailed error messages
2. **Verify secrets** are correctly set
3. **Test Docker build locally**:
   ```bash
   docker build -t test-image .
   ```

## Security Best Practices

1. **Use Access Tokens** instead of passwords
2. **Limit token permissions** to minimum required
3. **Rotate tokens regularly** (every 90 days)
4. **Monitor token usage** in Docker Hub

## Advanced Configuration

### Custom Image Names

To change the image name, update the workflow file:

```yaml
env:
  IMAGE_NAME: your-username/your-repo-name
```

### Multi-platform Builds

Add platform support:

```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    platforms: linux/amd64,linux/arm64
    # ... other options
```

### Conditional Pushing

Only push on specific conditions:

```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  if: github.ref == 'refs/heads/main'
  with:
    push: true
    # ... other options
```

## Support

If you encounter issues:

1. **Check GitHub Actions logs** first
2. **Verify Docker Hub permissions**
3. **Review workflow syntax** in GitHub Actions
4. **Test locally** with Docker commands
