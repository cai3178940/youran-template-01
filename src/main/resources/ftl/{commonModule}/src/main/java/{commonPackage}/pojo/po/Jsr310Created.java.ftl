<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("创建人&创建时间-jsr310时间API")/>
public interface Jsr310Created extends CreatedBy, Jsr310CreatedTime {
}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.pojo.po;

<@call this.printImport()/>

${code}
