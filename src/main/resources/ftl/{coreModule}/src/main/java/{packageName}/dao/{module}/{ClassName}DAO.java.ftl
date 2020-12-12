<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/mtmForOpp.ftl">
<#include "/abstracted/mtmCascadeExtsForOppList.ftl">
<#include "/abstracted/mtmCascadeExtsForOppShow.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${poPackageName}.${this.className}PO")/>
<@call this.addImport("${this.commonPackage}.dao.DAO")/>
<@call this.addImport("org.apache.ibatis.annotations.Mapper")/>
<@call this.addImport("org.springframework.stereotype.Repository")/>
<@call this.printClassCom("【${this.title}】数据库操作")/>
@Repository
@Mapper
public interface ${this.className}DAO extends DAO<${this.className}PO> {

<#if !this.pageSign>
    <@call this.addImport("${qoPackageName}.${this.className}QO")/>
    <@call this.addImport("${voPackageName}.${this.className}ListVO")/>
    <@call this.addImport("java.util.List")/>
    /**
     * 根据条件查询【${this.title}】列表
     * @param ${this.classNameLower}QO
     * @return
     */
    List<${this.className}ListVO> findListByQuery(${this.className}QO ${this.classNameLower}QO);

</#if>
<#if this.titleField??>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.commonPackage}.pojo.vo.OptionVO")/>
    <@call this.addImport("${this.commonPackage}.pojo.qo.OptionQO")/>
    List<OptionVO<${this.type}, ${this.titleField.jfieldType}>> findOptions(OptionQO<${this.type}, ${this.titleField.jfieldType}> qo);

</#if>
<#list this.fkFields as id, field>
    int getCountBy${field.jfieldName?capFirst}(${field.jfieldType} ${field.jfieldName});

</#list>
<#list this.holds! as otherEntity, mtm>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("org.apache.ibatis.annotations.Param")/>
    <#assign otherCName = otherEntity.className>
    <#assign otherType = otherEntity.pkField.jfieldType>
    <#assign theFkId = mtm.getFkAlias(this.entityId, false)>
    <#assign otherFkId = mtm.getFkAlias(otherEntity.entityId, false)>
    int getCountBy${otherCName}(${otherType} ${otherFkId});

    int add${otherCName}(@Param("${theFkId}") ${this.type} ${theFkId}, @Param("${otherFkId}")${otherType} ${otherFkId});

    int remove${otherCName}(@Param("${theFkId}") ${this.type} ${theFkId}, @Param("${otherFkId}")${otherType}[] ${otherFkId});

    int removeAll${otherCName}(${this.type} ${theFkId});

</#list>
<#list mtmEntitiesForOpp as otherEntity>
    <@call this.addImport("java.util.List")/>
    <#assign mtm = mtmsForOpp[otherEntity?index]/>
    <#assign otherCName = otherEntity.className/>
    <#assign otherType = otherEntity.pkField.jfieldType>
    <#assign otherFkId = mtm.getFkAlias(otherEntity.entityId, false)>
    List<${this.className}PO> findBy${otherCName}(${otherType} ${otherFkId});

</#list>

<#list this.metaEntity.checkUniqueIndexes as index>
    <@call this.addImport("org.apache.ibatis.annotations.Param")/>
    <#assign suffix = (index?index == 0)?string('', '' + index?index)>
    <#assign params = ''>
    <#list index.fields as field>
        <#assign params += '@Param("' + field.jfieldName + '") ' + field.jfieldType + ' ' + field.jfieldName + ', '>
    </#list>
    boolean notUnique${suffix}(${params}@Param("${this.id}") ${this.type} ${this.id});

</#list>
}
</#assign>
<#--开始渲染代码-->
package ${daoPackageName};

<@call this.printImport()/>

${code}


