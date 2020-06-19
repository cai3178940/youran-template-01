<#include "/abstracted/commonForChart.ftl">
<#include "/abstracted/chartItemMap.ftl">
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
    public PageVO<${this.chartName}VO> findDetailList(${this.chartName}QO qo) {
    <#if this.chartSource.whereMap?hasContent>
        this.initWhereParam(qo);
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
    public List<${this.chartName}VO> findChartData(${this.chartName}QO qo) {
    <#if this.chartSource.whereMap?hasContent>
        this.initWhereParam(qo);
    </#if>
        List<${this.chartName}VO> list = ${this.chartNameLower}DAO.findChartData(qo);
        return list;
    }

</#if>
<#-- 打印字段过滤值 -->
<#function printFilterValue field value>
    <#if field.jfieldType==JFieldType.STRING.getJavaType()>
        <#return "\"${value}\"">
    <#elseIf field.jfieldType==JFieldType.BOOLEAN.getJavaType()>
        <#return "${value}">
    <#elseIf field.jfieldType==JFieldType.INTEGER.getJavaType()>
        <#return "${value}">
    <#elseIf field.jfieldType==JFieldType.SHORT.getJavaType()>
        <#return "${value}">
    <#elseIf field.jfieldType==JFieldType.LONG.getJavaType()>
        <#return "${value}L">
    <#elseIf field.jfieldType==JFieldType.DOUBLE.getJavaType()>
        <#return "${value}d">
    <#elseIf field.jfieldType==JFieldType.FLOAT.getJavaType()>
        <#return "${value}f">
    <#elseIf field.jfieldType==JFieldType.BIGDECIMAL.getJavaType()>
        <@call this.addImport("java.math.BigDecimal")/>
        <#return "new BigDecimal(\"${value}\")">
    <#elseIf field.jfieldType==JFieldType.DATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#return "DateUtil.parseDate(\"${value}\")">
    <#elseIf field.jfieldType==JFieldType.LOCALDATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#return "DateUtil.parseLocalDate(\"${value}\")">
    <#elseIf field.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
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
    private void initWhereParam(${this.chartName}QO qo) {
    <#list paramedWhere as where>
        <#assign field=where.field>
        <#if FilterOperator.CONTAIN.getValue() == where.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == where.filterOperator>
            <@call this.addImport("com.google.common.collect.Lists")/>
        qo.setWhereParam${where?counter}(Lists.newArrayList(
            <#list where.filterValue as filterValue>
                ${printFilterValue(field,filterValue)}<#if filterValue?hasNext>,</#if>
            </#list>
        ));
        <#elseIf FilterOperator.BETWEEN.getValue() == where.filterOperator
        || FilterOperator.IS_NOW.getValue() == where.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == where.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == where.filterOperator>
        qo.setWhereParam${where?counter}Start(${printFilterValue(field,where.filterValue[0])});
        qo.setWhereParam${where?counter}End(${printFilterValue(field,where.filterValue[1])});
        <#else>
        qo.setWhereParam${where?counter}(${printFilterValue(field,where.filterValue[0])});
        </#if>
    </#list>
    }
</#if>
}

</#assign>
<#--开始渲染代码-->
package ${servicePackageName};

<@call this.printImport()/>

${code}
