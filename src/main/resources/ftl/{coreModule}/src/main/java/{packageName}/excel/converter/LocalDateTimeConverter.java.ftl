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
<@call this.addImport("java.time.LocalDateTime")/>
<@call this.printClassCom("LocalDateTime格式的日期转换器")/>
public class LocalDateTimeConverter implements Converter<LocalDateTime> {

    @Override
    public Class supportJavaTypeKey() {
        return LocalDateTime.class;
    }

    @Override
    public CellDataTypeEnum supportExcelTypeKey() {
        return CellDataTypeEnum.STRING;
    }

    @Override
    public LocalDateTime convertToJavaData(CellData cellData, ExcelContentProperty contentProperty, GlobalConfiguration globalConfiguration) throws Exception {
        return DateUtil.parseLocalDateTime(cellData.getStringValue());
    }

    @Override
    public CellData convertToExcelData(LocalDateTime value, ExcelContentProperty contentProperty, GlobalConfiguration globalConfiguration) throws Exception {
        return new CellData(DateUtil.getLocalDateTimeStr(value));
    }

}

</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.packageName + ".excel.converter")/>

${code}
