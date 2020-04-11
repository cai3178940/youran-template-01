<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("【${this.title}】图表查询服务")/>
@Service
public class ${this.chartName}Service {

}

</#assign>
<#--开始渲染代码-->
package ${servicePackageName};

<@call this.printImport()/>

${code}
