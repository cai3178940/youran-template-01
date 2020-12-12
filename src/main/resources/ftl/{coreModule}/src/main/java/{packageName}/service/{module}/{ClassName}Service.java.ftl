<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/mtmForOpp.ftl">
<#include "/abstracted/mtmCascadeExtsForList.ftl">
<#include "/abstracted/mtmCascadeExtsForShow.ftl">
<#include "/abstracted/guessDefaultJfieldValue.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.constant.ErrorCode")/>
<@call this.addImport("${this.commonPackage}.exception.BusinessException")/>
<@call this.addImport("${dtoPackageName}.${this.className}AddDTO")/>
<@call this.addImport("${qoPackageName}.${this.className}QO")/>
<@call this.addImport("${voPackageName}.${this.className}ListVO")/>
<@call this.addImport("${dtoPackageName}.${this.className}UpdateDTO")/>
<@call this.addImport("${mapperPackageName}.${this.className}Mapper")/>
<@call this.addImport("${poPackageName}.${this.className}PO")/>
<@call this.addImport("${voPackageName}.${this.className}ShowVO")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Autowired")/>
<@call this.addImport("org.springframework.stereotype.Service")/>
<@call this.addImport("org.springframework.transaction.annotation.Transactional")/>
<@call this.printClassCom("【${this.title}】增删改查服务")/>
@Service
public class ${this.className}Service {

<#-- 引入当前实体的DAO -->
<@call this.addAutowired("${daoPackageName}" "${this.className}DAO")/>
<#-- 引入多对多关联实体的DAO（当前持有） -->
<#list this.holds! as otherEntity, mtm>
    <#assign otherCName = otherEntity.className>
    <@call this.addAutowired("${daoPackageName}" "${otherCName}DAO")/>
</#list>
<#-- 引入多对多关联实体的DAO（被对方持有） -->
<#list mtmEntitiesForOpp as otherEntity>
    <@call this.addAutowired("${daoPackageName}" "${otherEntity.className}DAO")/>
</#list>
<#-- 引入外键对应的DAO （插入字段对应的外键）-->
<#list this.insertFields as id, field>
    <#if field.foreignKey>
        <@call this.addAutowired("${daoPackageName}" "${field.foreignEntity.className}DAO")/>
    </#if>
</#list>
<#-- 引入外键对应的DAO （更新字段对应的外键）-->
<#list this.updateFields as id, field>
    <#if field.foreignKey>
        <@call this.addAutowired("${daoPackageName}" "${field.foreignEntity.className}DAO")/>
    </#if>
</#list>
<#-- 被其他实体外键关联时，引入其他实体DAO -->
<#list this.foreignEntities! as foreignEntity>
    <@call this.addAutowired("${daoPackageName}" "${foreignEntity.className}DAO")/>
</#list>
<#-- 当前实体的外键字段存在级联扩展时，引入对应实体的DAO -->
<#list this.fkFields as id, field>
    <#if field.cascadeListExts?? && field.cascadeListExts?size &gt; 0>
        <@call this.addAutowired("${daoPackageName}" "${field.foreignEntity.className}DAO")/>
    </#if>
</#list>
<@call this.printAutowired()/>

<#if this.metaEntity.checkUniqueIndexes?? && this.metaEntity.checkUniqueIndexes?size &gt; 0>
    /**
     * 校验数据唯一性
     *
     * @param ${this.classNameLower}
     * @param isUpdate 是否更新校验
     */
    private void checkUnique(${this.className}PO ${this.classNameLower}, boolean isUpdate) {
    <#list this.metaEntity.checkUniqueIndexes as index>
        <#assign suffix = (index?index == 0)?string('', '' + index?index)>
        <#assign params = ''>
        <#list index.fields as field>
            <#assign params += this.classNameLower + '.get' + field.jfieldName?capFirst + '(), '>
        </#list>
        if (${this.classNameLower}DAO.notUnique${suffix}(${params}isUpdate ? ${this.classNameLower}.get${this.idUpper}() : null)) {
            throw new BusinessException(ErrorCode.DUPLICATE_KEY);
        }
    </#list>
    }

</#if>
<#-- 抽象出公共方法【校验外键字段对应实体是否存在】 -->
<#macro checkForeignKeys fields>
    <#list fields as id, field>
        <#if field.foreignKey>
            <@call this.addImport("org.springframework.util.Assert")/>
            <#assign foreigncName = lowerFirstWord(field.foreignEntity.className)>
        if (${this.classNameLower}.get${field.jfieldName?capFirst}() != null) {
            Assert.isTrue(${foreigncName}DAO.exist(${this.classNameLower}.get${field.jfieldName?capFirst}()), "${field.fieldDesc}有误");
        }
        </#if>
    </#list>
</#macro>

    /**
     * 新增【${this.title}】
     *
     * @param ${this.classNameLower}DTO
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    public ${this.className}PO save(${this.className}AddDTO ${this.classNameLower}DTO) {
        ${this.className}PO ${this.classNameLower} = ${this.className}Mapper.INSTANCE.fromAddDTO(${this.classNameLower}DTO);
        <@checkForeignKeys this.insertFields/>
<#if this.metaEntity.checkUniqueIndexes?? && this.metaEntity.checkUniqueIndexes?size &gt; 0>
        // 唯一性校验
        this.checkUnique(${this.classNameLower}, false);
</#if>
<#-- addDTO中不存在并且不能为空的字段，赋初始值 -->
<#list this.fields as id, field>
    <#if !field.insert && field.notNull && field.specialField?default("")?length == 0>
        <#if !field.primaryKey>
        ${this.classNameLower}.set${field.jfieldName?capFirst}(${guessDefaultJfieldValue(field.jfieldType)});
        <#elseIf field.pkStrategy == PrimaryKeyStrategy.UUID_16.getValue()>
            <@call this.addImport("${this.commonPackage}.util.UUIDUtil")/>
        ${this.classNameLower}.set${field.jfieldName?capFirst}(UUIDUtil.getUUID16());
        <#elseIf field.pkStrategy == PrimaryKeyStrategy.UUID_32.getValue()>
            <@call this.addImport("${this.commonPackage}.util.UUIDUtil")/>
        ${this.classNameLower}.set${field.jfieldName?capFirst}(UUIDUtil.getUUID());
        <#elseIf field.pkStrategy == PrimaryKeyStrategy.NONE.getValue()>
        // TODO 请手动给主键赋值
        // ${this.classNameLower}.set${field.jfieldName?capFirst}();
        </#if>
    </#if>
</#list>
        ${this.classNameLower}DAO.save(${this.classNameLower});
<#list this.holds! as otherEntity, mtm>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
    <#assign otherPk = otherEntity.pkField>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    <#assign entityFeature = mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.withinEntity>
        List<${otherPk.jfieldType}> ${othercName}List = ${this.classNameLower}DTO.get${otherCName}List();
        if (CollectionUtils.isNotEmpty(${othercName}List)) {
            this.doAdd${otherCName}(${this.classNameLower}.get${this.idUpper}(), ${othercName}List.toArray(new ${otherPk.jfieldType}[0]));
        }
    </#if>
</#list>
        return ${this.classNameLower};
    }

<#if this.entityFeature.excelImport>
    /**
     * 批量新增【${this.title}】
     *
     * @param list
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    <@call this.addImport("java.util.List")/>
    public int batchSave(List<${this.className}AddDTO> list) {
        <@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
        if (CollectionUtils.isEmpty(list)) {
            return 0;
        }
        for (${this.className}AddDTO addDTO : list) {
            this.save(addDTO);
        }
        return list.size();
    }

</#if>
    /**
     * 修改【${this.title}】
     *
     * @param ${this.classNameLower}UpdateDTO
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    <#if this.metaEntity.versionField??>
        <@call this.addImport("${this.commonPackage}.optimistic.OptimisticLock")/>
    @OptimisticLock
    </#if>
    public ${this.className}PO update(${this.className}UpdateDTO ${this.classNameLower}UpdateDTO) {
        ${this.type} ${this.id} = ${this.classNameLower}UpdateDTO.get${this.idUpper}();
        ${this.className}PO ${this.classNameLower} = this.get${this.className}(${this.id}, true);
        ${this.className}Mapper.INSTANCE.setUpdateDTO(${this.classNameLower}, ${this.classNameLower}UpdateDTO);
        <@checkForeignKeys this.updateFields/>
<#if this.metaEntity.checkUniqueIndexes?? && this.metaEntity.checkUniqueIndexes?size &gt; 0>
        // 唯一性校验
        this.checkUnique(${this.classNameLower}, true);
</#if>
        ${this.classNameLower}DAO.update(${this.classNameLower});
<#list this.holds! as otherEntity, mtm>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
    <#assign otherPk = otherEntity.pkField>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    <#assign entityFeature = mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.withinEntity>
        List<${otherPk.jfieldType}> ${othercName}List = ${this.classNameLower}UpdateDTO.get${otherCName}List();
        if (${othercName}List != null) {
            this.set${otherCName}(${this.classNameLower}.get${this.idUpper}(), ${othercName}List.toArray(new ${otherPk.jfieldType}[]{}));
        }
    </#if>
</#list>
        return ${this.classNameLower};
    }

<#if this.pageSign>
    <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    /**
     * 查询分页列表
     *
     * @param ${this.classNameLower}QO
     * @return
     */
    public PageVO<${this.className}ListVO> list(${this.className}QO ${this.classNameLower}QO) {
        PageVO<${this.className}ListVO> page = ${this.classNameLower}DAO.findByPage(${this.classNameLower}QO);
        <#if mtmCascadeEntitiesForList?hasContent>
        for (${this.className}ListVO listVO : page.getList()) {
            <#list mtmCascadeEntitiesForList as otherEntity>
                <#assign otherCName = otherEntity.className>
                <#assign othercName = lowerFirstWord(otherEntity.className)>
                <@call this.addImport("${mapperPackageName}.${otherCName}Mapper")/>
            listVO.set${otherCName}List(${otherCName}Mapper.INSTANCE.to${otherCName}VOFor${this.className}List(
                    ${othercName}DAO.findBy${this.className}(listVO.get${this.idUpper}())));
            </#list>
        }
        </#if>
        return page;
    }
<#else>
<@call this.addImport("java.util.List")/>
    /**
     * 查询列表
     *
     * @param ${this.classNameLower}QO
     * @return
     */
    public List<${this.className}ListVO> list(${this.className}QO ${this.classNameLower}QO) {
        List<${this.className}ListVO> list = ${this.classNameLower}DAO.findListByQuery(${this.classNameLower}QO);
    <#if mtmCascadeEntitiesForList?hasContent>
        for (${this.className}ListVO listVO : list) {
        <#list mtmCascadeEntitiesForList as otherEntity>
            <#assign otherCName = otherEntity.className>
            <#assign othercName = lowerFirstWord(otherEntity.className)>
            <@call this.addImport("${mapperPackageName}.${otherCName}Mapper")/>
            listVO.set${otherCName}List(${otherCName}Mapper.INSTANCE.to${otherCName}VOFor${this.className}List(
                    ${othercName}DAO.findBy${this.className}(listVO.get${this.idUpper}())));
        </#list>
        }
    </#if>
        return list;
    }
</#if>

<#if this.titleField??>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.commonPackage}.pojo.vo.OptionVO")/>
    <@call this.addImport("${this.commonPackage}.pojo.qo.OptionQO")/>
    /**
     * 查询【${this.title}】选项列表
     *
     * @return
     */
    public List<OptionVO<${this.type}, ${this.titleField.jfieldType}>> findOptions(OptionQO<${this.type}, ${this.titleField.jfieldType}> qo) {
        List<OptionVO<${this.type}, ${this.titleField.jfieldType}>> options = ${this.classNameLower}DAO.findOptions(qo);
        return options;
    }

</#if>
<#if this.holds!?hasContent>
    /**
     * 根据主键获取【${this.title}】
     * 不获取多对多级联对象
     *
     <@formatParamComments>
     * @param ${this.id} 主键
     * @param force 是否强制获取
     </@formatParamComments>
     * @return
     */
    public ${this.className}PO get${this.className}(${this.type} ${this.id}, boolean force) {
    <#assign withFalseCode = "">
    <#list this.holds! as otherEntity, mtm>
        <#assign withFalseCode = withFalseCode + "false, ">
    </#list>
        return this.get${this.className}(${this.id}, ${withFalseCode}force);
    }

</#if>
    /**
     * 根据主键获取【${this.title}】
     *
     <@formatParamComments>
     * @param ${this.id} 主键
<#assign withHoldParam = "">
<#list this.holds! as otherEntity, mtm>
    <#assign otherCName = otherEntity.className>
    <#assign withParamName = "with" + otherCName>
    <#assign withHoldParam = withHoldParam + "boolean with" + otherCName + ", ">
     * @param ${withParamName} 是否级联获取【${otherEntity.title}】
</#list>
     * @param force 是否强制获取
     </@formatParamComments>
     * @return
     */
    public ${this.className}PO get${this.className}(${this.type} ${this.id}, ${withHoldParam}boolean force) {
        ${this.className}PO ${this.classNameLower} = ${this.classNameLower}DAO.findById(${this.id});
        if (force && ${this.classNameLower} == null) {
            throw new BusinessException(ErrorCode.RECORD_NOT_FIND);
        }
<#list this.holds! as otherEntity, mtm>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
        if (with${otherCName}) {
            ${this.classNameLower}.set${otherCName}POList(${othercName}DAO.findBy${this.className}(${this.id}));
        }
</#list>
        return ${this.classNameLower};
    }


    /**
     * 查询【${this.title}】详情
     *
     * @param ${this.id}
     * @return
     */
    public ${this.className}ShowVO show(${this.type} ${this.id}) {
        ${this.className}PO ${this.classNameLower} = this.get${this.className}(${this.id}, true);
        ${this.className}ShowVO showVO = ${this.className}Mapper.INSTANCE.toShowVO(${this.classNameLower});
<#--外键级联扩展，详情展示-->
<#list this.fkFields as id, field>
    <#if field.cascadeShowExts?? && field.cascadeShowExts?size &gt; 0>
        <#assign otherCName = field.foreignEntity.className>
        <#assign othercName = lowerFirstWord(field.foreignEntity.className)>
        <@call this.addImport("${poPackageName}.${otherCName}PO")/>
        if (${this.classNameLower}.get${field.jfieldName?capFirst}() != null) {
            ${otherCName}PO _${othercName}PO = ${othercName}DAO.findById(${this.classNameLower}.get${field.jfieldName?capFirst}());
        <#list field.cascadeShowExts as cascadeExt>
            showVO.set${cascadeExt.alias?capFirst}(_${othercName}PO.get${cascadeExt.cascadeField.jfieldName?capFirst}());
        </#list>
        }
    </#if>
</#list>
<#--多对多随实体一起维护并且未设置级联扩展时，需要返回对方的id列表-->
<#list this.holds! as otherEntity, mtm>
    <#if mtm.getEntityFeature(this.entityId).withinEntity
        && !mtmCascadeEntitiesForShow?seqContains(otherEntity)>
        <#assign otherCName = otherEntity.className>
        <#assign othercName = lowerFirstWord(otherEntity.className)>
        <@call this.addImport("java.util.stream.Collectors")/>
        // 设置【${otherEntity.title}】主键列表
        showVO.set${otherCName}List(${othercName}DAO.findBy${this.className}(${this.id})
                .stream()
                .map(t -> t.get${otherEntity.pkField.jfieldName?capFirst}())
                .collect(Collectors.toList()));
    </#if>
</#list>
<#--多对多级联扩展详情展示-->
<#list mtmCascadeEntitiesForShow as otherEntity>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    <@call this.addImport("${mapperPackageName}.${otherCName}Mapper")/>
        // 设置【${otherEntity.title}】列表
        showVO.set${otherCName}List(${otherCName}Mapper.INSTANCE.to${otherCName}VOFor${this.className}Show(
                ${othercName}DAO.findBy${this.className}(${this.id})));
</#list>
        return showVO;
    }

    /**
     * 删除【${this.title}】
     *
     * @param ${this.id}s
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    public int delete(${this.type}... ${this.id}s) {
        int count = 0;
        for (${this.type} ${this.id} : ${this.id}s) {
<#list this.foreignEntities! as foreignEntity>
    <#assign foreignCName = foreignEntity.className>
            this.checkDeleteBy${foreignCName}(${this.id});
</#list>
<#list mtmEntitiesForOpp as otherEntity>
    <#assign otherCName = otherEntity.className>
            // 校验是否存在【${otherEntity.title}】关联
            this.checkDeleteBy${otherCName}(${this.id});
</#list>
            count += ${this.classNameLower}DAO.delete(${this.id});
        }
        return count;
    }

<#list this.foreignEntities! as foreignEntity>
    <#assign foreignCName = foreignEntity.className>
    <#assign foreigncName = lowerFirstWord(foreignEntity.className)>
    <#assign alreadyFind = false>
    /**
     * 校验是否存在【${foreignEntity.title}】关联
     *
     * @param ${this.id}
     */
    private void checkDeleteBy${foreignCName}(${this.type} ${this.id}) {
    <#list this.foreignFields as foreignField>
        <#if foreignField.entityId == foreignEntity.entityId>
        <#if !alreadyFind>int </#if>count = ${foreigncName}DAO.getCountBy${foreignField.jfieldName?capFirst}(${this.id});
        if (count > 0) {
            throw new BusinessException(ErrorCode.CASCADE_DELETE_ERROR);
        }
            <#assign alreadyFind = true>
        </#if>
    </#list>
    }

</#list>
<#list mtmEntitiesForOpp as otherEntity>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    /**
     * 校验是否存在【${otherEntity.title}】关联
     *
     * @param ${this.id}
     */
    private void checkDeleteBy${otherCName}(${this.type} ${this.id}) {
        int count = ${othercName}DAO.getCountBy${this.className}(${this.id});
        if (count > 0) {
            throw new BusinessException(ErrorCode.CASCADE_DELETE_ERROR);
        }
    }

</#list>
<#list this.holds! as otherEntity, mtm>
    <@call this.addImport("org.apache.commons.lang3.ArrayUtils")/>
    <#assign otherPk = otherEntity.pkField>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    <#assign otherFkId = mtm.getFkAlias(otherEntity.entityId, false)>
    <#assign entityFeature = mtm.getEntityFeature(this.entityId)>
    /**
     * 执行【${otherEntity.title}】添加
     *
     * @param ${this.id}
     * @param ${otherFkId}
     * @return
     */
    private int doAdd${otherCName}(${this.type} ${this.id}, ${otherPk.jfieldType}... ${otherFkId}) {
        int count = 0;
        for (${otherPk.jfieldType} _id : ${otherFkId}) {
            if (${othercName}DAO.exist(_id)) {
                count += ${this.classNameLower}DAO.add${otherCName}(${this.id}, _id);
            }
        }
        return count;
    }

    <#if entityFeature.addRemove>
    /**
     * 添加【${otherEntity.title}】
     *
     * @param ${this.id}
     * @param ${otherFkId}
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    public int add${otherCName}(${this.type} ${this.id}, ${otherPk.jfieldType}... ${otherFkId}) {
        ${this.className}PO ${this.classNameLower} = this.get${this.className}(${this.id}, true);
        if (ArrayUtils.isEmpty(${otherFkId})) {
            throw new BusinessException(ErrorCode.PARAM_IS_NULL);
        }
        return doAdd${otherCName}(${this.id}, ${otherFkId});
    }

    /**
     * 移除【${otherEntity.title}】
     *
     * @param ${this.id}
     * @param ${otherFkId}
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    public int remove${otherCName}(${this.type} ${this.id}, ${otherPk.jfieldType}... ${otherFkId}) {
        ${this.className}PO ${this.classNameLower} = this.get${this.className}(${this.id}, true);
        if (ArrayUtils.isEmpty(${otherFkId})) {
            throw new BusinessException(ErrorCode.PARAM_IS_NULL);
        }
        return ${this.classNameLower}DAO.remove${otherCName}(${this.id}, ${otherFkId});
    }

    </#if>
    <#if entityFeature.set || entityFeature.withinEntity>
    /**
     * 设置【${otherEntity.title}】
     *
     * @param ${this.id}
     * @param ${otherFkId}
     * @return
     */
    @Transactional(rollbackFor = RuntimeException.class)
    public int set${otherCName}(${this.type} ${this.id}, ${otherPk.jfieldType}[] ${otherFkId}) {
        ${this.className}PO ${this.classNameLower} = this.get${this.className}(${this.id}, true);
        ${this.classNameLower}DAO.removeAll${otherCName}(${this.id});
        if (ArrayUtils.isEmpty(${otherFkId})) {
            return 0;
        }
        return doAdd${otherCName}(${this.id}, ${otherFkId});
    }

    </#if>
</#list>

}

</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(servicePackageName)/>

${code}
