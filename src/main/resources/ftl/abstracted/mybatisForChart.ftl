<#-- mybatis sql模板专用 -->
<#include "/abstracted/common.ftl">
<#include "/abstracted/mybatis.ftl">
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
<#-- 映射排序运算符 -->
<#function mapperOrderBySymbol sortType>
    <#if SortType.ASC.getValue()==sortType>
        <#return "asc">
    <#else>
        <#return "desc">
    </#if>
</#function>
<#-- 映射排序运算符 -->
<#function mapperJoinSymbol joinType>
    <#if JoinType.RIGHT_JOIN.getValue()==joinType>
        <#return "right join">
    <#elseIf JoinType.LEFT_JOIN.getValue()==joinType>
        <#return "left join">
    <#else>
        <#return "inner join">
    </#if>
</#function>
<#-- join的表名 -->
<#function joinTableName joinPart>
    <#if joinPart.joinPartType == "entity">
        <#return wrapMysqlKeyword(joinPart.entity.tableName)>
    <#else>
        <#return wrapMysqlKeyword(joinPart.mtm.tableName)>
    </#if>
</#function>
<#-- join的字段名 -->
<#function joinFieldName joinPart>
    <#if joinPart.joinPartType == "entity">
        <#return wrapMysqlKeyword(joinPart.field.fieldName)>
    <#else>
        <#return wrapMysqlKeyword(joinPart.mtmField)>
    </#if>
</#function>
<#-- 渲染维度 -->
<#function renderDimension dimension>
    <#local fieldName = "t${dimension.joinIndex}.${wrapMysqlKeyword(dimension.field.fieldName)}">
    <#if dimension.granularity == Granularity.SINGLE_VALUE.getValue()>
        <#return fieldName>
    <#elseIf dimension.granularity == Granularity.INTERVAL_10.getValue()>
        <#return fieldName + " / 10">
    <#elseIf dimension.granularity == Granularity.INTERVAL_100.getValue()>
        <#return fieldName + " / 100">
    <#elseIf dimension.granularity == Granularity.INTERVAL_1000.getValue()>
        <#return fieldName + " / 1000">
    <#elseIf dimension.granularity == Granularity.INTERVAL_10000.getValue()>
        <#return fieldName + " / 10000">
    <#elseIf dimension.granularity == Granularity.MINUTE.getValue()>
        <#return fieldName + " / 10000">
    <#else>
    </#if>
</#function>
<#-- 渲染指标 -->
<#function renderMetrics metrics>
</#function>
<#-- 渲染having -->
<#function renderHaving having>
</#function>
<#-- 渲染having -->
<#function renderAggOrder aggOrder>
</#function>
