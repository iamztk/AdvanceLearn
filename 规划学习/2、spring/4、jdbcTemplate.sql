jdbcTemplate详解：

1、依赖的jar包：
	druid, mysql-con, spring-jdbc, spring-tx(事务)
	spring-orm(整合mybatis等需要)
	
2、XML配置：
	1、数据库连接
	2、配置JdbcTemplate
		<bean id="" class="org.springframework. jdbc.core.JdbcTemplate">
			<property name="dataSource" ref="dateSource" />
		</bean>
	
3、代码编写：
	在dao实现类中注入jdbcTemplate对象
	
	UserImpl:
	
	private JdbcTemplate jdbcTemplate;
	
	public void add(Book book){
		--sql：是需要执行的语句
		例如：String sql = "insert into t_book values(?,?,?)";
		jdbcTemplate.update(sql, book.getId(),book.getName,..);
		--args：sql语句中的参数
		jdbcTemplate.update(String sql, Object ... args)
		}
		--修改和删除是一样的，只是执行的语句不同：
		update t_book set t.name = ? where t.id = ?
		
	2、查询	
		1、查询返回某个值
			--Integer.class: sql语句的返回值类型
			jdbcTemplate.queryForObject(sql, Integer.class);
			
		2、查询返回某个对象
			jdbcTemplate.queryForObject(
				sql, RowMapper<T> rowMapper, args)
			
			rowMapper:RowMapper是个接口，返回不同的数据类型，是用这个接口里面实现类完成数据封装。
			具体使用：(返回值的类型由RowMapper中的类型决定)
				Book book = jdbcTemplate.queryForObject(
					sql, new BeanPropertyRowMapper<Book>(Book.class), args);
			
		3、查询返回某个集合
			List<T> list = jdbcTemplate.query(sql, RowMapper<T>, args)
		
