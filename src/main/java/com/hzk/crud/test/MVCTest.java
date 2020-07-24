package com.hzk.crud.test;

import com.github.pagehelper.PageInfo;
import com.hzk.crud.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * Spring4需要Servlet3.0支持
 * 使用Spring模块提供的测试请求功能，测试crud请求的正确性
 * @author hzk
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration       //用于配合 @Autowired获取WebApplicationContext容器
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:dispatcherServlet-servlet.xml"})
public class MVCTest {
    //传入Springmvc的IOC
    @Autowired
    WebApplicationContext webApplicationContext;
    //模拟虚拟的MVC请求，获取处理结果
    MockMvc mockMvc;

    //表示在任意使用@Test注解标注的public void方法执行之前执行
    @Before
    public void initMockMvc(){
        //这个mockMvc可以用来模拟SpringMvc请求发送
         mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
    }

    @Test
    public void testPage() throws Exception {
        //1.模拟get请求操作，并且拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5")).andReturn();

        //2.请求成功后，请求域中会有pageInfo,我们取出pageInfo
        MockHttpServletRequest request = result.getRequest();
        PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码："+pi.getPageNum());
        System.out.println("总页码："+pi.getPages());
        System.out.println("总记录数："+pi.getTotal());
        System.out.println("当前页码需要连续显示的页码：");
        int[] nums = pi.getNavigatepageNums();
        for (int i : nums){
            System.out.println("  "+i);
        }

        System.out.println("获取员工数据:");
        List<Employee> list = pi.getList();
        for (Employee employee:list
             ) {
            System.out.println("ID:"+employee.getEmpId()+"==>Name"+employee.getEmpName()+"==>gender"+
                    employee.getGender()+"==>email"+employee.getEmail());
        }


    }
}
