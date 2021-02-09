<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
<@call this.addImport("org.apache.commons.lang3.StringUtils")/>
<@call this.addImport("org.apache.commons.lang3.reflect.MethodUtils")/>
<@call this.addImport("org.slf4j.Logger")/>
<@call this.addImport("org.slf4j.LoggerFactory")/>
<@call this.addImport("javax.validation.Constraint")/>
<@call this.addImport("javax.validation.ConstraintValidator")/>
<@call this.addImport("javax.validation.ConstraintValidatorContext")/>
<@call this.addImport("javax.validation.Payload")/>
<@call this.addImport("java.lang.annotation.Documented")/>
<@call this.addImport("java.lang.annotation.Retention")/>
<@call this.addImport("java.lang.annotation.Target")/>
<@call this.addImport("java.lang.reflect.InvocationTargetException")/>
<@call this.addImport("java.lang.reflect.Method")/>
<@call this.addImport("java.util.List")/>
<@call this.addStaticImport("java.lang.annotation.ElementType.FIELD")/>
<@call this.addStaticImport("java.lang.annotation.ElementType.METHOD")/>
<@call this.addStaticImport("java.lang.annotation.RetentionPolicy.RUNTIME")/>
<@call this.printClassCom("自定义校验注解：常量校验" "校验常量值是否合法")/>
@Target({FIELD, METHOD})
@Retention(RUNTIME)
@Constraint(validatedBy = {Const.Checker.class})
@Documented
public @interface Const {

    String DEFAULT_MESSAGE = "{${this.commonPackage}.validator.Const}";

    Class constClass();

    String message() default DEFAULT_MESSAGE;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    class Checker implements ConstraintValidator<Const, Object> {

        private static final Logger logger = LoggerFactory.getLogger(Checker.class);

        private Class constClass;
        private Method checkMethod;
        private String defaultMsg;

        @Override
        public void initialize(Const constAnnotation) {
            this.constClass = constAnnotation.constClass();
            List<Method> checkMethods = MethodUtils.getMethodsListWithAnnotation(this.constClass, Check.class);
            if (CollectionUtils.isNotEmpty(checkMethods)) {
                this.checkMethod = checkMethods.get(0);
            }
            if (this.checkMethod != null && DEFAULT_MESSAGE.equals(constAnnotation.message())) {
                Check check = this.checkMethod.getAnnotation(Check.class);
                this.defaultMsg = check.message();
            }
        }

        @Override
        public boolean isValid(Object value, ConstraintValidatorContext context) {
            if (value == null) {
                return true;
            }
            if (checkMethod == null) {
                return false;
            }
            boolean success = true;
            // 校验常量数组
            if (value.getClass().isArray()) {
                Object[] array = (Object[]) value;
                for (Object obj : array) {
                    success &= this.doValid(obj);
                    if (!success) {
                        break;
                    }
                }
            }
            // 校验常量集合
            else if (value instanceof Iterable) {
                Iterable iterable = (Iterable) value;
                for (Object obj : iterable) {
                    success &= this.doValid(obj);
                    if (!success) {
                        break;
                    }
                }
            }
            // 校验单个常量
            else {
                success = this.doValid(value);
            }
            if (!success && StringUtils.isNotBlank(defaultMsg)) {
                context.disableDefaultConstraintViolation();
                context.buildConstraintViolationWithTemplate(defaultMsg)
                        .addConstraintViolation();
            }
            return success;
        }

        /**
         * 单个常量值校验
         */
        private boolean doValid(Object value) {
            if (value == null) {
                return true;
            }
            try {
                Object result = checkMethod.invoke(null, value);
                if (result instanceof Boolean) {
                    return (Boolean) result;
                } else {
                    throw new RuntimeException("校验方法返回值类型必须是boolean");
                }
            } catch (IllegalAccessException e) {
                logger.error("自定义校验异常", e);
                throw new RuntimeException("自定义校验异常", e);
            } catch (InvocationTargetException e) {
                logger.error("自定义校验异常", e);
                throw new RuntimeException("自定义校验异常", e);
            }
        }

    }

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".validator")/>

${code}
