事务概念

1、什么是事务 ？
	事务是数据库操作最基本单元，逻辑上一组操作，要么都成功，要么都失败。

2、事务的四个特性（ACID）
	原子性
	一致性
	隔离性
	持久性
	
3、事务操作（Spring事务管理介绍）
1、事务添加到JavaEE三层结构里面Service层（业务逻辑层）
2、在Spring即兴事务管理操作：
	两种方式：
		1、编程式事务管理
			通过代码实现事务的开启，提交和回滚【不建议使用】
		2、声明式事务管理
		
3、声明式事务管理
	1、基于注解方式
	2、基于XML配置文件方式
	
4、在Spring中进行声明式事务管理，底层使用到了AOP原理。

5、Spring事务管理API
	1、提供了一个接口，代表事务管理器，这个接口针对不同的框架提供了不同的实现类
		接口：PlatformTransactionManager
		
6、注解声明式事务管理
	<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"  --aop需要用到的名称空间
       xmlns:tx="http://www.springframework.org/schema/tx"	  --tx事务需要用到的名称空间
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
                           http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd
                           http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd">

        <!--开启注解扫描-->
        <context:component-scan base-package="com.itguigu.spring.aop"></context:component-scan>

        <!--开启aop扫描-->
        <aop:aspectj-autoproxy></aop:aspectj-autoproxy>
		
		<!--开启事务注解-->
        <tx:annotation-driven transaction-manager="transactionManager"></tx:annotation-driven>


        <!--数据库连接池-->
        <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource" destroy-method="close">
                <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
                <property name="url" value="jdbc:mysql:///user_db"></property>  --自己数据库的名称
                <property name="username" value="admin"></property>
                <property name="password" value="root"></property>
        </bean>

        <!--jdbcTemplate对象-->
        <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
                <property name="dataSource" ref="dataSource"></property>
         </bean>

        <!--配置事务管理器-->
        <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
                <property name="dataSource" ref="dataSource"></property>
        </bean>

</beans>

	在Service类或者方法上添加注解：@Transactional
		加在类上，则相当于类中所有的方法上都添加了该注解
		加在方法上，则表明只有改方法 存在事务。
		
7、声明式事务管理参数配置
	在@Transactional（value=""）
	是可以配置value的值，value的值有如下几种：
	1、propagation:事务传播行为
			方法一：
				@Transaction(propagation = "Propagation.required")
				public void add(){
					
					update();
				}
			方法二：
				public void update(){
				
				}
			事务传播行为可以由传播属性指定： 
			
				1、required:
						如果有事务在运行，当前的方法就在这个事务内运行，
					否则就启动一个新的事务，并在自己的事务内运行。									
						问：如果原来有事务，则该方法在这个事务中启用，如果出现
					异常，那么这个事务是全部回滚吗？
				2、qeruires_new：
						不管add()中是否有事务，反正在执行update()时，否会开启
					一个新事务，并将add()中的事务挂起。
				3、supports:
						add()中有事务，则update()在该事务中运行，否则，
					update()不开启事务。
				4、Not_supporte...:
						update()方法，不运行在事务中，如果add()有事务，则挂起。
				5、mandatory:
						update()方法必须运行在事务中，没有事务则抛异常。
				6、Nested：
						add()有事务，则update()在该事务内运行，否则
					update()则启动一个事务，并在自己的事务内部运行。
					
	2、ioslation：事务隔离级别
		    @Transactional(propagation= Propagation.REQUIRED, isolation= Isolation.REPEATABLE_READ)
			四大事务隔离级别：
				read uncommitted
				read commited
				repeatable read
				serialable
	
	3、timeout：超时时间
		(1)事务需要在一定的时间内进行提交，如果不提交则进行回滚
		(2)默认值为-1， 即没有超时时间，单位是秒
		@Transactional(timeout = 5)
	
	4、readOnly：是否只读
		(1)默认值为false，可以进行修改
	    @Transactional(readOnly = false)

	
	5、rollbackFor：回滚
	    @Transactional(rollbackFor = Exception.class)
		所以异常都回滚。
		如果是有具体的
		    @Transactional(rollbackFor = NullPointerException.class)
		则只有在空指针异常的时候，才会回滚。
	
	7、noRollbackFor：不回滚
		与上相反。

	
8、使用XML完成声明式事务配置
	 <!--配置事务通知-->
    <tx:advice id="txadvice">
        <!--配置事务参数-->
        <tx:attributes>
            <tx:method name="insert" propagation="REQUIRED"/>
            <!--<tx:method name="inser*" progapation="REQUIRED>-->
            <!--通配符匹配，所有以inser为前缀的都添加该事务传播行为-->
        </tx:attributes>
    </tx:advice>

    <!--配置切入点和切面：aop的典型应用就是事务-->
    <aop:config>
	--spring.tx.中所有的类中所有的方法都有配置事务，并配置其事务传播行为为required
        <aop:pointcut id="pt" expression="execution(* com.itguigu.spring.tx.*.*.*(..))"/>
        <aop:advisor advice-ref="txadvice" pointcut-ref="pt" ></aop:advisor>
    </aop:config>
		
		
9、完全注解的方式进行编写（不再使用xml中的配置）
/**
 * 完全注解方式编写
 */
@Configuration
@ComponentScan(value = "com.itguigu.spring.tx")
@EnableAspectJAutoProxy
public class SpringConfig {

    /**
     * 配置连接池
     * @Bean：则spring会默认创建该对象，存放于单例池中
     */
    @Bean
    public DruidDataSource getDruidDataSource(){
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/mybatis");
        dataSource.setUsername("root");
        dataSource.setPassword("admin");
        return dataSource;
    }

    /*
    *配置JDBC
    */
    @Bean
    public JdbcTemplate getJdbcTemplate(DataSource dataSource){
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.setDataSource(dataSource);
        return jdbcTemplate;
    }

    /**
     * 配置事务管理器
     */
    @Bean
    public DataSourceTransactionManager getDataSourceTransactionManager(DataSource dataSource) {
        DataSourceTransactionManager dataSourceTransactionManager = new DataSourceTransactionManager();
        dataSourceTransactionManager.setDataSource(dataSource);
        return dataSourceTransactionManager;
    }
}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		