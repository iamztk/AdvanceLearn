SpringBoot集成Redis

1、SpringBoot操作数据 ： Spring-Data  [全在这个中支持] 包括jpa,jdbc,mongodb,redis等
	SpringData也适合SpringBoot齐名的项目
	
2、在springboot2.x之后，原来使用的jedis被替换为lettuce了，为什么？		
	jedis：采用的直连，多个线程操作的话，是不安全的，如果想要避免不安全，使用jedis pool连接池！更像BIO模式
	lettuce：采用netty，实例可以在多个线程中共享，不存在线程不安全的情况！可以减少线程数据，更像NIO模式
	
3、springboot 的所有配置类，都有一个自动配置类，自动配置类都会绑定一个properties配置文件
	去spring-boot-autoconfigure -> META-INF -> spring.factories -> 查找关键字redis
	即可查找到redis的默认配置类


默认配置类如下：
@Configuration(
    proxyBeanMethods = false
)
@ConditionalOnClass({RedisOperations.class})
@EnableConfigurationProperties({RedisProperties.class})
@Import({LettuceConnectionConfiguration.class, JedisConnectionConfiguration.class})
public class RedisAutoConfiguration {
    public RedisAutoConfiguration() {
    }

    @Bean
    @ConditionalOnMissingBean(  --该注解表明：如果不存在该bean，则默认使用配置中的bean
        name = {"redisTemplate"}
    )
    @ConditionalOnSingleCandidate(RedisConnectionFactory.class)  --RedisConnectionFactory 
    public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory) {
		--一般都会重写，希望的是<String, Object>
        RedisTemplate<Object, Object> template = new RedisTemplate();
        template.setConnectionFactory(redisConnectionFactory);
        return template;
    }

    @Bean
    @ConditionalOnMissingBean
    @ConditionalOnSingleCandidate(RedisConnectionFactory.class)
    public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory) {
        StringRedisTemplate template = new StringRedisTemplate();
        template.setConnectionFactory(redisConnectionFactory);
        return template;
    }
}