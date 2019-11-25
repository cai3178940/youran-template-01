<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("java.lang.annotation.*")/>
<@call this.printClassCom("无视XSS脚本")/>
@Inherited
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD})
public @interface IgnoreXSS {


}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.xss;

<@call this.printImport()/>

${code}
