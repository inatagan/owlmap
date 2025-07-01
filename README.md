![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) ![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![LaTeX](https://img.shields.io/badge/latex-%23008080.svg?style=for-the-badge&logo=latex&logoColor=white) ![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)

![banner](assets/banner.png)

# owlmap
owlmap is a tracking app for bird sightings enthusiasts or any other thing you want.

![sample](assets/sample.png)

# Development info

If you wish to work in the development of the app, during set up you must provide your Firebase and Google Maps connection API Key.

### Setting up the development environment
Clone this repository

`git clone https://github.com/inatagan/owlmap.git`

To work/build the flutter front-end, on the root of the repository navigate to:

`cd owlmap-flutter`

in this directory create the ".env" file, or a .json, to store the Google Map API key.

The you can run the the app with:

`flutter run --dart-define=<name_of_the_file>`

To build using the environment variables ue:

`flutter build apk --dart-define=<name_of_the_file>`