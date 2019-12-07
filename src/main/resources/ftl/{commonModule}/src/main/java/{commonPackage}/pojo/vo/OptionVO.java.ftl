<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("下拉框选项VO")/>
public class OptionVO<K, V> extends AbstractVO {

    private K key;

    private V value;

    public OptionVO(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public K getKey() {
        return key;
    }

    public void setKey(K key) {
        this.key = key;
    }

    public V getValue() {
        return value;
    }

    public void setValue(V value) {
        this.value = value;
    }

}
</#assign>
<#--开始渲染代码-->
package ${this.commonPackage}.pojo.vo;

${code}
