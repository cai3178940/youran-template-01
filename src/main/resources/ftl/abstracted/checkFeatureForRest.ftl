<#-- 功能简介：校验是否需要生成rest服务类 -->
<#include "/abstracted/common.ftl">
<#function getGenRest entity>
    <#local genRest = entity.entityFeature.save
                        ||  entity.entityFeature.update
                        ||  entity.entityFeature.delete
                        ||  entity.entityFeature.deleteBatch
                        ||  entity.entityFeature.list
                        ||  entity.entityFeature.show
                        ||  entity.entityFeature.excelExport
                        ||  entity.entityFeature.excelImport >
    <#if !genRest>
        <#list entity.holds! as otherEntity,mtm>
            <#assign entityFeature=mtm.getEntityFeature(entity.entityId)>
            <#if entityFeature.addRemove
                || entityFeature.set
                || entityFeature.withinEntity >
                <#local genRest = true >
            </#if>
        </#list>
    </#if>
    <#return genRest>
</#function>
<#-- 提供rest服务的模块 -->
<#assign modulesForRest = CommonTemplateFunction.createHashSet()>
<#list this.metaEntities as metaEntity>
    <#if getGenRest(metaEntity)>
        <#if metaEntity.module?hasContent>
            <@justCall modulesForRest.add(metaEntity.module)/>
        </#if>
    </#if>
</#list>
<#list this.charts as chart>
    <#if chart.module?hasContent>
        <@justCall modulesForRest.add(chart.module)/>
    </#if>
</#list>
