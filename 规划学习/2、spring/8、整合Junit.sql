Spring整合Junit4
1、jar包
	spring-test.jar
	
2、测试代码

	@RunWith(SpringJUnit4ClassRunner.class)
	@ContextConfiguration("classpath:bean1.xml")
	public class TestDemo02 {

		@Autowired
		private User user;

		@Test
		public void testDemo_02(){
			user.add();
		}

Spring整合Junit5
测试代码:
	@ExtendWith(SpringExtension.class)
	@ContextConfiguration("classpath:bean1.xml")
	public class Junit5Test {
		
	}
	
	--将两个注解整合成一个
	@SpringJUnitConfig(locations = "classpath:bean1.xml")
	public class Junit5Test {

	}