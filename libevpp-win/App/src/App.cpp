#include <iostream>
#include <cctype>
#include <cwctype>
#include <cstdlib>
#include <string>
#include <cstdarg>
#include <cstdio>
#include <direct.h>

#include <evpp\tcp_server.h>
#include <evpp\buffer.h>
#include <evpp\tcp_conn.h>
#include <evpp\http\service.h>
#include <evpp\http\http_server.h>
#include <evpp\event_loop_thread_pool.h>

#include <evpp\stringutil.h>
#include <evpp\event_loop.h>
#include <evpp\xhttp/xhttp.h>
#include <evpp\xhttp/httpresponse.h>
#include <evpp\xhttp/httpserver.h>
#include <evpp\xhttp/httpconnection.h>

#include <event2/http_struct.h>
#include <event2/http.h>


#include <3partyInc.h>


#ifdef _WIN32
#include "winmain-inl.h"
#endif

#define GLOG_PATH	".\\logs"

using namespace evpp;

using namespace evpp::xhttp;

void funtionOnXhttpppDefaultCallback(const HttpConnectionPtr_t& conn, const HttpRequest& req) 
{
	HttpResponse resp(200);
	std::string sResp = req.url;
	resp.appendBody(sResp);
	conn->send(resp);
};

int main(int argc, char *argv[], char *env[])
{
	_mkdir(GLOG_PATH);
	FLAGS_log_dir = GLOG_PATH;
	google::InitGoogleLogging(argv[0]);
	FLAGS_colorlogtostderr = true;  // Set log color
	FLAGS_logbufsecs = 0;  // Set log output speed(s)
	FLAGS_max_log_size = 1024;  // Set max log file size
	FLAGS_stop_logging_if_full_disk = true;  // If disk is full

	std::string s = "This is test";
	std::cout << s << std::endl;
	std::cout << evpp::StringUtil::upper(s) << std::endl;

	evpp::EventLoop* loop = new evpp::EventLoop();
	evpp::xhttp::HttpServer httpServer(loop, "0.0.0.0:9999", "test", 4);
	httpServer.setHttpCallback("/test", [](const HttpConnectionPtr_t& conn, const HttpRequest& req) {
		std::cout << "OnHttpRequest" << std::endl;
		HttpResponse resp(200);
		resp.appendBody("Hello World!");

		conn->send(resp);
	});

	httpServer.setHttpDefaultCallback(funtionOnXhttpppDefaultCallback);

	httpServer.Init();
	httpServer.Start();

	loop->Run();

	delete loop;

	google::ShutdownGoogleLogging();

	return 0;
}