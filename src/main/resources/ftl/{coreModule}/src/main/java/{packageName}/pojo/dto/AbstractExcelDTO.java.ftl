<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.jd.y.ss.price.common.pojo.dto.AbstractDTO")/>
<@call this.printClassCom("抽象excel数据传输对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
@Data
</#if>
public abstract class AbstractExcelDTO extends AbstractDTO {

    /**
     * 行号
     */
    private Integer rowIndex;

<#if !this.projectFeature.lombokEnabled>
    public Integer getRowIndex() {
        return rowIndex;
    }

    public void setRowIndex(Integer rowIndex) {
        this.rowIndex = rowIndex;
    }
</#if>

}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.pojo.dto;

<@call this.printImport()/>

${code}
