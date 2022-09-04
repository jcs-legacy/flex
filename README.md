[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# flex
> Flexible Matching Library

[![CI](https://github.com/jcs-elpa/flex/actions/workflows/test.yml/badge.svg)](https://github.com/jcs-elpa/flex/actions/workflows/test.yml)

Algorithm is extracted from package [ido-better-flex](https://github.com/vic/ido-better-flex).

## Usage

```el
(flex-score "package-install" "instpkg")  ; 6.581987975707267
(flex-score "install-package" "instpkg")  ; 7.9400006103701894
(flex-score "" "instpkg")                 ; 0.0
```

## Contribute

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Elisp styleguide](https://img.shields.io/badge/elisp-style%20guide-purple)](https://github.com/bbatsov/emacs-lisp-style-guide)
[![Donate on paypal](https://img.shields.io/badge/paypal-donate-1?logo=paypal&color=blue)](https://www.paypal.me/jcs090218)
[![Become a patron](https://img.shields.io/badge/patreon-become%20a%20patron-orange.svg?logo=patreon)](https://www.patreon.com/jcs090218)

If you would like to contribute to this project, you may either
clone and make pull requests to this repository. Or you can
clone the project and establish your own branch of this tool.
Any methods are welcome!
