<#include "/abstracted/common.ftl">
<#-- 定义变量——主实体 -->
<#assign mainEntity=this.chartSource.entity>
<#-- 定义变量——join关联 -->
<#assign joins=this.chartSource.joins>
<#-- 带模块名的包路径 -->
<#if this.module?hasContent>
    <#assign daoPackageName = this.packageName+".dao."+this.module>
    <#assign qoPackageName = this.packageName+".pojo.qo."+this.module>
    <#assign voPackageName = this.packageName+".pojo.vo."+this.module>
    <#assign servicePackageName = this.packageName+".service."+this.module>
    <#assign apiPackageName = this.packageName+".web.api."+this.module>
    <#assign restPackageName = this.packageName+".web.rest."+this.module>
<#else>
    <#assign daoPackageName = this.packageName+".dao">
    <#assign qoPackageName = this.packageName+".pojo.qo">
    <#assign voPackageName = this.packageName+".pojo.vo">
    <#assign servicePackageName = this.packageName+".service">
    <#assign apiPackageName = this.packageName+".web.api">
    <#assign restPackageName = this.packageName+".web.rest">
</#if>
<#-- 判断当前图表的类型 -->
<#function isChartType chartTypeEnum>
    <#return this.chartType == chartTypeEnum.getValue()>
</#function>
<#-- 映射图表自定义字段类型 -->
<#function convertCustomFieldType type>
    <#if CustomFieldType.STRING.getValue() == type>
        <#return "String">
    <#elseIf CustomFieldType.INT.getValue() == type>
        <#return "Integer">
    <#elseIf CustomFieldType.DOUBLE.getValue() == type>
        <#return "Double">
    <#elseIf CustomFieldType.DATE.getValue() == type>
        <@call this.addImport("java.util.Date")/>
        <#return "Date">
    <#elseIf CustomFieldType.DATE_TIME.getValue() == type>
        <@call this.addImport("java.util.Date")/>
        <#return "Date">
    <#else>
        <#return "String">
    </#if>
</#function>
<#-- 映射指标字段类型 -->
<#function convertMetricsFieldType metrics>
    <#if metrics.custom>
        <#return convertCustomFieldType(metrics.customFieldType)>
    <#else>
        <#if AggFunction.COUNT == metrics.aggFunction
            || AggFunction.COUNT_DISTINCT == metrics.aggFunction>
            <#return "Integer">
        <#else>
            <#local field = metrics.field>
            <#return field.jfieldType>
        </#if>
    </#if>
</#function>
