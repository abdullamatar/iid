ELM_DIR = ./iid
SERVER_DIR = ./server
DIST_DIR = $(ELM_DIR)/dist
TARGET_DIR = $(SERVER_DIR)/dist

SERVER_MAIN = $(SERVER_DIR)/main.cpp

SERVER_BIN = $(SERVER_DIR)/server

all: build-elm move-dist build-server

build-elm:
	@echo "Building Elm frontend in $(ELM_DIR)"
	cd $(ELM_DIR) && elm-land build

move-dist:
	@echo "mv $(ELM_DIR)/dist $(SERVER_DIR)/dist ..."
	rm -rf $(TARGET_DIR)
	mv $(DIST_DIR) $(SERVER_DIR)

build-server:
	@echo "Building C++ server..."
	g++ $(SERVER_MAIN) -o $(SERVER_BIN)


clean:
	@echo "Nothing is happening"


.PHONY: all build-elm move-dist build-server clean
