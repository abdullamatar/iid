# Compiler flags
CXX=g++
CXXFLAGS=-std=c++23 -Wall -Wextra -Werror -pedantic -O3
LDFLAGS=-lssl -lcrypto -lpthread


ELM_DIR = ./iid
SERVER_DIR = ./server
DIST_DIR = $(ELM_DIR)/dist
TARGET_DIR = $(SERVER_DIR)/dist

SERVER_MAIN = $(SERVER_DIR)/main.cpp
SERVER_BIN = $(SERVER_DIR)/server

.PHONY: all build-elm move-dist build-server clean

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
	$(CXX) $(CXXFLAGS) $(SERVER_MAIN) -o $(SERVER_BIN) $(LDFLAGS)


clean:
	@echo "rm'ing server executable and static site build directory in $(SERVER_BIN) and $(TARGET_DIR)."
	rm -rf $(SERVER_BIN) $(TARGET_DIR)

clean-logs:
	@echo "Clearing logfile..."
	truncate -s 0 $(SERVER_DIR)/logs/server.log
