# Example 1
from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root@localhost/test'
db = SQLAlchemy(app)

class User(db.Model):
	id = db.Column(db.Integer,primary_key=True)
	username = db.Column(db.String(32),unique=True)
	password = db.Column(db.String(32))
	def __init__(self,username,password):
		self.username = username
		self.password = password
	def add(self):
		try:
			db.session.add(self)
			db.session.commit()
			return self.id
		except Exception,e:
			db.session.rollback()
			return e
		finally:
			return 0
	def isExisted(self):
		temUser=User.query.filter_by(username=self.username,password=self.password).first()
		if temUser is None:
			return 0
		else:
			return 1


# Example 2
class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer,primary_key=True)
    username = db.Column(db.String(64),unique=True,index=True)

    role_id = db.Column(db.Integer,db.ForeignKey('roles.id'))
    #就是User类中添加了一个role_id变量，数据类型db.Integer,第二个参数指定外键是哪个表中的哪个id

class Role(db.Model):
    __tablename__ = 'roles'
    id = db.Column(db.Integer,primary_key=True)
    name = db.Column(db.String(64),unique=True)

    users = db.relationship('User',backref='role')	#一对多
#这句话比较复杂，仔细读下面的话：
#0.添加到Role模型中的users属性代表这个关系的面向对象视角。对于一个Role类的实例，其users属性将返回与角色相关联的用户组成的列表。
#db.Relationship()
#第1个参数表明这个关系的另一端是哪个模型（类）。如果模型类尚未定义可使用字串形式指定。
#第2个参数backref，将向User类中添加一个role属性，从而定义反向关系。这属性可替代role_id访问Role模型，此时获取的是模型对象而不是外键的值


