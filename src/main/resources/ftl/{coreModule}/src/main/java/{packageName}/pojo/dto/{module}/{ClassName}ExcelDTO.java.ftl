<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/forEntityInsert.ftl">
<#if !this.entityFeature.excelImport>
    <@call this.skipCurrent()/>
</#if>
<#--解析字段类型-->
<#function parseJfieldType field>
<#--枚举字段使用String类型-->
    <#if field.dicType??>
        <#local jfieldType = "String">
    <#else>
    <#--import字段类型-->
        <@call this.addFieldTypeImport(field)/>
        <#local jfieldType = field.jfieldType>
    </#if>
    <#return jfieldType>
</#function>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.pojo.dto.AbstractExcelDTO")/>
<@call this.addImport("com.alibaba.excel.annotation.ExcelProperty")/>
<@call this.addImport("com.alibaba.excel.annotation.write.style.ColumnWidth")/>
<@call this.addStaticImport("${examplePackageName}.${this.className}Example.*")/>
<@call this.printClassCom("excel导入【${this.title}】的数据传输对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper = true)
</#if>
public class ${this.className}ExcelDTO extends AbstractExcelDTO {

<#list this.insertFields as id, field>
    <#if field.jfieldType == JFieldType.LOCALDATE.getJavaType()>
        <@call this.addImport("${this.packageName}.excel.converter.LocalDateConverter")/>
    @ExcelProperty(value = "${field.fieldDesc}<#if field.notNull>*</#if>", converter = LocalDateConverter.class)
    <#elseIf field.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("${this.packageName}.excel.converter.LocalDateTimeConverter")/>
    @ExcelProperty(value = "${field.fieldDesc}<#if field.notNull>*</#if>", converter = LocalDateTimeConverter.class)
    <#else>
    @ExcelProperty("${field.fieldDesc}<#if field.notNull>*</#if>")
    </#if>
    <#if field.jfieldType == JFieldType.DATE.getJavaType()>
        <@call this.addImport("com.alibaba.excel.annotation.format.DateTimeFormat")/>
    @DateTimeFormat(${guessDateFormat(field)})
    </#if>
    <#if field.columnWidth?? && field.columnWidth &gt; 0>
    @ColumnWidth(${field.columnWidth/8})
    <#else>
    @ColumnWidth(15)
    </#if>
    private ${parseJfieldType(field)} ${field.jfieldName};

</#list>
<#list withinEntityList as otherEntity>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    @ExcelProperty("${otherEntity.title}")
    @ColumnWidth(15)
    private String ${othercName}List;

</#list>

    /**
     * 创建模板示例
     *
     * @return
     */
    public static ${this.className}ExcelDTO example() {
        ${this.className}ExcelDTO example = new ${this.className}ExcelDTO();
<#list this.insertFields as id, field>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName, true)>
    <#assign arg = "">
    <#if field.dicType??>
        <@call this.addConstImport(field.dicType)/>
        <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
        <#assign arg = "${field.dicType}.valueToDesc(SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase}))">
    <#elseIf field.jfieldType == JFieldType.STRING.getJavaType()>
        <#assign arg = "E_${jfieldNameSnakeCase}">
    <#elseIf field.jfieldType == JFieldType.DATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#assign arg = "DateUtil.parseDate(E_${jfieldNameSnakeCase})">
    <#elseIf field.jfieldType == JFieldType.LOCALDATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#assign arg = "DateUtil.parseLocalDate(E_${jfieldNameSnakeCase})">
    <#elseIf field.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#assign arg = "DateUtil.parseLocalDateTime(E_${jfieldNameSnakeCase})">
    <#elseIf field.jfieldType == JFieldType.BIGDECIMAL.getJavaType()>
        <@call this.addImport("java.math.BigDecimal")/>
        <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
        <#assign arg = "SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase})">
    <#else>
        <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
        <#assign arg = "SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase})">
    </#if>
        example.set${field.jfieldName?capFirst}(${arg});
</#list>
        return example;
    }

<#if !this.projectFeature.lombokEnabled>
    <#list this.insertFields as id, field>
        <@call JavaTemplateFunction.printGetterSetter(field.jfieldName, parseJfieldType(field))/>
    </#list>
    <#list withinEntityList as otherEntity>
        <#assign othercName = lowerFirstWord(otherEntity.className)>
        <@call JavaTemplateFunction.printGetterSetter(othercName + "List", "String")/>
    </#list>
</#if>
}
</#assign>
<#--开始渲染代码-->
package ${dtoPackageName};

<@call this.printImport()/>

${code}

