<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("【${this.title}】图表API" "swagger接口文档")/>
@Api(tags = "【${this.title}】图表API")
public interface ${this.chartName}API {
}
</#assign>
<#--开始渲染代码-->
package ${apiPackageName};

<@call this.printImport()/>

${code}
