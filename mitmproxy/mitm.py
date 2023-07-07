from mitmproxy import http

result = '''{
    "streaming_eligible": false
}'''


def request(flow: http.HTTPFlow) -> None:
    if flow.request.pretty_url == "https://api.honeygain.com/api/v1/ping":
        flow.response = http.Response.make(
            200,  # (optional) status code
            result.encode(),  # (optional) content
            {"Content-Type": "application/json"}  # (optional) headers
        )
