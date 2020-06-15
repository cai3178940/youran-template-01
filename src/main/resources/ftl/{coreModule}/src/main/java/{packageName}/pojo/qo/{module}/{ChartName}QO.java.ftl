<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
import com.cbb.common.pojo.qo.PageQO;
<@call this.addImport("io.swagger.annotations.ApiParam")/>
<#if isChartType(ChartType.DETAIL_LIST)>
    <@call this.addImport("${this.commonPackage}.pojo.qo.PageQO")/>
<#else>
    <@call this.addImport("${this.commonPackage}.pojo.qo.AbstractQO")/>
</#if>
<@call this.printClassCom("查询【${this.title}】的参数")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
public class ${this.chartName}QO extends <#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>PageQO<#else>AbstractQO</#if> {

<#list this.chartSource.whereMap as itemId,whereItem>
    <#if !whereItem.custom>
        <#if FilterOperator.IS_NULL.getValue() == whereItem.filterOperator
                || FilterOperator.NOT_NULL.getValue() == whereItem.filterOperator>
            <#continue>
        </#if>
        <#assign field=whereItem.field>
        <#if FilterOperator.CONTAIN.getValue() == whereItem.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == whereItem.filterOperator>
            <@call this.addImport("java.util.List")/>
    @ApiParam(hidden = true)
    private List<${field.jfieldType}> fixedParam${itemId?counter};

        <#elseIf FilterOperator.BETWEEN.getValue() == whereItem.filterOperator
        || FilterOperator.IS_NOW.getValue() == whereItem.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == whereItem.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == whereItem.filterOperator>
    @ApiParam(hidden = true)
    private ${field.jfieldType} fixedParam${itemId?counter}Start;

    @ApiParam(hidden = true)
    private ${field.jfieldType} fixedParam${itemId?counter}End;

        <#else>
    @ApiParam(hidden = true)
    private ${field.jfieldType} fixedParam${itemId?counter};

        </#if>
    </#if>
</#list>

<#if !this.projectFeature.lombokEnabled>
    <#list this.chartSource.whereMap as itemId,whereItem>
        <#if !whereItem.custom>
            <#if FilterOperator.IS_NULL.getValue() == whereItem.filterOperator
            || FilterOperator.NOT_NULL.getValue() == whereItem.filterOperator>
                <#continue>
            </#if>
            <#assign field=whereItem.field>
            <#if FilterOperator.CONTAIN.getValue() == whereItem.filterOperator
            || FilterOperator.NOT_CONTAIN.getValue() == whereItem.filterOperator>
                <@call JavaTemplateFunction.printGetterSetterList("fixedParam${itemId?counter}","${field.jfieldType}",false)/>
            <#elseIf FilterOperator.BETWEEN.getValue() == whereItem.filterOperator
            || FilterOperator.IS_NOW.getValue() == whereItem.filterOperator
            || FilterOperator.BEFORE_TIME.getValue() == whereItem.filterOperator
            || FilterOperator.AFTER_TIME.getValue() == whereItem.filterOperator>
                <@call JavaTemplateFunction.printGetterSetter("fixedParam${itemId?counter}Start","${field.jfieldType}")/>
                <@call JavaTemplateFunction.printGetterSetter("fixedParam${itemId?counter}End","${field.jfieldType}")/>
            <#else>
                <@call JavaTemplateFunction.printGetterSetter("fixedParam${itemId?counter}","${field.jfieldType}")/>
            </#if>
        </#if>
    </#list>
</#if>
}
</#assign>
<#--开始渲染代码-->
package ${qoPackageName};

<@call this.printImport()/>

${code}
