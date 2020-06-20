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
<@call this.addImport("${voPackageName}.${this.chartName}VO")/>
<@call this.addImport("javax.validation.Valid")/>
<@call this.printClassCom("【${this.title}】图表控制器")/>
@RestController
@RequestMapping(${renderApiPathForChart(this.chart, "")})
public class ${this.chartName}Controller extends AbstractController implements ${this.chartName}API {

    @Autowired
    private ${this.chartName}Service ${this.chartNameLower}Service;

<#if isChartType(ChartType.DETAIL_LIST) || isChartType(ChartType.AGG_TABLE)>
    @Override
    @GetMapping
    <@call this.addImport("${this.commonPackage}.pojo.vo.PageVO")/>
    public ResponseEntity<PageVO<${this.chartName}VO>> findList(@Valid ${this.chartName}QO qo) {
        PageVO<${this.chartName}VO> page = ${this.chartNameLower}Service.findList(qo);
        return ResponseEntity.ok(page);
    }
<#else>
    @Override
    @GetMapping
    <@call this.addImport("java.util.List")/>
    public ResponseEntity<List<${this.chartName}VO>> findChartData(@Valid ${this.chartName}QO qo) {
        List<${this.chartName}VO> list = ${this.chartNameLower}Service.findChartData(qo);
        return ResponseEntity.ok(list);
    }
</#if>

}

</#assign>
<#--开始渲染代码-->
package ${restPackageName};

<@call this.printImport()/>

${code}
