<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.5-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
     <img src="https://img.shields.io/badge/platforms-mac+linux-brightgreen.svg?style=flat" alt="Mac + Linux" />
</p>

# Blog with publish framework

The Blog use [Publish](https://github.com/JohnSundell/Publish/tree/master) to generate a static web pages

## Install `Publish`

The Publish command line tool is also available via [Homebrew](https://brew.sh) and can be installed using the following command if you have Homebrew installed:

```
brew install publish
```

## GitHub Actions

The project use GitHub pages to build, test and deploy the blog

### Actions used

- [peaceiris/actions-gh-pages: GitHub Actions for GitHub Pages 🚀 Deploy static files and publish your site easily. Static-Site-Generators-friendly.](https://github.com/peaceiris/actions-gh-pages)
