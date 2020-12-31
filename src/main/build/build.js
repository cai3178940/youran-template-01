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
var obj = JSON.parse(FileUtils.readFileToString(new File('src/main/build/template.json'), 'utf-8'))
obj.remark = FileUtils.readFileToString(new File('src/main/build/remark.md'), 'utf-8') + ''

obj.templateFiles = []
var baseDir = new File('src/main/resources/ftl')
var dirs = FileUtils.listFilesAndDirs(baseDir, FileFilterUtils.directoryFileFilter(), FileFilterUtils.trueFileFilter())
for (var i = 0; i < dirs.size(); i++) {
    var dir = dirs.get(i)
    var typeFile = new File(dir, '__type.json')
    if (typeFile.exists()) {
        var types = JSON.parse(FileUtils.readFileToString(typeFile, 'utf-8'))
        for (var j = 0; j < types.length; j++) {
            var type = types[j]
            type.fileDir = '/' + getRelativePath(dir, baseDir)
            obj.templateFiles.push(type)
        }
    }
}
var output = JSON.stringify(obj, null, 2);
System.out.println(output)
FileUtils.writeStringToFile(new File('src/main/resources/template.json'), output, 'utf-8')
