<#include "/abstracted/commonForChart.ftl">
<#-- 定义数据项id->图表项的映射 -->
<#assign chartItemMap = CommonTemplateFunction.createHashMap()>
<#--定义宏：组装chartItemMap-->
<#macro buildChartItemMap items...>
    <#list items as item>
        <@justCall chartItemMap.put(item.sourceItemId, item)/>
    </#list>
</#macro>
<#if isChartType(ChartType.DETAIL_LIST)>
    <@buildChartItemMap this.columnList/>
<#elseif isChartType(ChartType.AGG_TABLE)>
    <@buildChartItemMap this.dimensionList/>
    <@buildChartItemMap this.metricsList/>
<#elseif isChartType(ChartType.BAR_LINE)>
    <@buildChartItemMap this.axisX, this.axisX2/>
    <@buildChartItemMap this.axisYList/>
<#elseif isChartType(ChartType.PIE)>
    <@buildChartItemMap this.dimension, this.metrics/>
</#if>
<#-- 判断数据项是否被图表项引用 -->
<#function isSourceItemUsed sourceItem>
    <#return chartItemMap.containsKey(sourceItem.sourceItemId)>
</#function>
<#-- 过滤有效的明细列 -->
<#assign filteredDetailColumn = []>
<#list this.chartSource.detailColumnMap as detailColumn>
    <#if isSourceItemUsed(detailColumn)>
        <#assign filteredDetailColumn += [detailColumn]>
    </#if>
</#list>
<#-- 过滤有效的dimension -->
<#assign filteredDimension = []>
<#list this.chartSource.dimensionMap as dimension>
    <#if isSourceItemUsed(dimension)>
        <#assign filteredDimension += [dimension]>
    </#if>
</#list>
<#-- 过滤有效的metrics -->
<#assign filteredMetrics = []>
<#list this.chartSource.metricsMap as metrics>
    <#if isSourceItemUsed(metrics)>
        <#assign filteredMetrics += [metrics]>
    </#if>
</#list>
<#-- 过滤有效的having -->
<#assign filteredHaving = []>
<#list this.chartSource.havingMap as having>
    <#if isSourceItemUsed(having.parent)>
        <#assign filteredHaving += [having]>
    </#if>
</#list>
<#-- 过滤有效的aggOrder -->
<#assign filteredAggOrder = []>
<#list this.chartSource.aggOrderMap as aggOrder>
    <#if isSourceItemUsed(aggOrder.parent)>
        <#assign filteredAggOrder += [aggOrder]>
    </#if>
</#list>
