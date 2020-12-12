<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/chartItem.ftl">
<#if !isChartType(ChartType.DETAIL_LIST) && !isChartType(ChartType.AGG_TABLE)>
    <@call this.skipCurrent()/>
</#if>
<#if !this.excelExport>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.vo.AbstractVO")/>
<@call this.addImport("com.alibaba.excel.annotation.ExcelProperty")/>
<@call this.addImport("com.alibaba.excel.annotation.write.style.ColumnWidth")/>
<@call this.printClassCom("【${this.title}】excel导出对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper = true)
</#if>
public class ${this.chartName}ExcelVO extends AbstractVO <#if barLineParamMode == 1>implements Chart2DimensionVO </#if>{

<#-- 定义getterSetter代码 -->
<#assign getterSetterCode = "">
<#if isChartType(ChartType.DETAIL_LIST)>
    <#-- 明细列字段 -->
    <#list this.columnList as column>
        <#assign sourceItem = column.sourceItem>
        <#if sourceItem.custom>
            <#--字段类型-->
            <#assign jfieldType = convertCustomFieldType(sourceItem.customFieldType)>
            <#--字段名-->
            <#assign name = column.alias>
            <#--字段标题-->
            <#assign label = column.titleAlias>
            <#--日期格式-->
            <#assign dateFormat = guessDateFormatForCustom(sourceItem.customFieldType)>
            <#--列宽-->
            <#assign columnWidth = 15>
        <#else>
            <#assign field = sourceItem.field>
            <#if field.dicType??>
                <#assign jfieldType = "String">
            <#else>
                <#--import字段类型-->
                <@call this.addFieldTypeImport(field)/>
                <#assign jfieldType = field.jfieldType>
            </#if>
            <#if column.alias?hasContent>
                <#assign name = column.alias>
            <#else>
                <#assign name = field.jfieldName>
            </#if>
            <#if column.titleAlias?hasContent>
                <#assign label = column.titleAlias>
            <#else>
                <#assign label = field.fetchComment()?replace('\"', '\\"')?replace('\n', '\\n')>
            </#if>
            <#--日期格式-->
            <#assign dateFormat = guessDateFormat(field)>
            <#--列宽-->
            <#if field.columnWidth?? && field.columnWidth &gt; 0>
                <#assign columnWidth = field.columnWidth/8>
            <#else>
                <#assign columnWidth = 15>
            </#if>
        </#if>
        <#if jfieldType == JFieldType.DATE.getJavaType()
        || jfieldType == JFieldType.LOCALDATE.getJavaType()
        || jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.alibaba.excel.annotation.format.DateTimeFormat")/>
    @DateTimeFormat(${dateFormat})
        </#if>
    @ExcelProperty("${label}")
    @ColumnWidth(${columnWidth})
    private ${jfieldType} ${name};
        <#assign getterSetterCode += genGetterSetter(jfieldType, name)>

    </#list>
<#elseIf isChartType(ChartType.AGG_TABLE)>

    <#-- 维度字段 -->
    <#list filteredDimension as dimension>
        <#assign chartItem = chartItemMapWrapper.get(dimension.sourceItemId)>
        <#if dimension.field.dicType??>
            <#assign jfieldType = "String">
        <#else>
            <#assign jfieldType = convertDimensionFieldType(dimension)>
        </#if>
        <#if chartItem.alias?hasContent>
            <#assign name = chartItem.alias>
        <#else>
            <#assign name = dimension.field.jfieldName>
        </#if>
        <#if jfieldType == JFieldType.DATE.getJavaType()
            || jfieldType == JFieldType.LOCALDATE.getJavaType()
            || jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.alibaba.excel.annotation.format.DateTimeFormat")/>
    @DateTimeFormat(${guessDateFormat(dimension.field)})
        </#if>
    @ExcelProperty("${chartItem.titleAlias}")
        <#if dimension.field.columnWidth?? && dimension.field.columnWidth &gt; 0>
    @ColumnWidth(${dimension.field.columnWidth/8})
        <#else>
    @ColumnWidth(15)
        </#if>
    private ${jfieldType} ${name};
        <#assign getterSetterCode += genGetterSetter(jfieldType, name)>

    </#list>
    <#-- 指标字段 -->
    <#list filteredMetrics as metrics>
        <#assign chartItem = chartItemMapWrapper.get(metrics.sourceItemId)>
        <#assign jfieldType = convertMetricsFieldType(metrics)>
        <#--字段名-->
        <#assign name = chartItem.alias>
        <#--字段标题-->
        <#assign label = chartItem.titleAlias>
        <#if metrics.custom>
            <#--日期格式-->
            <#assign dateFormat = guessDateFormatForCustom(metrics.customFieldType)>
            <#--列宽-->
            <#assign columnWidth = 15>
        <#else>
            <#--日期格式-->
            <#assign dateFormat = guessDateFormat(metrics.field)>
            <#--列宽-->
            <#if metrics.field.columnWidth?? && metrics.field.columnWidth &gt; 0>
                <#assign columnWidth = metrics.field.columnWidth/8>
            <#else>
                <#assign columnWidth = 15>
            </#if>
        </#if>
        <#if jfieldType == JFieldType.DATE.getJavaType()
            || jfieldType == JFieldType.LOCALDATE.getJavaType()
            || jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("com.alibaba.excel.annotation.format.DateTimeFormat")/>
    @DateTimeFormat(${dateFormat})
        </#if>
    @ExcelProperty("${label}")
    @ColumnWidth(${columnWidth})
    private ${jfieldType} ${name};
        <#assign getterSetterCode += genGetterSetter(jfieldType, name)>

    </#list>
</#if>

<#if !this.projectFeature.lombokEnabled>${getterSetterCode}</#if>
}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(voPackageName)/>

${code}
