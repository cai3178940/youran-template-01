<#include "/abstracted/common.ftl">
<#include "/abstracted/checkFeatureForRest.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("web常量")/>
public class WebConst {

    /**
     * 接口路径前缀
     */
    public static final String API_PATH = "/api";

<#list modulesForRest>
    /**
     * 各个模块的路径
     */
    public static class ModulePath {

    <#items as module>
        public static final String ${module?upperCase} = API_PATH + "/${module}";

    </#items>
    }

</#list>
}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.web.constant;

<@call this.printImport()/>

${code}
