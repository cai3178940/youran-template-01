<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("io.swagger.annotations.Api")/>
<@call this.addImport("io.swagger.annotations.ApiOperation")/>
<@call this.addImport("org.springframework.http.ResponseEntity")/>
<@call this.addImport("${qoPackageName}.${this.chartName}QO")/>
<@call this.addImport("${voPackageName}.${this.chartName}VO")/>
<@call this.printClassCom("【${this.title}】图表API" "swagger接口文档")/>
@Api(tags = "【${this.title}】图表API")
public interface ${this.chartName}API {

<#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>
    /**
     * 查询明细表
     */
    @ApiOperation(value="查询明细表")
    <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    ResponseEntity<PageVO<${this.chartName}VO>> findList(${this.chartName}QO qo);
<#else>
    /**
     * 查询图表数据
     */
    @ApiOperation(value="查询图表数据")
    <@call this.addImport("java.util.List")/>
    ResponseEntity<List<${this.chartName}VO>> findChartData(${this.chartName}QO qo);
</#if>

}
</#assign>
<#--开始渲染代码-->
package ${apiPackageName};

<@call this.printImport()/>

${code}
