<#include "/abstracted/common.ftl">
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

<#-- 映射过滤运算符 -->
<#function mapperOperatorSymbol operator>
    <#if FilterOperator.EQUAL.getValue()==operator>
        <#return "=">
    <#elseIf FilterOperator.NOT_EQUAL.getValue()==operator>
        <#return "!=">
    <#elseIf FilterOperator.GT.getValue()==operator>
        <#return ">">
    <#elseIf FilterOperator.GE.getValue()==operator>
        <#return ">=">
    <#elseIf FilterOperator.LT.getValue()==operator>
        <#return "&lt;">
    <#elseIf FilterOperator.LE.getValue()==operator>
        <#return "&lt;=">
    <#elseIf FilterOperator.BETWEEN.getValue()==operator>
        <#return "between">
    <#elseIf FilterOperator.CONTAIN.getValue()==operator>
        <#return "in">
    <#elseIf FilterOperator.NOT_CONTAIN.getValue()==operator>
        <#return "not in">
    <#elseIf FilterOperator.IS_NULL.getValue()==operator>
        <#return "is null">
    <#elseIf FilterOperator.NOT_NULL.getValue()==operator>
        <#return "is not null">
    <#elseIf FilterOperator.LIKE.getValue()==operator>
        <#return "like">
    <#elseIf FilterOperator.IS_NOW.getValue()==operator>
        <#return "between">
    <#elseIf FilterOperator.BEFORE_TIME.getValue()==operator>
        <#return "between">
    <#elseIf FilterOperator.AFTER_TIME.getValue()==operator>
        <#return "between">
    </#if>
</#function>


