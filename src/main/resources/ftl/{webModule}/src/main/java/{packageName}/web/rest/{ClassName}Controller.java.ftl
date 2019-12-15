<#include "/abstracted/common.ftl">
<#include "/abstracted/checkFeatureForRest.ftl">
<#include "/abstracted/mtmCascadeExtsForShow.ftl">
<#--判断如果不需要生成当前文件，则直接跳过-->
<#if !getGenRest(this.metaEntity)>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.web.constant.WebConst")/>
<@call this.addImport("${this.packageName}.web.AbstractController")/>
<@call this.addImport("${this.packageName}.web.api.${this.classNameUpper}API")/>
<@call this.addImport("org.apache.commons.lang3.ArrayUtils")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Autowired")/>
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
        return ResponseEntity.created(new URI(WebConst.API_PATH +"/${this.className}/" + ${this.className}.get${this.idUpper}()))
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
                .map(t -> t.get${otherEntity.pkField.jfieldName?capFirst}())
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

}

</#assign>
<#--开始渲染代码-->
package ${this.packageName}.web.rest;

<@call this.printImport()/>

${code}
