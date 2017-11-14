#### code
```python
app = Flask(__name__)  
app.config['SECRET_KEY'] = "a complex string"  

from flask.ext.wtf import Form  
from wtforms import StringField, SubmitField  
from wtforms.validators import Required  
  
class NameForm(Form):  
    name = StringField('What is your name',  validators = [Required])  
    submit = SubmitField('Submit')

@app.route('/', methods=['GET','POST'])  
def index():  
    name = None  
    form = NameForm()                 #表单类实例  
    if form.validate_on_submit():     #如果验证通过  
        name = form.name.data         #获取表单name字段的值  
        form.name.data = ''  
    return render_template('index.html', form = form, name = name)  
    
```
#### model
```python
<form>  
    {{form.hidden_tag()}}  
    {{form.name.label}} {{form.name()}}  
    {{form.submit()}}  
</form>  
```
