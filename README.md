# thunderbird-sq

Dockerfile for building and running a Docker image for
[Thunderbird with Sequoia-Octopus](https://sequoia-pgp.org/blog/2021/12/13/202112-octopus/).

## License

Copyright (c) 2021-2024, Bernd R. Fix >Y<

thunderbird-sq is free software: you can redistribute it and/or modify it
under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

thunderbird-sq is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

SPDX-License-Identifier: AGPL3.0-or-later

## tl;dr

You need a GNU/Linux system and [Docker](https://docker.com) installed.

Run `./build.sh` to build the Docker image (can take some time).

Adjust `run.sh` to your environment; folders are defined at the beginning of the script:

    MAILDIR=${HOME}/.thunderbird
    NSSDIR=${HOME}/.pki/nssdb
    GPGDIR=${HOME}/.gnupg
    EXCHANGE=${HOME}/Downloads

Start Thunderbird by running `./run.sh`.
