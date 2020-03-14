<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("操作人&操作时间-jsr310时间API")/>
public interface Jsr310Operated extends OperatedBy, Jsr310OperatedTime {
}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.pojo.po;

<@call this.printImport()/>

${code}
