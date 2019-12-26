setup:
	pip install --user -r requirements.txt

test:
	pytest -m "not integration" --cov=. --cov-report html --cov-report term && flake8

testintegration:
	pytest -m integration

hints:
	mypy --ignore-missing-imports --html-report typecov .

deploy:
	kubectl apply -f deploy/$(artifact).yml
