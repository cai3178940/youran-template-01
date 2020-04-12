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


    <sql id="queryCondition">
        and t.sex = #{fixedParam1}
        and t.reg_time &lt; #{fixedParam2}
    </sql>

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
