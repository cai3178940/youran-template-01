<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.alibaba.excel.metadata.Head")/>
<@call this.addImport("com.alibaba.excel.util.StyleUtil")/>
<@call this.addImport("com.alibaba.excel.write.metadata.style.WriteCellStyle")/>
<@call this.addImport("com.alibaba.excel.write.metadata.style.WriteFont")/>
<@call this.addImport("com.alibaba.excel.write.style.AbstractCellStyleStrategy")/>
<@call this.addImport("org.apache.poi.ss.usermodel.*")/>
<@call this.printClassCom("excel模板单元格样式策略")/>
public class TemplateCellStyleStrategy extends AbstractCellStyleStrategy {

    private final WriteCellStyle headWriteCellStyle;
    private final WriteCellStyle contentWriteCellStyle;

    private CellStyle headCellStyle;
    private CellStyle contentCellStyle;

    public TemplateCellStyleStrategy() {
        // 表头的样式
        headWriteCellStyle = new WriteCellStyle();
        // 表头背景色
        headWriteCellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        WriteFont headWriteFont = new WriteFont();
        headWriteFont.setBold(true);
        headWriteCellStyle.setWriteFont(headWriteFont);
        // 内容的样式
        contentWriteCellStyle = new WriteCellStyle();
        contentWriteCellStyle.setFillPatternType(FillPatternType.SOLID_FOREGROUND);
        // 内容背景色
        contentWriteCellStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
    }

    @Override
    protected void initCellStyle(Workbook workbook) {
        if (headWriteCellStyle != null) {
            headCellStyle = StyleUtil.buildHeadCellStyle(workbook, headWriteCellStyle);
        }
        if (contentWriteCellStyle != null) {
            contentCellStyle = StyleUtil.buildContentCellStyle(workbook, contentWriteCellStyle);
        }
    }

    @Override
    protected void setHeadCellStyle(Cell cell, Head head, Integer relativeRowIndex) {
        if (headCellStyle == null) {
            return;
        }
        cell.setCellStyle(headCellStyle);
    }

    @Override
    protected void setContentCellStyle(Cell cell, Head head, Integer relativeRowIndex) {
        if (contentCellStyle == null) {
            return;
        }
        cell.setCellStyle(contentCellStyle);
    }


}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.packageName + ".excel.handler")/>

${code}
