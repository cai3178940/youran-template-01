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
<#-- 渲染别名 -->
<#function renderAlias chartItem>

</#function>
<#-- 渲染维度 -->
<#function renderDimension dimension>
    <#local fieldName = "t${dimension.joinIndex}.${wrapMysqlKeyword(dimension.field.fieldName)}">
    <#if dimension.granularity == Granularity.INTERVAL_10.getValue()>
        <#return "${fieldName} / 10">
    <#elseIf dimension.granularity == Granularity.INTERVAL_100.getValue()>
        <#return "${fieldName} / 100">
    <#elseIf dimension.granularity == Granularity.INTERVAL_1000.getValue()>
        <#return "${fieldName} / 1000">
    <#elseIf dimension.granularity == Granularity.INTERVAL_10000.getValue()>
        <#return "${fieldName} / 10000">
    <#elseIf dimension.granularity == Granularity.MINUTE.getValue()>
        <#return "DATE_FORMAT(${fieldName},'%Y-%m-%d %H:%i:00')">
    <#elseIf dimension.granularity == Granularity.HOUR.getValue()>
        <#return "DATE_FORMAT(${fieldName},'%Y-%m-%d %H:00:00')">
    <#elseIf dimension.granularity == Granularity.DAY.getValue()>
        <#return "DATE_FORMAT(${fieldName},'%Y-%m-%d')">
    <#elseIf dimension.granularity == Granularity.WEEK.getValue()>
        <#return "DATE_FORMAT(${fieldName},'%x-%v')">
    <#elseIf dimension.granularity == Granularity.MONTH.getValue()>
        <#return "DATE_FORMAT(${fieldName},'%Y-%m')">
    <#elseIf dimension.granularity == Granularity.QUARTER.getValue()>
        <#return "CONCAT(YEAR(${fieldName}),'-',QUARTER(${fieldName}))">
    <#elseIf dimension.granularity == Granularity.YEAR.getValue()>
        <#return "DATE_FORMAT(${fieldName},'%Y')">
    <#else>
        <#return fieldName>
    </#if>
</#function>
<#-- 渲染指标 -->
<#function renderMetrics metrics>
    <#if metrics.custom>
        <#return metrics.customContent>
    <#else>
        <#local fieldName = "t${metrics.joinIndex}.${wrapMysqlKeyword(metrics.field.fieldName)}">
        <#if metrics.aggFunction == AggFunction.SUM.getValue()>
            <#return "SUM(${fieldName})">
        <#elseIf metrics.aggFunction == AggFunction.MAX.getValue()>
            <#return "MAX(${fieldName})">
        <#elseIf metrics.aggFunction == AggFunction.MIN.getValue()>
            <#return "MIN(${fieldName})">
        <#elseIf metrics.aggFunction == AggFunction.AVG.getValue()>
            <#return "AVG(${fieldName})">
        <#elseIf metrics.aggFunction == AggFunction.COUNT.getValue()>
            <#return "COUNT(${fieldName})">
        <#elseIf metrics.aggFunction == AggFunction.COUNT_DISTINCT.getValue()>
            <#return "COUNT(DISTINCT ${fieldName})">
        </#if>
    </#if>
</#function>
<#-- 渲染指标排序 -->
<#function renderAggOrder aggOrder>
</#function>
