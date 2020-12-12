<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("操作人接口")/>
public interface OperatedBy {

    String getOperatedBy();

    void setOperatedBy(String operatedBy);

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.po")/>

${code}
