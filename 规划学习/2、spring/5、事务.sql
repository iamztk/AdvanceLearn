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
	
	2、ioslation：事务隔离级别
	
	3、timeout：超时时间
	
	4、readOnly：是否只读
	
	5、rollbackFor：回滚
	
	7、noRollbackFor：不回滚
	
	aa
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		