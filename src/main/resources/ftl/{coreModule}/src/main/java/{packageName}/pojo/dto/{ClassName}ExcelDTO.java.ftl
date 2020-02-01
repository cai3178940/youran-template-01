<#include "/abstracted/common.ftl">
<#include "/abstracted/guessDateFormat.ftl">
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
<@call this.addImport("${this.commonPackage}.pojo.dto.AbstractDTO")/>
<@call this.addImport("com.alibaba.excel.annotation.ExcelProperty")/>
<@call this.addStaticImport("${this.packageName}.pojo.example.${this.classNameUpper}Example.*")/>
<@call this.printClassCom("excel导入【${this.title}】的数据传输对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
public class ${this.classNameUpper}ExcelDTO extends AbstractDTO {

<#list this.insertFields as id,field>
    @ExcelProperty("${field.fieldDesc}")
    <#if field.jfieldType==JFieldType.DATE.getJavaType()>
        <@call this.addImport("com.alibaba.excel.annotation.format.DateTimeFormat")/>
    @DateTimeFormat(${guessDateFormat(field)})
    </#if>
    private ${parseJfieldType(field)} ${field.jfieldName};

</#list>
<#list this.holds! as otherEntity,mtm>
    <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.withinEntity>
        <#assign othercName=otherEntity.className?uncapFirst>
    @ExcelProperty("${otherEntity.title}")
    private String ${othercName}List;

    </#if>
</#list>

    /**
     * 创建模板示例
     *
     * @return
     */
    public static ${this.classNameUpper}ExcelDTO example() {
        ${this.classNameUpper}ExcelDTO example = new ${this.classNameUpper}ExcelDTO();
<#list this.insertFields as id,field>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
    <#assign arg="">
    <#if field.dicType??>
        <@call this.addConstImport(field.dicType)/>
        <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
        <#assign arg="${field.dicType}.valueToDesc(SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase}))">
    <#elseIf field.jfieldType==JFieldType.STRING.getJavaType()>
        <#assign arg="E_${jfieldNameSnakeCase}">
    <#elseIf field.jfieldType==JFieldType.DATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        <#assign arg="DateUtil.parseDate(E_${jfieldNameSnakeCase})">
    <#elseIf field.jfieldType==JFieldType.BIGDECIMAL.getJavaType()>
        <@call this.addImport("java.math.BigDecimal")/>
        <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
        <#assign arg="SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase})">
    <#else>
        <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
        <#assign arg="SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase})">
    </#if>
        example.set${field.jfieldName?capFirst}(${arg});
</#list>
        return example;
    }

<#if !this.projectFeature.lombokEnabled>
    <#list this.insertFields as id,field>
        <@call JavaTemplateFunction.printGetterSetter(field.jfieldName,parseJfieldType(field))/>
    </#list>
    <#list this.holds! as otherEntity,mtm>
        <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
        <#if entityFeature.withinEntity>
            <#assign othercName=otherEntity.className?uncapFirst>
            <@call JavaTemplateFunction.printGetterSetter(othercName+"List","String")/>
        </#if>
    </#list>
</#if>
}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.pojo.dto;

<@call this.printImport()/>

${code}

