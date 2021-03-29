<#-- 功能简介：根据java字段类型，猜测默认值 -->
<#include "/abstracted/common.ftl">
<#function  guessDefaultJfieldValue jfieldType defaultValue>
    <#if jfieldType == JFieldType.INTEGER.getJavaType()
        || jfieldType == JFieldType.SHORT.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <#return defaultValue?trim >
        <#else>
            <#return "0" >
        </#if>
    <#elseIf jfieldType == JFieldType.BOOLEAN.getJavaType()>
        <#if defaultValue?hasContent && defaultValue == "1">
            <#return "true" >
        <#else>
            <#return "false" >
        </#if>
    <#elseIf jfieldType == JFieldType.LONG.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <#return "${defaultValue?trim}L" >
        <#else>
            <#return "0L" >
        </#if>
    <#elseIf jfieldType == JFieldType.STRING.getJavaType()>
        <#if defaultValue?? && defaultValue != "NULL">
            <#return "\"${defaultValue}\"">
        <#else>
            <#return "\"\"" >
        </#if>
    <#elseIf jfieldType == JFieldType.DATE.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
            <#return "DateUtil.parseDate(\"${defaultValue}\")" >
        <#else>
            <@call this.addImport("java.util.Date")/>
            <#return "new Date()" >
        </#if>
    <#elseIf jfieldType == JFieldType.LOCALDATE.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
            <#return "DateUtil.parseLocalDate(\"${defaultValue}\")" >
        <#else>
            <@call this.addImport("java.time.LocalDate")/>
            <#return "LocalDate.now()" >
        </#if>
    <#elseIf jfieldType == JFieldType.LOCALDATETIME.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
            <#return "DateUtil.parseLocalDateTime(\"${defaultValue}\")" >
        <#else>
            <@call this.addImport("java.time.LocalDateTime")/>
            <#return "LocalDateTime.now()" >
        </#if>
    <#elseIf jfieldType == JFieldType.DOUBLE.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <#return "${defaultValue?trim}d" >
        <#else>
            <#return "0.0d" >
        </#if>
    <#elseIf jfieldType == JFieldType.FLOAT.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <#return "${defaultValue?trim}f" >
        <#else>
            <#return "0.0f" >
        </#if>
    <#elseIf jfieldType == JFieldType.BIGDECIMAL.getJavaType()>
        <#if defaultValue?hasContent && defaultValue != "NULL">
            <@call this.addImport("java.math.BigDecimal")/>
            <#return "new BigDecimal(\"${defaultValue?trim}\")" >
        <#else>
            <@call this.addImport("java.math.BigDecimal")/>
            <#return "BigDecimal.ZERO" >
        </#if>
    </#if>
</#function>
