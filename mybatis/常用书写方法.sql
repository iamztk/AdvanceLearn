1、<include refid="sql">:
    include标签引用，可以复用SQL片段 
	sql标签中id属性对应include标签中的refid属性。通过include标签将sql片段和原sql片段进行拼接成一个完整的sql语句进行执行
	
示例：
<select id="selectMonthByPage" parameterType="java.util.Map" resultMap="BaseResultMap">
		select
			<include refid="Base_Column_List" />
		from bawageotherbonus
		where bonusmonth = #{bonusMonth, jdbcType=VARCHAR}	
		order by serialno desc
</select>
<sql id="Base_Column_List">
  		SERIALNO, BONUSMONTH, MANAGECOM, AGENTNUM, NAME, WAGEOTHERMONEY,
  		WAGETYPE, REMARK, DATASOURCE, SYSTEMNODE, REVIEWSTATE, BAK1,
  		BAK2, BAK3, OPERATOR, MAKEDATE, MAKETIME, MODIFYOPERATOR,
  		MODIFYDATE, MODIFYTIME
</sql>

2、<trim>标签
	mybatis的trim标签一般用于去除sql语句中多余的and关键字，逗号，
或者给sql语句前拼接 “where“、“set“以及“values(“ 等前缀，或者添加“)“等后缀，
可用于选择性插入、更新、删除或者条件查询等操作
	prefix: 给sql语句拼接的前缀
	suffix: 给sql语句拼接的后缀
	prefixOverrides:去除sql语句前面的关键字或字符，该关键字或者字符又prefixOverrides属性指定，
假设该属性指定为"AND",当sql语句的开头为"AND",trim标签将会去除该"AND"
	suffixOverrides:去除sql语句后面的关键字或字符，该关键字或者字符由suffixOverrides属性指定。
<trim prefix="(" suffix=")">
			<include refid="Base_Column_List" />		
</trim>

3、
 <delete id="deleteBatch" parameterType="java.lang.String" >
        <foreach collection="list" index="index" item="item" open="begin" close=";end;" separator=";">
	  		 delete from LDSYSMAILSENDER
	  		 where MANAGECOM = #{item.managecom,jdbcType=VARCHAR}
	          and MAILTYPE = #{item.mailtype,jdbcType=VARCHAR}
	          and MAILPARA = #{item.mailpara,jdbcType=VARCHAR}
  		</foreach>
    </delete>
解析：
collection：
index:在list和数组中,index是元素的序号，在map中，index是元素的key，该参数可选(暂未发现用途)
item:集合中元素迭代时的别名，该参数为必选
open: 前缀
close: 后缀
separator: 参数间的分隔符

示例：
 <select id="countByUserList" resultType="_int" parameterType="list">
2 select count(*) from users
3   <where>
4     id in
5     <foreach item="item" collection="list" separator="," open="(" close=")" index="">
6       #{item.id, jdbcType=NUMERIC}
7     </foreach>
8   </where>
9 </select>



















