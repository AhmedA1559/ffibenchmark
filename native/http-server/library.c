#include <stdio.h>
#include <pthread.h>
#include "mongoose.h"
#include "mjson.h"

static void f5(struct mg_connection *c, int ev, void *ev_data, void *fn_data) {
    if (ev == MG_EV_HTTP_MSG) {
        struct mg_http_message *hm = (struct mg_http_message *) ev_data;
        double value;
        mjson_get_number(hm->body.ptr, hm->body.len, "$.value", &value);
        mg_http_reply(c, 200, "", "%d\n", (int) value);
    }
}

static void f4(struct mg_connection *c, int ev, void *ev_data, void *fn_data) {
    if (ev == MG_EV_HTTP_MSG) {
        struct mg_http_message *hm = (struct mg_http_message *) ev_data;
        //mg_printf(c, "HTTP/1.0 200 OK\n\n%.*s", (int) hm->uri.len, hm->uri.ptr);
        printf("%s\r\n", hm->message.ptr);
    }
}

void run() {
    struct mg_mgr mgr;
    const char *url = "http://localhost:8000";
    struct mg_connection *c;
    int i;
    mg_mgr_init(&mgr);
    mg_http_listen(&mgr, url, f5, NULL);
    c = mg_http_connect(&mgr, url, f4, NULL);
    for (int k = 1; k <= 10; k++)mg_printf(c, "POST / HTTP/1.0\nContent-Length: 10\nContent-Type: application/json\n\n{\"value\":%d}", k);
    for (i = 0; i < 5; i++) mg_mgr_poll(&mgr, 1);
    mg_mgr_free(&mgr);
}