<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("io.swagger.annotations.ApiModel")/>
<@call this.addImport("io.swagger.annotations.ApiModelProperty")/>
<@call this.addImport("${this.commonPackage}.pojo.vo.AbstractVO")/>
<@call this.printClassCom("【${this.title}】图表展示对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
@ApiModel(description = "【${this.title}】图表展示对象")
public class ${this.chartName}VO extends AbstractVO {


<#if isChartType(ChartType.DETAIL_LIST)>
    <#list this.columnList as column>
        <#assign sourceItem=column.sourceItem>
        <#if sourceItem.custom>
    @ApiModelProperty(notes = "${column.titleAlias}")
    private ${convertCustomFieldType(sourceItem.customFieldType)} ${sourceItem.alias};
        <#else>
            <#assign field=sourceItem.field>
            <#--import字段类型-->
            <@call this.addFieldTypeImport(field)/>
            <#--字段名转下划线大写-->
            <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
            <#if column.titleAlias?hasContent>
    @ApiModelProperty(notes = "${column.titleAlias}")
            <#else>
    @ApiModelProperty(notes = "${field.fetchComment()?replace('\"','\\"')?replace('\n','\\n')}")
            </#if>
            <#if field.jfieldType==JFieldType.DATE.getJavaType()
                || field.jfieldType==JFieldType.LOCALDATE.getJavaType()
                || field.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${guessDateFormat(field)}, timezone = "GMT+8")
            </#if>
            <#if sourceItem.alias?hasContent>
    private ${field.jfieldType} ${sourceItem.alias};
            <#else>
    private ${field.jfieldType} ${field.jfieldName};
            </#if>
        </#if>
    </#list>
<#else>
</#if>

}
</#assign>
<#--开始渲染代码-->
package ${voPackageName};

<@call this.printImport()/>

${code}
