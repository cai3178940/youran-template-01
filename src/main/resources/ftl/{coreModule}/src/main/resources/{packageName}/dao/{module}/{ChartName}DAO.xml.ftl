<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/mybatisForChart.ftl">
<#include "/abstracted/chartItem.ftl">
<#-- 渲染别名 -->
<#function renderAlias sourceItem>
    <#local chartItem = chartItemMapWrapper.get(sourceItem.sourceItemId)>
    <#return wrapMysqlKeyword(chartItem.alias)>
</#function>
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

<#if this.chartSource.whereMap?hasContent>
    <sql id="queryCondition">
    <#list paramedWhere as where>
        <#assign field=where.field>
        <#--in、not in查询-->
        <#if FilterOperator.CONTAIN.getValue() == where.filterOperator
            || FilterOperator.NOT_CONTAIN.getValue() == where.filterOperator>
        and t${where.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(where.filterOperator)}
            <foreach collection="whereParam${where?counter}" item="_value" open="(" separator="," close=")">
                ${r'#'}{_value}
            </foreach>
        <#--like查询-->
        <#elseIf FilterOperator.LIKE.getValue() == where.filterOperator>
            <bind name="whereParam${where?counter}_pattern" value="'%' + whereParam${where?counter} + '%'" />
        and t${where.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(where.filterOperator)} ${r'#'}{whereParam${where?counter}_pattern}
        <#--between查询-->
        <#elseIf FilterOperator.BETWEEN.getValue() == where.filterOperator
            || FilterOperator.IS_NOW.getValue() == where.filterOperator
            || FilterOperator.BEFORE_TIME.getValue() == where.filterOperator
            || FilterOperator.AFTER_TIME.getValue() == where.filterOperator>
        and t${where.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(where.filterOperator)} ${r'#'}{whereParam${where?counter}Start} and ${r'#'}{whereParam${where?counter}End}
        <#else>
        and t${where.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(where.filterOperator)} ${r'#'}{whereParam${where?counter}}
        </#if>
    </#list>
    <#list unparamedWhere as where>
        <#if where.custom>
        and ${where.customContent}
        <#else>
            <#--is null 、is not null查询-->
            <#assign field=where.field>
        and t${where.joinIndex}.${wrapMysqlKeyword(field.fieldName)} ${mapperOperatorSymbol(where.filterOperator)}
        </#if>
    </#list>
    </sql>

</#if>
<#list filteredHaving>
    <sql id="havingCondition">
        having
    <#items as having>
        <#assign metricsAlias = renderAlias(having.parent)>
        <#--is null 、is not null查询-->
        <#if FilterOperator.IS_NULL.getValue() == having.filterOperator
            || FilterOperator.NOT_NULL.getValue() == having.filterOperator>
            <#if !having?isFirst>and </#if>${metricsAlias} ${mapperOperatorSymbol(having.filterOperator)}
        <#--in、not in查询-->
        <#elseIf FilterOperator.CONTAIN.getValue() == having.filterOperator
            || FilterOperator.NOT_CONTAIN.getValue() == having.filterOperator>
            <#if !having?isFirst>and </#if>${metricsAlias} ${mapperOperatorSymbol(having.filterOperator)}
            <foreach collection="havingParam${having?counter}" item="_value" open="(" separator="," close=")">
                ${r'#'}{_value}
            </foreach>
        <#--like查询-->
        <#elseIf FilterOperator.LIKE.getValue() == having.filterOperator>
            <bind name="havingParam${having?counter}_pattern" value="'%' + havingParam${having?counter} + '%'" />
            <#if !having?isFirst>and </#if>${metricsAlias} ${mapperOperatorSymbol(having.filterOperator)} ${r'#'}{havingParam${having?counter}_pattern}
        <#--between查询-->
        <#elseIf FilterOperator.BETWEEN.getValue() == having.filterOperator
                || FilterOperator.IS_NOW.getValue() == having.filterOperator
                || FilterOperator.BEFORE_TIME.getValue() == having.filterOperator
                || FilterOperator.AFTER_TIME.getValue() == having.filterOperator>
            <#if !having?isFirst>and </#if>${metricsAlias} ${mapperOperatorSymbol(having.filterOperator)} ${r'#'}{havingParam${having?counter}Start} and ${r'#'}{havingParam${having?counter}End}
        <#else>
            <#if !having?isFirst>and </#if>${metricsAlias} ${mapperOperatorSymbol(having.filterOperator)} ${r'#'}{havingParam${having?counter}}
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
            select
        <#list filteredDimension as dimension>
                ${renderDimension(dimension)} as ${renderAlias(dimension)}<#if dimension?hasNext || filteredMetrics?hasContent>,</#if>
        </#list>
        <#list filteredMetrics as metrics>
                ${renderMetrics(metrics)} as ${renderAlias(metrics)}<#if metrics?hasNext>,</#if>
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
        <#list filteredDimension as dimension>
                ${renderAlias(dimension)}<#if dimension?hasNext>,</#if>
        </#list>
        <#if filteredHaving?hasContent>
            <include refid="havingCondition"/>
        </#if>
        ) tmp
    </select>

    <select id="selectList" parameterType="${this.chartName}QO" resultType="${this.chartName}VO">
        select
    <#list filteredDimension as dimension>
            ${renderDimension(dimension)} as ${renderAlias(dimension)}<#if dimension?hasNext || filteredMetrics?hasContent>,</#if>
    </#list>
    <#list filteredMetrics as metrics>
            ${renderMetrics(metrics)} as ${renderAlias(metrics)}<#if metrics?hasNext>,</#if>
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
    <#list filteredDimension as dimension>
            ${renderAlias(dimension)}<#if dimension?hasNext>,</#if>
    </#list>
    <#if filteredHaving?hasContent>
        <include refid="havingCondition"/>
    </#if>
    <#if filteredAggOrder?hasContent>
        order by
        <#list filteredAggOrder as aggOrder>
            ${renderAlias(aggOrder.parent)} ${mapperOrderBySymbol(aggOrder.sortType)}<#if aggOrder?hasNext>,</#if>
        </#list>
    </#if>
        limit ${r'#'}{startIndex},${r'#'}{pageSize}
    </select>
</#if>

</mapper>
