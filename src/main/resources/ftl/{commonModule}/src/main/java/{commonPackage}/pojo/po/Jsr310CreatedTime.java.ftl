<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("java.time.LocalDateTime")/>
<@call this.printClassCom("创建时间接口-jsr310时间API")/>
public interface Jsr310CreatedTime {

    LocalDateTime getCreatedTime();

    void setCreatedTime(LocalDateTime createdTime);

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.po")/>

${code}
