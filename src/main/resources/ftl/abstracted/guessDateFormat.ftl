<#-- 功能简介：推断日期格式 -->
<#include "/abstracted/common.ftl">
<#function  guessDateFormat field>
    <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
    <#if field.editType == EditType.DATE.getValue()>
        <#return "JsonFieldConst.DEFAULT_DATE_FORMAT" >
    <#elseif field.editType == EditType.DATETIME.getValue()>
        <#return "JsonFieldConst.DEFAULT_DATETIME_FORMAT" >
    <#elseif field.fieldType=="date">
        <#return "JsonFieldConst.DEFAULT_DATE_FORMAT" >
    <#else>
        <#return "JsonFieldConst.DEFAULT_DATETIME_FORMAT" >
    </#if>
</#function>
<#function  guessDateFormatForCustom customFieldType>
    <@call this.addImport("${this.commonPackage}.constant.JsonFieldConst")/>
    <#if customFieldType==CustomFieldType.DATE.getValue()>
        <#return "JsonFieldConst.DEFAULT_DATE_FORMAT" >
    <#else>
        <#return "JsonFieldConst.DEFAULT_DATETIME_FORMAT" >
    </#if>
</#function>
