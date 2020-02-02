<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.alibaba.excel.util.StyleUtil")/>
<@call this.addImport("com.alibaba.excel.write.handler.SheetWriteHandler")/>
<@call this.addImport("com.alibaba.excel.write.metadata.holder.WriteSheetHolder")/>
<@call this.addImport("com.alibaba.excel.write.metadata.holder.WriteWorkbookHolder")/>
<@call this.addImport("org.apache.poi.ss.usermodel.*")/>
<@call this.addImport("org.apache.poi.ss.util.CellRangeAddress")/>
<@call this.printClassCom("给excel单元格设置下拉框")/>
public class TitleDescriptionWriteHandler implements SheetWriteHandler {


    private String title;
    private String[] description;
    private Class dtoClass;

    public TitleDescriptionWriteHandler(String title, String[] description, Class dtoClass) {
        this.title = title;
        this.description = description;
        this.dtoClass = dtoClass;
    }

    private String parseDescriptionCellValue() {
        StringBuilder sb = new StringBuilder("说明：\n");
        for (int i = 0; i < description.length; i++) {
            sb.append(i + 1).append("、").append(description[i]);
            if (i < description.length - 1) {
                sb.append("\n");
            }
        }
        return sb.toString();
    }


    @Override
    public void beforeSheetCreate(WriteWorkbookHolder writeWorkbookHolder, WriteSheetHolder writeSheetHolder) {

    }

    @Override
    public void afterSheetCreate(WriteWorkbookHolder writeWorkbookHolder, WriteSheetHolder writeSheetHolder) {
        int lastCol = dtoClass.getDeclaredFields().length - 1;
        Sheet sheet = writeSheetHolder.getSheet();
        Row row1 = sheet.createRow(0);
        Row row2 = sheet.createRow(1);
        row2.setHeightInPoints(80);
        Workbook workbook = writeWorkbookHolder.getWorkbook();
        CellStyle cellStyle1 = StyleUtil.buildDefaultCellStyle(workbook);
        Font font = workbook.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short) 14);
        font.setBold(true);
        cellStyle1.setFont(font);
        CellStyle cellStyle2 = StyleUtil.buildDefaultCellStyle(workbook);
        cellStyle2.setAlignment(HorizontalAlignment.LEFT);
        for (int i = 0; i <= lastCol; i++) {
            Cell cell1 = row1.createCell(i);
            Cell cell2 = row2.createCell(i);
            cell1.setCellStyle(cellStyle1);
            cell2.setCellStyle(cellStyle2);
            if (i == 0) {
                cell1.setCellValue(this.title);
                cell2.setCellValue(this.parseDescriptionCellValue());
            }
        }
        // 合并单元格
        CellRangeAddress region = new CellRangeAddress(0, 0, 0, lastCol);
        sheet.addMergedRegion(region);
        CellRangeAddress region2 = new CellRangeAddress(1, 1, 0, lastCol);
        sheet.addMergedRegion(region2);
    }

}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.excel.handler;

<@call this.printImport()/>

${code}
