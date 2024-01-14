PYTHON_INTERPRETER := python3

.venv/bin/activate: requirements.txt
	rm -rf .venv
	${PYTHON_INTERPRETER} -m pip install --upgrade pip
	${PYTHON_INTERPRETER} -m pip install --upgrade setuptools
	${PYTHON_INTERPRETER} -m pip install --upgrade virtualenv
	virtualenv --python ${PYTHON_INTERPRETER} .venv
	. .venv/bin/activate; \
		${PYTHON_INTERPRETER} -m pip install -r requirements.txt;
