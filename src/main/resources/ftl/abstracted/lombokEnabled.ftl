<#-- 功能简介：用于兼容老版本的lombok配置 -->
<#include "/abstracted/common.ftl">
<#assign lombokEnabled = false>
<#if this.hasLabel("lombok")>
    <#if this.getLabelValue("lombok") == "true">
        <#assign lombokEnabled = true>
    </#if>
<#elseIf this.projectFeature.lombokEnabled>
    <#assign lombokEnabled = true>
</#if>
