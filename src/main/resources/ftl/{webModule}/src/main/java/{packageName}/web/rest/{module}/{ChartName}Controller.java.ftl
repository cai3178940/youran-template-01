<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForChart.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.web.AbstractController")/>
<@call this.addImport("${apiPackageName}.${this.chartName}API")/>
<@call this.addImport("${servicePackageName}.${this.chartName}Service")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Autowired")/>
<@call this.addImport("org.springframework.web.bind.annotation.*")/>
<@call this.addImport("org.springframework.http.ResponseEntity")/>
<@call this.addImport("${qoPackageName}.${this.chartName}QO")/>
<@call this.addImport("javax.validation.Valid")/>
<@call this.printClassCom("【${this.title}】图表控制器")/>
@RestController
@RequestMapping(${renderApiPathForChart(this.chart, "")})
public class ${this.chartName}Controller extends AbstractController implements ${this.chartName}API {

    @Autowired
    private ${this.chartName}Service ${this.chartNameLower}Service;

<#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>
    <@call this.addImport("${voPackageName}.${this.chartName}VO")/>
    @Override
    @GetMapping
    <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    public ResponseEntity<PageVO<${this.chartName}VO>> findList(@Valid ${this.chartName}QO qo) {
        PageVO<${this.chartName}VO> page = ${this.chartNameLower}Service.findList(qo);
        return ResponseEntity.ok(page);
    }

    <#if this.excelExport>
        <@call this.addImport("javax.servlet.http.HttpServletResponse")/>
        <@call this.addImport("com.alibaba.excel.EasyExcel")/>
        <@call this.addImport("java.net.URLEncoder")/>
        <@call this.addImport("java.util.List")/>
        <@call this.addImport("${mapperPackageName}.${this.chartName}Mapper")/>
        <@call this.addImport("${voPackageName}.${this.chartName}ExcelVO")/>
    @Override
    @GetMapping("/export")
    public void exportExcel(@Valid ${this.chartName}QO qo, HttpServletResponse response) throws Exception {
        qo.setPageSize(Integer.MAX_VALUE);
        qo.setPageNo(1);
        List<${this.chartName}VO> list = ${this.chartNameLower}Service.findList(qo).getList();
        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("${this.title}", "utf-8");
        response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), ${this.chartName}ExcelVO.class)
                .sheet()
                .doWrite(${this.chartName}Mapper.INSTANCE.toExcelVOList(list));
    }
    </#if>
<#else>
    @Override
    @GetMapping
    <@call this.addImport("java.util.List")/>
    public ResponseEntity<List<Object[]>> findChartData(@Valid ${this.chartName}QO qo) {
        List<Object[]> list = ${this.chartNameLower}Service.findChartData(qo);
        return ResponseEntity.ok(list);
    }
</#if>

}

</#assign>
<#--开始渲染代码-->
package ${restPackageName};

<@call this.printImport()/>

${code}
