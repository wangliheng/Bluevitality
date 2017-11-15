#request 就是 request context。当 HTTP 请求过来的时候进入这个上下文

#Example 1
from flask import Flask
from flask import render_template, redirect,url_for
from flask import request

app = Flask(__name__)

@app.route('/login', methods=['POST','GET'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username']=='admin':
            return redirect(url_for('home',username=request.form['username']))
        else:
            error = 'Invalid username/password'
    return render_template('login.html', error=error)

@app.route('/home')
def home():
    return render_template('home.html', username=request.args.get('username'))

if __name__ == '__main__':
    app.debug = True
    app.run('0.0.0.0',80)


#Example 2
class Flask(_PackageBoundObject):  
  
# 省略一部分代码  
  
    def wsgi_app(self, environ, start_response):  
        ctx = self.request_context(environ)     #上下文变量ctx被赋值为request_context(environ)的值  
        ctx.push()                              #  


#Example 3
#下面的示例在访问首页 / 时设置cookie，并在访问 /page2 时读取cookie：
@app.route('/')
def index():
   rsp = make_response('go <a href="%s">page2</a>' % '/page2')
   rsp.set_cookie('user','JJJJJohnny')
   return rsp
@app.route('/page2')
def page2():
   user = request.cookies['user']
   return 'you are %s' % user
