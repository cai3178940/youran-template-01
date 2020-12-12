<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.dto.AbstractDTO")/>
<@call this.printClassCom("抽象excel数据传输对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
@Data
</#if>
public abstract class AbstractExcelDTO extends AbstractDTO {

    /**
     * 行号
     */
    <@call this.addImport("com.alibaba.excel.annotation.ExcelIgnore")/>
    @ExcelIgnore
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
<@call this.printPackageAndImport(this.packageName + ".pojo.dto")/>

${code}
