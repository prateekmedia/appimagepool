<p align="center"><a href="#appimagepool"><img src="https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/appimagepool.png" height=80px alt="AppImage Pool Logo"/></a></p>
<h1 align="center">AppImagePool</h1>
<p align="center">
<a href="https://github.com/prateekmedia/appimagepool/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/prateekmedia/appimagepool?color=blueviolet"/></a> <a href="LICENSE"><img alt="License" src="https://img.shields.io/github/license/prateekmedia/appimagepool?color=blueviolet"/></a> <a href="https://github.com/prateekmedia"><img alt="Maintainer" src="https://img.shields.io/badge/Maintainer-prateekmedia-blueviolet"/></a>
</p>

<p align="center"><b>
Simple AppImageHub Client</b></p>

<table>
    <tr>
        <td colspan='3'>
            <img src="https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/screenshot/home.jpg" alt="Screenshot 1"/>
        </td>
    </tr>
    <tr>
        <td>
            <img src="https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/screenshot/app.jpg" alt="Screenshot 2"/>
        </td>
        <td>
            <img src="https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/screenshot/search.jpg" alt="Screenshot 3"/>
        </td>
        <td>
            <img src="https://raw.githubusercontent.com/prateekmedia/appimagepool/main/assets/screenshot/category.jpg" alt="Screenshot 4"/>
        </td>
    </tr>

</table>

## Main Features

- FLOSS and non profit app
- Simple categories
- Download from github directly, no extra-server involved
- Upgrade and Downgrade appimages easily
- Version History and multi dowload support
- Fast downloader

### Download Links

| Flatpak | AppImage | Nightly AppImage |
|    -    |    -     |        -         |
| <a href='https://flathub.org/apps/details/io.github.prateekmedia.appimagepool'><img width='130' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.png'/></a> | <a href='https://github.com/prateekmedia/appimagepool/releases/latest/'><img width='130' alt='Download AppImage' src='https://github.com/srevinsaju/get-appimage/raw/master/static/badges/get-appimage-branding-dark.png'/></a> | <a href='https://github.com/prateekmedia/appimagepool/releases/continuous/'><img width='130' alt='Download AppImage' src='https://github.com/srevinsaju/get-appimage/raw/master/static/badges/get-appimage-branding-dark.png'/></a> |

---

### Contribute translations

- Simply copy the content of `app_en.arb` located in `lib/translations` to your language like `app_hi.arb`
- Now Modify the values of every key for example:
`"preferences": "सेटिंग्स"`
- Now make a Pull Request or simply create an issue and upload your translations there.

## Supporters

[![Stargazers repo roster for @prateekmedia/appimagepool](https://reporoster.com/stars/prateekmedia/appimagepool)](https://github.com/prateekmedia/appimagepool/stargazers)

### Build from source

- Download latest Flutter SDK (>=2.5.0 / beta version)
- Clone this repo and then

```
# Download dependencies and Enable Linux support
flutter pub get; flutter config --enable-linux-desktop

# For Direct Testing
flutter run -v -d linux
```
