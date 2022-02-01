install-deps:
	cd client && pip3 install -r requirements.txt || echo "!!! Unable to install Python libaries. !!!"
	cd gateway && cp dot_env .env && npm install
	cd subgraph1 && cp dot_env .env && npm install
	cd subgraph2 && cp dot_env .env && npm install
	cd subgraph3 && cp dot_env .env && npm install

supergraph:
	rover supergraph compose --config supergraph.yaml > gateway/supergraph.graphql

run-local-unmanaged: supergraph
	docker build -f gateway/Dockerfile.unmanaged gateway -t gateway-unmanaged
	docker build -f subgraph1/Dockerfile subgraph1 -t subgraph1
	docker build -f subgraph2/Dockerfile subgraph2 -t subgraph2
	docker build -f subgraph3/Dockerfile subgraph3 -t subgraph3
	docker-compose -f local-test-unmanaged.yaml up 

run-local-managed:
	docker build -f gateway/Dockerfile gateway -t gateway
	docker build -f subgraph1/Dockerfile subgraph1 -t subgraph1
	docker build -f subgraph2/Dockerfile subgraph2 -t subgraph2
	docker build -f subgraph3/Dockerfile subgraph3 -t subgraph3
	docker-compose --env-file ./gateway/.env -f local-test.yaml up 

deploy:
	cd gateway && make deploy
	cd subgraph1 && make deploy
	cd subgraph2 && make deploy
	cd subgraph3 && make deploy