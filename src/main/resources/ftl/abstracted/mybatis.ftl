<#-- mybatis sql模板专用 -->
<#include "/abstracted/common.ftl">
<#-- 生成if不为空条件内容，支持字段别名-->
<#function ifNotEmptyConditionWithAlias alias field>
    <#if QueryType.isIn(field.queryType)>
        <#return "${alias} != null and ${alias}.size() >0 " >
    <#elseIf field.jfieldType==JFieldType.STRING.getJavaType()>
        <#return "${alias} != null and ${alias} !='' " >
    <#else>
        <#return "${alias} != null " >
    </#if>
</#function>
<#-- 生成if不为空条件内容 -->
<#function ifNotEmptyCondition field>
    <#return "${ifNotEmptyConditionWithAlias(field.jfieldName,field)}" >
</#function>
<#-- 将mysql中的关键字加``包裹 -->
<#function wrapMysqlKeyword fieldName>
    <#return "${SqlTemplateFunction.wrapMysqlKeyword(fieldName)}" >
</#function>

<#-- 获取select列名，支持别名 -->
<#function getSelectFieldWithAlias field tableAlias fieldAlias="">
    <#if fieldAlias?hasContent>
        <#return "${tableAlias}.${wrapMysqlKeyword(field.fieldName)} as ${wrapMysqlKeyword(fieldAlias)}">
    <#elseIf field.fieldName?capitalize!=field.jfieldName?capitalize>
        <#return "${tableAlias}.${wrapMysqlKeyword(field.fieldName)} as ${wrapMysqlKeyword(field.jfieldName)}">
    <#else>
        <#return "${tableAlias}.${wrapMysqlKeyword(field.fieldName)}">
    </#if>
</#function>
