<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/chartItem.ftl">
<#--定义主体代码-->
<#assign code>
<#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>
    <@call this.addImport("${this.commonPackage}.pojo.qo.PageQO")/>
<#else>
    <@call this.addImport("${this.commonPackage}.pojo.qo.AbstractQO")/>
</#if>
<@call this.printClassCom("查询【${this.title}】的参数")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper = true)
</#if>
public class ${this.chartName}QO extends <#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>PageQO<#else>AbstractQO</#if> {

<#list paramedWhere as where>
    <#assign field = where.field>
    <@call this.addImport("io.swagger.annotations.ApiParam")/>
    <#if FilterOperator.CONTAIN.getValue() == where.filterOperator
    || FilterOperator.NOT_CONTAIN.getValue() == where.filterOperator>
        <@call this.addImport("java.util.List")/>
    @ApiParam(hidden = true)
    private List<${field.jfieldType}> whereParam${where?counter};

    <#elseIf FilterOperator.BETWEEN.getValue() == where.filterOperator
    || FilterOperator.IS_NOW.getValue() == where.filterOperator
    || FilterOperator.BEFORE_TIME.getValue() == where.filterOperator
    || FilterOperator.AFTER_TIME.getValue() == where.filterOperator>
    @ApiParam(hidden = true)
    private ${field.jfieldType} whereParam${where?counter}Start;

    @ApiParam(hidden = true)
    private ${field.jfieldType} whereParam${where?counter}End;

    <#else>
    @ApiParam(hidden = true)
    private ${field.jfieldType} whereParam${where?counter};

    </#if>
</#list>
<#list filteredHaving as having>
    <#if FilterOperator.IS_NULL.getValue() == having.filterOperator
        || FilterOperator.NOT_NULL.getValue() == having.filterOperator>
        <#continue>
    </#if>
    <#assign jfieldType = convertMetricsFieldType(having.parent)>
    <@call this.addImport("io.swagger.annotations.ApiParam")/>
    <#if FilterOperator.CONTAIN.getValue() == having.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == having.filterOperator>
        <@call this.addImport("java.util.List")/>
    @ApiParam(hidden = true)
    private List<${field.jfieldType}> havingParam${having?counter};

    <#elseIf FilterOperator.BETWEEN.getValue() == having.filterOperator
        || FilterOperator.IS_NOW.getValue() == having.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == having.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == having.filterOperator>
    @ApiParam(hidden = true)
    private ${jfieldType} havingParam${having?counter}Start;

    @ApiParam(hidden = true)
    private ${jfieldType} havingParam${having?counter}End;

    <#else>
    @ApiParam(hidden = true)
    private ${jfieldType} havingParam${having?counter};

    </#if>
</#list>

<#if !this.projectFeature.lombokEnabled>
    <#list paramedWhere as where>
        <#assign field = where.field>
        <#if FilterOperator.CONTAIN.getValue() == where.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == where.filterOperator>
            <@call JavaTemplateFunction.printGetterSetterList("whereParam${where?counter}", "${field.jfieldType}", false)/>
        <#elseIf FilterOperator.BETWEEN.getValue() == where.filterOperator
        || FilterOperator.IS_NOW.getValue() == where.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == where.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == where.filterOperator>
            <@call JavaTemplateFunction.printGetterSetter("whereParam${where?counter}Start", "${field.jfieldType}")/>
            <@call JavaTemplateFunction.printGetterSetter("whereParam${where?counter}End", "${field.jfieldType}")/>
        <#else>
            <@call JavaTemplateFunction.printGetterSetter("whereParam${where?counter}", "${field.jfieldType}")/>
        </#if>
    </#list>
    <#list filteredHaving as having>
        <#if FilterOperator.IS_NULL.getValue() == having.filterOperator
        || FilterOperator.NOT_NULL.getValue() == having.filterOperator>
            <#continue>
        </#if>
        <#assign jfieldType = convertMetricsFieldType(having.parent)>
        <#if FilterOperator.CONTAIN.getValue() == having.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == having.filterOperator>
            <@call JavaTemplateFunction.printGetterSetterList("havingParam${having?counter}", "${jfieldType}", false)/>
        <#elseIf FilterOperator.BETWEEN.getValue() == having.filterOperator
        || FilterOperator.IS_NOW.getValue() == having.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == having.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == having.filterOperator>
            <@call JavaTemplateFunction.printGetterSetter("havingParam${having?counter}Start", "${jfieldType}")/>
            <@call JavaTemplateFunction.printGetterSetter("havingParam${having?counter}End", "${jfieldType}")/>
        <#else>
            <@call JavaTemplateFunction.printGetterSetter("havingParam${having?counter}", "${jfieldType}")/>
        </#if>
    </#list>
</#if>
}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(qoPackageName)/>

${code}
