package com.hzk.crud.controller;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.PageInterceptor;
import com.hzk.crud.bean.Employee;
import com.hzk.crud.bean.Msg;
import com.hzk.crud.service.EmployeeService;
import com.sun.org.apache.xpath.internal.XPathVisitable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工的CRUD请求
 * @author  hzk
 */
@Controller
public class EmployeeContoller {

    @Autowired
    EmployeeService employeeService;
    /**
     * 查询员工数据（分页查询），采用非JSON方式
     * @return
     */
//    @RequestMapping("/emps")
//    public String getEmps(@RequestParam(value ="pn",defaultValue = "1") int pn, Model model){  //传入页码位置
//        //这不是一个分页
////        List<Employee> emps =employeeService.getAll();
//        //引入pageHelper分页插件
//        PageHelper.startPage(pn,10);
//        //startPage 后面紧跟着的这个查询就是一个分页查询
//        List<Employee> emps =employeeService.getAll();
//        //使用pageInfo包装查询后的结果，只需要将pageInfo交给显示页面就行了
//        //pageInfo封装了详细的分页信息，包括我们查询出来的数据
//        PageInfo pageInfo=new PageInfo(emps,5);     //navigatePage  传入连续显示的页数
//        model.addAttribute("pageInfo",pageInfo);      //将封装数据放在请求域中
//        return "list";
//    }


    /**
     * 导入Jsckson包，@ResponseBody才可以正常使用，才可使对象转化为JSON字符串
     *采用JSON的方式
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value ="pn",defaultValue = "1") int pn){
        //这不是一个分页
        //List<Employee> emps =employeeService.getAll();
        //引入pageHelper分页插件
        PageHelper.startPage(pn,10);
        //startPage 后面紧跟着的这个查询就是一个分页查询
        List<Employee> emps =employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给显示页面就行了
        //pageInfo封装了详细的分页信息，包括我们查询出来的数据
        PageInfo pageInfo=new PageInfo(emps,5);     //navigatePage  传入连续显示的页数
        return  Msg.success().add("pageInfo",pageInfo);
    }

    /**
     * 1，支持JSR-303校验
     * 2，导入hibernate-Validate
     * //@Valid表示需要给对象进行校验
     * BindingResult 对象用来封装校验结果信息
     * 员工保存
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/emp",method = RequestMethod.POST)
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String,Object> map=new HashMap<String,Object>();
            List<FieldError> errors= result.getFieldErrors();
            for (FieldError fieldError:errors) {
                System.out.println("错误字段："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 校验用户名是否可用
     * @param empName
     * @return
     */

    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkuser(@RequestParam("empName") String empName){   //@RequestParam表示明确要取出的数据
        // 先判断用户名是否合法的表达式
        String regx="(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if(!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名必须是2-5位中文，或者6-16的英文和数字的组合");
        }
        //数据库用户名重复校验
        boolean b=  employeeService.checkUser(empName);
         if(b){
          return Msg.success();
        }else {
          return Msg.fail().add("va_msg","用户名已存在");
         }

    }

    /**
     * 根据id进行查询任务
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id ){  //@PathVariable("id")获取路径中的参数
        Employee employee=employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }


    /**
     * 员工更新
     * @param employee
     * @return
     */
    /**
     *1.
     */
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee){
        System.out.println("更新员工信息：="+employee.toString());
        employeeService.updateEmp(employee);
        return  Msg.success();
    }

    /**
     * 批量删除/单个删除二合一
     * 单个：1
     * 批量：1-2-3-4
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/delete/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids") String ids){
        if(ids.contains("-")){
            List<Integer> list=new ArrayList<>();
            String[] splits = ids.split("-");
            for (String str:splits){
                list.add(Integer.parseInt(str));
            }
            employeeService.deleteBach(list);

        }else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }


}
