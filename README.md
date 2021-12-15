# Plain Web [Unicode Fonts and CSS]

Copyright © 2018–2019, Christopher Alan Mosher, Shelton, Connecticut, USA, <cmosher01@gmail.com>.

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CVSSQ2BWDCKQ2)
[![License](https://img.shields.io/github/license/cmosher01/Tei-Server.svg)](https://www.gnu.org/licenses/gpl.html)
[![Docker](https://img.shields.io/docker/cloud/build/cmosher01/universal-web-fonts?label=Docker)](https://hub.docker.com/r/cmosher01/universal-web-fonts)

A web server that serves a curated set of Unicode Web Fonts, covering a huge set of languages,
both ancient and modern, along with a plain-style stylesheet.

Available as a Docker image, so you can host your own web-font server.

You can view an [example server](https://mosher.mine.nu/uniwebfonts/).

### architecture

There are three main stylesheets in the system:

* [reset.css](reset.css) normalizes HTML5 elements across browsers
* [solarized.css](solarized.css) Solarized color scheme
* [fonts.css](fonts.css) unicode webfonts (requires Docker image web server)

These can be used separately. See [test.html](test/test.html) for a small example.

### docker

```shell script
docker run -d -p 8080:80 cmosher01/universal-web-fonts
```

Then browse to http://localhost:8080/ to test. View sources for examples of use.

---
`test.html`
```html
<!doctype html>
<html class="unicodeWebFonts fontFeatures solarizedLight">
    <head>
        <meta charset="UTF-8">
        <title>Test</title>
        <link rel="stylesheet" href="test.css">
    </head>
    <body>
        <p>Test</p>
    </body>
</html>
```
---
`test.css`
```css
@import url("reset.css");
@import url("solarized.css");
@import url("fonts.css");
```
