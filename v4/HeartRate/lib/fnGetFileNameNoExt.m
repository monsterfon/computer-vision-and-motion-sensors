function fileName = fnGetFileNameNoExt(fullFileName)

temp     = split(fullFileName, '.');
fileName = temp{1};

