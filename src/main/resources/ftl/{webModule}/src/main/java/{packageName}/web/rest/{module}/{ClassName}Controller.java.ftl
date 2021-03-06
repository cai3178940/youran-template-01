<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/checkFeatureForRest.ftl">
<#include "/abstracted/mtmCascadeExtsForShow.ftl">
<#include "/abstracted/forEntityInsert.ftl">
<#--判断如果不需要生成当前文件，则直接跳过-->
<#if !getGenRest(this.metaEntity)>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.web.AbstractController")/>
<@call this.addImport("${apiPackageName}.${this.className}API")/>
<@call this.addImport("org.springframework.http.HttpStatus")/>
<@call this.addImport("org.springframework.http.ResponseEntity")/>
<@call this.addImport("org.springframework.web.bind.annotation.RestController")/>
<@call this.addImport("org.springframework.web.bind.annotation.RequestMapping")/>
<@call this.addImport("javax.validation.Valid")/>
<@call this.addImport("java.net.URI")/>
<@call this.printClassCom("【${this.title}】控制器")/>
@RestController
@RequestMapping(${renderApiPath(this.metaEntity, "")})
public class ${this.className}Controller extends AbstractController implements ${this.className}API {

    <@call this.addAutowired("${servicePackageName}" "${this.className}Service")/>
    <#if this.entityFeature.excelImport>
        <@call this.addAutowired("javax.validation" "Validator")/>
    </#if>
    <@call this.printAutowired()/>

<#if this.entityFeature.save>
    <@call this.addImport("${dtoPackageName}.${this.className}AddDTO")/>
    <@call this.addImport("${voPackageName}.${this.className}ShowVO")/>
    <@call this.addImport("${mapperPackageName}.${this.className}Mapper")/>
    <@call this.addImport("${poPackageName}.${this.className}PO")/>
    <@call this.addImport("org.springframework.web.bind.annotation.PostMapping")/>
    <@call this.addImport("org.springframework.web.bind.annotation.ResponseStatus")/>
    <@call this.addImport("org.springframework.web.bind.annotation.RequestBody")/>
    @Override
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<${this.className}ShowVO> save(@Valid @RequestBody ${this.className}AddDTO ${this.classNameLower}AddDTO) throws Exception {
        ${this.className}PO ${this.classNameLower} = ${this.classNameLower}Service.save(${this.classNameLower}AddDTO);
        return ResponseEntity.created(new URI(${renderApiPath(this.metaEntity, "/")} + ${this.classNameLower}.get${this.idUpper}()))
                .body(${this.className}Mapper.INSTANCE.toShowVO(${this.classNameLower}));
    }

</#if>
<#if this.entityFeature.update>
    <@call this.addImport("${dtoPackageName}.${this.className}UpdateDTO")/>
    <@call this.addImport("${voPackageName}.${this.className}ShowVO")/>
    <@call this.addImport("${mapperPackageName}.${this.className}Mapper")/>
    <@call this.addImport("${poPackageName}.${this.className}PO")/>
    <@call this.addImport("org.springframework.web.bind.annotation.PutMapping")/>
    <@call this.addImport("org.springframework.web.bind.annotation.RequestBody")/>
    @Override
    @PutMapping
    public ResponseEntity<${this.className}ShowVO> update(@Valid @RequestBody ${this.className}UpdateDTO ${this.classNameLower}UpdateDTO) {
        ${this.className}PO ${this.classNameLower} = ${this.classNameLower}Service.update(${this.classNameLower}UpdateDTO);
        return ResponseEntity.ok(${this.className}Mapper.INSTANCE.toShowVO(${this.classNameLower}));
    }

</#if>
<#if this.entityFeature.list>
    <@call this.addImport("${qoPackageName}.${this.className}QO")/>
    <@call this.addImport("${voPackageName}.${this.className}ListVO")/>
    <@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
    <#if this.pageSign>
        <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    @Override
    @GetMapping
    public ResponseEntity<PageVO<${this.className}ListVO>> list(@Valid ${this.className}QO ${this.classNameLower}QO) {
        PageVO<${this.className}ListVO> page = ${this.classNameLower}Service.list(${this.classNameLower}QO);
        return ResponseEntity.ok(page);
    }
    <#else>
        <@call this.addImport("java.util.List")/>
    @Override
    @GetMapping
    public ResponseEntity<List<${this.className}ListVO>> list(@Valid ${this.className}QO ${this.classNameLower}QO) {
        List<${this.className}ListVO> list = ${this.classNameLower}Service.list(${this.classNameLower}QO);
        return ResponseEntity.ok(list);
    }
    </#if>

</#if>
<#if this.titleField??>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.commonPackage}.pojo.vo.OptionVO")/>
    <@call this.addImport("${this.commonPackage}.pojo.qo.OptionQO")/>
    <@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
    @Override
    @GetMapping(value = "/options")
    public ResponseEntity<List<OptionVO<${this.type}, ${this.titleField.jfieldType}>>> findOptions(OptionQO<${this.type}, ${this.titleField.jfieldType}> qo) {
        List<OptionVO<${this.type}, ${this.titleField.jfieldType}>> options = ${this.classNameLower}Service.findOptions(qo);
        return ResponseEntity.ok(options);
    }

</#if>
<#if this.entityFeature.show>
    <@call this.addImport("${voPackageName}.${this.className}ShowVO")/>
    <@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
    <@call this.addImport("org.springframework.web.bind.annotation.PathVariable")/>
    @Override
    @GetMapping(value = "/{${this.id}}")
    public ResponseEntity<${this.className}ShowVO> show(@PathVariable ${this.type} ${this.id}) {
        ${this.className}ShowVO ${this.classNameLower}ShowVO = ${this.classNameLower}Service.show(${this.id});
        return ResponseEntity.ok(${this.classNameLower}ShowVO);
    }

</#if>
<#if this.entityFeature.delete>
    <@call this.addImport("org.springframework.web.bind.annotation.DeleteMapping")/>
    <@call this.addImport("org.springframework.web.bind.annotation.PathVariable")/>
    @Override
    @DeleteMapping(value = "/{${this.id}}")
    public ResponseEntity<Integer> delete(@PathVariable ${this.type} ${this.id}) {
        int count = ${this.classNameLower}Service.delete(${this.id});
        return ResponseEntity.ok(count);
    }

</#if>
<#if this.entityFeature.deleteBatch>
    <@call this.addImport("${this.commonPackage}.exception.BusinessException")/>
    <@call this.addImport("${this.commonPackage}.constant.ErrorCode")/>
    <@call this.addImport("org.springframework.web.bind.annotation.DeleteMapping")/>
    <@call this.addImport("org.springframework.web.bind.annotation.RequestBody")/>
    @Override
    @DeleteMapping
    public ResponseEntity<Integer> deleteBatch(@RequestBody ${this.type}[] id) {
        <@call this.addImport("org.apache.commons.lang3.ArrayUtils")/>
        if (ArrayUtils.isEmpty(id)) {
            throw new BusinessException(ErrorCode.PARAM_IS_NULL);
        }
        int count = ${this.classNameLower}Service.delete(id);
        return ResponseEntity.ok(count);
    }

</#if>
<#list this.holds! as otherEntity, mtm>
    <#assign otherPk = otherEntity.pkField>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    <#assign otherFkId = mtm.getFkAlias(otherEntity.entityId, false)>
    <#assign entityFeature = mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.addRemove || entityFeature.set>
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${poPackageName}.${otherCName}PO")/>
        <@call this.addImport("${poPackageName}.${this.className}PO")/>
        <@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
        <@call this.addImport("org.springframework.web.bind.annotation.PathVariable")/>
        <#assign index = getMtmCascadeEntityIndexForShow(otherEntity.entityId)>
        <#--如果存在级联扩展，则返回值为级联扩展VO-->
        <#if entityFeature.addRemove>
            <@call this.addImport("${voPackageName}.${otherCName}ListVO")/>
            <#assign resultType = "${otherCName}ListVO">
        <#elseIf index &gt; -1>
            <@call this.addImport("${voPackageName}.${this.className}ShowVO")/>
            <#assign resultType = "${this.className}ShowVO.${otherCName}VO">
        <#else>
            <#assign resultType = otherPk.jfieldType>
        </#if>
    @Override
    @GetMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<List<${resultType}>> fetch${otherCName}List(@PathVariable ${this.type} ${this.id}) {
        <#assign withFalseCode = "">
        <#list this.holds! as otherHoldEntity, mtm>
            <#if otherEntity == otherHoldEntity>
                <#assign withCode = withFalseCode + "true, ">
            <#else>
                <#assign withCode = withFalseCode + "false, ">
            </#if>
        </#list>
        ${this.className}PO ${this.classNameLower} = ${this.classNameLower}Service.get${this.className}(${this.id}, ${withCode}true);
        List<${otherCName}PO> list = ${this.classNameLower}.get${otherCName}POList();
        <#if entityFeature.addRemove>
            <@call this.addImport("${mapperPackageName}.${otherCName}Mapper")/>
        return ResponseEntity.ok(${otherCName}Mapper.INSTANCE.toListVOList(list));
        <#elseIf index &gt; -1>
            <@call this.addImport("${mapperPackageName}.${otherCName}Mapper")/>
        return ResponseEntity.ok(${otherCName}Mapper.INSTANCE.to${otherCName}VOFor${this.className}Show(list));
        <#else>
            <@call this.addImport("java.util.stream.Collectors")/>
        return ResponseEntity.ok(list.stream()
                .map(t -> t.get${otherPk.jfieldName?capFirst}())
                .collect(Collectors.toList()));
        </#if>
    }

    </#if>
    <#if entityFeature.addRemove>
        <@call this.addImport("${voPackageName}.${otherCName}ListVO")/>
        <@call this.addImport("org.springframework.web.bind.annotation.PostMapping")/>
        <@call this.addImport("org.springframework.web.bind.annotation.DeleteMapping")/>
        <@call this.addImport("org.springframework.web.bind.annotation.PathVariable")/>
    @Override
    @PostMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<Integer> add${otherCName}(@PathVariable ${this.type} ${this.id},
                        @RequestBody ${otherPk.jfieldType}[] ${otherFkId}) {
        int count = ${this.classNameLower}Service.add${otherCName}(${this.id}, ${otherFkId});
        return ResponseEntity.ok(count);
    }

    @Override
    @DeleteMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<Integer> remove${otherCName}(@PathVariable ${this.type} ${this.id},
                        @RequestBody ${otherPk.jfieldType}[] ${otherFkId}) {
        int count = ${this.classNameLower}Service.remove${otherCName}(${this.id}, ${otherFkId});
        return ResponseEntity.ok(count);
    }

    <#elseIf entityFeature.set>
        <@call this.addImport("org.springframework.web.bind.annotation.PutMapping")/>
        <@call this.addImport("org.springframework.web.bind.annotation.PathVariable")/>
    @Override
    @PutMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<Integer> set${otherCName}(@PathVariable ${this.type} ${this.id},
        @RequestBody ${otherPk.jfieldType}[] ${otherFkId}) {
        int count = ${this.classNameLower}Service.set${otherCName}(${this.id}, ${otherFkId});
        return ResponseEntity.ok(count);
    }

    </#if>
</#list>
<#if this.entityFeature.excelExport>
    <@call this.addImport("${qoPackageName}.${this.className}QO")/>
    <@call this.addImport("javax.servlet.http.HttpServletResponse")/>
    <@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
    @Override
    @GetMapping("/export")
    public void exportExcel(@Valid ${this.className}QO ${this.classNameLower}QO, HttpServletResponse response) throws Exception {
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${voPackageName}.${this.className}ListVO")/>
    <#if this.pageSign>
        ${this.classNameLower}QO.setPageSize(Integer.MAX_VALUE);
        ${this.classNameLower}QO.setPageNo(1);
        List<${this.className}ListVO> list = ${this.classNameLower}Service.list(${this.classNameLower}QO).getList();
    <#else>
        List<${this.className}ListVO> list = ${this.classNameLower}Service.list(${this.classNameLower}QO);
    </#if>
        this.exportExcel(response,
                <@call this.addImport("${voPackageName}.${this.className}ExcelVO")/>
                ${this.className}ExcelVO.class,
                <@call this.addImport("${mapperPackageName}.${this.className}Mapper")/>
                ${this.className}Mapper.INSTANCE.toExcelVOList(list),
                "${this.title}导出");
    }

</#if>
<#if this.entityFeature.excelImport>
    <@call this.addImport("org.springframework.web.bind.annotation.PostMapping")/>
    @Override
    @PostMapping("/import")
    <@call this.addImport("org.springframework.web.bind.annotation.RequestPart")/>
    <@call this.addImport("org.springframework.web.multipart.MultipartFile")/>
    public ResponseEntity<Integer> importExcel(@RequestPart MultipartFile file) throws Exception {
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${dtoPackageName}.${this.className}AddDTO")/>
        <@call this.addImport("${dtoPackageName}.${this.className}ExcelDTO")/>
        List<${this.className}AddDTO> list = this.parseExcel(file, ${this.className}ExcelDTO.class).stream()
                .map(excelDTO -> {
                    // 将excelDTO映射成addDTO
                    <@call this.addImport("${mapperPackageName}.${this.className}Mapper")/>
                    ${this.className}AddDTO addDTO = ${this.className}Mapper.INSTANCE.fromExcelDTO(excelDTO);
                    // 校验数据
                    <@call this.addImport("java.util.Set")/>
                    <@call this.addImport("javax.validation.ConstraintViolation")/>
                    Set<ConstraintViolation<${this.className}AddDTO>> set = validator.validate(addDTO);
                    if (!set.isEmpty()) {
                        ConstraintViolation<${this.className}AddDTO> violation = set.stream().findFirst().get();
                        String errorMsg = "第" + (excelDTO.getRowIndex() + 1) + "行数据不合法：" + violation.getMessage();
                        <@call this.addImport("javax.validation.ConstraintViolationException")/>
                        throw new ConstraintViolationException(errorMsg, set);
                    }
                    return addDTO;
                })
                <@call this.addImport("java.util.stream.Collectors")/>
                .collect(Collectors.toList());
        int count = ${this.classNameLower}Service.batchSave(list);
        return ResponseEntity.ok(count);
    }

    <#assign dicFieldSet = CommonTemplateFunction.createHashSet()>
    <#assign dicSet = CommonTemplateFunction.createHashSet()>
    <#list this.insertFields as id, field>
        <#if field.dicType??>
            <@justCall dicFieldSet.add(field)/>
            <@justCall dicSet.add(field.dicType)/>
        </#if>
    </#list>
    <@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
    <@call this.addImport("javax.servlet.http.HttpServletResponse")/>
    @Override
    @GetMapping("/template")
    public void downloadExcelTemplate(HttpServletResponse response) throws Exception {
        <#list dicSet as dic>
            <@call this.addImport("java.util.Arrays")/>
            <@call this.addConstImport(dic)/>
        String[] ${dic?uncapFirst}Constraint = Arrays.stream(${dic}.values()).map(${dic}::getDesc).toArray(String[]::new);
        </#list>
        this.downloadExcelTemplate(response,
                <@call this.addImport("${dtoPackageName}.${this.className}ExcelDTO")/>
                ${this.className}ExcelDTO.class,
                <@call this.addImport("java.util.Arrays")/>
                Arrays.asList(${this.className}ExcelDTO.example()),
                <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
                <@call this.addImport("java.util.Date")/>
                "${this.title}导入模板(" + DateUtil.getDateStr(new Date()) + ")",
                new String[]{
                        "模版前三行标题请勿修改",
                        "带“*”号为必填项",
                <#if fkFieldsForInsert?hasContent>
                    <#assign fkFieldNames = "">
                    <#list fkFieldsForInsert as fkField>
                        <#assign fkFieldNames += "“${fkField.fieldDesc}”">
                        <#if fkField?hasNext>
                            <#assign fkFieldNames += "、">
                        </#if>
                    </#list>
                        "${fkFieldNames}请填入id值",
                </#if>
                <#if withinEntityList?hasContent>
                    <#assign withinTitles = "">
                    <#list withinEntityList as otherEntity>
                        <#assign withinTitles += "“${otherEntity.title}”">
                        <#if otherEntity?hasNext>
                            <#assign withinTitles += "、">
                        </#if>
                    </#list>
                        "${withinTitles}支持一次性填入多个id（请用英文逗号分隔）",
                </#if>
                },
                <#if dicFieldSet?hasContent>
                    <@call this.addImport("com.alibaba.excel.write.handler.WriteHandler")/>
                new WriteHandler[]{
                    <#list this.insertFields as id, field>
                        <#if field.dicType??>
                        <@call this.addImport("${this.packageName}.excel.handler.ConstConstraintHandler")/>
                        new ConstConstraintHandler(${field.dicType?uncapFirst}Constraint, 3, 3, ${field?index}, ${field?index}),
                        </#if>
                    </#list>
                });
                <#else>
                null);
                </#if>
    }

</#if>
}

</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(restPackageName)/>

${code}
