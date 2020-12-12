<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.fasterxml.jackson.core.JsonParser")/>
<@call this.addImport("com.fasterxml.jackson.databind.BeanProperty")/>
<@call this.addImport("com.fasterxml.jackson.databind.DeserializationContext")/>
<@call this.addImport("com.fasterxml.jackson.databind.JsonDeserializer")/>
<@call this.addImport("com.fasterxml.jackson.databind.JsonMappingException")/>
<@call this.addImport("com.fasterxml.jackson.databind.deser.ContextualDeserializer")/>
<@call this.addImport("com.fasterxml.jackson.databind.deser.std.StdScalarDeserializer")/>
<@call this.addImport("com.fasterxml.jackson.databind.deser.std.StringDeserializer")/>
<@call this.addImport("com.fasterxml.jackson.databind.jsontype.TypeDeserializer")/>
<@call this.addImport("java.io.IOException")/>
<@call this.printClassCom("jackson防XSS反序列化器")/>
public class JacksonXSSDeserializer extends StdScalarDeserializer<String> implements ContextualDeserializer {

    public JacksonXSSDeserializer() {
        super(String.class);
    }

    @Override
    public JsonDeserializer<?> createContextual(DeserializationContext ctxt, BeanProperty property) throws JsonMappingException {
        if (property != null) {
            IgnoreXSS annotation = property.getAnnotation(IgnoreXSS.class);
            if (annotation != null) {
                return StringDeserializer.instance;
            }
        }
        return this;
    }

    @Override
    public String deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String value = StringDeserializer.instance.deserialize(p, ctxt);
        return XSSUtil.clean(value);
    }

    @Override
    public String deserializeWithType(JsonParser jp, DeserializationContext ctxt, TypeDeserializer typeDeserializer) throws IOException {
        String value = StringDeserializer.instance.deserializeWithType(jp, ctxt, typeDeserializer);
        return XSSUtil.clean(value);
    }

    @Override
    public boolean isCachable() {
        return StringDeserializer.instance.isCachable();
    }

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".xss")/>

${code}
