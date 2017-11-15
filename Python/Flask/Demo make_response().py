def cookies_login():
    name = request.args.get("username", False)
    password = request.args.get("password", False)

    if not password == "password" or not name:
        abort(401)

    resp = make_response("You are now authorized")
    resp.set_cookie("username", name)
    return resp
    
