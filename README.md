# tm-manylinux

[Docker](https://www.docker.com/) image for building portable Python wheels for [tmTable](https://github.com/cms-l1-globaltrigger/tm-table), [tmGrammar](https://github.com/cms-l1-globaltrigger/tm-grammar) and [tmEventSetup](https://github.com/cms-l1-globaltrigger/tm-eventsetup).

Designed for continuous integration and automated deployment with [github actions](https://github.com/features/actions).

Based on [pypa's manylinux](https://github.com/pypa/manylinux) docker Image with additional build tools installed:
 * [Boost 1.71.0](https://www.boost.org/)
 * [Xerces-C 3.2.2](https://xerces.apache.org/xerces-c/)
 * [SWIG 4.0.1](http://www.swig.org/)
 * [XSD 4.0.0](https://codesynthesis.com/products/xsd/)

## Usage

Use `build_wheels.sh [version] [module...]` to build utm python wheels.

```bash
docker pull docker.pkg.github.com/cms-l1-globaltrigger/tm-manylinux/tm-manylinux:latest
docker run --name utm_wheels tm-manylinux:latest build_wheels.sh 0.7.4 tm-grammar tm-table tm-eventsetup
docker cp utm_wheels:/io/wheelhouse .
docker rm utm_wheels
```

Generated wheels can be found in the local directory `wheelhouse`.
