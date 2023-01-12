<div align="center">
  <h2>TMDB Submission</h2>
</div>

## Features

This repository ispacked with:

-   Swift 5.7
-   RxSwift 5.13
-   RxCocoa 5.13
-   SDWebImage
-   Cocoapods 1.13
-   SVProgressHUD
-   IQKeyboardManagerSwift
-   Xcode Version 14.1

# Getting Started

## Cocoapods dependency manager install, if you have installed it please just skip to step no. 3

### 1. Install ffi

```
sudo arch -x86_64 gem install ffi
```
### 2. Install cocoapod

```
sudo arch -x86_64 gem install cocoapod
```
### 3. Change Directory to your current working directory

```
cd \your-directory\
```
### 4. Remove Podfile.lock file

```
rm -rf Podfile.lock
```

### 5. Install project dependency

```
sudo arch -x86_64 pod install or pod install
```

### 6. Conflict Mitigation if Cocoapod Error

```
sudo arch -x86_64 pod deintegrate or pod deintegrate
sudo arch -x86_64 pod init or pod init
sudo arch -x86_64 pod install or pod install
```

### 7. Commit Message Convention

This repository follows [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)
#### Format
`<type>(optional scope): <description>`
Contoh: `feat(dashboard): add button`

#### Type:

- feat → Kalo ada penambahan/pengurangan codingan
- fix → kalo ada bug fixing
- BREAKING CHANGE → kalo ada perubahan yang signifikan (ubah login flow)
- docs → update documentation (README.md)
- styling → update styling, ga ngubah logic sama sekali (reorder import, benerin whitespace)
- ci → update github workflow
- test → update testing
- perf → fix sesuatu yang bersifat cuma untuk performance issue (derived state, memo)

### 8. Branch Naming Rules
> - CONTOH NAMING RULES 

- MCTDMB-xx-lorem-ipsum-dolor-amit
- MCTDMB-xx-MCTDMB-yy-MCTDMB-zz-lorem-ipsum

### 9. Pull Request Title Naming Rules
> **IMPORTANT:**
> - Gunakan Squash & Merge dan mengganti commit sesuai aturan conventional commit pada poin #3 di README

- MCTDMB-xx-lorem-ipsum-dolor-amit
- MCTDMB-xx-MCTDMB-yy-MCTDMB-zz-lorem-ipsum

### 10. Variable case convention
- Use `camelCase` for every situation
- Use `PascalCase` for file name
- Use 'snake_case' for metadata file

### 11. Directory Structure
> **IMPORTANT:**
> - use PascalCase for folder name & View Controller Name
> - use camelCase for Variables
```js
--Project Workspace
  |--Base
  |  |--App Delegate
  |  |--Scene Delegate
  |--Services
  |  |--Api Services
  |--Providers
  |  |--Base Provider
  |--Components
  |  |--SharedLayout
  |--Miscellaneous
  |--Model
  |  |--Class Model
  |--ViewModel
  |--Views
  |  |--home
  |  |-----|Domain
  |  |-----------|Response
  |  |--anotherpage
  |--Utils
  |  |--Extension
  |  |--Helper Class
```
