<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("org.apache.ibatis.annotations.Mapper")/>
<@call this.addImport("org.springframework.stereotype.Repository")/>
<@call this.printClassCom("【${this.title}】数据库操作")/>
@Repository
@Mapper
public interface ${this.chartName}DAO {

}
</#assign>
<#--开始渲染代码-->
package ${daoPackageName};

<@call this.printImport()/>

${code}


