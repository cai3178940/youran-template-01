<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.convert.MyCustomDateEditor")/>
<@call this.addImport("${this.commonPackage}.convert.MyCustomLocalDateEditor")/>
<@call this.addImport("${this.commonPackage}.convert.MyCustomLocalDateTimeEditor")/>
<@call this.addImport("org.springframework.web.bind.WebDataBinder")/>
<@call this.addImport("org.springframework.web.bind.annotation.InitBinder")/>
<@call this.addImport("java.util.Date")/>
<@call this.addImport("java.time.LocalDate")/>
<@call this.addImport("java.time.LocalDateTime")/>
<@call this.printClassCom("抽象controller")/>
public abstract class AbstractController {

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Date.class, new MyCustomDateEditor());
        binder.registerCustomEditor(LocalDate.class, new MyCustomLocalDateEditor());
        binder.registerCustomEditor(LocalDateTime.class, new MyCustomLocalDateTimeEditor());
    }

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.packageName + ".web")/>

${code}
