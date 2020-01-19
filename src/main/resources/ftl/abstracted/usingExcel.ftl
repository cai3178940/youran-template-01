<#-- 功能简介：判断是否需要引入excel功能 -->
<#include "/abstracted/common.ftl">
<#--是否引入excel-->
<#assign usingExcel = false>
<#list this.metaEntities as entity>
    <#if entity.entityFeature.excelExport || entity.entityFeature.excelImport>
        <#assign usingExcel = true>
        <#break>
    </#if>
</#list>
