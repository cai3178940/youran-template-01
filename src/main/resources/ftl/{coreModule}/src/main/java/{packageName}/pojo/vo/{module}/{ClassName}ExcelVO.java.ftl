<#include "/abstracted/common.ftl">
<#include "/abstracted/lombokEnabled.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/mtmCascadeExtsForList.ftl">
<#if !this.entityFeature.excelExport>
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
<@call this.addImport("${this.commonPackage}.pojo.vo.AbstractVO")/>
<@call this.addImport("com.alibaba.excel.annotation.ExcelProperty")/>
<@call this.addImport("com.alibaba.excel.annotation.write.style.ColumnWidth")/>
<@call this.printClassCom("【${this.title}】excel导出对象")/>
<#if lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper = true)
</#if>
public class ${this.className}ExcelVO extends AbstractVO {

<#--当前实体列表展示字段-->
<#list this.listFields as id, field>
    <#if field.jfieldType == JFieldType.LOCALDATE.getJavaType()>
        <@call this.addImport("${this.packageName}.excel.converter.LocalDateConverter")/>
    @ExcelProperty(value = "${field.fieldDesc}", converter = LocalDateConverter.class)
    <#elseIf field.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("${this.packageName}.excel.converter.LocalDateTimeConverter")/>
    @ExcelProperty(value = "${field.fieldDesc}", converter = LocalDateTimeConverter.class)
    <#else>
    @ExcelProperty("${field.fieldDesc}")
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
<#--外键级联扩展，列表展示字段-->
<#list this.fkFields as id, field>
    <#list field.cascadeListExts! as cascadeExt>
        <#assign cascadeField = cascadeExt.cascadeField>
        <#if cascadeField.jfieldType == JFieldType.LOCALDATE.getJavaType()>
            <@call this.addImport("${this.packageName}.excel.converter.LocalDateConverter")/>
    @ExcelProperty(value = "${cascadeField.fieldDesc}", converter = LocalDateConverter.class)
        <#elseIf cascadeField.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("${this.packageName}.excel.converter.LocalDateTimeConverter")/>
    @ExcelProperty(value = "${cascadeField.fieldDesc}", converter = LocalDateTimeConverter.class)
        <#else>
    @ExcelProperty("${cascadeField.fieldDesc}")
        </#if>
        <#if cascadeField.jfieldType == JFieldType.DATE.getJavaType()>
            <@call this.addImport("com.alibaba.excel.annotation.format.DateTimeFormat")/>
    @DateTimeFormat(${guessDateFormat(cascadeField)})
        </#if>
        <#if cascadeField.columnWidth?? && cascadeField.columnWidth &gt; 0>
    @ColumnWidth(${cascadeField.columnWidth/8})
        <#else>
    @ColumnWidth(15)
        </#if>
    private ${parseJfieldType(cascadeField)} ${cascadeExt.alias};

    </#list>
</#list>
<#--多对多级联扩展列表展示-->
<#list mtmCascadeEntitiesForList as otherEntity>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    @ExcelProperty("${otherEntity.title}")
    @ColumnWidth(20)
    private String ${othercName}List;

</#list>

<#if !lombokEnabled>
    <#--当前实体列表展示字段：getter-setter方法-->
    <#list this.listFields as id, field>
        <@call JavaTemplateFunction.printGetterSetter(field.jfieldName, parseJfieldType(field))/>
    </#list>
    <#--外键级联扩展，列表展示字段：getter-setter方法-->
    <#list this.fkFields as id, field>
        <#list field.cascadeListExts! as cascadeExt>
            <@call JavaTemplateFunction.printGetterSetter(cascadeExt.alias, parseJfieldType(cascadeExt.cascadeField))/>
        </#list>
    </#list>
    <#--多对多列表展示：getter-setter方法-->
    <#list mtmCascadeEntitiesForList as otherEntity>
        <#assign othercName = lowerFirstWord(otherEntity.className)>
        <@call JavaTemplateFunction.printGetterSetter(othercName + "List", "String")/>
    </#list>
</#if>

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(voPackageName)/>

${code}
