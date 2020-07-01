<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/chartItem.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("io.swagger.annotations.ApiModel")/>
<@call this.addImport("io.swagger.annotations.ApiModelProperty")/>
<@call this.addImport("${this.commonPackage}.pojo.vo.AbstractVO")/>
<@call this.printClassCom("【${this.title}】图表展示对象")/>
<#if barLineParamMode == 1>
    <@call this.addImport("${this.commonPackage}.pojo.vo.Chart2DimensionVO")/>
</#if>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
@ApiModel(description = "【${this.title}】图表展示对象")
public class ${this.chartName}VO extends AbstractVO <#if barLineParamMode == 1>implements Chart2DimensionVO </#if>{

<#-- 定义getterSetter代码 -->
<#assign getterSetterCode = "">
<#if isChartType(ChartType.DETAIL_LIST)>
    <#-- 明细列字段 -->
    <#list this.columnList as column>
        <#assign sourceItem=column.sourceItem>
        <#if sourceItem.custom>
            <#--字段类型-->
            <#assign jfieldType=convertCustomFieldType(sourceItem.customFieldType)>
            <#--字段名-->
            <#assign name=column.alias>
            <#--字段标题-->
            <#assign label=column.titleAlias>
            <#--日期格式-->
            <#assign dateFormat=guessDateFormatForCustom(sourceItem.customFieldType)>
        <#else>
            <#assign field=sourceItem.field>
            <#--import字段类型-->
            <@call this.addFieldTypeImport(field)/>
            <#assign jfieldType=field.jfieldType>
            <#if column.alias?hasContent>
                <#assign name=column.alias>
            <#else>
                <#assign name=field.jfieldName>
            </#if>
            <#if column.titleAlias?hasContent>
                <#assign label=column.titleAlias>
            <#else>
                <#assign label=field.fetchComment()?replace('\"','\\"')?replace('\n','\\n')>
            </#if>
            <#--日期格式-->
            <#assign dateFormat=guessDateFormat(field)>
        </#if>
        <#if jfieldType==JFieldType.DATE.getJavaType()
        || jfieldType==JFieldType.LOCALDATE.getJavaType()
        || jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${dateFormat}, timezone = "GMT+8")
        </#if>
    @ApiModelProperty(notes = "${label}")
    private ${jfieldType} ${name};
        <#assign getterSetterCode += genGetterSetter(jfieldType,name)>

    </#list>
<#else>

    <#-- 维度字段 -->
    <#list filteredDimension as dimension>
        <#assign chartItem = chartItemMapWrapper.get(dimension.sourceItemId)>
        <#assign jfieldType=convertDimensionFieldType(dimension)>
        <#if chartItem.alias?hasContent>
            <#assign name=chartItem.alias>
        <#else>
            <#assign name=dimension.field.jfieldName>
        </#if>
        <#if jfieldType==JFieldType.DATE.getJavaType()
            || jfieldType==JFieldType.LOCALDATE.getJavaType()
            || jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${guessDateFormat(dimension.field)}, timezone = "GMT+8")
        </#if>
    @ApiModelProperty(notes = "${chartItem.titleAlias}")
    private ${jfieldType} ${name};
        <#assign getterSetterCode += genGetterSetter(jfieldType,name)>

    </#list>
    <#-- 指标字段 -->
    <#list filteredMetrics as metrics>
        <#assign chartItem = chartItemMapWrapper.get(metrics.sourceItemId)>
        <#assign jfieldType=convertMetricsFieldType(metrics)>
        <#--字段名-->
        <#assign name=chartItem.alias>
        <#--字段标题-->
        <#assign label=chartItem.titleAlias>
        <#if metrics.custom>
            <#--日期格式-->
            <#assign dateFormat=guessDateFormatForCustom(metrics.customFieldType)>
        <#else>
            <#--日期格式-->
            <#assign dateFormat=guessDateFormat(metrics.field)>
        </#if>
        <#if jfieldType==JFieldType.DATE.getJavaType()
            || jfieldType==JFieldType.LOCALDATE.getJavaType()
            || jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${dateFormat}, timezone = "GMT+8")
        </#if>
    @ApiModelProperty(notes = "${label}")
    private ${jfieldType} ${name};
        <#assign getterSetterCode += genGetterSetter(jfieldType,name)>

    </#list>
</#if>

<#if isChartType(ChartType.BAR_LINE)>
    <#if barLineParamMode == 1>
        <#assign axisXField = this.axisX.sourceItem.field>
        <#assign axisX2Field = this.axisX2.sourceItem.field>
    public static String header0() {
        return "${this.axisX.titleAlias}";
    }

    @Override
    public Object fetchDimension1() {
        <#if axisXField.dicType??>
            <@call this.addConstImport(axisXField.dicType)/>
        return ${axisXField.dicType}.valueToDesc(${this.axisX.alias});
        <#else>
        return ${this.axisX.alias};
        </#if>
    }

    @Override
    public Object fetchDimension2() {
        <#if axisX2Field.dicType??>
            <@call this.addConstImport(axisX2Field.dicType)/>
        return ${axisX2Field.dicType}.valueToDesc(${this.axisX2.alias});
        <#else>
        return ${this.axisX2.alias};
        </#if>
    }

    @Override
    public Object fetchMetrics() {
        return ${this.axisYList[0].alias};
    }

    <#elseIf barLineParamMode == 2>
        <#assign axisXField = this.axisX.sourceItem.field>
    public static Object[] header() {
        return new Object[]{
                "${this.axisX.titleAlias}",
        <#list this.axisYList as axisY>
                "${axisY.titleAlias}"<#if axisY_has_next>,</#if>
        </#list>
        };
    }

    public Object[] dataArray() {
        return new Object[]{
        <#if axisXField.dicType??>
            <@call this.addConstImport(axisXField.dicType)/>
                ${axisXField.dicType}.valueToDesc(${this.axisX.alias}),
        <#else>
                ${this.axisX.alias},
        </#if>
        <#list this.axisYList as axisY>
                ${axisY.alias}<#if axisY_has_next>,</#if>
        </#list>
        };
    }

    </#if>
<#elseIf isChartType(ChartType.PIE)>
    <#assign dimensionField = this.dimension.sourceItem.field>
    public static Object[] header() {
        return new Object[]{
                "${this.dimension.titleAlias}",
                "${this.metrics.titleAlias}"
        };
    }

    public Object[] dataArray() {
        return new Object[]{
    <#if dimensionField.dicType??>
        <@call this.addConstImport(dimensionField.dicType)/>
                ${dimensionField.dicType}.valueToDesc(${this.dimension.alias}),
    <#else>
                ${this.dimension.alias},
    </#if>
                ${this.metrics.alias}
        };
    }

</#if>
<#if !this.projectFeature.lombokEnabled>${getterSetterCode}</#if>

}
</#assign>
<#--开始渲染代码-->
package ${voPackageName};

<@call this.printImport()/>

${code}
