<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.util.DateUtil")/>
<@call this.addImport("org.springframework.util.StringUtils")/>
<@call this.addImport("java.beans.PropertyEditorSupport")/>
<@call this.addImport("java.time.LocalDateTime")/>
<@call this.printClassCom("自定义日期装换")/>
public class MyCustomLocalDateTimeEditor extends PropertyEditorSupport {


    @Override
    public String getAsText() {
        LocalDateTime value = (LocalDateTime) getValue();
        return DateUtil.getLocalDateTimeStr(value);
    }

    @Override
    public void setAsText(String text) throws IllegalArgumentException {
        if (!StringUtils.hasText(text)) {
            // Treat empty String as null value.
            setValue(null);
        } else {
            setValue(DateUtil.parseLocalDateTime(text));
        }
    }


}

</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".convert")/>

${code}
