<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#if !usingExcel>
    <@call this.skipCurrent()/>
</#if>
<#--定义主体代码-->
<#assign code>
<@call this.addImport("com.alibaba.excel.write.handler.SheetWriteHandler")/>
<@call this.addImport("com.alibaba.excel.write.metadata.holder.WriteSheetHolder")/>
<@call this.addImport("com.alibaba.excel.write.metadata.holder.WriteWorkbookHolder")/>
<@call this.addImport("org.apache.poi.ss.usermodel.DataValidation")/>
<@call this.addImport("org.apache.poi.ss.usermodel.DataValidationConstraint")/>
<@call this.addImport("org.apache.poi.ss.usermodel.DataValidationHelper")/>
<@call this.addImport("org.apache.poi.ss.util.CellRangeAddressList")/>
<@call this.printClassCom("给excel单元格设置下拉框")/>
public class ConstConstraintHandler implements SheetWriteHandler {

    private String[] constraint;
    private int firstRow;
    private int lastRow;
    private int firstCol;
    private int lastCol;

    public ConstConstraintHandler(String[] constraint,
                                  int firstRow, int lastRow,
                                  int firstCol, int lastCol) {
        this.constraint = constraint;
        this.firstRow = firstRow;
        this.lastRow = lastRow;
        this.firstCol = firstCol;
        this.lastCol = lastCol;
    }

    @Override
    public void beforeSheetCreate(WriteWorkbookHolder writeWorkbookHolder, WriteSheetHolder writeSheetHolder) {

    }

    @Override
    public void afterSheetCreate(WriteWorkbookHolder writeWorkbookHolder, WriteSheetHolder writeSheetHolder) {
        CellRangeAddressList cellRangeAddressList = new CellRangeAddressList(firstRow, lastRow, firstCol, lastCol);
        DataValidationHelper helper = writeSheetHolder.getSheet().getDataValidationHelper();
        DataValidationConstraint validationConstraint = helper.createExplicitListConstraint(constraint);
        DataValidation dataValidation = helper.createValidation(validationConstraint, cellRangeAddressList);
        writeSheetHolder.getSheet().addValidationData(dataValidation);
    }

}

</#assign>
<#--开始渲染代码-->
package ${this.packageName}.excel.handler;

<@call this.printImport()/>

${code}
