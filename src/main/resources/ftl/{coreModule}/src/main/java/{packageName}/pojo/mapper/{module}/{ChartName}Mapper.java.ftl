<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<#if !isChartType(ChartType.DETAIL_LIST) && !isChartType(ChartType.AGG_TABLE)>
    <@call this.skipCurrent()/>
</#if>
<#if !this.excelExport>
    <@call this.skipCurrent()/>
</#if>
<@call this.addImport("org.mapstruct.Mapper")/>
<@call this.addImport("org.mapstruct.factory.Mappers")/>
<@call this.printClassCom("【${this.title}】映射")/>
@Mapper
public interface ${this.chartName}Mapper {

    ${this.chartName}Mapper INSTANCE = Mappers.getMapper(${this.chartName}Mapper.class);

<#if this.excelExport>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${voPackageName}.${this.chartName}ExcelVO")/>
    <@call this.addImport("${voPackageName}.${this.chartName}VO")/>
    /**
     * 转excelVO列表
     *
     * @param list
     * @return
     */
    List<${this.chartName}ExcelVO> toExcelVOList(List<${this.chartName}VO> list);

</#if>
}
</#assign>
<#--开始渲染代码-->
package ${mapperPackageName};

<@call this.printImport()/>

${code}
