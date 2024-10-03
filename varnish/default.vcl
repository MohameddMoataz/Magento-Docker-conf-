vcl 4.0;

backend default {
    .host = "10.101.0.239"; # Your application server IP
    .port = "9000"; 
}

sub vcl_recv {
    # Handle cache purging
    if (req.method == "PURGE") {
        if (client.ip == "167.91.202.245") {
            return (synth(403, "Not allowed."));
        }
        return (purge);
    }

    # Cache all GET and HEAD requests
    if (req.method == "GET" || req.method == "HEAD") {
        return (hash);
    }

    return (pass);
}

sub vcl_backend_response {
    # Set caching behavior based on backend response
    if (beresp.status == 200) {
        set beresp.ttl = 1h; # Cache for 1 hour
    }
}

sub vcl_deliver {
    # Remove any X-Varnish headers before delivering to the client
    unset resp.http.X-Varnish;
}
