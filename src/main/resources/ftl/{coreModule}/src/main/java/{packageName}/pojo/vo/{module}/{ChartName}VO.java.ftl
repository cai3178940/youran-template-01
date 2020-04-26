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

<#-- 定义getterSetter代码 -->
<#assign getterSetterCode = "">
<#if isChartType(ChartType.DETAIL_LIST)>
    <#list this.columnList as column>
        <#assign sourceItem=column.sourceItem>
        <#if sourceItem.custom>
            <#--字段类型-->
            <#assign type=convertCustomFieldType(sourceItem.customFieldType)>
            <#--字段名-->
            <#assign name=sourceItem.alias>
            <#--字段标题-->
            <#assign label=column.titleAlias>
        <#else>
            <#assign field=sourceItem.field>
            <#--import字段类型-->
            <@call this.addFieldTypeImport(field)/>
            <#assign type=field.jfieldType>
            <#if sourceItem.alias?hasContent>
                <#assign name=sourceItem.alias>
            <#else>
                <#assign name=field.jfieldName>
            </#if>
            <#if column.titleAlias?hasContent>
                <#assign label=column.titleAlias>
            <#else>
                <#assign label=field.fetchComment()?replace('\"','\\"')?replace('\n','\\n')>
            </#if>
            <#if field.jfieldType==JFieldType.DATE.getJavaType()
                || field.jfieldType==JFieldType.LOCALDATE.getJavaType()
                || field.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${guessDateFormat(field)}, timezone = "GMT+8")
            </#if>
        </#if>
    @ApiModelProperty(notes = "${label}")
    private ${type} ${name};
        <#assign getterSetterCode += genGetterSetter(type,name)>

    </#list>
<#else>
</#if>

<#if !this.projectFeature.lombokEnabled>${getterSetterCode}</#if>

}
</#assign>
<#--开始渲染代码-->
package ${voPackageName};

<@call this.printImport()/>

${code}
