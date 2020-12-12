<#include "/abstracted/common.ftl">
<#-- 定义变量——主实体 -->
<#assign mainEntity = this.chartSource.entity>
<#-- 定义变量——join关联 -->
<#assign joins = this.chartSource.joins>
<#-- 带模块名的包路径 -->
<#if this.module?hasContent>
    <#assign daoPackageName = this.packageName+".dao."+this.module>
    <#assign qoPackageName = this.packageName+".pojo.qo."+this.module>
    <#assign voPackageName = this.packageName+".pojo.vo."+this.module>
    <#assign mapperPackageName = this.packageName+".pojo.mapper."+this.module>
    <#assign servicePackageName = this.packageName+".service."+this.module>
    <#assign apiPackageName = this.packageName+".web.api."+this.module>
    <#assign restPackageName = this.packageName+".web.rest."+this.module>
<#else>
    <#assign daoPackageName = this.packageName+".dao">
    <#assign qoPackageName = this.packageName+".pojo.qo">
    <#assign voPackageName = this.packageName+".pojo.vo">
    <#assign mapperPackageName = this.packageName+".pojo.mapper">
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
    <#local jfieldType = CustomFieldType.valueToJfieldType(type)>
    <@call this.addFieldTypeImport(jfieldType)/>
    <#return jfieldType>
</#function>
<#-- 映射维度字段类型 -->
<#function convertDimensionFieldType dimension>
    <#-- 时间聚合全部返回String类型 -->
    <#if Granularity.MINUTE.getValue() == dimension.granularity
        || Granularity.HOUR.getValue() == dimension.granularity
        || Granularity.DAY.getValue() == dimension.granularity
        || Granularity.WEEK.getValue() == dimension.granularity
        || Granularity.MONTH.getValue() == dimension.granularity
        || Granularity.QUARTER.getValue() == dimension.granularity
        || Granularity.YEAR.getValue() == dimension.granularity>
        <#return "String">
    <#else>
        <#local field = dimension.field>
        <#--import字段类型-->
        <@call this.addFieldTypeImport(field)/>
        <#return field.jfieldType>
    </#if>
</#function>
<#-- 映射指标字段类型 -->
<#function convertMetricsFieldType metrics>
    <#if metrics.custom>
        <#return convertCustomFieldType(metrics.customFieldType)>
    <#else>
        <#if AggFunction.COUNT.getValue() == metrics.aggFunction
            || AggFunction.COUNT_DISTINCT.getValue() == metrics.aggFunction>
            <#return "Integer">
        <#else>
            <#local field = metrics.field>
            <#--import字段类型-->
            <@call this.addFieldTypeImport(field)/>
            <#return field.jfieldType>
        </#if>
    </#if>
</#function>
<#-- 柱线图的参数模式 -->
<#assign barLineParamMode = 0>
<#if isChartType(ChartType.BAR_LINE)>
    <#if this.axisX2??>
        <#assign barLineParamMode = 1>
    <#else>
        <#assign barLineParamMode = 2>
    </#if>
</#if>
