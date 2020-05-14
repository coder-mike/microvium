cmake_minimum_required(VERSION 3.10)

project(restoring-a-snapshot-in-c)

add_executable(restoring-a-snapshot-in-c
              artifacts/5.restoring-a-snapshot-in-c.c
              "${PROJECT_SOURCE_DIR}/../../native-vm/microvium.c"
              )

target_include_directories(restoring-a-snapshot-in-c PUBLIC
                          "${PROJECT_SOURCE_DIR}/../../native-vm"
                          "${PROJECT_SOURCE_DIR}"
                          )