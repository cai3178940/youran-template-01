<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/mtmCascadeExtsForList.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("io.swagger.annotations.ApiModel")/>
<@call this.addImport("io.swagger.annotations.ApiModelProperty")/>
<@call this.addImport("${this.commonPackage}.pojo.vo.AbstractVO")/>
<@call this.addStaticImport("${examplePackageName}.${this.className}Example.*")/>
<@call this.printClassCom("【${this.title}】列表展示对象")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
@ApiModel(description = "【${this.title}】列表展示对象")
public class ${this.className}ListVO extends AbstractVO {

<#--当前实体列表展示字段-->
<#list this.listFields as id,field>
    <#--import字段类型-->
    <@call this.addFieldTypeImport(field)/>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
    <#if field.dicType??>
        <@call this.addConstImport(field.dicType)/>
    </#if>
    @ApiModelProperty(notes = N_${jfieldNameSnakeCase}, example = E_${jfieldNameSnakeCase}<#if field.dicType??>, allowableValues = ${JavaTemplateFunction.fetchClassName(field.dicType)}.VALUES_STR</#if>)
    <#if field.jfieldType==JFieldType.DATE.getJavaType()
            || field.jfieldType==JFieldType.LOCALDATE.getJavaType()
            || field.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${guessDateFormat(field)}, timezone = "GMT+8")
    </#if>
    private ${field.jfieldType} ${field.jfieldName};

</#list>
<#--外键级联扩展，列表展示字段-->
<#list this.fkFields as id,field>
    <#list field.cascadeListExts! as cascadeExt>
        <#assign cascadeField=cascadeExt.cascadeField>
        <#--import字段类型-->
        <@call this.addFieldTypeImport(cascadeField)/>
        <#assign exampleClass="">
        <#if cascadeField.dicType??>
            <@call this.addConstImport(cascadeField.dicType)/>
        </#if>
        <#if field.foreignEntity!=this.metaEntity>
            <@call this.addImport("${examplePackageName}.${field.foreignEntity.className}Example")/>
            <#assign exampleClass="${field.foreignEntity.className}Example.">
        </#if>
        <#--字段名转下划线大写-->
        <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(cascadeField.jfieldName,true)>
    @ApiModelProperty(notes = ${exampleClass}N_${jfieldNameSnakeCase}, example = ${exampleClass}E_${jfieldNameSnakeCase}<#if cascadeField.dicType??>, allowableValues = ${JavaTemplateFunction.fetchClassName(cascadeField.dicType)}.VALUES_STR</#if>)
        <#if cascadeField.jfieldType==JFieldType.DATE.getJavaType()
            || cascadeField.jfieldType==JFieldType.LOCALDATE.getJavaType()
            || cascadeField.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern = ${guessDateFormat(cascadeField)}, timezone = "GMT+8")
        </#if>
    private ${cascadeField.jfieldType} ${cascadeExt.alias};

    </#list>
</#list>
<#--多对多级联扩展列表展示-->
<#list mtmCascadeEntitiesForList as otherEntity>
    <@call this.addImport("java.util.List")/>
    <#assign otherCName=otherEntity.className/>
    <#assign othercName=lowerFirstWord(otherEntity.className)>
    @ApiModelProperty(notes = "【${otherEntity.title}】列表")
    private List<${otherCName}VO> ${othercName}List;

</#list>

<#if !this.projectFeature.lombokEnabled>
    <#--当前实体列表展示字段：getter-setter方法-->
    <#list this.listFields as id,field>
        <@call JavaTemplateFunction.printGetterSetter(field)/>
    </#list>
    <#--外键级联扩展，列表展示字段：getter-setter方法-->
    <#list this.fkFields as id,field>
        <#list field.cascadeListExts! as cascadeExt>
            <@call JavaTemplateFunction.printGetterSetter(cascadeExt.alias,cascadeExt.cascadeField.jfieldType)/>
        </#list>
    </#list>
    <#--多对多列表展示：getter-setter方法-->
    <#list mtmCascadeEntitiesForList as otherEntity>
        <#assign otherCName=otherEntity.className/>
        <#assign othercName=lowerFirstWord(otherEntity.className)>
        <@call JavaTemplateFunction.printGetterSetterList(othercName,"${otherCName}VO")/>
    </#list>
</#if>

<#--多对多列表展示【静态内部类】-->
<#list mtmCascadeEntitiesForList as otherEntity>
    <#assign mtmCascadeExts = groupMtmCascadeExtsForList[otherEntity?index]>
    <#assign otherCName=otherEntity.className>
    <#assign exampleClass="${otherEntity.className}Example">
    <@call this.addImport("${examplePackageName}.${exampleClass}")/>
    <#if this.projectFeature.lombokEnabled>
    @Data
    @EqualsAndHashCode(callSuper=true)
    </#if>
    public static class ${otherCName}VO extends AbstractVO {

    <#--主键字段-->
    <#assign otherPkField=otherEntity.pkField>
    <#--字段名转下划线大写-->
    <#assign pkFieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(otherPkField.jfieldName,true)>
        @ApiModelProperty(notes = ${exampleClass}.N_${pkFieldNameSnakeCase},example = ${exampleClass}.E_${pkFieldNameSnakeCase})
        private ${otherPkField.jfieldType} ${otherPkField.jfieldName};

    <#--多对多级联扩展，列表展示字段-->
    <#list mtmCascadeExts as mtmCascadeExt>
        <#assign field=mtmCascadeExt.cascadeField>
        <#--import字段类型-->
        <@call this.addFieldTypeImport(field)/>
        <#--字段名转下划线大写-->
        <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
        <#if field.dicType??>
            <@call this.addConstImport(field.dicType)/>
        </#if>
        @ApiModelProperty(notes = ${exampleClass}.N_${jfieldNameSnakeCase},example = ${exampleClass}.E_${jfieldNameSnakeCase}<#if field.dicType??>, allowableValues = ${JavaTemplateFunction.fetchClassName(field.dicType)}.VALUES_STR</#if>)
        <#if field.jfieldType==JFieldType.DATE.getJavaType()
            || field.jfieldType==JFieldType.LOCALDATE.getJavaType()
            || field.jfieldType==JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
        @JsonFormat(pattern = ${guessDateFormat(field)}, timezone = "GMT+8")
        </#if>
        private ${field.jfieldType} ${field.jfieldName};

    </#list>

    <#if !this.projectFeature.lombokEnabled>
        <#--主键字段：getter-setter方法-->
        <@call JavaTemplateFunction.printGetterSetter(otherPkField,2)/>
        <#--多对多级联扩展，列表展示字段：getter-setter方法-->
        <#list mtmCascadeExts as mtmCascadeExt>
            <#assign field=mtmCascadeExt.cascadeField>
            <@call JavaTemplateFunction.printGetterSetter(field,2)/>
        </#list>
    </#if>
    }
</#list>

}
</#assign>
<#--开始渲染代码-->
package ${voPackageName};

<@call this.printImport()/>

${code}
