<#include "/abstracted/commonForChart.ftl">
<#-- 定义数据项id->图表项的映射 -->
<#assign chartItemMapWrapper = CommonTemplateFunction.createHashMapWrapper()>
<#--定义宏：组装chartItemMap-->
<#macro buildChartItemMap items>
    <#list items as item>
        <@justCall chartItemMapWrapper.put(item.sourceItemId, item)/>
    </#list>
</#macro>
<#if isChartType(ChartType.DETAIL_LIST)>
    <@buildChartItemMap this.columnList/>
<#elseif isChartType(ChartType.AGG_TABLE)>
    <@buildChartItemMap this.dimensionList/>
    <@buildChartItemMap this.metricsList/>
<#elseif isChartType(ChartType.BAR_LINE)>
    <@buildChartItemMap [this.axisX, this.axisX2]/>
    <@buildChartItemMap this.axisYList/>
<#elseif isChartType(ChartType.PIE)>
    <@buildChartItemMap [this.dimension, this.metrics]/>
</#if>
<#-- 判断数据项是否被图表项引用 -->
<#function isSourceItemUsed sourceItem>
    <#return chartItemMapWrapper.containsKey(sourceItem.sourceItemId)>
</#function>
<#-- 过滤有效的dimension -->
<#assign filteredDimension = []>
<#list this.chartSource.dimensionMap as itemId,dimension>
    <#if isSourceItemUsed(dimension)>
        <#assign filteredDimension += [dimension]>
    </#if>
</#list>
<#-- 过滤有效的metrics -->
<#assign filteredMetrics = []>
<#list this.chartSource.metricsMap as itemId,metrics>
    <#if isSourceItemUsed(metrics)>
        <#assign filteredMetrics += [metrics]>
    </#if>
</#list>
<#-- 过滤有效的having -->
<#assign filteredHaving = []>
<#list this.chartSource.havingMap as itemId,having>
    <#if isSourceItemUsed(having.parent!)>
        <#assign filteredHaving += [having]>
    </#if>
</#list>
<#-- 过滤有效的aggOrder -->
<#assign filteredAggOrder = []>
<#list this.chartSource.aggOrderMap as itemId,aggOrder>
    <#if isSourceItemUsed(aggOrder.parent!)>
        <#assign filteredAggOrder += [aggOrder]>
    </#if>
</#list>
<#-- 需要传入参数的where条件 -->
<#assign paramedWhere = []>
<#-- 不需要传入参数的where条件 -->
<#assign unparamedWhere = []>
<#list this.chartSource.whereMap as itemId,where>
    <#if where.custom>
        <#assign unparamedWhere += [where]>
    <#else>
        <#if FilterOperator.IS_NULL.getValue() == where.filterOperator
        || FilterOperator.NOT_NULL.getValue() == where.filterOperator>
            <#assign unparamedWhere += [where]>
        <#else>
            <#assign paramedWhere += [where]>
        </#if>
    </#if>
</#list>
