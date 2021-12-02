# tm-manylinux

[Docker](https://www.docker.com/) image for building portable Python wheels for
[tmTable](https://github.com/cms-l1-globaltrigger/tm-table),
[tmGrammar](https://github.com/cms-l1-globaltrigger/tm-grammar) and
[tmEventSetup](https://github.com/cms-l1-globaltrigger/tm-eventsetup).

Designed for continuous integration and automated deployment with
[github actions](https://github.com/features/actions).

Based on [pypa's manylinux](https://github.com/pypa/manylinux) docker Image with
additional build tools installed:
 * [Boost 1.77.0](https://www.boost.org/)
 * [Xerces-C 3.2.3](https://xerces.apache.org/xerces-c/)
 * [SWIG 4.0.2](http://www.swig.org/)
 * [XSD 4.0.0](https://codesynthesis.com/products/xsd/)

## Build

```bash
docker build . -t tm-manylinux:latest
```

## Usage

Use `build_wheels.sh <version> <module...>` to build utm python wheels.

```bash
docker run --name utm_wheels tm-manylinux:latest build_wheels.sh 0.10.0 tm-grammar tm-table tm-eventsetup
docker cp utm_wheels:/io/wheelhouse .
docker rm utm_wheels
```

Generated wheels can be found in the local directory `wheelhouse`.
