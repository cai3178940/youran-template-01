<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/mtmCascadeExtsForList.ftl">
<#include "/abstracted/mtmCascadeExtsForOppList.ftl">
<#include "/abstracted/mtmCascadeExtsForOppShow.ftl">
<#include "/abstracted/mtmForOpp.ftl">
<#-- 包裹Mapping注解 -->
<#macro wrapMappings>
    <#local content><#nested></#local>
    <#if content?hasContent>
        <@call this.addImport("org.mapstruct.Mappings")/>
        <@call this.addImport("org.mapstruct.Mapping")/>
    @Mappings({
${content}<#rt>
    })
    </#if>
</#macro>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${dtoPackageName}.${this.className}AddDTO")/>
<@call this.addImport("${dtoPackageName}.${this.className}UpdateDTO")/>
<@call this.addImport("${poPackageName}.${this.className}PO")/>
<@call this.addImport("${voPackageName}.${this.className}ShowVO")/>
<@call this.addImport("org.mapstruct.Mapper")/>
<@call this.addImport("org.mapstruct.MappingTarget")/>
<@call this.addImport("org.mapstruct.factory.Mappers")/>
<@call this.printClassCom("【${this.title}】映射")/>
@Mapper
public interface ${this.className}Mapper {

    ${this.className}Mapper INSTANCE = Mappers.getMapper( ${this.className}Mapper.class );

    /**
     * addDTO映射po
     *
     * @param ${this.classNameLower}AddDTO
     * @return
     */
    ${this.className}PO fromAddDTO(${this.className}AddDTO ${this.classNameLower}AddDTO);

    /**
     * 将updateDTO中的值设置到po
     *
     * @param ${this.classNameLower}PO
     * @param ${this.classNameLower}UpdateDTO
     */
    void setUpdateDTO(@MappingTarget ${this.className}PO ${this.classNameLower}PO, ${this.className}UpdateDTO ${this.classNameLower}UpdateDTO);

    /**
     * po映射showVO
     *
     * @param ${this.classNameLower}PO
     * @return
     */
    ${this.className}ShowVO toShowVO(${this.className}PO ${this.classNameLower}PO);


<#--为被持有的实体提供级联【列表】查询方法-->
<#list mtmCascadeEntitiesForOppList as otherEntity>
    <#assign otherCName=otherEntity.className>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${voPackageName}.${otherCName}ListVO")/>
    List<${otherCName}ListVO.${this.className}VO> to${this.className}VOFor${otherCName}List(List<${this.className}PO> list);

</#list>
<#--为被持有的实体提供级联【详情】查询方法-->
<#list mtmCascadeEntitiesForOppShow as otherEntity>
    <#assign otherCName=otherEntity.className>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${voPackageName}.${otherCName}ShowVO")/>
    List<${otherCName}ShowVO.${this.className}VO> to${this.className}VOFor${otherCName}Show(List<${this.className}PO> list);

</#list>
<#--多对多被对方持有，提供PO列表转ListVO列表 -->
<#list mtmEntitiesForOpp as otherEntity>
    <#assign mtm=mtmsForOpp[otherEntity?index]/>
    <#assign otherEntityFeature=mtm.getEntityFeature(otherEntity.entityId)>
    <#--对方支持添加删除的情况才需要该服务 -->
    <#if otherEntityFeature.addRemove>
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${voPackageName}.${this.className}ListVO")/>
    List<${this.className}ListVO> toListVOList(List<${this.className}PO> list);

    </#if>
</#list>
<#if this.entityFeature.excelImport>
    <@call this.addImport("${dtoPackageName}.${this.className}ExcelDTO")/>
    /**
     * excelDTO映射addDTO
     *
     * @param dto
     * @return
     */
    <@wrapMappings>
        <#list this.insertFields as id,field>
            <#if field.dicType??>
            @Mapping(target = "${field.jfieldName}", expression = "java(${this.getConstFullClassPath(field.dicType)}.descToValue(dto.get${field.jfieldName?capFirst}()))"),
            </#if>
        </#list>
        <#list this.holds! as otherEntity,mtm>
            <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
            <#assign pkFieldType=otherEntity.pkField.jfieldType>
            <#if entityFeature.withinEntity>
                <#assign othercName=lowerFirstWord(otherEntity.className)>
                <#assign otherCName=otherEntity.className>
            @Mapping(target = "${othercName}List", expression = "java(${this.commonPackage}.util.ConvertUtil.convert${pkFieldType}List(dto.get${otherCName}List()))"),
            </#if>
        </#list>
    </@wrapMappings>
    ${this.className}AddDTO fromExcelDTO(${this.className}ExcelDTO dto);

</#if>
<#if this.entityFeature.excelExport>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${voPackageName}.${this.className}ExcelVO")/>
    <@call this.addImport("${voPackageName}.${this.className}ListVO")/>
    /**
     * listVO列表转excelVO列表
     *
     * @param list
     * @return
     */
    List<${this.className}ExcelVO> toExcelVOList(List<${this.className}ListVO> list);

    /**
     * listVO转excelVO
     *
     * @param vo
     * @return
     */
    <@wrapMappings>
        <#list this.insertFields as id,field>
            <#if field.dicType??>
            @Mapping(target = "${field.jfieldName}", expression = "java(${this.getConstFullClassPath(field.dicType)}.valueToDesc(vo.get${field.jfieldName?capFirst}()))"),
            </#if>
        </#list>
        <#list this.fkFields as id,field>
            <#list field.cascadeListExts! as cascadeExt>
                <#assign cascadeField=cascadeExt.cascadeField>
                <#if cascadeField.dicType??>
            @Mapping(target = "${cascadeField.jfieldName}", expression = "java(${this.getConstFullClassPath(cascadeField.dicType)}.valueToDesc(vo.get${cascadeField.jfieldName?capFirst}()))"),
                </#if>
            </#list>
        </#list>
    </@wrapMappings>
    ${this.className}ExcelVO toExcelVO(${this.className}ListVO vo);

    <#list mtmCascadeEntitiesForList as otherEntity>
        <#assign mtmCascadeExts = groupMtmCascadeExtsForList[otherEntity?index]>
        <#assign otherCName=otherEntity.className>
        <#--级联扩展列表字段中，如果有标题字段，则使用标题字段展示，否则直接展示主键字段-->
        <#if hasTitleField(otherEntity,mtmCascadeExts)>
            <#assign displayField = otherEntity.titleField>
        <#else>
            <#assign displayField = otherEntity.pkField>
        </#if>
    /**
     * ${otherEntity.title}列表转字符串逗号分隔
     *
     * @param list
     * @return
     */
    default String convert${otherCName}List(List<${this.className}ListVO.${otherCName}VO> list) {
        String result = "";
        <@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
        if (CollectionUtils.isNotEmpty(list)) {
            result = list.stream()
                    .map(${this.className}ListVO.${otherCName}VO::get${displayField.jfieldName?capFirst})
                    <@call this.addImport("java.util.stream.Collectors")/>
                    .collect(Collectors.joining(","));
        }
        return result;
    }
    </#list>

</#if>
}
</#assign>
<#--开始渲染代码-->
package ${mapperPackageName};

<@call this.printImport()/>

${code}
