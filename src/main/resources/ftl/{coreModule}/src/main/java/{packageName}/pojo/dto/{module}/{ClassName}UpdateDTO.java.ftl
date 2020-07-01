<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.dto.AbstractDTO")/>
<@call this.addImport("io.swagger.annotations.ApiModel")/>
<@call this.addImport("javax.validation.constraints.NotNull")/>
<@call this.addStaticImport("${examplePackageName}.${this.className}Example.*")/>
<@call this.printClassCom("修改【${this.title}】的参数")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
@ApiModel(description = "修改【${this.title}】的参数")
public class ${this.className}UpdateDTO extends AbstractDTO {

    <@call this.addImport("io.swagger.annotations.ApiModelProperty")/>
    <#--字段名转下划线大写-->
    <#assign pkNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(this.pk.jfieldName,true)>
    @ApiModelProperty(notes = N_${pkNameSnakeCase},example = E_${pkNameSnakeCase},required = true)
    @NotNull
    <#if this.pk.jfieldType==JFieldType.STRING.getJavaType()>
        <#if this.pk.fieldLength gt 0 >
            <@call this.addImport("org.hibernate.validator.constraints.Length")/>
    @Length(max = ${this.pk.fieldLength})
        </#if>
    </#if>
    private ${this.pk.jfieldType} ${this.pk.jfieldName};

<#list this.updateFields as id,field>
    <#--import字段类型-->
    <@call this.addFieldTypeImport(field)/>
    <@call this.addImport("io.swagger.annotations.ApiModelProperty")/>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
    @ApiModelProperty(notes = N_${jfieldNameSnakeCase},example = E_${jfieldNameSnakeCase}<#if field.notNull>,required = true</#if><#if field.dicType??>, allowableValues = ${field.dicType}.VALUES_STR</#if>)
    <#if field.notNull>
    @NotNull
    </#if>
    <#if field.dicType??>
        <@call this.addImport("${this.commonPackage}.validator.Const")/>
        <@call this.addConstImport(field.dicType)/>
    @Const(constClass = ${field.dicType}.class)
    <#elseIf field.jfieldType==JFieldType.STRING.getJavaType()>
        <#if field.fieldLength gt 0 >
            <@call this.addImport("org.hibernate.validator.constraints.Length")/>
    @Length(max = ${field.fieldLength})
        </#if>
    <#elseIf field.jfieldType==JFieldType.DATE.getJavaType()
            || field.jfieldType==JFieldType.LOCALDATE.getJavaType()
            || field.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern=${guessDateFormat(field)},timezone="GMT+8")
    </#if>
    private ${field.jfieldType} ${field.jfieldName};

</#list>
<#list this.holds! as otherEntity,mtm>
    <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.withinEntity>
        <#assign otherPk=otherEntity.pkField>
        <#assign othercName=lowerFirstWord(otherEntity.className)>
        <@call this.addImport("java.util.List")/>
    private List<${otherPk.jfieldType}> ${othercName}List;

    </#if>
</#list>

<#if !this.projectFeature.lombokEnabled>
    <@call JavaTemplateFunction.printGetterSetter(this.pk)/>
    <#list this.updateFields as id,field>
        <@call JavaTemplateFunction.printGetterSetter(field)/>
    </#list>
    <#list this.holds! as otherEntity,mtm>
        <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
        <#if entityFeature.withinEntity>
            <#assign otherPk=otherEntity.pkField>
            <#assign othercName=lowerFirstWord(otherEntity.className)>
            <@call JavaTemplateFunction.printGetterSetterList(othercName,otherPk.jfieldType)/>
        </#if>
    </#list>
</#if>

}
</#assign>
<#--开始渲染代码-->
package ${dtoPackageName};

<@call this.printImport()/>

${code}
