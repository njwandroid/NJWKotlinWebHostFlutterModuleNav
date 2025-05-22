# Story: Deploy Flutter Web Application to GitHub Pages

## Summary (TLDR)

**Configure and deploy the Flutter web app to GitHub Pages for public access.**

* **Key Tasks**:
    * Configure Flutter build for GitHub Pages compatibility
    * Set up **automated deployment workflow** with GitHub Actions
    * Configure correct base href for asset loading
    * Test deployed application in various environments
* **Technical Focus**:
    * Creating reliable deployment process for future updates
    * Ensuring assets and navigation work correctly in deployed environment
* **Time Estimate**: 6-8 hours

## Description

Configure and deploy the Flutter web application to GitHub Pages, making it publicly accessible on
the web. This includes setting up the build process, configuring GitHub Pages settings, and
providing clear documentation for future deployments.

## Requirements

- Configure project for GitHub Pages compatibility
- Set up build workflow for web deployment
- Deploy application to GitHub Pages
- Verify all features work correctly in the deployed version
- Document the deployment process for future updates

## Technical Tasks

- [ ] Configure Flutter web build settings for GitHub Pages compatibility
- [ ] Create GitHub workflow for automated builds
- [ ] Configure base href settings for proper asset loading in GitHub Pages
- [ ] Set up GitHub repository for Pages deployment
- [ ] Create deployment script for manual deployments
- [ ] Test deployed application on GitHub Pages
- [ ] Document step-by-step deployment process
- [ ] Configure custom domain (if applicable)

## Acceptance Criteria

- [ ] Application is successfully deployed to GitHub Pages
- [ ] All navigation features work correctly in the deployed version
- [ ] Assets (images, fonts, etc.) load properly in the deployed version
- [ ] Documentation includes clear steps for future deployments
- [ ] GitHub Actions workflow successfully builds and deploys the application
- [ ] Application works on mobile browsers when accessed via GitHub Pages URL

## Dependencies

- Story: Configure Flutter Project for Web Platform
- Story: Adapt Navigation Patterns for Web Platform
- Story: Create Web Demo Environment with Clear Instructions

## Notes

This story focuses on making the application publicly accessible through GitHub Pages. Special
attention should be paid to asset paths, base href configuration, and ensuring all features work
correctly in the deployed environment.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium
- **LOE with Firebender using Gemini 2.5 Pro:** Medium-High

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 7/10
- **Likelihood of Frustration:** 7/10
- **Likelihood of Manual Steps:** 8/10

### Time Estimate

- **Estimated Hours:** 6-8 hours

### Notes

For a Flutter developer with minimal web knowledge, deploying to GitHub Pages can present several
challenges:

1. Understanding GitHub Pages path requirements
2. Configuring base href correctly for asset loading
3. Setting up GitHub Actions workflows for automated deployment

**Deployment Steps to Include:**

```
# GitHub Pages Deployment Guide

## Manual Deployment

1. Build the Flutter web app with the correct base href:
   ```

flutter build web --base-href /your-repo-name/

   ```

2. Navigate to the build output directory:
   ```

cd build/web

   ```

3. Create a new git repository in the build directory:
   ```

git init
git add .
git commit -m "Deploy to GitHub Pages"

   ```

4. Add your GitHub repository as a remote:
   ```

git remote add origin https://github.com/username/your-repo-name.git

   ```

5. Push to the gh-pages branch:
   ```

git push -f origin master:gh-pages

   ```

## Automated Deployment with GitHub Actions

1. Create `.github/workflows/deploy.yml` with the following content:
   ```yaml
   name: Deploy to GitHub Pages

   on:
     push:
       branches: [ main ]

   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v2
         - uses: subosito/flutter-action@v1
           with:
             flutter-version: '3.10.x'
             channel: 'stable'
         - run: flutter pub get
         - run: flutter build web --base-href /your-repo-name/
         - name: Deploy
           uses: peaceiris/actions-gh-pages@v3
           with:
             github_token: ${{ secrets.GITHUB_TOKEN }}
             publish_dir: ./build/web
   ```

2. Commit and push this workflow to your repository
3. GitHub Actions will automatically build and deploy your site

## GitHub Repository Settings

1. Go to your repository on GitHub
2. Navigate to Settings > Pages
3. Select "gh-pages" branch as the source
4. (Optional) Configure a custom domain

## Testing the Deployed Site

1. Access your site at: https://username.github.io/your-repo-name/
2. Verify all navigation features work correctly
3. Test on both desktop and mobile browsers

```

Common issues to document include:
- Asset loading failures due to incorrect base href
- 404 errors on page refresh due to GitHub Pages SPA limitations
- Differences between local and deployed behavior