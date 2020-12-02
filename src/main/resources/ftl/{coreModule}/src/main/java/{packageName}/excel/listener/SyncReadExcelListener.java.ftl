<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.alibaba.excel.context.AnalysisContext")/>
<@call this.addImport("com.alibaba.excel.event.AnalysisEventListener")/>
<@call this.addImport("com.alibaba.excel.read.metadata.holder.ReadRowHolder")/>
<@call this.addImport("com.jd.y.ss.price.sale.pojo.dto.AbstractExcelDTO")/>
<@call this.addImport("java.util.ArrayList")/>
<@call this.addImport("java.util.List")/>
<@call this.printClassCom("同步读取excel的监听器")/>
public class SyncReadExcelListener<T extends AbstractExcelDTO> extends AnalysisEventListener<T> {

    private final List<T> list = new ArrayList<>();

    @Override
    public void invoke(T data, AnalysisContext context) {
        ReadRowHolder rowHolder = context.readRowHolder();
        data.setRowIndex(rowHolder.getRowIndex());
        list.add(data);
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {

    }

    public List<T> getList() {
        return list;
    }
}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.excel.listener;

<@call this.printImport()/>

${code}
