<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("java.util.Date")/>
<@call this.printClassCom("创建时间接口")/>
public interface CreatedTime {

    Date getCreatedTime();

    void setCreatedTime(Date createdTime);

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.po")/>

${code}
