#Example 1
def cookies_login():
    name = request.args.get("username", False)
    password = request.args.get("password", False)

    if not password == "password" or not name:
        abort(401)

    resp = make_response("You are now authorized")
    resp.set_cookie("username", name)
    return resp


#Example 2
def session_login():
    name = request.args.get("username", False)
    password = request.args.get("password", False)
    print name, password
    if not password == "password" or not name:
        abort(401)

    resp = make_response("You are now authorized")
    session['username'] = name
    session['login-time'] = datetime.now()
    return resp


#Example 3
def dynamic_js():
    from sagenb.notebook.js import javascript
    # the javascript() function is cached, so there shouldn't be a big slowdown calling it
    data,datahash = javascript()
    if request.environ.get('HTTP_IF_NONE_MATCH', None) == datahash:
        response = make_response('',304)
    else:
        response = make_response(data)
        response.headers['Content-Type'] = 'text/javascript; charset=utf-8'
        response.headers['Etag']=datahash
    return response
