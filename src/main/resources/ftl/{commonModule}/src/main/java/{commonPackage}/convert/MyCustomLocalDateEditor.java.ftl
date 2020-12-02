<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.util.DateUtil")/>
<@call this.addImport("org.springframework.util.StringUtils")/>
<@call this.addImport("java.beans.PropertyEditorSupport")/>
<@call this.addImport("java.time.LocalDate")/>
<@call this.printClassCom("自定义日期装换")/>
public class MyCustomLocalDateEditor extends PropertyEditorSupport {


    @Override
    public String getAsText() {
        LocalDate value = (LocalDate) getValue();
        return DateUtil.getLocalDateStr(value);
    }

    @Override
    public void setAsText(String text) throws IllegalArgumentException {
        if (!StringUtils.hasText(text)) {
            // Treat empty String as null value.
            setValue(null);
        } else {
            setValue(DateUtil.parseLocalDate(text));
        }
    }


}

</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.convert;

<@call this.printImport()/>

${code}
