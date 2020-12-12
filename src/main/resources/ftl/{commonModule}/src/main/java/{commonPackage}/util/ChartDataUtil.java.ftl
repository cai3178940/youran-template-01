<#include "/abstracted/common.ftl">
<#if !hasChart>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.vo.Chart2DimensionVO")/>
<@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
<@call this.addImport("java.util.*")/>
<@call this.addImport("java.util.function.BiConsumer")/>
<@call this.addImport("java.util.function.BinaryOperator")/>
<@call this.addImport("java.util.function.Function")/>
<@call this.addImport("java.util.function.Supplier")/>
<@call this.addImport("java.util.stream.Collector")/>
<@call this.addImport("java.util.stream.Collectors")/>
<@call this.printClassCom("图表数据工具类")/>
public class ChartDataUtil {

    /**
     * 获取列表数据中某个字段的所有可能值
     *
     * @param chartVOList
     * @param getter
     * @param <T>
     * @param <R>
     * @return
     */
    public static <T, R> List<R> getDistinctValues(List<T> chartVOList,
                                                   Function<T, R> getter) {
        if (CollectionUtils.isEmpty(chartVOList)) {
            return Collections.emptyList();
        }
        return chartVOList.stream()
                .map(getter)
                .filter(v -> v != null)
                .distinct()
                .collect(Collectors.toList());
    }


    /**
     * 将具有两个维度值的数据列表转换成二维矩阵
     *
     * @param chartVOList      列表数据
     * @param dimension2Values 第二维度的所有可能值
     * @return
     */
    public static <T extends Chart2DimensionVO> List<Object[]> convert2DimensionMetrix(List<T> chartVOList,
                                                                                       List<Object> dimension2Values) {
        if (CollectionUtils.isEmpty(chartVOList)) {
            return Collections.emptyList();
        }
        // 转换
        return chartVOList.stream()
                .filter(v -> v != null)
                .collect(new Collector<T, Map<Object, Object[]>, List<Object[]>>() {
                    @Override
                    public Supplier<Map<Object, Object[]>> supplier() {
                        return HashMap::new;
                    }

                    @Override
                    public BiConsumer<Map<Object, Object[]>, T> accumulator() {
                        return (map, vo) -> map.compute(vo.fetchDimension1(), (key, array) -> {
                            if (array == null) {
                                array = new Object[dimension2Values.size() + 1];
                                array[0] = key;
                            }
                            int index = dimension2Values.indexOf(vo.fetchDimension2());
                            array[index + 1] = vo.fetchMetrics();
                            return array;
                        });
                    }

                    @Override
                    public BinaryOperator<Map<Object, Object[]>> combiner() {
                        return (map1, map2) -> {
                            HashMap<Object, Object[]> map = new HashMap<>(map1);
                            map2.forEach((key, value) -> map.merge(key, value, (arr1, arr2) -> {
                                Object[] merger = new Object[dimension2Values.size() + 1];
                                merger[0] = arr1[0];
                                for (int i = 1; i < merger.length; i++) {
                                    merger[i] = arr1[i] == null ? arr2[i] : arr1[i];
                                }
                                return merger;
                            }));
                            return map;
                        };
                    }

                    @Override
                    public Function<Map<Object, Object[]>, List<Object[]>> finisher() {
                        return map -> map.values().stream().collect(Collectors.toList());
                    }

                    @Override
                    public Set<Characteristics> characteristics() {
                        return Collections.emptySet();
                    }
                });
    }

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".util")/>

${code}
