#Example 1
from flask import Flask, session, redirect, url_for, escape, request

app = Flask(__name__)

@app.route('/')
def index():
    if 'username' in session:
        return 'Logged in as %s' % escape(session['username'])
    return 'You are not logged in'

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return '''
        <form action="" method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
    '''

@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('username', None)
    return redirect(url_for('index'))

# set the secret key.  keep this really secret:
app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'


#Example 2
from flask import Flask,session,redirect,url_for,request,render_template
app = Flask(__name__)
app.secret_key='123'    #配置secret_key,否则不能实现session对话
@app.route('/')
def index():
    if session.get('username') == 'wanghao' and session.get('password') == '123':
        return "你已经登陆"
    msg="没有登陆"
    return render_template('from_login.html')

@app.route("/login",methods=["POST","GET"])
def login():
    if request.method=='POST':
        session['username']=request.form['username']
        session['password']=request.form['password']
        return redirect(url_for('index'))
    return '123'

if __name__ == '__main__':
    app.debug=True
    app.run(port=7998)
