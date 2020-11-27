<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/forEntityInsert.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.dto.AbstractDTO")/>
<@call this.addImport("io.swagger.annotations.ApiModel")/>
<@call this.addStaticImport("${examplePackageName}.${this.className}Example.*")/>
<@call this.printClassCom("新增【${this.title}】的参数")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
@ApiModel(description = "新增【${this.title}】的参数")
public class ${this.className}AddDTO extends AbstractDTO {

<#list this.insertFields as id,field>
    <#--import字段类型-->
    <@call this.addFieldTypeImport(field)/>
    <@call this.addImport("io.swagger.annotations.ApiModelProperty")/>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
    @ApiModelProperty(notes = N_${jfieldNameSnakeCase}, example = E_${jfieldNameSnakeCase}<#if field.notNull>, required = true</#if><#if field.dicType??>, allowableValues = ${field.dicType}.VALUES_STR</#if>)
    <#if field.notNull>
        <@call this.addImport("javax.validation.constraints.NotNull")/>
    @NotNull
    </#if>
    <#if field.dicType??>
        <@call this.addImport("${this.commonPackage}.validator.Const")/>
        <@call this.addConstImport(field.dicType)/>
    @Const(constClass = ${field.dicType}.class)
    <#elseIf field.jfieldType == JFieldType.STRING.getJavaType()>
        <#if field.fieldLength gt 0 >
            <@call this.addImport("org.hibernate.validator.constraints.Length")/>
    @Length(max = ${field.fieldLength})
        </#if>
    <#elseIf field.jfieldType == JFieldType.DATE.getJavaType()
            || field.jfieldType == JFieldType.LOCALDATE.getJavaType()
            || field.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern=${guessDateFormat(field)},timezone="GMT+8")
    </#if>
    private ${field.jfieldType} ${field.jfieldName};

</#list>
<#list withinEntityList as otherEntity>
    <#assign otherPk=otherEntity.pkField>
    <#assign othercName=lowerFirstWord(otherEntity.className)>
    <@call this.addImport("java.util.List")/>
    private List<${otherPk.jfieldType}> ${othercName}List;

</#list>

<#if !this.projectFeature.lombokEnabled>
    <#list this.insertFields as id,field>
        <@call JavaTemplateFunction.printGetterSetter(field)/>
    </#list>
    <#list withinEntityList as otherEntity>
        <#assign otherPk=otherEntity.pkField>
        <#assign othercName=lowerFirstWord(otherEntity.className)>
        <@call JavaTemplateFunction.printGetterSetterList(othercName,otherPk.jfieldType)/>
    </#list>
</#if>
}
</#assign>
<#--开始渲染代码-->
package ${dtoPackageName};

<@call this.printImport()/>

${code}

