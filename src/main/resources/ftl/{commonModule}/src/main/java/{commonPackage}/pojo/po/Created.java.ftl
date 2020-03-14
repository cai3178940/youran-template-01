<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("创建人&创建时间")/>
public interface Created extends CreatedBy, CreatedTime {
}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.pojo.po;

<@call this.printImport()/>

${code}
