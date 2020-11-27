<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${dtoPackageName}.*")/>
<@call this.addImport("${poPackageName}.*")/>
<@call this.addImport("org.springframework.stereotype.Component")/>
<@call this.addStaticImport("${examplePackageName}.${this.className}Example.*")/>
@Component
public class ${this.className}Helper {

    <@call this.addAutowired("${servicePackageName}" "${this.className}Service")/>
    <@call this.printAutowired()/>

    <#--定义外键字段参数串-->
    <#assign foreignArg="">
    <#assign foreignArg2="">
    <#list this.insertFields as id,field>
        <#if field.foreignKey>
            <#assign foreignArg=foreignArg+"${field.jfieldType} ${field.jfieldName}, ">
            <#assign foreignArg2=foreignArg2+"${field.jfieldName}, ">
        </#if>
    </#list>
    <#if foreignArg?length gt 0>
        <#assign foreignArg=foreignArg?substring(0,foreignArg?length-2)>
        <#assign foreignArg2=foreignArg2?substring(0,foreignArg2?length-2)>
    </#if>
    /**
     * 生成add测试数据
     * @return
     */
    public ${this.className}AddDTO get${this.className}AddDTO(${foreignArg}) {
        ${this.className}AddDTO dto = new ${this.className}AddDTO();
    <#list this.insertFields as id,field>
        <#--字段名转下划线大写-->
        <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
        <#assign arg="">
        <#if field.foreignKey>
            <#assign arg="${field.jfieldName}">
        <#elseIf field.jfieldType == JFieldType.STRING.getJavaType()>
            <#assign arg="E_${jfieldNameSnakeCase}">
        <#elseIf field.jfieldType == JFieldType.DATE.getJavaType()>
            <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
            <#assign arg="DateUtil.parseDate(E_${jfieldNameSnakeCase})">
        <#elseIf field.jfieldType == JFieldType.LOCALDATE.getJavaType()>
            <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
            <#assign arg="DateUtil.parseLocalDate(E_${jfieldNameSnakeCase})">
        <#elseIf field.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
            <#assign arg="DateUtil.parseLocalDateTime(E_${jfieldNameSnakeCase})">
        <#elseIf field.jfieldType == JFieldType.BIGDECIMAL.getJavaType()>
            <@call this.addImport("java.math.BigDecimal")/>
            <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
            <#assign arg="SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase})">
        <#else>
            <@call this.addImport("${this.commonPackage}.util.SafeUtil")/>
            <#assign arg="SafeUtil.get${field.jfieldType}(E_${jfieldNameSnakeCase})">
        </#if>
        dto.set${field.jfieldName?capFirst}(${arg});
    </#list>
        return dto;
    }


    /**
     * 生成update测试数据
     * @return
     */
    public ${this.className}UpdateDTO get${this.className}UpdateDTO(${this.className}PO ${this.classNameLower}) {
        ${this.className}UpdateDTO dto = new ${this.className}UpdateDTO();
        dto.set${this.idUpper}(${this.classNameLower}.get${this.idUpper}());
        <#list this.updateFields as id,field>
        dto.set${field.jfieldName?capFirst}(${this.classNameLower}.get${field.jfieldName?capFirst}());
        </#list>
        return dto;
    }

    /**
     * 保存示例
     * @return
     */
    public ${this.className}PO save${this.className}Example(${foreignArg}) {
        ${this.className}AddDTO addDTO = this.get${this.className}AddDTO(${foreignArg2});
        return ${this.classNameLower}Service.save(addDTO);
    }



}
</#assign>
<#--开始渲染代码-->
package ${helpPackageName};

<@call this.printImport()/>

${code}
