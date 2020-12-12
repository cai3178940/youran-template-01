<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/chartItem.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("java.util.List")/>
<@call this.addImport("${daoPackageName}.${this.chartName}DAO")/>
<@call this.addImport("${qoPackageName}.${this.chartName}QO")/>
<@call this.addImport("${voPackageName}.${this.chartName}VO")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Autowired")/>
<@call this.addImport("org.springframework.stereotype.Service")/>
<@call this.printClassCom("【${this.title}】图表查询服务")/>
@Service
public class ${this.chartName}Service {

    @Autowired
    private ${this.chartName}DAO ${this.chartNameLower}DAO;

<#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>
    /**
     * 查询明细表
     *
     * @param qo
     * @return
     */
    <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    public PageVO<${this.chartName}VO> findList(${this.chartName}QO qo) {
    <#if paramedWhere?hasContent || filteredHaving?hasContent>
        this.initQueryParam(qo);
    </#if>
        List<${this.chartName}VO> list;
        int count = ${this.chartNameLower}DAO.selectCount(qo);
        if (count > 0) {
            list = ${this.chartNameLower}DAO.selectList(qo);
        } else {
            <@call this.addImport("java.util.ArrayList")/>
            list = new ArrayList<>();
        }
        PageVO<${this.chartName}VO> pageVO = new PageVO<>(list, qo.getPageNo(), qo.getPageSize(), count);
        return pageVO;
    }

<#else>
    /**
     * 查询图表数据
     *
     * @param qo
     * @return
     */
    public List<Object[]> findChartData(${this.chartName}QO qo) {
    <#if paramedWhere?hasContent || filteredHaving?hasContent>
        this.initQueryParam(qo);
    </#if>
        List<${this.chartName}VO> list = ${this.chartNameLower}DAO.selectList(qo);
        return this.convertChartData(list);
    }

    /**
     * 图表数据转换
     *
     * @param list
     * @return
     */
    private List<Object[]> convertChartData(List<${this.chartName}VO> list) {
        <@call this.addImport("java.util.LinkedList")/>
        List<Object[]> result = new LinkedList<>();
    <#-- 柱线图的数据转换 -->
    <#if isChartType(ChartType.BAR_LINE)>
        <#-- 模式1 -->
        <#if barLineParamMode == 1>
            <@call this.addImport("${this.commonPackage}.util.ChartDataUtil")/>
            <@call this.addImport("${this.commonPackage}.pojo.vo.Chart2DimensionVO")/>
            <@call this.addImport("java.util.ArrayList")/>
        List<Object> dimension2Values = ChartDataUtil.getDistinctValues(list, Chart2DimensionVO::fetchDimension2);
        List<Object> header = new ArrayList<>();
        header.add(${this.chartName}VO.header0());
        header.addAll(dimension2Values);
        result.add(header.toArray());
        List<Object[]> datas = ChartDataUtil.convert2DimensionMetrix(list, dimension2Values);
        result.addAll(datas);
        <#-- 模式2 -->
        <#elseIf barLineParamMode == 2>
        result.add(${this.chartName}VO.header());
        for (${this.chartName}VO vo : list) {
            result.add(vo.dataArray());
        }
        </#if>
    <#elseIf isChartType(ChartType.PIE)>
        result.add(${this.chartName}VO.header());
        for (${this.chartName}VO vo : list) {
            result.add(vo.dataArray());
        }
    </#if>
        return result;
    }

</#if>
<#-- 打印字段过滤值 -->
<#function printFilterValue jfieldType value>
    <#if jfieldType == JFieldType.STRING.getJavaType()>
        <#return "\"${value}\"">
    <#elseIf jfieldType == JFieldType.BOOLEAN.getJavaType()>
        <#return "${value}">
    <#elseIf jfieldType == JFieldType.INTEGER.getJavaType()>
        <#return "${value}">
    <#elseIf jfieldType == JFieldType.SHORT.getJavaType()>
        <#return "${value}">
    <#elseIf jfieldType == JFieldType.LONG.getJavaType()>
        <#return "${value}L">
    <#elseIf jfieldType == JFieldType.DOUBLE.getJavaType()>
        <#return "${value}d">
    <#elseIf jfieldType == JFieldType.FLOAT.getJavaType()>
        <#return "${value}f">
    <#elseIf jfieldType == JFieldType.BIGDECIMAL.getJavaType()>
        <@call this.addImport("java.math.BigDecimal")/>
        <#return "new BigDecimal(\"${value}\")">
    <#elseIf jfieldType == JFieldType.DATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#return "DateUtil.parseDate(\"${value}\")">
    <#elseIf jfieldType == JFieldType.LOCALDATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#return "DateUtil.parseLocalDate(\"${value}\")">
    <#elseIf jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#return "DateUtil.parseLocalDateTime(\"${value}\")">
    </#if>
</#function>
<#if this.chartSource.whereMap?hasContent>
    /**
     * 初始化固定查询参数
     *
     * @param qo
     */
    private void initQueryParam(${this.chartName}QO qo) {
    <#list paramedWhere as where>
        <#assign jfieldType = where.field.jfieldType>
        <#if FilterOperator.CONTAIN.getValue() == where.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == where.filterOperator>
            <@call this.addImport("com.google.common.collect.Lists")/>
        qo.setWhereParam${where?counter}(Lists.newArrayList(
            <#list where.filterValue as filterValue>
                ${printFilterValue(jfieldType, filterValue)}<#if filterValue?hasNext>,</#if>
            </#list>
        ));
        <#elseIf FilterOperator.BETWEEN.getValue() == where.filterOperator
        || FilterOperator.IS_NOW.getValue() == where.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == where.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == where.filterOperator>
        qo.setWhereParam${where?counter}Start(${printFilterValue(jfieldType, where.filterValue[0])});
        qo.setWhereParam${where?counter}End(${printFilterValue(jfieldType, where.filterValue[1])});
        <#else>
        qo.setWhereParam${where?counter}(${printFilterValue(jfieldType, where.filterValue[0])});
        </#if>
    </#list>
    <#list filteredHaving as having>
        <#assign jfieldType = convertMetricsFieldType(having.parent)>
        <#if FilterOperator.CONTAIN.getValue() == having.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == having.filterOperator>
            <@call this.addImport("com.google.common.collect.Lists")/>
        qo.setHavingParam${having?counter}(Lists.newArrayList(
            <#list having.filterValue as filterValue>
                ${printFilterValue(jfieldType, filterValue)}<#if filterValue?hasNext>,</#if>
            </#list>
        ));
        <#elseIf FilterOperator.BETWEEN.getValue() == having.filterOperator
        || FilterOperator.IS_NOW.getValue() == having.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == having.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == having.filterOperator>
        qo.setHavingParam${having?counter}Start(${printFilterValue(jfieldType, having.filterValue[0])});
        qo.setHavingParam${having?counter}End(${printFilterValue(jfieldType, having.filterValue[1])});
        <#else>
        qo.setHavingParam${having?counter}(${printFilterValue(jfieldType, having.filterValue[0])});
        </#if>
    </#list>
    }
</#if>
}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(servicePackageName)/>

${code}
