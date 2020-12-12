<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.validator.Check")/>
<@call this.addImport("java.util.HashMap")/>
<@call this.addImport("java.util.Map")/>
<@call this.printClassCom("枚举【${this.remark}】")/>
public enum ${this.constNameUpper} {

<#assign allValuesStr = "">
<#list this.detailList as detail>
    <#if this.constType == MetaConstType.INTEGER>
        <#assign valueStr>${detail.detailValue}</#assign>
    <#elseIf this.constType == MetaConstType.STRING>
        <#assign valueStr>"${detail.detailValue}"</#assign>
    </#if>
    <#if detail?hasNext>
        <#assign allValuesStr += detail.detailValue + ",">
    <#else>
        <#assign allValuesStr += detail.detailValue>
    </#if>
    /**
     * ${detail.detailRemark}
     */
    ${detail.detailName}(${valueStr}, "${detail.detailRemark}"),
</#list>
    ;


    /**
     * 枚举值罗列，给swagger接口文档展示用
     */
    public static final String VALUES_STR = "${allValuesStr}";

    private static final Map<${this.constTypeStr}, ${this.constNameUpper}> LOOKUP = new HashMap<>();

    static {
        for (${this.constNameUpper} e : ${this.constNameUpper}.values()) {
            LOOKUP.put(e.value, e);
        }
    }

    private final ${this.constTypeStr} value;
    private final String desc;


    ${this.constNameUpper}(${this.constTypeStr} value, String desc) {
        this.value = value;
        this.desc = desc;
    }

    public static ${this.constNameUpper} find(${this.constTypeStr} value) {
        return LOOKUP.get(value);
    }

    public static ${this.constNameUpper} findByDesc(String desc) {
        for (${this.constNameUpper} e : ${this.constNameUpper}.values()) {
            if (e.getDesc().equals(desc)) {
                return e;
            }
        }
        return null;
    }


    /**
     * desc映射value
     *
     * @param desc
     * @return
     */
    public static ${this.constTypeStr} descToValue(String desc) {
        ${this.constNameUpper} theEnum = findByDesc(desc);
        if (theEnum != null) {
            return theEnum.getValue();
        }
        return null;
    }

    /**
     * value映射desc
     *
     * @param value
     * @return
     */
    public static String valueToDesc(${this.constTypeStr} value) {
        ${this.constNameUpper} theEnum = find(value);
        if (theEnum != null) {
            return theEnum.getDesc();
        }
        return null;
    }

    /**
     * 校验有效性
     */
    @Check
    public static final boolean validate(${this.constTypeStr} value) {
        ${this.constNameUpper} theEnum = find(value);
        return theEnum != null;
    }

    public ${this.constTypeStr} getValue() {
        return value;
    }

    public String getDesc() {
        return desc;
    }


}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.constant;

<@call this.printImport()/>

${code}
