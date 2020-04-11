<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
import com.cbb.common.pojo.qo.PageQO;
<@call this.addImport("io.swagger.annotations.ApiParam")/>
<#if this.pageSign>
    <@call this.addImport("${this.commonPackage}.pojo.qo.PageQO")/>
<#else>
    <@call this.addImport("${this.commonPackage}.pojo.qo.AbstractQO")/>
</#if>
<@call this.printClassCom("查询【${this.title}】的参数")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
public class ${this.chartName}QO extends <#if this.pageSign>PageQO<#else>AbstractQO</#if> {

    <#-- TODO -->
}
</#assign>
<#--开始渲染代码-->
package ${qoPackageName};

<@call this.printImport()/>

${code}
