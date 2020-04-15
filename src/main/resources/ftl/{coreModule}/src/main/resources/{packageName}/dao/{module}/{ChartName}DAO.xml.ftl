<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/mybatis.ftl">
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
    <sql id="orderCondition">
        order by
            t.created_time desc
    </sql>

    <select id="selectCount" parameterType="ThreeTableQO" resultType="int">
        select count(1)
        from `user` t
        inner join dept t2
            on t.dept_id = t2.id
        <where>
            <include refid="queryCondition"/>
        </where>
    </select>

    <select id="selectList" parameterType="ThreeTableQO" resultType="ThreeTableVO">
        select
        <include refid="columns"></include>
        from `user` t
        inner join dept t2
            on t.dept_id = t2.id
        <where>
            <include refid="queryCondition"/>
        </where>
        <include refid="orderCondition"/>
        limit #{startIndex},#{pageSize}
    </select>


</mapper>
