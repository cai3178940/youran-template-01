<#include "/abstracted/common.ftl">
<#if !hasChart>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("有两个维度的图表数据")/>
public interface Chart2DimensionVO {

    /**
     * 获取第一维度值
     *
     * @return
     */
    Object fetchDimension1();

    /**
     * 获取第二维度值
     *
     * @return
     */
    Object fetchDimension2();

    /**
     * 获取指标值
     *
     * @return
     */
    Object fetchMetrics();

}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.pojo.vo;

${code}
