<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
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

<#if isChartType(ChartType.DETAIL_LIST)>
    /**
     * 查询明细表
     *
     * @param qo
     * @return
     */
    <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    public PageVO<${this.chartName}VO> findDetailList(${this.chartName}QO qo) {
        this.initFixedParam(qo);
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
        this.initFixedParam(qo);
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
    /**
     * 初始化固定查询参数
     *
     * @param qo
     */
    private void initFixedParam(${this.chartName}QO qo) {
        qo.setFixedParam2(LocalDate.now());
<#list this.chartSource.whereMap as itemId,whereItem>
    <#if !whereItem.custom>
        <#if FilterOperator.IS_NULL.getValue() == whereItem.filterOperator
                || FilterOperator.NOT_NULL.getValue() == whereItem.filterOperator>
            <#continue>
        </#if>
        <#assign field=whereItem.field>
        <#if FilterOperator.CONTAIN.getValue() == whereItem.filterOperator
        || FilterOperator.NOT_CONTAIN.getValue() == whereItem.filterOperator>
            <@call this.addImport("com.google.common.collect.Lists")/>
        qo.setFixedParam${itemId?counter}(Lists.newArrayList(
            <#list whereItem.filterValue as filterValue>
                ${printFilterValue(field,filterValue)}<#if filterValue?hasNext>,</#if>
            </#list>
        ));
        <#elseIf FilterOperator.BETWEEN.getValue() == whereItem.filterOperator
        || FilterOperator.IS_NOW.getValue() == whereItem.filterOperator
        || FilterOperator.BEFORE_TIME.getValue() == whereItem.filterOperator
        || FilterOperator.AFTER_TIME.getValue() == whereItem.filterOperator>
        qo.setFixedParam${itemId?counter}Start(${printFilterValue(field,whereItem.filterValue[0])});
        qo.setFixedParam${itemId?counter}End(${printFilterValue(field,whereItem.filterValue[1])});
        <#else>
        qo.setFixedParam${itemId?counter}(${printFilterValue(field,whereItem.filterValue[0])});
        </#if>
    </#if>
</#list>
    }

}

</#assign>
<#--开始渲染代码-->
package ${servicePackageName};

<@call this.printImport()/>

${code}
