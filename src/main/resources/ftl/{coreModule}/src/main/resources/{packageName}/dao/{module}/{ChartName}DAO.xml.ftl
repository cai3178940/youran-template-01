<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/mybatisForChart.ftl">
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${daoPackageName}.${this.chartName}DAO">

    <sql id="columns">
<#if isChartType(ChartType.DETAIL_LIST)>
    <#list this.columnList as column>
        <#assign sourceItem=column.sourceItem>
        <#if sourceItem.custom>
        ${sourceItem.customContent} as ${wrapMysqlKeyword(column.alias)}<#if column?hasNext>,</#if>
        <#else>
            <#assign field=sourceItem.field>
        ${getSelectFieldWithAlias(field,"t${sourceItem.joinIndex}",column.alias)}<#if column?hasNext>,</#if>
        </#if>
    </#list>
<#else>
</#if>
    </sql>

<#list this.chartSource.whereMap>
    <sql id="queryCondition">
    <#items as itemId,whereItem>
        <#if whereItem.custom>
        and ${whereItem.customContent}
        <#else>
            <#assign field=whereItem.field>
            <#--is null 、is not null查询-->
            <#if FilterOperator.IS_NULL.getValue() == whereItem.filterOperator
                || FilterOperator.NOT_NULL.getValue() == whereItem.filterOperator>
        and t${whereItem.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(whereItem.filterOperator)}
            <#--in、not in查询-->
            <#elseIf FilterOperator.CONTAIN.getValue() == whereItem.filterOperator
                || FilterOperator.NOT_CONTAIN.getValue() == whereItem.filterOperator>
        and t${whereItem.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(whereItem.filterOperator)}
            <foreach collection="fixedParam${itemId?counter}" item="_value" open="(" separator="," close=")">
                ${r'#'}{_value}
            </foreach>
            <#--like查询-->
            <#elseIf FilterOperator.LIKE.getValue() == whereItem.filterOperator>
            <bind name="fixedParam${itemId?counter}_pattern" value="'%' + fixedParam${itemId?counter} + '%'" />
        and t${whereItem.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(whereItem.filterOperator)} ${r'#'}{fixedParam${itemId?counter}_pattern}
            <#--between查询-->
            <#elseIf FilterOperator.BETWEEN.getValue() == whereItem.filterOperator
                || FilterOperator.IS_NOW.getValue() == whereItem.filterOperator
                || FilterOperator.BEFORE_TIME.getValue() == whereItem.filterOperator
                || FilterOperator.AFTER_TIME.getValue() == whereItem.filterOperator>
        and t${whereItem.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(whereItem.filterOperator)} ${r'#'}{fixedParam${itemId?counter}Start} and ${r'#'}{fixedParam${itemId?counter}End}
            <#else>
        and t${whereItem.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(whereItem.filterOperator)} ${r'#'}{fixedParam${itemId?counter}}
            </#if>
        </#if>
    </#items>
    </sql>

</#list>
<#if isChartType(ChartType.DETAIL_LIST)>
    <#list this.chartSource.detailOrderMap>
    <sql id="orderCondition">
        order by
        <#items as itemId,detailOrderItem>
            <#assign detailListItem=detailOrderItem.parent>
            <#if detailListItem.custom>
        ${detailListItem.customContent} ${mapperOrderBySymbol(detailOrderItem.sortType)}<#if itemId?hasNext>,</#if>
            <#else>
                <#assign field=detailListItem.field>
        t${detailListItem.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOrderBySymbol(detailOrderItem.sortType)}<#if itemId?hasNext>,</#if>
            </#if>
        </#items>
    </sql>

    </#list>
</#if>

<#if isChartType(ChartType.DETAIL_LIST)>
    <select id="selectCount" parameterType="${this.chartName}QO" resultType="int">
        select count(1)
        from ${wrapMysqlKeyword(mainEntity.tableName)} t0
    <#list joins as join>
        ${mapperJoinSymbol(join.joinType)} ${joinTableName(join.right)} t${join.right.joinIndex}
            on t${join.left.joinIndex}.${joinFieldName(join.left)} = t${join.right.joinIndex}.${joinFieldName(join.right)}
    </#list>
    <#if this.chartSource.whereMap?hasContent>
        <where>
            <include refid="queryCondition"/>
        </where>
    </#if>
    </select>

    <select id="selectList" parameterType="${this.chartName}QO" resultType="${this.chartName}VO">
        select
        <include refid="columns"></include>
        from ${wrapMysqlKeyword(mainEntity.tableName)} t0
    <#list joins as join>
        ${mapperJoinSymbol(join.joinType)} ${joinTableName(join.right)} t${join.right.joinIndex}
            on t${join.left.joinIndex}.${joinFieldName(join.left)} = t${join.right.joinIndex}.${joinFieldName(join.right)}
    </#list>
    <#if this.chartSource.whereMap?hasContent>
        <where>
            <include refid="queryCondition"/>
        </where>
    </#if>
    <#if this.chartSource.detailOrderMap?hasContent>
        <include refid="orderCondition"/>
    </#if>
        limit ${r'#'}{startIndex},${r'#'}{pageSize}
    </select>
<#elseIf isChartType(ChartType.AGG_TABLE)>
    <select id="selectCount" parameterType="${this.chartName}QO" resultType="int">
        select count(1) from (
            select 1
            from ${wrapMysqlKeyword(mainEntity.tableName)} t0
        <#list joins as join>
            ${mapperJoinSymbol(join.joinType)} ${joinTableName(join.right)} t${join.right.joinIndex}
                on t${join.left.joinIndex}.${joinFieldName(join.left)} = t${join.right.joinIndex}.${joinFieldName(join.right)}
        </#list>
        <#if this.chartSource.whereMap?hasContent>
            <where>
                <include refid="queryCondition"/>
            </where>
        </#if>
            group by
        <#list this.chartSource.dimensionMap as dimension>
                ${renderDimension(dimension)}<#if dimension?hasNext>,</#if>
        </#list>
        <#if this.chartSource.havingMap?hasContent>
            having
            <#list this.chartSource.havingMap as having>
                <#if !having?isFirst>and </#if>${renderHaving(having)}
            </#list>
        </#if>
        ) tmp
    </select>

    <select id="selectList" parameterType="${this.chartName}QO" resultType="${this.chartName}VO">
        select
    <#list this.chartSource.dimensionMap as dimension>
            ${renderDimension(dimension)}<#if dimension?hasNext || this.chartSource.metricsMap?hasContent>,</#if>
    </#list>
    <#list this.chartSource.metricsMap as metrics>
            ${renderMetrics(metrics)}<#if metrics?hasNext>,</#if>
    </#list>
        from ${wrapMysqlKeyword(mainEntity.tableName)} t0
    <#list joins as join>
        ${mapperJoinSymbol(join.joinType)} ${joinTableName(join.right)} t${join.right.joinIndex}
            on t${join.left.joinIndex}.${joinFieldName(join.left)} = t${join.right.joinIndex}.${joinFieldName(join.right)}
    </#list>
    <#if this.chartSource.whereMap?hasContent>
        <where>
            <include refid="queryCondition"/>
        </where>
    </#if>
        group by
    <#list this.chartSource.dimensionMap as dimension>
            ${renderDimension(dimension)}<#if dimension?hasNext>,</#if>
    </#list>
    <#if this.chartSource.havingMap?hasContent>
        having
        <#list this.chartSource.havingMap as having>
            <#if !having?isFirst>and </#if>${renderHaving(having)}
        </#list>
    </#if>
    <#if this.chartSource.aggOrderMap?hasContent>
        order by
        <#list this.chartSource.aggOrderMap as aggOrder>
            ${renderAggOrder(aggOrder)}<#if aggOrder?hasNext>,</#if>
        </#list>
    </#if>
        limit ${r'#'}{startIndex},${r'#'}{pageSize}
    </select>
</#if>

</mapper>
