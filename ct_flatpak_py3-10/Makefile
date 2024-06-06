#
# Make and run the python flatpak
#
SHELL=/bin/bash
# Flatpak platform 23.08 requires too new a version of GLIBC
PAKVER=23.08
PYV=py3-10
PAKNAME=com.candelatech.$(PYV)
PAKFILE=$(PAKNAME).flatpak
PAKJSON=$(PAKNAME).json
BUILDDIR=build.d
BUNDLEFILE=candela-$(PYV).flatpak
PAK_TOOLS=${HOME}/git/flatpak-builder-tools/pip
PAK_PIP=$(PAK_TOOLS)/flatpak-pip-generator

OSVER=$()

all: |create-env flatpak-tools bundle

/usr/bin/python3.10:
		[ -x /usr/bin/dnf ] && sudo dnf install python3.10 python3.10-devel python3.10-venv \
		|| [ -x /usr/bin/apt ] && sudo apt install python3.10 python3.10-dev python3.10-venv \
		|| { echo "No target python to install"; exit1;}

create-env: /usr/bin/python3.10
	( \
		if [ ! -d builder-env/bin ]; then \
			mkdir builder-env; \
			mkdir $(BUILDDIR); \
			echo "creating virtual environment..."; \
			python3.10 -m venv builder-env; \
			echo "...done"; \
		fi; \
	)

builder-env/bin/activate: create-env

${HOME}/git/flatpak-builder-tools: flatpak-tools

flatpak-tools: create-env ./builder-env/bin/activate
	if [ -x /bin/dnf ]; then sudo dnf install -y flatpak flatpak-builder; fi
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	sudo flatpak install -y flathub org.freedesktop.Platform//$(PAKVER)
	sudo flatpak install -y flathub org.freedesktop.Sdk//$(PAKVER)
	( \
		if [ ! -d ${HOME}/git/flatpak-builder-tools ]; then \
			pushd ${HOME}/git; \
			git clone https://github.com/flatpak/flatpak-builder-tools/; \
			popd; \
		fi; \
		source ./builder-env/bin/activate \
			&& pip3 install --upgrade pip requirements-parser pipdeptree \
			&& pip3 install -r requirements.txt; \
	)
#  pybind11 wheel==0.43.0 bcrypt==3.1.3 

# this builds a requirements.json file
requirements.0.json: requirements.0.txt
	( \
		source ./builder-env/bin/activate \
		&& python3 $(PAK_PIP) --requirements-file requirements.0.txt -o requirements.0 \
	)

requirements.1.json: requirements.1.txt
	( \
		source ./builder-env/bin/activate \
		&& python3 $(PAK_PIP) --requirements-file requirements.1.txt -o requirements.1 \
	)
# --ignore-pkg=packaging \

requirements.numpy.json: requirements.numpy.txt
	( \
		source ./builder-env/bin/activate \
		&& python3 $(PAK_PIP) --requirements-file requirements.numpy.txt -o requirements.numpy \
	)

requirements.9.json: requirements.9.txt
	( \
		source ./builder-env/bin/activate \
		&& python3 $(PAK_PIP) --requirements-file requirements.9.txt -o requirements.9 \
	)

requirements: |create-env ${HOME}/git/flatpak-builder-tools requirements.0.json requirements.1.json requirements.numpy.json requirements.9.json


bundle: $(PAKFILE)
	if [ ! -d repo ]; then mkdir repo; fi
	flatpak build-finish --command ctpy.bash --filesystem=/home/lanforge -v build.d
	flatpak build-export repo build.d
	flatpak build-bundle -v repo $(BUNDLEFILE) $(PAKNAME)

$(PAKFILE): |create-env flatpak-tools $(PAKJSON) requirements
	flatpak-builder -v --force-clean --build-only --disable-tests --keep-build-dirs --repo=repo --user $(BUILDDIR) $(PAKJSON)

run: $(PAKFILE)
	flatpak-builder --run $(BUILDDIR) $(PAKJSON) ctpy.bash

clean:
	rm -rf $(BUILDDIR) .flatpak-builder $(BUNDLEFILE) requirements.json

distclean: clean
	rm -rf repo/* repo/.lock builder-env requirements.9.json
#
