<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/chartItem.ftl">
<#--定义主体代码-->
<#assign code>
<#if !isChartType(ChartType.DETAIL_LIST) && !isChartType(ChartType.AGG_TABLE)>
    <@call this.skipCurrent()/>
</#if>
<#if !this.excelExport>
    <@call this.skipCurrent()/>
</#if>
<#-- 包裹Mapping注解 -->
<#macro wrapMappings>
    <#local content><#nested></#local>
    <#if content?hasContent>
        <@call this.addImport("org.mapstruct.Mappings")/>
        <@call this.addImport("org.mapstruct.Mapping")/>
    @Mappings({
${content}<#rt>
    })
    </#if>
</#macro>
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

    /**
     * 转excelVO
     *
     * @param vo
     * @return
     */
    <@wrapMappings>
        <#if isChartType(ChartType.DETAIL_LIST)>
            <#-- 明细列字段 -->
            <#list this.columnList as column>
                <#assign sourceItem = column.sourceItem>
                <#if !sourceItem.custom && sourceItem.field.dicType??>
                    <#assign field = sourceItem.field>
                    <#if column.alias?hasContent>
                        <#assign name = column.alias>
                    <#else>
                        <#assign name = field.jfieldName>
                    </#if>
            @Mapping(target = "${name}", expression = "java(${this.getConstFullClassPath(field.dicType)}.valueToDesc(vo.get${name?capFirst}()))"),
                </#if>
            </#list>
        <#elseIf isChartType(ChartType.AGG_TABLE)>
            <#-- 维度字段 -->
            <#list filteredDimension as dimension>
                <#assign chartItem = chartItemMapWrapper.get(dimension.sourceItemId)>
                <#if dimension.field.dicType??>
                    <#assign field = dimension.field>
                    <#if chartItem.alias?hasContent>
                        <#assign name = chartItem.alias>
                    <#else>
                        <#assign name = field.jfieldName>
                    </#if>
            @Mapping(target = "${name}", expression = "java(${this.getConstFullClassPath(field.dicType)}.valueToDesc(vo.get${name?capFirst}()))"),
                </#if>
            </#list>
        </#if>
    </@wrapMappings>
    ${this.chartName}ExcelVO toExcelVO(${this.chartName}VO vo);
</#if>
}
</#assign>
<#--开始渲染代码-->
package ${mapperPackageName};

<@call this.printImport()/>

${code}
