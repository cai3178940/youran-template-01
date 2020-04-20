<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("org.apache.ibatis.annotations.Mapper")/>
<@call this.addImport("org.springframework.stereotype.Repository")/>
<@call this.addImport("${qoPackageName}.${this.chartName}QO")/>
<@call this.addImport("${voPackageName}.${this.chartName}VO")/>
<@call this.addImport("java.util.List")/>
<@call this.printClassCom("【${this.title}】数据库操作")/>
@Repository
@Mapper
public interface ${this.chartName}DAO {

<#if isChartType(ChartType.DETAIL_LIST)>
    /**
     * 根据条件查询【${this.title}】明细条数
     *
     * @param qo
     * @return
     */
    int selectCount(${this.chartName}QO qo);

    /**
     * 根据条件查询【${this.title}】明细列表
     *
     * @param qo
     * @return
     */
    List<${this.chartName}VO> selectList(${this.chartName}QO qo);
<#else>
    /**
     * 根据条件查询【${this.title}】图表数据
     *
     * @param qo
     * @return
     */
    List<${this.chartName}VO> findChartData(${this.chartName}QO qo);
</#if>

}
</#assign>
<#--开始渲染代码-->
package ${daoPackageName};

<@call this.printImport()/>

${code}


