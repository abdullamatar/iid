#include "httplib.h"
#include <fstream>
#include <sstream>
#include <string>

bool file_exists(const std::string &path)
{
    std::ifstream file(path);
    return file.good();
}

// Helper function to read the contents of a file into a string
std::string read_file(const std::string &path)
{
    std::ifstream file(path);
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

int main()
{
    httplib::Server server;

    // Serve static files from the "dist" directory
    server.set_mount_point("/", "./dist");

    // Serve index.html for all unknown routes to handle client-side routing
    server.set_file_extension_and_mimetype_mapping("html", "text/html");
    server.Get(".*", [](const httplib::Request &req, httplib::Response &res)
               {
        std::string path = "./dist" + req.path;

        if (!file_exists(path)) {
            // If file doesn't exist, serve index.html to allow client-side routing
            std::string content = read_file("./dist/index.html");
            res.set_content(content, "text/html");
        } });

    // Start the server
    server.listen("0.0.0.0", 8080);

    return 0;
}
