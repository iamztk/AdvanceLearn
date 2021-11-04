Redis特殊数据类型：Geospatial --描述地理位置的

1、 geoadd key  经度 纬度 城市 [value...]  --添加城市经纬度
	geopos key  城市  --查询城市所在的经纬度
	geodist key 城市1 城市2  --计算城市1到城市2之间的距离  可以自行设置单位 m/km/...
	
	
    有效的经度从-180度到180度。
    有效的纬度从-85.05112878度到85.05112878度。
	当坐标位置超出上述指定范围时，该命令将会返回一个错误。
	
		127.0.0.1:6379> geoadd china:city 116.23 40.22 beijing
		(integer) 1
		127.0.0.1:6379> geoadd china:city 112.00 27.72 loudi 111.88 27.8 gansu
		(integer) 2
		127.0.0.1:6379> geoadd china:city 181 30 tiankong  --超出经纬度限制，返回错误
		(error) ERR invalid longitude,latitude pair 181.000000,30.000000
		127.0.0.1:6379> geoadd china:city 180 86 tiankong
		(error) ERR invalid longitude,latitude pair 180.000000,86.000000
		127.0.0.1:6379> geopos china:city beijing
		1) 1) "116.23000055551529"
		   2) "40.220001033873984"
		127.0.0.1:6379> geopos china:city loudi
		1) 1) "112.00000137090683"
		   2) "27.720000824103515"
		127.0.0.1:6379> geodist china:city beijing loudi
		"1443540.8073"
		127.0.0.1:6379> geodist china:city beijing loudi km
		"1443.5408"
		127.0.0.1:6379>  

2、georadius key  经度 纬度 半径 单位（m/km/...） [withcoord-显示经纬度]	[withdist -显示距离]
		127.0.0.1:6379> georadius china:city 110 30 1000 km --以110 30 为中心，查找半径1000km内的城市
		1) "loudi"
		2) "gansu"
		127.0.0.1:6379> georadius china:city 110 30 5000 km
		1) "loudi"
		2) "gansu"
		3) "beijing"
		127.0.0.1:6379> georadius china:city 110 30 1000 km withdist  --需返回离110 30 该中心点的距离
		1) 1) "loudi"
		   2) "319.7765"
		2) 1) "gansu"
		   2) "305.5831"
		127.0.0.1:6379> georadius china:city 110 30 1000 km withcoord  --需返回在半径1000km内的城市的经纬度
		1) 1) "loudi"
		   2) 1) "112.00000137090683"
			  2) "27.720000824103515"
		2) 1) "gansu"
		   2) 1) "111.87999933958054"
			  2) "27.79999915861341"
		127.0.0.1:6379> geopos china:city loudi
		1) 1) "112.00000137090683"
		   2) "27.720000824103515"

3、georadiusbymember key 城市 半径 单位[m/km/...]
		127.0.0.1:6379> georadiusbymember china:city beijing 1000 km --返回以北京为中心，1000km内的城市
		1) "beijing"
		127.0.0.1:6379> georadiusbymember china:city loudi 1000 km  
		1) "loudi"
		2) "gansu"


4、geohash  --返回一个或多个位置元素的geohash表示
	该命令将返回11个字符的geohash字符串！
	--将一个二维的经纬度转化为一维的字符串，两个字符串越相似，则距离越近
	127.0.0.1:6379> geohash china:city beijing loudi
	1) "wx4sucu47r0"
	2) "wkztsw7btn0"
	
	
5、geo的底层使用的是Zset，可以通过Zset的命令来操作geo元素
	127.0.0.1:6379> zrange china:city 0 -1  --查询
	1) "loudi" 
	2) "gansu"
	3) "beijing"
	127.0.0.1:6379> zrem china:city gansu  --删除
	(integer) 1
	127.0.0.1:6379> zrange china:city 0 -1
	1) "loudi"
	2) "beijing"
	127.0.0.1:6379>   
























