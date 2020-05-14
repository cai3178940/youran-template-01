<#-- 功能简介：实体添加专用 -->
<#include "/abstracted/common.ftl">
<#assign fkFieldsForInsert = []>
<#list this.insertFields as id,field>
    <#if field.foreignKey>
        <#assign fkFieldsForInsert += [field]>
    </#if>
</#list>
<#assign withinEntityList = []>
<#list this.holds! as otherEntity,mtm>
    <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.withinEntity>
        <#assign withinEntityList += [otherEntity]>
    </#if>
</#list>
