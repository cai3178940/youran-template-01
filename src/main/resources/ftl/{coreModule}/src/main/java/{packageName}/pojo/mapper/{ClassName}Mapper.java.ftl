<#include "/abstracted/common.ftl">
<#include "/abstracted/mtmCascadeExtsForOppList.ftl">
<#include "/abstracted/mtmCascadeExtsForOppShow.ftl">
<#include "/abstracted/mtmForOpp.ftl">
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
}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.pojo.mapper;

<@call this.printImport()/>

${code}
