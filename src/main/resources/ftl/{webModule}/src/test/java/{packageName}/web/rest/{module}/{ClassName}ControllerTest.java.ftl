<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#include "/abstracted/checkFeatureForRest.ftl">
<#--判断如果不需要生成当前文件，则直接跳过-->
<#if !getGenRest(this.metaEntity)>
    <@call this.skipCurrent()/>
</#if>
<@call this.addImport("${this.commonPackage}.util.JsonUtil")/>
<@call this.addImport("${helpPackageName}.${this.className}Helper")/>
<@call this.addImport("${poPackageName}.${this.className}PO")/>
<@call this.addImport("${this.packageName}.web.AbstractWebTest")/>
<@call this.addImport("${this.packageName}.web.constant.WebConst")/>
<@call this.addImport("org.junit.jupiter.api.Test")/>
<@call this.addImport("org.junit.jupiter.api.DisplayName")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Autowired")/>
<@call this.addImport("org.springframework.http.MediaType")/>
<@call this.addStaticImport("org.hamcrest.Matchers.is")/>
<@call this.addStaticImport("org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*")/>
<@call this.addStaticImport("org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath")/>
<@call this.addStaticImport("org.springframework.test.web.servlet.result.MockMvcResultMatchers.status")/>
<#--获取保存Example的代码-->
<#assign saveExampleCode = this.getPrintingSaveExample()/>
<#--定义方法区代码-->
<#assign methodCode>
<#if this.entityFeature.save>
    @Test
    @DisplayName("新增【${this.title}】")
    public void save() throws Exception {
    <#list saveExampleCode as saveExample>
        <#if saveExample?hasNext>
        ${saveExample}
        </#if>
    </#list>
        <@call this.addImport("${dtoPackageName}.${this.className}AddDTO")/>
        ${this.className}AddDTO addDTO = ${this.classNameLower}Helper.get${this.className}AddDTO(<@call this.printSaveExampleArg(this.metaEntity)/>);
        restMockMvc.perform(post(${renderApiPath(this.metaEntity, "")})
                .contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJSONString(addDTO)))
                .andExpect(status().isCreated());
    }

</#if>
<#if this.entityFeature.update>
    @Test
    @DisplayName("修改【${this.title}】")
    public void update() throws Exception {
        <#list saveExampleCode as saveExample>
        ${saveExample}
        </#list>
        <@call this.addImport("${dtoPackageName}.${this.className}UpdateDTO")/>
        ${this.className}UpdateDTO updateDTO = ${this.classNameLower}Helper.get${this.className}UpdateDTO(${this.classNameLower});
        restMockMvc.perform(put(${renderApiPath(this.metaEntity, "")})
                .contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJSONString(updateDTO)))
                .andExpect(status().isOk());
    }

</#if>
<#if this.entityFeature.list>
    @Test
    <#if this.pageSign>
    @DisplayName("分页查询【${this.title}】")
    <#else>
    @DisplayName("列表查询【${this.title}】")
    </#if>
    public void list() throws Exception {
    <#list saveExampleCode as saveExample>
        ${saveExample}
    </#list>
        restMockMvc.perform(get(${renderApiPath(this.metaEntity, "")}))
                .andExpect(status().isOk())
    <#if this.pageSign>
                .andExpect(jsonPath("$.list.length()").value(is(1)));
    <#else>
                .andExpect(jsonPath("$.length()").value(is(1)));
    </#if>
    }

</#if>
<#if this.titleField??>
    @Test
    @DisplayName("查询【${this.title}】选项列表")
    public void findOptions() throws Exception {
    <#list saveExampleCode as saveExample>
        ${saveExample}
    </#list>
        restMockMvc.perform(get(${renderApiPath(this.metaEntity, "/options")}))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(is(1)));
    }

</#if>
<#if this.entityFeature.show>
    @Test
    @DisplayName("查看【${this.title}】详情")
    public void show() throws Exception {
    <#list saveExampleCode as saveExample>
        ${saveExample}
    </#list>
        restMockMvc.perform(get(${renderApiPath(this.metaEntity, "/{${this.id}}")}, ${this.classNameLower}.get${this.idUpper}()))
                .andExpect(status().isOk());
    }

</#if>
<#if this.entityFeature.delete>
    @Test
    @DisplayName("删除单个【${this.title}】")
    public void del() throws Exception {
    <#list saveExampleCode as saveExample>
        ${saveExample}
    </#list>
        restMockMvc.perform(delete(${renderApiPath(this.metaEntity, "/{${this.id}}")}, ${this.classNameLower}.get${this.idUpper}()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(is(1)));
    }

</#if>
<#if this.entityFeature.deleteBatch>
    <@call this.addImport("com.google.common.collect.Lists")/>
    @Test
    @DisplayName("批量删除【${this.title}】")
    public void deleteBatch() throws Exception {
    <#list saveExampleCode as saveExample>
        ${saveExample}
    </#list>
        restMockMvc.perform(delete(${renderApiPath(this.metaEntity, "")})
                .contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJSONString(Lists.newArrayList(${this.classNameLower}.get${this.idUpper}()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(is(1)));
    }

</#if>
<#if this.entityFeature.excelExport>
    @Test
    @DisplayName("导出【${this.title}】excel")
    <@call this.addImport("org.junit.jupiter.api.TestReporter")/>
    public void exportExcel(TestReporter testReporter) throws Exception {
    <#list saveExampleCode as saveExample>
        ${saveExample}
    </#list>
        <@call this.addImport("org.springframework.test.web.servlet.MvcResult")/>
        MvcResult mvcResult = restMockMvc.perform(get(${renderApiPath(this.metaEntity, "/export")}))
                .andExpect(status().isOk())
                .andReturn();
        <@call this.addImport("org.springframework.mock.web.MockHttpServletResponse")/>
        MockHttpServletResponse response = mvcResult.getResponse();
        <@call this.addImport("${this.commonPackage}.util.TempDirUtil")/>
        String outFile = TempDirUtil.getTmpDir(null, true, true) + ".xlsx";
        // 写入临时文件
        <@call this.addImport("org.apache.commons.io.FileUtils")/>
        <@call this.addImport("java.io.File")/>
        FileUtils.writeByteArrayToFile(new File(outFile), response.getContentAsByteArray());
        // 输出导出路径，手动查看导出文件是否正确
        testReporter.publishEntry("导出路径", outFile);
    }

</#if>
<#if this.entityFeature.excelImport>
    @Test
    @DisplayName("导入【${this.title}】excel")
    public void importExcel() throws Exception {
        <@call this.addImport("org.springframework.test.web.servlet.MvcResult")/>
        // 首先下载excel模板
        MvcResult mvcResult = restMockMvc.perform(get(${renderApiPath(this.metaEntity, "/template")}))
                .andExpect(status().isOk())
                .andReturn();
        <@call this.addImport("org.springframework.mock.web.MockHttpServletResponse")/>
        MockHttpServletResponse response = mvcResult.getResponse();

        <@call this.addImport("org.springframework.mock.web.MockMultipartFile")/>
        // 将模板原封不动导入
        MockMultipartFile file = new MockMultipartFile("file", response.getContentAsByteArray());
        restMockMvc.perform(multipart(${renderApiPath(this.metaEntity, "/import")})
                .file(file))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(is(1)));
    }

</#if>
<#list this.holds! as otherEntity, mtm>
    <#assign otherPk = otherEntity.pkField>
    <#assign otherCName = otherEntity.className>
    <#assign othercName = lowerFirstWord(otherEntity.className)>
    <#assign otherFkId = mtm.getFkAlias(otherEntity.entityId, false)>
    <#assign entityFeature = mtm.getEntityFeature(this.entityId)>
    <#--保存多对多Example的代码块-->
    <#assign saveMtmExampleCode = ""/>
    <#if entityFeature.addRemove || entityFeature.set>
        <#assign saveMtmExampleCode = this.getPrintingSaveExampleForMtm(otherEntity)/>
    </#if>
    <#--测试多对多的“添加/移除”功能-->
    <#if entityFeature.addRemove>
        <@call this.addImport("com.google.common.collect.Lists")/>
    @Test
    @DisplayName("添加/移除【${otherEntity.title}】关联")
    public void addRemove${otherCName}2() throws Exception {
        <#list saveMtmExampleCode as saveExample>
        ${saveExample}
        </#list>
        // 先测试添加【${otherEntity.title}】关联
        restMockMvc.perform(post(${renderApiPath(this.metaEntity, "/{${this.id}}/${othercName}")},
                ${this.classNameLower}.get${this.idUpper}())
                .contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJSONString(Lists.newArrayList(${othercName}.get${otherPk.jfieldName?capFirst}()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(is(1)));
        // 再测试查询【${otherEntity.title}】关联
        restMockMvc.perform(get(${renderApiPath(this.metaEntity, "/{${this.id}}/${othercName}")},
                ${this.classNameLower}.get${this.idUpper}()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(is(1)));
        // 最后测试移除【${otherEntity.title}】关联
        restMockMvc.perform(delete(${renderApiPath(this.metaEntity, "/{${this.id}}/${othercName}")},
                ${this.classNameLower}.get${this.idUpper}())
                .contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJSONString(Lists.newArrayList(${othercName}.get${otherPk.jfieldName?capFirst}()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(is(1)));
    }

    </#if>
    <#--测试多对多的“设置”功能-->
    <#if entityFeature.set>
        <@call this.addImport("com.google.common.collect.Lists")/>
    @Test
    @DisplayName("设置【${otherEntity.title}】关联")
    public void set${otherCName}() throws Exception {
        <#list saveMtmExampleCode as saveExample>
        ${saveExample}
        </#list>
        // 先测试设置【${otherEntity.title}】关联
        restMockMvc.perform(put(${renderApiPath(this.metaEntity, "/{${this.id}}/${othercName}")},
                ${this.classNameLower}.get${this.idUpper}())
                .contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJSONString(Lists.newArrayList(${othercName}.get${otherPk.jfieldName?capFirst}()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").value(is(1)));
        // 再测试查询【${otherEntity.title}】关联
        restMockMvc.perform(get(${renderApiPath(this.metaEntity, "/{${this.id}}/${othercName}")},
                ${this.classNameLower}.get${this.idUpper}()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(is(1)));
    }

    </#if>
</#list>
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(restPackageName)/>

<@call this.printClassCom("【${this.title}】单元测试")/>
@DisplayName("【${this.title}】Controller")
public class ${this.className}ControllerTest extends AbstractWebTest {

<@call this.printAutowired()/>


${methodCode}
}
