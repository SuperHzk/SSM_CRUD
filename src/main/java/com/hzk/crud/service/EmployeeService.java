package com.hzk.crud.service;

import com.hzk.crud.bean.Employee;
import com.hzk.crud.bean.EmployeeExample;
import com.hzk.crud.bean.Msg;
import com.hzk.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 查询所有员工
     * @return
     */
    public List<Employee> getAll() {

        return  employeeMapper.selectByExampleWithDept(null) ;

    }

    public void saveEmp(Employee employee){
        employeeMapper.insertSelective(employee);

    }

    /**
     * 检测用户名是否可用
     * @param empName
     * @return  true:代表当前姓名可用， false:代表用户名不可以
     */
    public boolean checkUser(String empName){
        EmployeeExample example=new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count==0;
    }


    /**
     * 查询员工信息
     * @param id
     * @return
     */
    public Employee getEmp(Integer id){
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    /**
     * 更新数据
     * @param employee
     */
    public void updateEmp(Employee employee){
        //带上主键，有选择的更新(此处不更新id,empName)
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 删除单个员工
     * @param id
     */
    public void  deleteEmp(Integer id){
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBach(List<Integer> splits) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        //andEmpIdIn(splits)的作用：delete from XXXX where id in (1,2,3,4,5)
        criteria.andEmpIdIn(splits);
        employeeMapper.deleteByExample(example);
    }
}
