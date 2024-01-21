PYTHON_INTERPRETER := python3

all: venv/bin/activate mnist.zip

venv/bin/activate: requirements.txt
	rm -rf .venv
	${PYTHON_INTERPRETER} -m pip install --upgrade pip
	${PYTHON_INTERPRETER} -m pip install --upgrade setuptools
	${PYTHON_INTERPRETER} -m pip install --upgrade virtualenv
	virtualenv --python ${PYTHON_INTERPRETER} venv
	. venv/bin/activate; \
		${PYTHON_INTERPRETER} -m pip install -r requirements.txt;

mnist.zip:
	wget https://raw.githubusercontent.com/laegsgaardTroels/data/master/mnist.zip
