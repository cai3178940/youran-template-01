<#include "/abstracted/common.ftl">
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
${content}
    })
    </#if>
</#macro>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}AddDTO")/>
<@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}UpdateDTO")/>
<@call this.addImport("${this.packageName}.pojo.po.${this.classNameUpper}PO")/>
<@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ShowVO")/>
<@call this.addImport("org.mapstruct.Mapper")/>
<@call this.addImport("org.mapstruct.MappingTarget")/>
<@call this.addImport("org.mapstruct.factory.Mappers")/>
<@call this.printClassCom("【${this.title}】映射")/>
@Mapper
public interface ${this.classNameUpper}Mapper {

    ${this.classNameUpper}Mapper INSTANCE = Mappers.getMapper( ${this.classNameUpper}Mapper.class );

    /**
     * addDTO映射po
     *
     * @param ${this.className}AddDTO
     * @return
     */
    ${this.classNameUpper}PO fromAddDTO(${this.classNameUpper}AddDTO ${this.className}AddDTO);

    /**
     * 将updateDTO中的值设置到po
     *
     * @param ${this.className}PO
     * @param ${this.className}UpdateDTO
     */
    void setUpdateDTO(@MappingTarget ${this.classNameUpper}PO ${this.className}PO, ${this.classNameUpper}UpdateDTO ${this.className}UpdateDTO);

    /**
     * po映射showVO
     *
     * @param ${this.className}PO
     * @return
     */
    ${this.classNameUpper}ShowVO toShowVO(${this.classNameUpper}PO ${this.className}PO);


<#--为被持有的实体提供级联【列表】查询方法-->
<#list mtmCascadeEntitiesForOppList as otherEntity>
    <#assign otherCName=otherEntity.className?capFirst>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${otherCName}ListVO")/>
    List<${otherCName}ListVO.${this.classNameUpper}VO> to${this.classNameUpper}VOFor${otherCName}List(List<${this.classNameUpper}PO> list);

</#list>
<#--为被持有的实体提供级联【详情】查询方法-->
<#list mtmCascadeEntitiesForOppShow as otherEntity>
    <#assign otherCName=otherEntity.className?capFirst>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${otherCName}ShowVO")/>
    List<${otherCName}ShowVO.${this.classNameUpper}VO> to${this.classNameUpper}VOFor${otherCName}Show(List<${this.classNameUpper}PO> list);

</#list>
<#--多对多被对方持有，提供PO列表转ListVO列表 -->
<#list mtmEntitiesForOpp as otherEntity>
    <#assign mtm=mtmsForOpp[otherEntity?index]/>
    <#assign otherEntityFeature=mtm.getEntityFeature(otherEntity.entityId)>
    <#--对方支持添加删除的情况才需要该服务 -->
    <#if otherEntityFeature.addRemove>
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ListVO")/>
    List<${this.classNameUpper}ListVO> toListVOList(List<${this.classNameUpper}PO> list);

    </#if>
</#list>
<#if this.entityFeature.excelImport>
    <@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}ExcelDTO")/>
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
                <#assign othercName=otherEntity.className?uncapFirst>
                <#assign otherCName=otherEntity.className?capFirst>
            @Mapping(target = "${othercName}List", expression = "java(${this.commonPackage}.util.ConvertUtil.convert${pkFieldType}List(dto.get${otherCName}List()))"),
            </#if>
        </#list>
    </@wrapMappings>
    ${this.classNameUpper}AddDTO fromExcelDTO(${this.classNameUpper}ExcelDTO dto);

</#if>
<#if this.entityFeature.excelExport>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ExcelVO")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ListVO")/>
    /**
     * listVO列表转excelVO列表
     *
     * @param list
     * @return
     */
    List<${this.classNameUpper}ExcelVO> toExcelVOList(List<${this.classNameUpper}ListVO> list);

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
    </@wrapMappings>
    ${this.classNameUpper}ExcelVO toExcelVO(${this.classNameUpper}ListVO vo);

    <#list mtmCascadeEntitiesForList as otherEntity>
        <#assign mtmCascadeExts = groupMtmCascadeExtsForList[otherEntity?index]>
        <#assign otherCName=otherEntity.className?capFirst>
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
    default String convert${otherCName}List(List<${this.classNameUpper}ListVO.${otherCName}VO> list) {
        String result = "";
        <@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
        if (CollectionUtils.isNotEmpty(list)) {
            result = list.stream()
                    .map(${this.classNameUpper}ListVO.${otherCName}VO::get${displayField.jfieldName?capFirst})
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
package ${this.packageName}.pojo.mapper;

<@call this.printImport()/>

${code}
