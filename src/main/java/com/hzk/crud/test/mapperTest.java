package com.hzk.crud.test;


import com.hzk.crud.bean.Department;
import com.hzk.crud.bean.Employee;
import com.hzk.crud.dao.DepartmentMapper;
import com.hzk.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * @author  hzk
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class mapperTest {

    /**
     * 测试departmentMapper
     */
//    @Test
//    public  void testCRUD() {
//    //1，创建SpringIOC容器
//        ApplicationContext ioc=new ClassPathXmlApplicationContext("applicationContext.xml");
//    //2，从容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
//    }
    /*
        推荐Spring项目的可以使用Spring的单元测试，可以自动加入我们需要的组件
        1.现在pom.xml中引入spring-test依赖
        2.@ContextConfiguration指定Spring配置文件的位置，locations的值为一个数组，指定配置文件的位置
        3.@RunWith()是Junit里面的注解，表示用哪一个单元测试模块，这里使用的SpringJUnit4ClassRunner.class模块,
        这里所有的@Test的运行都是靠SpringJUnit4ClassRunner.class模块
    */
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;
    @Test
    public void testCRUD(){
        //插入部门
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));
//        for (int i=0;i<1100;i++){
//            employeeMapper.deleteByPrimaryKey(i);
//        }


        //插入员工信息
//        employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@hzk.com",1));
//        employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@hzk.com",1));

        //批量插入多个员工，批量，使用可以执行批量操作的sqlSession
        //获取mapper，可以进行批量操作
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);

        for (int i=0;i<1000;i++){
            String uid = UUID.randomUUID().toString().substring(0, 5)+1;
            mapper.insertSelective(new Employee(null,uid,"M",uid+"@hzk.com",1));
        }
        System.out.println("操作成功！");

    }
}
