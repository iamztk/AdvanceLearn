//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.springframework.beans.factory.config;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.SimpleTypeConverter;
import org.springframework.beans.TypeConverter;
import org.springframework.beans.factory.BeanClassLoaderAware;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.FactoryBeanNotInitializedException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.lang.Nullable;
import org.springframework.util.Assert;
import org.springframework.util.ClassUtils;
import org.springframework.util.ObjectUtils;
import org.springframework.util.ReflectionUtils;

public abstract class AbstractFactoryBean<T> implements FactoryBean<T>, BeanClassLoaderAware, BeanFactoryAware, InitializingBean, DisposableBean {
    protected final Log logger = LogFactory.getLog(this.getClass());
    private boolean singleton = true;
    @Nullable
    private ClassLoader beanClassLoader = ClassUtils.getDefaultClassLoader();
    @Nullable
    private BeanFactory beanFactory;
    private boolean initialized = false;
    @Nullable
    private T singletonInstance;
    @Nullable
    private T earlySingletonInstance;

    public AbstractFactoryBean() {
    }

    public void setSingleton(boolean singleton) {
        this.singleton = singleton;
    }

    public boolean isSingleton() {
        return this.singleton;
    }

    public void setBeanClassLoader(ClassLoader classLoader) {
        this.beanClassLoader = classLoader;
    }

    public void setBeanFactory(@Nullable BeanFactory beanFactory) {
        this.beanFactory = beanFactory;
    }

    @Nullable
    protected BeanFactory getBeanFactory() {
        return this.beanFactory;
    }

    protected TypeConverter getBeanTypeConverter() {
        BeanFactory beanFactory = this.getBeanFactory();
        return (TypeConverter)(beanFactory instanceof ConfigurableBeanFactory ? ((ConfigurableBeanFactory)beanFactory).getTypeConverter() : new SimpleTypeConverter());
    }

    public void afterPropertiesSet() throws Exception {
        if (this.isSingleton()) {
            this.initialized = true;
            this.singletonInstance = this.createInstance();
            this.earlySingletonInstance = null;
        }

    }

    public final T getObject() throws Exception {
        if (this.isSingleton()) {
            return this.initialized ? this.singletonInstance : this.getEarlySingletonInstance();
        } else {
            return this.createInstance();
        }
    }

    private T getEarlySingletonInstance() throws Exception {
        Class<?>[] ifcs = this.getEarlySingletonInterfaces();
        if (ifcs == null) {
            throw new FactoryBeanNotInitializedException(this.getClass().getName() + " does not support circular references");
        } else {
            if (this.earlySingletonInstance == null) {
                this.earlySingletonInstance = Proxy.newProxyInstance(this.beanClassLoader, ifcs, new AbstractFactoryBean.EarlySingletonInvocationHandler());
            }

            return this.earlySingletonInstance;
        }
    }

    @Nullable
    private T getSingletonInstance() throws IllegalStateException {
        Assert.state(this.initialized, "Singleton instance not initialized yet");
        return this.singletonInstance;
    }

    public void destroy() throws Exception {
        if (this.isSingleton()) {
            this.destroyInstance(this.singletonInstance);
        }

    }

    @Nullable
    public abstract Class<?> getObjectType();

    protected abstract T createInstance() throws Exception;

    @Nullable
    protected Class<?>[] getEarlySingletonInterfaces() {
        Class<?> type = this.getObjectType();
        return type != null && type.isInterface() ? new Class[]{type} : null;
    }

    protected void destroyInstance(@Nullable T instance) throws Exception {
    }

    private class EarlySingletonInvocationHandler implements InvocationHandler {
        private EarlySingletonInvocationHandler() {
        }

        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            if (ReflectionUtils.isEqualsMethod(method)) {
                return proxy == args[0];
            } else if (ReflectionUtils.isHashCodeMethod(method)) {
                return System.identityHashCode(proxy);
            } else if (!AbstractFactoryBean.this.initialized && ReflectionUtils.isToStringMethod(method)) {
                return "Early singleton proxy for interfaces " + ObjectUtils.nullSafeToString(AbstractFactoryBean.this.getEarlySingletonInterfaces());
            } else {
                try {
                    return method.invoke(AbstractFactoryBean.this.getSingletonInstance(), args);
                } catch (InvocationTargetException var5) {
                    throw var5.getTargetException();
                }
            }
        }
    }
}
