<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/guessDateFormat.ftl">
<#include "/abstracted/mtmCascadeExtsForQuery.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("io.swagger.annotations.ApiParam")/>
<#if this.pageSign>
    <@call this.addImport("${this.commonPackage}.pojo.qo.PageQO")/>
<#else>
    <@call this.addImport("${this.commonPackage}.pojo.qo.AbstractQO")/>
</#if>
<@call this.addStaticImport("${examplePackageName}.${this.className}Example.*")/>
<@call this.printClassCom("查询【${this.title}】的参数")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
public class ${this.className}QO extends <#if this.pageSign>PageQO<#else>AbstractQO</#if> {

<#--定义宏-查询字段申明模块
    field-字段对象
    alias-字段别名
    exampleClass-示例类名
-->
<#macro queryField field alias="" exampleClass="">
    <#if alias?hasContent>
        <#assign jfieldName=alias>
    <#else>
        <#assign jfieldName=field.jfieldName>
    </#if>
    <#--import字段类型-->
    <@call this.addFieldTypeImport(field)/>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
    <#--查询方式：IN-->
    <#if QueryType.isIn(field.queryType)>
        <@call this.addImport("java.util.List")/>
    @ApiParam(value = ${exampleClass}N_${jfieldNameSnakeCase})
    private List<${field.jfieldType}> ${jfieldName};
    <#else>
    <#--其他查询方式-->
    @ApiParam(value = ${exampleClass}N_${jfieldNameSnakeCase},example = ${exampleClass}E_${jfieldNameSnakeCase})
        <#if field.jfieldType == JFieldType.STRING.getJavaType()>
            <@call this.addImport("org.hibernate.validator.constraints.Length")/>
    @Length(max = ${field.fieldLength},message = "${jfieldName}最大长度不能超过{max}")
        <#elseIf field.jfieldType == JFieldType.DATE.getJavaType()
            || field.jfieldType == JFieldType.LOCALDATE.getJavaType()
            || field.jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
            <@call this.addImport("java.util.Date")/>
            <@call this.addImport("com.fasterxml.jackson.annotation.JsonFormat")/>
    @JsonFormat(pattern=${guessDateFormat(field)},timezone="GMT+8")
        </#if>
    private ${field.jfieldType} ${jfieldName};
    </#if>

</#macro>
<#--开始渲染查询字段声明语句-->
<#list this.queryFields as id,field>
    <#if !QueryType.isBetween(field.queryType)>
        <@queryField field></@queryField>
    <#else>
        <@queryField field field.jfieldName+"Start"></@queryField>
        <@queryField field field.jfieldName+"End"></@queryField>
    </#if>
</#list>
<#--开始渲染【外键级联扩展】字段声明语句-->
<#list this.fkFields as id,field>
    <#if field.cascadeQueryExts?? && field.cascadeQueryExts?size &gt; 0>
        <#assign exampleClass="">
        <#if field.foreignEntity != this.metaEntity>
            <@call this.addImport("${examplePackageName}.${field.foreignEntity.className}Example")/>
            <#assign exampleClass="${field.foreignEntity.className}Example.">
        </#if>
        <#list field.cascadeQueryExts as cascadeExt>
            <#assign cascadeField=cascadeExt.cascadeField>
            <#if !QueryType.isBetween(cascadeField.queryType)>
                <@queryField cascadeField cascadeExt.alias exampleClass></@queryField>
            <#else>
                <@queryField cascadeField cascadeExt.alias+"Start" exampleClass></@queryField>
                <@queryField cascadeField cascadeExt.alias+"End" exampleClass></@queryField>
            </#if>
        </#list>
    </#if>
</#list>
<#--开始渲染【多对多级联扩展】字段声明语句-->
<#list mtmCascadeExtsForQuery as mtmCascadeExt>
    <#assign cascadeField=mtmCascadeExt.cascadeField>
    <#assign cascadeEntity=mtmCascadeExt.cascadeEntity>
    <@call this.addImport("${examplePackageName}.${cascadeEntity.className}Example")/>
    <#assign exampleClass="${cascadeEntity.className}Example.">
    <#if !QueryType.isBetween(cascadeField.queryType)>
        <@queryField cascadeField mtmCascadeExt.alias exampleClass></@queryField>
    <#else>
        <@queryField cascadeField mtmCascadeExt.alias+"Start" exampleClass></@queryField>
        <@queryField cascadeField mtmCascadeExt.alias+"End" exampleClass></@queryField>
    </#if>
</#list>
<#--开始渲染排序条件声明语句-->
<#list this.listSortFields as id,field>
    @ApiParam(value = "${field.fieldDesc}排序标识【1升序,-1降序,0不排序】",example = "1")
    private Integer ${field.jfieldName}SortSign;

</#list>

<#if !this.projectFeature.lombokEnabled>
    <#--定义宏-查询字段getter-setter模块
        field-字段对象
        alias-字段别名
    -->
    <#macro queryMethod field alias="">
        <#if alias?hasContent>
            <#assign jfieldName=alias>
        <#else>
            <#assign jfieldName=field.jfieldName>
        </#if>
        <#--查询方式：IN-->
        <#if QueryType.isIn(field.queryType)>
            <@call JavaTemplateFunction.printGetterSetterList("${jfieldName}","${field.jfieldType}",false)/>
        <#else>
        <#--其他查询方式-->
            <@call JavaTemplateFunction.printGetterSetter("${jfieldName}","${field.jfieldType}")/>
        </#if>
    </#macro>
    <#--开始渲染查询字段getter-setter方法-->
    <#list this.queryFields as id,field>
        <#if !QueryType.isBetween(field.queryType)>
            <@queryMethod field></@queryMethod>
        <#else>
            <@queryMethod field field.jfieldName+"Start"></@queryMethod>
            <@queryMethod field field.jfieldName+"End"></@queryMethod>
        </#if>
    </#list>
    <#--开始渲染【外键级联扩展】字段getter-setter方法-->
    <#list this.fkFields as id,field>
        <#list field.cascadeQueryExts! as cascadeExt>
            <#assign cascadeField=cascadeExt.cascadeField>
            <#if !QueryType.isBetween(cascadeField.queryType)>
                <@queryMethod cascadeField cascadeExt.alias></@queryMethod>
            <#else>
                <@queryMethod cascadeField cascadeExt.alias+"Start"></@queryMethod>
                <@queryMethod cascadeField cascadeExt.alias+"End"></@queryMethod>
            </#if>
        </#list>
    </#list>
    <#--开始渲染【多对多级联扩展】字段getter-setter方法-->
    <#list mtmCascadeExtsForQuery as mtmCascadeExt>
        <#assign cascadeField=mtmCascadeExt.cascadeField>
        <#if !QueryType.isBetween(cascadeField.queryType)>
            <@queryMethod cascadeField mtmCascadeExt.alias></@queryMethod>
        <#else>
            <@queryMethod cascadeField mtmCascadeExt.alias+"Start"></@queryMethod>
            <@queryMethod cascadeField mtmCascadeExt.alias+"End"></@queryMethod>
        </#if>
    </#list>
    <#--开始渲染排序字段getter-setter方法-->
    <#list this.listSortFields as id,field>
        <@call JavaTemplateFunction.printGetterSetter("${field.jfieldName}SortSign","Integer")/>
    </#list>
</#if>
}
</#assign>
<#--开始渲染代码-->
package ${qoPackageName};

<@call this.printImport()/>

${code}
