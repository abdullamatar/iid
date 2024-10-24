#pragma once

#include <ctime>
#include <cassert>
#include <fstream>
#include <iostream>
#include <sstream>
#include <mutex>
#include <stdexcept>
#include <filesystem>

#define assertm(exp, msg) assert(((void)msg, exp))

enum LogLevel
{
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    CRITICAL
};

class Logger
{
public:
    Logger(const std::string &fname)
    {
        try
        {
            if (!std::filesystem::exists("logs"))
            {
                std::filesystem::create_directory("logs");
            }

            std::string filepath = "logs/" + fname;

            logFile.open(filepath, std::ios::app);

            if (!logFile.is_open())
            {
                throw std::runtime_error("Error opening: " + filepath);
            }
        }
        catch (const std::exception &e)
        {
            std::cerr << "Error opening log file, make sure it exists" << e.what() << std::endl;
        }
    }
    ~Logger()
    {
        if (logFile.is_open())
        {
            logFile.close();
            assertm(!logFile.is_open(), "Failed to close log file in Logger destructor.");
        }
    }

    void log(LogLevel level, const std::string &msg)
    {

        std::lock_guard<std::mutex> lock(logMutex);

        time_t now = time(0);
        tm *timeinfo = localtime(&now);

        // const char *format = "%Y-%m-%d  | TIME: %H:%M:%S";

        // size_t buff_size = strftime(NULL, 0, format, timeinfo) + 1;
        // std::vector<char> timestamp(buff_size);

        // change from hardcoded buffersize...
        char timestamp[40];

        strftime(timestamp, sizeof(timestamp), "%Y-%m-%d  | TIME: %H:%M:%S", timeinfo);

        std::ostringstream logEntry;
        logEntry << "[" << timestamp << "] "
                 << logLvlToString(level) << ": " << msg
                 << std::endl;

        std::cout << logEntry.str();

        if (logFile.is_open())
        {
            logFile << logEntry.str();
            logFile.flush();
        }
    }
    void setLogLevel(LogLevel lvl)
    {
        minLogLevel = lvl;
    }

private:
    std::ofstream logFile;
    LogLevel minLogLevel = INFO;

    std::mutex logMutex;

    std::string logLvlToString(LogLevel lvl)
    {
        switch (lvl)
        {
        case DEBUG:
            return "DEBUG";
        case INFO:
            return "INFO";
        case WARNING:
            return "WARNING";
        case ERROR:
            return "ERROR";
        case CRITICAL:
            return "CRITICAL";
        default:
            return "UNKNOWN";
        }
    }
};