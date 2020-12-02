<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.google.common.base.Function")/>
<@call this.addImport("com.google.common.base.Joiner")/>
<@call this.addImport("com.google.common.base.Splitter")/>
<@call this.addImport("com.google.common.collect.Iterables")/>
<@call this.addImport("com.google.common.collect.Lists")/>
<@call this.addImport("org.apache.commons.lang3.StringUtils")/>
<@call this.addImport("java.util.List")/>
<@call this.addImport("java.util.Map")/>
<@call this.printClassCom("各种形式的转换工具类")/>
public class ConvertUtil {

    /**
     * 整型数组转字符串
     *
     * @param array
     * @return
     */
    public static String convertIntegerArrayToString(Iterable<?> array) {
        if (array == null) {
            return null;
        }
        String join = Joiner.on(',').join(array);
        return join;
    }

    /**
     * 逗号分割字符串转换成字符串数组
     *
     * @param str
     * @return
     */
    public static String[] convertStringArray(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        Iterable<String> split = Splitter.on(',').omitEmptyStrings().split(str);
        return Iterables.toArray(split, String.class);
    }

    /**
     * 逗号分割字符串转换成字符串列表
     *
     * @param str
     * @return
     */
    public static List<String> convertStringList(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        List<String> list = Splitter.on(',').omitEmptyStrings().splitToList(str);
        return list;
    }

    /**
     * 逗号分割字符串转换成整数数组
     *
     * @param str
     * @return
     */
    public static Integer[] convertIntegerArray(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        Iterable<String> split = Splitter.on(',').omitEmptyStrings().split(str);
        Iterable<Integer> transform = Iterables.transform(split, SafeUtil::getInteger);
        return Iterables.toArray(transform, Integer.class);
    }

    /**
     * 逗号分割字符串转换成Double数组
     *
     * @param str
     * @return
     */
    public static Double[] convertDoubleArray(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        Iterable<String> split = Splitter.on(',').omitEmptyStrings().split(str);
        Iterable<Double> transform = Iterables.transform(split, SafeUtil::getDouble);
        return Iterables.toArray(transform, Double.class);
    }


    /**
     * 将map列表转换成单一数组
     *
     * @param list
     * @param key
     * @param clazz
     * @return
     */
    public static <T> T[] convertMapListToArray(List<Map<String, Object>> list, final String key, Class<T> clazz) {
        if (list == null) {
            return null;
        }
        return convertListToArray(list, input -> (T)input.get(key), clazz);
    }

    /**
     * 自定义转换器进行数组转换
     *
     * @param list
     * @param function
     * @param clazz
     * @return
     */
    public static <F, T> T[] convertListToArray(List<F> list, Function<F, T> function, Class<T> clazz) {
        if (list == null) {
            return null;
        }
        Iterable<T> transform = Iterables.transform(list, function);
        return Iterables.toArray(transform, clazz);
    }

    /**
     * 自定义转换器进行列表转换
     *
     * @param list
     * @param function
     * @return
     */
    public static <F, T> List<T> convertList(List<F> list, Function<F, T> function) {
        if (list == null) {
            return null;
        }
        List<T> transform = Lists.transform(list, function);
        return transform;
    }

    /**
     * 逗号分割字符串转换成整数列表
     *
     * @param str
     * @return
     */
    public static List<Integer> convertIntegerList(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        List<String> list = Splitter.on(',').omitEmptyStrings().splitToList(str);
        return Lists.transform(list, SafeUtil::getInteger);
    }

    /**
     * 逗号分割字符串转换成长整数列表
     *
     * @param str
     * @return
     */
    public static List<Long> convertLongList(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        List<String> list = Splitter.on(',').omitEmptyStrings().splitToList(str);
        return Lists.transform(list, SafeUtil::getLong);
    }


}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.util;

<@call this.printImport()/>

${code}
