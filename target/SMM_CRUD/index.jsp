<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/7/5
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--使用内置标签，用于获取数据-->
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>
<html>
<!--web路径，不以/开始的相对路径，找资源，以当前路径的资源为基准，经常容易出问题-->
<!--以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306）; 需要加上项目名
http://localhost:3306/crud
-->
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-2.2.4.js"></script>
    <!--引入bootstrap样式-->
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 添加新增弹出模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <!--在表单里设置name值，name值与Javabean里的属性名称相同，这样可以封装JavaBean对象和表单对象对应-->
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@hzk.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                           <label>
                               <input id="gender1_add_input" name="gender" type="radio" value="M" checked="selected">男
                           </label>
                            <label>
                                <input id="gender2_add_input" name="gender" type="radio" value="F">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!--部门提交部门id-->
                           <select class="form-control" name="dId" id="dept_add_select">

                           </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!--弹出编辑模态框-->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <!--在表单里设置name值，name值与Javabean里的属性名称相同，这样可以封装JavaBean对象和表单对象对应-->
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <!--此处为一个静态框-->
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@hzk.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label>
                                <input id="gender1_update_input" name="gender" type="radio" value="M" checked="selected">男
                            </label>
                            <label>
                                <input id="gender2_update_input" name="gender" type="radio" value="F">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!--部门提交部门id-->
                            <select class="form-control" name="dId" >

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>


<!--bootStrap搭建显示页面-->

<div class="container">
    <!--标题-->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM_CRUD</h1>
        </div>
    </div>
    <!--按钮-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn"  >新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn" >删除</button>
        </div>
    </div>
    <!--显示表格数据-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emp_table">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all">
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>department</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </div>
    </div>
    <!--分页条-->
    <div class="row">

        <!--分页文字信息-->
        <div class="col-md-6" id="page_info_area">

        </div>

        <!--分页条信息-->
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>


<!--引入JS-->
<script type="text/javascript">
    var totalRecord,currentPage ;

    //1.页面加载完成以后，直接去发送一个Ajax请求，得到分页数据
    $(function () {
        //去首页
        to_page(1);
    })

    //添加分页条的跳转方法
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"get",
            success:function (result) {
                //1,解析员工数据
                build_emps_table(result);

                //2,显示分页信息
                build_page_info(result);

                //3,解析并显示分页信息
                build_page_nav(result);
            }

        });
    }

    function build_emps_table(result){
        //情况上一次表格
        $("#emp_table tbody").empty();
        var emps=result.extend.pageInfo.list;
        //遍历员工数据,index代表索引，item代表当前元素
        $.each(emps,function (index,item) {
            var checkBoxId=$("<td><input type='checkbox' class='check_item' /></td>")
            var empIdTd=$("<td></td>").append(item.empId);
            var empNameTd=$("<td></td>").append(item.empName);
            var genderTd=$("<td></td>").append(item.gender=="M"?"男":"女");
            var emailTd=$("<td></td>").append(item.email);
            var deptNameTd=$("<td></td>").append(item.department.deptName);

            var editBtn= $("<button></button>").addClass("btn btn-primary btn-sm edit-btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            ///为编辑按钮添加一个自定义的属性，目的是为了方便获取此列的的值
                editBtn.attr("edit-id",item.empId)

            var deltBtn= $("<button></button>").addClass("btn btn-danger btn-sm delete-btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            //为删除按钮自定义一个属性，目的用于获取此列的值
            deltBtn.attr("del-id",item.empId);

            var btnTd= $("<td></td>").append(editBtn).append(" ").append(deltBtn);
            $("<tr></tr>").append(checkBoxId)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emp_table tbody")
        })
    }

    //解析显示分页信息
    function build_page_info(result) {
         $("#page_info_area").empty();
        //操作#page_info_area
        $("#page_info_area")
            .append("  当前第"+result.extend.pageInfo.pageNum+" 页，总"
            +result.extend.pageInfo.pages+"页,总共" +result.extend.pageInfo.total+"条记录");

        totalRecord=result.extend.pageInfo.total;
        currentPage=result.extend.pageInfo.pageNum;
    }


    //解析显示分页条,
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        //操作#page_nav_area
        var ul=$("<ul></ul>").addClass("pagination");
        //构建元素，
        var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var   prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;").attr("href","#"));
        if (result.extend.pageInfo.hasPreviousPage==false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else {
            //添加点击翻页功能
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum-1);
            })
        }


        //构建元素
        var  nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));
        var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if (result.extend.pageInfo.hasNextPage==false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum+1);
            })
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }


        //添加首页和前一页 的提示
        ul.append(firstPageLi).append(prePageLi);
        //遍历给ul中添加页码提示 
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi=$("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum==item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });

            ul.append(numLi);
        })
        //添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        //把<ul>加入到<nav>
        var navEle=$("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
         //表单数据重置封装
        function reset_form(ele){
            //清空表单数据
            $(ele)[0].reset();
            //情况表单样式
            $(ele).find("*").removeClass("has-success has-error");
            $(ele).find(".help-block").text("");
         }
        //使用js方式绑定新增模态框事件
        $("#emp_add_modal_btn").click(function () {
            //清除表单上一次数据（表单重置）
            reset_form("#empAddModal form");
            //发送Ajax请求，查出部门信息，显示在
            getDepts("#empAddModal select");

            //打开模态框
            $("#empAddModal").modal({
                backdrop:"static"
            });

        })
            //查出所有部门显示在下拉列表
        function getDepts(ele){
        //1，首先每次请求，清空上一次的数据
            $(ele).empty();
                $.ajax({
                    url: "${APP_PATH}/depts",
                    type: "GET",
                    success: function(result) {
                        //获取下拉列表
                        //$("#empAddModal select").append("")
                        $.each(result.extend.depts,function () {
                            var optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
                            optionEle.appendTo(ele);
                        });
                    }
                })
            }

            //前端数据校验
            function validate_add_form(){
                //拿到要校验的数据，使用正则表达
                var empName=$("#empName_add_input").val();
                var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;  //前面检验英文，后面检验中文
                if (!regName.test(empName)){
                    //alert("用户名可以是2-5位中文，或者6-16的英文和数字的组合")
                    show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文，或者6-16的英文和数字的组合")
                    return false;
                }else{
                    show_validate_msg("#empName_add_input","success","")
                }
                var empEmail=$("#email_add_input").val();
                var regEmail=/^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
                if (!regEmail.test(empEmail)){
                    //alert("邮箱格式错误")
                    show_validate_msg("#email_add_input","error","邮箱格式错误")
                    return  false;
                }else {
                    show_validate_msg("#email_add_input","success","")
                }
                return  true;

            }

            //表单验证封装
            function show_validate_msg(ele,status,msg){
                //1,首先清除上一次元素的校验状态信息
                $(ele).parent().removeClass("has-error has-success")
                $(ele).next("span").text("")

                if("success"==status){
                    $(ele).parent().addClass("has-success");
                    $(ele).next("span").text(msg);
                }else if("error"==status){
                    $(ele).parent().addClass("has-error");
                    $(ele).next("span").text(msg);
                }

            }

            //校验文本框change事件，校验用户名是否可用
            $("#empName_add_input").change(function () {
                //(发送Ajax请求，去后台校验数据是否可用)
                var empName=$("#empName_add_input").val();
                $.ajax({
                    url:"${APP_PATH}/checkuser",
                    type:"POST",
                    data:"empName="+empName,
                    success:function (result) {
                        if(result.code==100){
                            show_validate_msg("#empName_add_input","success",result.extend.va_msg)
                            $("#emp_save_btn").attr("ajax-va","success")  //给提交按钮添加属性，满足要求才提交
                        }else {
                            show_validate_msg("#empName_add_input","error",result.extend.va_msg)
                            $("#emp_save_btn").attr("ajax-va","error")
                        }
                    }
                })
            })


            //点击保存，保存员工
            $("#emp_save_btn").click(function () {
                //1,点击提交，把表单数据提交给服务器进行保存
                //1,先对要提交的服务器的数据进行校验
                if(!validate_add_form()){
                    return false;
                }
                //1，判断之前Ajax用户名校验是否成功，如果成功
                if($(this).attr("ajax-va")=="error"){
                    return  false;
                }

               // ("#empAddModal form").serialize()  Jquery用来获取表单数据的方法（序列化数据）
                $.ajax( {
                    url: "${APP_PATH}/emp" ,
                    type: "POST" ,
                    data:$("#empAddModal form").serialize() ,
                    success:function (result) {
                        //alert(result.msg)
                        if (result.code==100){
                            //1,当员工保存成功，关闭模态框
                            $("#empAddModal").modal("hide");
                            //2,跳转最后一页到最新数据
                            //发送Ajax请求显示最后一页数据即可，
                            to_page(totalRecord)
                        }else {
                            //console.log(result)
                            //有哪个字段错误就显示该字段为错误信息
                            if(undefined!=result.extend.errorFields.email){
                                //在Email不为空的情况下，显示邮箱错误信息
                                show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                            }
                            if(undefined!=result.extend.errorFields.empName){
                                //在empName不为空的情况下，显示用户名错误信息
                                show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                            }

                        }
                    }
                })
            })
    //点击删除按钮
    $(document).on("click",".delete-btn",function () {
        //1,确实是否删除，首先获取该列的用户名(查找该点击对象的所有父节点下的tr的td的第二个标签下的empName)
        var empName=$(this).parents("tr").find("td:eq(2)").text();
        var empId=$(this).attr("del-id");
        if(confirm("确认删除【"+empName+"】吗？")){
            //确认，发送Ajax请求
            $.ajax({
                url: "${APP_PATH}/delete/"+empId,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg)
                    //删除成功回到本页
                    to_page(currentPage);
                }
            })
        }
    })

    //点击修改
    //因为按钮是在此事件之后才创建，所有按钮无法与该事件进行绑定
    // $(".edit-btn").click(function () {
    //     alert("edit")
    // })
    //解决方法 1，在Ajax得到数据创建按钮的时候进行事件绑定
    //解决方法 2，使用Jquery的on()方法,绑定到document下的
    $(document).on("click",".edit-btn",function () {
        //alert("edit")
        //1，查出部门信息，并显示部门列表
        getDepts("#empUpdateModal select")
        //2，查出员工信息，是显示员工信息
        getEmp($(this).attr("edit-id"))
        //3,把员工的id传递给模态框的更新按钮,用于更新操作
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));

        $("#empUpdateModal").modal({
            backdrop: "static"
        })
    })

    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id  ,
            type: "GET" ,
            success: function (result) {

                var empData=result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
                console.log(empData.dId);
            }
        })
    }


    //为更新按钮绑定事件
    $("#emp_update_btn").click(function () {
        //1,邮箱验证
        var empEmail=$("#email_update_input").val();
        var regEmail=/^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
        if (!regEmail.test(empEmail)){
            show_validate_msg("#email_update_input","error","邮箱格式错误")
            return  false;
        }else {
            show_validate_msg("#email_update_input","success","")
        }
        //发送Ajax请求，更新数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id") ,
            type: "PUT",
            data:$("#empUpdateModal form").serialize(),
            success: function (result) {
                alert(result.msg)
                //1,当员工保存成功，关闭模态框
                $("#empUpdateModal").modal("hide");
                //2,跳转最后一页到最新数据
                //发送Ajax请求显示最后一页数据即可，
                to_page(currentPage)
            }
        })
    })

    //完成checkBox全选/全不选
    $("#check_all").click(function () {
        //原生的dom属性需要prop来获取属性值，而自定义的的属性需要attr来获取属性值
        //$(".check_item").attr("checked");
        $(".check_item").prop("checked",$(this).prop("checked"));
    })

    //设置单个checkBox点击事件
    $(document).on("click",".check_item",function () {
        //:checked是jq的选择器，表示复选框被选中的
        var flag=$(".check_item:checked").length==$(".check_item").length;
        $("#check_all").prop("checked",flag);
    })

    //创建全选/多选删除按钮
    $("#emp_delete_all_btn").click(function () {
        var empNames="";
        var del_idstr="";
        $.each($(".check_item:checked"),function () {
            //组装员工名称字符串
          empNames +=  $(this).parents("tr").find("td:eq(2)").text()+",";
            //组装员工id字符串
          del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
        })
        //去除多余”，“
        empNames=empNames.substring(0,empNames.length-1);
        del_idstr=del_idstr.substring(0,del_idstr.length-1);
        if (confirm("确认删除【"+empNames+"】吗？")){
            $.ajax({
                url: "${APP_PATH}/delete/"+del_idstr,
                type:"DELETE" ,
                success:function (result) {
                    alert(result.msg)
                    to_page(currentPage);
                }
            })
        }

    })
</script>
</body>
</html>
