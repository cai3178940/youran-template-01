<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.alibaba.excel.converters.Converter")/>
<@call this.addImport("com.alibaba.excel.enums.CellDataTypeEnum")/>
<@call this.addImport("com.alibaba.excel.metadata.CellData")/>
<@call this.addImport("com.alibaba.excel.metadata.GlobalConfiguration")/>
<@call this.addImport("com.alibaba.excel.metadata.property.ExcelContentProperty")/>
<@call this.addImport("${this.commonPackage}.util.DateUtil")/>
<@call this.addImport("java.time.LocalDate")/>
<@call this.printClassCom("LocalDate格式的日期转换器")/>
public class LocalDateConverter implements Converter<LocalDate> {

    @Override
    public Class supportJavaTypeKey() {
        return LocalDate.class;
    }

    @Override
    public CellDataTypeEnum supportExcelTypeKey() {
        return CellDataTypeEnum.STRING;
    }

    @Override
    public LocalDate convertToJavaData(CellData cellData, ExcelContentProperty contentProperty, GlobalConfiguration globalConfiguration) throws Exception {
        return DateUtil.parseLocalDate(cellData.getStringValue());
    }

    @Override
    public CellData convertToExcelData(LocalDate value, ExcelContentProperty contentProperty, GlobalConfiguration globalConfiguration) throws Exception {
        return new CellData(DateUtil.getLocalDateStr(value));
    }

}

</#assign>
<#--开始渲染代码-->
package ${this.packageName}.excel.converter;

<@call this.printImport()/>

${code}
