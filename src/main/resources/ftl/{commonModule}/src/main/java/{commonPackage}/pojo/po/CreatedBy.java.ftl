<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("创建人接口")/>
public interface CreatedBy {

    String getCreatedBy();

    void setCreatedBy(String createdBy);

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.po")/>

${code}
