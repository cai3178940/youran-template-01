importPackage(java.lang)
importPackage(org.apache.commons.io)
importPackage(org.apache.commons.io.filefilter)
importPackage(java.io)
importPackage(java.nio.file)

/**
 * 获取目录的相对路径
 * @param targetDir 目标目录
 * @param baseDir 基础目录
 */
function getRelativePath(targetDir, baseDir) {
    var pathAbsolute = Paths.get(targetDir.toURI())
    var pathBase = Paths.get(baseDir.toURI())
    var pathRelative = pathBase.relativize(pathAbsolute)
    return FilenameUtils.separatorsToUnix(pathRelative.toString())
}

System.out.println('开始构建template.json文件')
// 解析初始template.json
var obj = JSON.parse(FileUtils.readFileToString(new File('src/main/build/template.json'), 'utf-8'))
// 读取remark
obj.remark = FileUtils.readFileToString(new File('src/main/build/remark.md'), 'utf-8') + ''
// 解析metaLabel.json
var metaLabel = JSON.parse(FileUtils.readFileToString(new File('src/main/build/metaLabel.json'), 'utf-8'))
obj.metaLabel = JSON.stringify(metaLabel);
// 初始化模板文件数组
obj.templateFiles = []
// freemarker的基础目录
var baseDir = new File('src/main/resources/ftl')
// 获取所有子目录
var dirs = FileUtils.listFilesAndDirs(baseDir, FileFilterUtils.directoryFileFilter(), FileFilterUtils.trueFileFilter())
for (var i = 0; i < dirs.size(); i++) {
    var dir = dirs.get(i)
    var typeFile = new File(dir, '__type.json')
    if (typeFile.exists()) {
        // 解析__type.json内的数据
        var types = JSON.parse(FileUtils.readFileToString(typeFile, 'utf-8'))
        for (var j = 0; j < types.length; j++) {
            var type = types[j]
            // 将目录字段补充上
            type.fileDir = '/' + getRelativePath(dir, baseDir)
            obj.templateFiles.push(type)
        }
    }
}
// 生成整个完整的template.json文件内容
var output = JSON.stringify(obj, null, 2);
System.out.println(output)
// 写入template.json文件
FileUtils.writeStringToFile(new File('src/main/resources/template.json'), output, 'utf-8')
