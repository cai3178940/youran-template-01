<#include "/abstracted/common.ftl">
<#include "/abstracted/checkFeatureForRest.ftl">
<#include "/abstracted/mtmCascadeExtsForShow.ftl">
<#include "/abstracted/forEntityInsert.ftl">
<#--判断如果不需要生成当前文件，则直接跳过-->
<#if !getGenRest(this.metaEntity)>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.web.constant.WebConst")/>
<@call this.addImport("${this.packageName}.web.AbstractController")/>
<@call this.addImport("${this.packageName}.web.api.${this.classNameUpper}API")/>
<@call this.addImport("org.springframework.http.HttpStatus")/>
<@call this.addImport("org.springframework.http.ResponseEntity")/>
<@call this.addImport("org.springframework.web.bind.annotation.*")/>
<@call this.addImport("javax.validation.Valid")/>
<@call this.addImport("java.net.URI")/>
<@call this.printClassCom("【${this.title}】控制器")/>
@RestController
@RequestMapping(WebConst.API_PATH + "/${this.className}")
public class ${this.classNameUpper}Controller extends AbstractController implements ${this.classNameUpper}API {

    <@call this.addAutowired("${this.packageName}.service" "${this.classNameUpper}Service")/>
    <#if this.entityFeature.excelImport>
        <@call this.addAutowired("javax.validation" "Validator")/>
    </#if>
    <@call this.printAutowired()/>

<#if this.entityFeature.save>
    <@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}AddDTO")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ShowVO")/>
    <@call this.addImport("${this.packageName}.pojo.mapper.${this.classNameUpper}Mapper")/>
    <@call this.addImport("${this.packageName}.pojo.po.${this.classNameUpper}PO")/>
    @Override
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<${this.classNameUpper}ShowVO> save(@Valid @RequestBody ${this.classNameUpper}AddDTO ${this.className}AddDTO) throws Exception {
        ${this.classNameUpper}PO ${this.className} = ${this.className}Service.save(${this.className}AddDTO);
        return ResponseEntity.created(new URI(WebConst.API_PATH + "/${this.className}/" + ${this.className}.get${this.idUpper}()))
            .body(${this.classNameUpper}Mapper.INSTANCE.toShowVO(${this.className}));
    }

</#if>
<#if this.entityFeature.update>
    <@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}UpdateDTO")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ShowVO")/>
    <@call this.addImport("${this.packageName}.pojo.mapper.${this.classNameUpper}Mapper")/>
    <@call this.addImport("${this.packageName}.pojo.po.${this.classNameUpper}PO")/>
    @Override
    @PutMapping
    public ResponseEntity<${this.classNameUpper}ShowVO> update(@Valid @RequestBody ${this.classNameUpper}UpdateDTO ${this.className}UpdateDTO) {
        ${this.classNameUpper}PO ${this.className} = ${this.className}Service.update(${this.className}UpdateDTO);
        return ResponseEntity.ok(${this.classNameUpper}Mapper.INSTANCE.toShowVO(${this.className}));
    }

</#if>
<#if this.entityFeature.list>
    <@call this.addImport("${this.packageName}.pojo.qo.${this.classNameUpper}QO")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ListVO")/>
    <#if this.pageSign>
        <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    @Override
    @GetMapping
    public ResponseEntity<PageVO<${this.classNameUpper}ListVO>> list(@Valid ${this.classNameUpper}QO ${this.className}QO) {
        PageVO<${this.classNameUpper}ListVO> page = ${this.className}Service.list(${this.className}QO);
        return ResponseEntity.ok(page);
    }
    <#else>
        <@call this.addImport("java.util.List")/>
    @Override
    @GetMapping
    public ResponseEntity<List<${this.classNameUpper}ListVO>> list(@Valid ${this.classNameUpper}QO ${this.className}QO) {
        List<${this.classNameUpper}ListVO> list = ${this.className}Service.list(${this.className}QO);
        return ResponseEntity.ok(list);
    }
    </#if>

</#if>
<#if this.titleField??>
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.commonPackage}.pojo.vo.OptionVO")/>
    <@call this.addImport("${this.commonPackage}.pojo.qo.OptionQO")/>
    @Override
    @GetMapping(value = "/options")
    public ResponseEntity<List<OptionVO<${this.type}, ${this.titleField.jfieldType}>>> findOptions(OptionQO<${this.type}, ${this.titleField.jfieldType}> qo) {
        List<OptionVO<${this.type}, ${this.titleField.jfieldType}>> options = ${this.className}Service.findOptions(qo);
        return ResponseEntity.ok(options);
    }

</#if>
<#if this.entityFeature.show>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ShowVO")/>
    @Override
    @GetMapping(value = "/{${this.id}}")
    public ResponseEntity<${this.classNameUpper}ShowVO> show(@PathVariable ${this.type} ${this.id}) {
        ${this.classNameUpper}ShowVO ${this.className}ShowVO = ${this.className}Service.show(${this.id});
        return ResponseEntity.ok(${this.className}ShowVO);
    }

</#if>
<#if this.entityFeature.delete>
    @Override
    @DeleteMapping(value = "/{${this.id}}")
    public ResponseEntity<Integer> delete(@PathVariable ${this.type} ${this.id}) {
        int count = ${this.className}Service.delete(${this.id});
        return ResponseEntity.ok(count);
    }

</#if>
<#if this.entityFeature.deleteBatch>
    <@call this.addImport("${this.commonPackage}.exception.BusinessException")/>
    <@call this.addImport("${this.commonPackage}.constant.ErrorCode")/>
    @Override
    @DeleteMapping
    public ResponseEntity<Integer> deleteBatch(@RequestBody ${this.type}[] id) {
        <@call this.addImport("org.apache.commons.lang3.ArrayUtils")/>
        if(ArrayUtils.isEmpty(id)){
            throw new BusinessException(ErrorCode.PARAM_IS_NULL);
        }
        int count = ${this.className}Service.delete(id);
        return ResponseEntity.ok(count);
    }

</#if>
<#list this.holds! as otherEntity,mtm>
    <#assign otherPk=otherEntity.pkField>
    <#assign otherCName=otherEntity.className?capFirst>
    <#assign othercName=otherEntity.className?uncapFirst>
    <#assign otherFkId=mtm.getFkAlias(otherEntity.entityId,false)>
    <#assign entityFeature=mtm.getEntityFeature(this.entityId)>
    <#if entityFeature.addRemove || entityFeature.set>
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${this.packageName}.pojo.po.${otherCName}PO")/>
        <@call this.addImport("${this.packageName}.pojo.po.${this.classNameUpper}PO")/>
        <#assign index=getMtmCascadeEntityIndexForShow(otherEntity.entityId)>
        <#--如果存在级联扩展，则返回值为级联扩展VO-->
        <#if entityFeature.addRemove>
            <@call this.addImport("${this.packageName}.pojo.vo.${otherCName}ListVO")/>
            <#assign resultType="${otherCName}ListVO">
        <#elseIf index &gt; -1>
            <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ShowVO")/>
            <#assign resultType="${this.classNameUpper}ShowVO.${otherCName}VO">
        <#else>
            <#assign resultType=otherPk.jfieldType>
        </#if>
    @Override
    @GetMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<List<${resultType}>> fetch${otherCName}List(@PathVariable ${this.type} ${this.id}) {
        <#assign withFalseCode="">
        <#list this.holds! as otherHoldEntity,mtm>
            <#if otherEntity == otherHoldEntity>
                <#assign withCode=withFalseCode+"true, ">
            <#else>
                <#assign withCode=withFalseCode+"false, ">
            </#if>
        </#list>
        ${this.classNameUpper}PO ${this.className} = ${this.className}Service.get${this.classNameUpper}(${this.id}, ${withCode}true);
        List<${otherCName}PO> list = ${this.className}.get${otherCName}POList();
        <#if entityFeature.addRemove>
            <@call this.addImport("${this.packageName}.pojo.mapper.${otherCName}Mapper")/>
        return ResponseEntity.ok(${otherCName}Mapper.INSTANCE.toListVOList(list));
        <#elseIf index &gt; -1>
            <@call this.addImport("${this.packageName}.pojo.mapper.${otherCName}Mapper")/>
        return ResponseEntity.ok(${otherCName}Mapper.INSTANCE.to${otherCName}VOFor${this.classNameUpper}Show(list));
        <#else>
            <@call this.addImport("java.util.stream.Collectors")/>
        return ResponseEntity.ok(list.stream()
                .map(t -> t.get${otherPk.jfieldName?capFirst}())
                .collect(Collectors.toList()));
        </#if>
    }

    </#if>
    <#if entityFeature.addRemove>
        <@call this.addImport("${this.packageName}.pojo.vo.${otherCName}ListVO")/>
    @Override
    @PostMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<Integer> add${otherCName}(@PathVariable ${this.type} ${this.id},
                        @RequestBody ${otherPk.jfieldType}[] ${otherFkId}) {
        int count = ${this.className}Service.add${otherCName}(${this.id}, ${otherFkId});
        return ResponseEntity.ok(count);
    }

    @Override
    @DeleteMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<Integer> remove${otherCName}(@PathVariable ${this.type} ${this.id},
                        @RequestBody ${otherPk.jfieldType}[] ${otherFkId}) {
        int count = ${this.className}Service.remove${otherCName}(${this.id}, ${otherFkId});
        return ResponseEntity.ok(count);
    }

    <#elseIf entityFeature.set>
    @Override
    @PutMapping(value = "/{${this.id}}/${othercName}")
    public ResponseEntity<Integer> set${otherCName}(@PathVariable ${this.type} ${this.id},
        @RequestBody ${otherPk.jfieldType}[] ${otherFkId}) {
        int count = ${this.className}Service.set${otherCName}(${this.id}, ${otherFkId});
        return ResponseEntity.ok(count);
    }

    </#if>
</#list>
<#if this.entityFeature.excelExport>
    @Override
    @GetMapping("/export")
    <@call this.addImport("${this.packageName}.pojo.qo.${this.classNameUpper}QO")/>
    <@call this.addImport("javax.servlet.http.HttpServletResponse")/>
    public void exportExcel(@Valid ${this.classNameUpper}QO ${this.className}QO, HttpServletResponse response) throws Exception {
    <@call this.addImport("java.util.List")/>
    <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ListVO")/>
    <#if this.pageSign>
        ${this.className}QO.setPageSize(Integer.MAX_VALUE);
        ${this.className}QO.setPageNo(1);
        List<${this.classNameUpper}ListVO> list = ${this.className}Service.list(${this.className}QO).getList();
    <#else>
        List<${this.classNameUpper}ListVO> list = ${this.className}Service.list(${this.className}QO);
    </#if>
        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding("utf-8");
        <@call this.addImport("java.net.URLEncoder")/>
        String fileName = URLEncoder.encode("${this.title}导出", "utf-8");
        response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xlsx");
        <@call this.addImport("com.alibaba.excel.EasyExcel")/>
        <@call this.addImport("${this.packageName}.pojo.vo.${this.classNameUpper}ExcelVO")/>
        EasyExcel.write(response.getOutputStream(), ${this.classNameUpper}ExcelVO.class)
                .sheet()
                <@call this.addImport("${this.packageName}.pojo.mapper.${this.classNameUpper}Mapper")/>
                .doWrite(${this.classNameUpper}Mapper.INSTANCE.toExcelVOList(list));
    }

</#if>
<#if this.entityFeature.excelImport>
    @Override
    @PostMapping("/import")
    <@call this.addImport("org.springframework.web.multipart.MultipartFile")/>
    public ResponseEntity<Integer> importExcel(@RequestParam(value = "file") MultipartFile file) throws Exception {
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}AddDTO")/>
        <@call this.addImport("com.alibaba.excel.EasyExcel")/>
        List<${this.classNameUpper}AddDTO> list = EasyExcel.read(file.getInputStream())
                <@call this.addImport("${this.packageName}.pojo.dto.${this.classNameUpper}ExcelDTO")/>
                .head(${this.classNameUpper}ExcelDTO.class)
                .sheet()
                .headRowNumber(3)
                .<${this.classNameUpper}ExcelDTO>doReadSync()
                .stream()
                <@call this.addImport("${this.packageName}.pojo.mapper.${this.classNameUpper}Mapper")/>
                .map(${this.classNameUpper}Mapper.INSTANCE::fromExcelDTO)
                .peek(${this.className}AddDTO -> {
                    // 校验数据
                    <@call this.addImport("java.util.Set")/>
                    <@call this.addImport("javax.validation.ConstraintViolation")/>
                    Set<ConstraintViolation<${this.classNameUpper}AddDTO>> set = validator.validate(${this.className}AddDTO);
                    if (!set.isEmpty()) {
                        <@call this.addImport("javax.validation.ConstraintViolationException")/>
                        throw new ConstraintViolationException(set);
                    }
                })
                <@call this.addImport("java.util.stream.Collectors")/>
                .collect(Collectors.toList());
        int count = ${this.className}Service.batchSave(list);
        return ResponseEntity.ok(count);
    }

    <#assign dicSet = CommonTemplateFunction.createHashSet()>
    <#list this.insertFields as id,field>
        <#if field.dicType??>
            <@justCall dicSet.add(field.dicType)/>
        </#if>
    </#list>
    @Override
    @GetMapping("/template")
    <@call this.addImport("javax.servlet.http.HttpServletResponse")/>
    public void downloadExcelTemplate(HttpServletResponse response) throws Exception {
        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding("utf-8");
        <@call this.addImport("java.util.Date")/>
        <@call this.addImport("${this.commonPackage}.util.DateUtil")/>
        String title = "${this.title}导入模板(" + DateUtil.getDateStr(new Date()) + ")";
        <@call this.addImport("java.net.URLEncoder")/>
        String fileName = URLEncoder.encode(title, "utf-8");
        response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xlsx");
        String[] description = new String[]{
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
        };
        <#list dicSet as dic>
            <@call this.addImport("java.util.Arrays")/>
            <@call this.addConstImport(dic)/>
        String[] ${dic?uncapFirst}Constraint = Arrays.stream(${dic}.values()).map(${dic}::getDesc).toArray(String[]::new);
        </#list>
        <@call this.addImport("com.alibaba.excel.ExcelWriter")/>
        ExcelWriter excelWriter = EasyExcel.write(response.getOutputStream())
        <#list this.insertFields as id,field>
            <#if field.dicType??>
                <@call this.addImport("${this.packageName}.excel.handler.ConstConstraintHandler")/>
                .registerWriteHandler(new ConstConstraintHandler(${field.dicType?uncapFirst}Constraint, 3, 3, ${field?index}, ${field?index}))
            </#if>
        </#list>
                // 第一行是标题，第二行是说明
                <@call this.addImport("${this.packageName}.excel.handler.TitleDescriptionWriteHandler")/>
                .registerWriteHandler(new TitleDescriptionWriteHandler(title, description, ${this.classNameUpper}ExcelDTO.class))
                // 自定义模板单元格样式
                <@call this.addImport("${this.packageName}.excel.handler.TemplateCellStyleStrategy")/>
                .registerWriteHandler(new TemplateCellStyleStrategy())
                .build();
        <@call this.addImport("com.alibaba.excel.write.metadata.WriteSheet")/>
        WriteSheet writeSheet = EasyExcel.writerSheet(0, "Sheet1")
                .head(${this.classNameUpper}ExcelDTO.class)
                // 从第三行开始写表头
                .relativeHeadRowIndex(2)
                .build();
        excelWriter.write(Arrays.asList(${this.classNameUpper}ExcelDTO.example()), writeSheet);

        excelWriter.finish();
    }

</#if>
}

</#assign>
<#--开始渲染代码-->
package ${this.packageName}.web.rest;

<@call this.printImport()/>

${code}
