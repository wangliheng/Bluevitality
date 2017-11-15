
app.route('/<post_id>/edit')
def edit(post_id):
    #do somethig
    pass
    
app.route('/<post_id>/delete')
def del(post_id):
    #del something
    pass

#Example：

  url_for('edit', post_id=post.id)  #动态部分作为参数传入，即：/<post_id>/edit
  url_for('del', post_id=post.id)


# url_for('user', name='john', _external=True) 的返回结果是 http://localhost:5000/user/john  (_external=True 返回绝对地址)
# url_for('index', page=2) 的返回结果是 /?page=2。 (函数可将任何额外的参数添加查询字符串中)

