<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("登录上下文接口")/>
public interface LoginContext {

    /**
     * 获取当前登录用户唯一标识
     *
     * @return 用户唯一标识
     */
    String getCurrentUser();

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".context")/>

${code}
