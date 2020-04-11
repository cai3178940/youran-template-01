<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.web.AbstractController")/>
<@call this.addImport("${apiPackageName}.${this.chartName}API")/>
<@call this.printClassCom("【${this.title}】图表控制器")/>
@RestController
@RequestMapping(${renderApiPathForChart(this.chart, "")})
public class ${this.chartName}Controller extends AbstractController implements ${this.chartName}API {
}

</#assign>
<#--开始渲染代码-->
package ${restPackageName};

<@call this.printImport()/>

${code}
