<#-- 功能简介：推断日期格式 -->
<#include "/abstracted/common.ftl">
<#-- 推断常规字段的日期格式 -->
<#function  guessDateFormat field>
    <#if field.editType == EditType.DATE.getValue()>
        <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
        <#return "JsonFieldConst.DEFAULT_DATE_FORMAT">
    <#elseIf field.editType == EditType.DATETIME.getValue()>
        <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
        <#return "JsonFieldConst.DEFAULT_DATETIME_FORMAT">
    <#elseIf field.fieldType==JFieldType.DATE.getJavaType()
    || field.fieldType==JFieldType.LOCALDATE.getJavaType()>
        <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
        <#return "JsonFieldConst.DEFAULT_DATE_FORMAT">
    <#elseIf field.fieldType==JFieldType.LOCALDATETIME.getJavaType()>
        <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
        <#return "JsonFieldConst.DEFAULT_DATETIME_FORMAT">
    <#else>
        <#return "">
    </#if>
</#function>
<#-- 推断自定义字段类型的日期格式（图表专用） -->
<#function  guessDateFormatForCustom customFieldType>
    <#if customFieldType==CustomFieldType.DATE.getValue()>
        <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
        <#return "JsonFieldConst.DEFAULT_DATE_FORMAT">
    <#elseIf customFieldType==CustomFieldType.DATE_TIME.getValue()>
        <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
        <#return "JsonFieldConst.DEFAULT_DATETIME_FORMAT">
    <#else>
        <#return "">
    </#if>
</#function>
