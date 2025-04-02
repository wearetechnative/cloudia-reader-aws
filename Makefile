setup:
	pip install -r requirements.txt

test:
	bash tests/scripts/unit_tests.sh

lint:
	bash tests/scripts/pylint.sh

test_e2e_prepare:
	bash tests/scripts/prepare_e2e.sh
