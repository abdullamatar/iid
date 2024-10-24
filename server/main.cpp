#define CPPHTTPLIB_OPENSSL_SUPPORT
#include "httplib.h"
#include "logger.h"

#include <fstream>
#include <sstream>
#include <string>

bool file_exists(const std::string &path)
{
    std::ifstream file(path);
    return file.good();
}

/**
 * @brief Reads the contents of a file into a string.
 *
 * This function opens a file specified by the given path, reads its entire
 * contents into a string, and returns the string. If the file cannot be
 * opened, the returned string will be empty.
 *
 * @param path The path to the file to be read.
 * @return A string containing the contents of the file.
 */
std::string read_file(const std::string &path)
{
    std::ifstream file(path);
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

int main()
{
    const bool DEBUG = 1;
    Logger logger("server.log");

    httplib::Server server;
    // httplib::SSLServer svr;

    auto ret = server.set_mount_point("/", "./dist");

    if (!ret)
    {
        throw std::runtime_error("Failed to set mount point, incorrect path");
    }
    // logger

    // server.set_logger([](const httplib::Request &req, const httplib::Response &res)
    //                   {
    //     if (req.path != "/status")
    //     {
    //         std::cout << req.method << " " << req.path << " -> " << res.status << std::endl;
    //     } });

    // lambdas cannot access local vars, pass var into "capture list", can capture by value, refr,
    server.set_logger([&logger](const auto &req, const auto &res)
                      {
                          std::ostringstream logMsg;
                          logMsg << req.method << " " << req.path << " -> " << res.status;
                          logger.log(INFO, logMsg.str()); });

    server.set_file_extension_and_mimetype_mapping("html", "text/html");
    server.set_file_extension_and_mimetype_mapping("svg", "image/svg+xml");

    server.Get(".*", [](const httplib::Request &req, httplib::Response &res)
               {
        std::string path = "./dist" + req.path;

        if (!file_exists(path)) {
            // If file doesn't exist, serve index.html to allow client-side routing
            std::string content = read_file("./dist/index.html");
            res.set_content(content, "text/html");
        } });

    if (DEBUG)
    {
        std::cout << "Server is starting..." << std::endl;
        std::cout << "Listening on http://localhost:8080" << std::endl;
    }
    server.listen("0.0.0.0", 8080);
    // std::cout << ""<< server.;

    return 0;
}
