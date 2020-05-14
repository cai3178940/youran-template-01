<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
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
        ${sourceItem.customContent} as ${wrapMysqlKeyword(sourceItem.alias)}<#if column?hasNext>,</#if>
        <#else>
            <#assign field=sourceItem.field>
        ${getSelectFieldWithAlias(field,"t${sourceItem.joinIndex}",sourceItem.alias)}<#if column?hasNext>,</#if>
        </#if>
    </#list>
<#else>
</#if>
    </sql>

<#list this.chartSource.whereMap>
    <sql id="queryCondition">
    <#items as itemId,whereItem>
        <#if whereItem.custom>
        and ${sourceItem.customContent}
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
        ${getSelectFieldWithAlias(field,"t${detailListItem.joinIndex}",detailListItem.alias)} ${mapperOrderBySymbol(detailOrderItem.sortType)}<#if itemId?hasNext>,</#if>
            </#if>
        </#items>
    </sql>

    </#list>
</#if>
<#-- join右边的表名 -->
<#function joinRightTableName join>
    <#if join.rightEntity??>
        <#return wrapMysqlKeyword(join.rightEntity.tableName)>
    <#else>
        <#return wrapMysqlKeyword(join.rightMtm.tableName)>
    </#if>
</#function>
<#-- join右边的字段名 -->
<#function joinRightFieldName join>
    <#if join.rightField??>
        <#return wrapMysqlKeyword(join.rightField.fieldName)>
    <#else>
        <#return wrapMysqlKeyword(join.rightMtmField)>
    </#if>
</#function>
<#-- join左边的字段名 -->
<#function joinLeftFieldName join>
    <#if join.leftField??>
        <#return wrapMysqlKeyword(join.leftField.fieldName)>
    <#else>
        <#return wrapMysqlKeyword(join.leftMtmField)>
    </#if>
</#function>
<#if isChartType(ChartType.DETAIL_LIST)>
    <select id="selectCount" parameterType="${this.chartName}QO" resultType="int">
        select count(1)
        from ${wrapMysqlKeyword(mainEntity.tableName)} t0
    <#list joins as join>
        ${mapperJoinSymbol(join.joinType)} ${joinRightTableName(join)} t${join.rightIndex}
            on t${join.leftIndex}.${joinLeftFieldName(join)} = t${join.rightIndex}.${joinRightFieldName(join)}
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
        ${mapperJoinSymbol(join.joinType)} ${joinRightTableName(join)} t${join.rightIndex}
            on t${join.leftIndex}.${joinLeftFieldName(join)} = t${join.rightIndex}.${joinRightFieldName(join)}
    </#list>
    <#if this.chartSource.whereMap?hasContent>
        <where>
            <include refid="queryCondition"/>
        </where>
    </#if>
    <#if isChartType(ChartType.DETAIL_LIST)
            && this.chartSource.detailOrderMap?hasContent>
        <include refid="orderCondition"/>
    </#if>
        limit ${r'#'}{startIndex},${r'#'}{pageSize}
    </select>
</#if>

</mapper>
