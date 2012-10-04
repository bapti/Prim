param($installPath, $toolsPath, $package, $project)

$project.Save()

$targetsFile = [System.IO.Path]::Combine($toolsPath, 'TypeScript.targets')

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Build") | out-null
$msbuild = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1

$projectUri = new-object Uri('file://' + $project.FullName)
$targetUri = new-object Uri('file://' + $targetsFile)
$relativePath = $projectUri.MakeRelativeUri($targetUri).ToString().Replace([System.IO.Path]::AltDirectorySeparatorChar, [System.IO.Path]::DirectorySeparatorChar)

$projectXml = New-Object System.Xml.XmlDocument
$projectXml.Load($project.FullName)
$namespace = 'http://schemas.microsoft.com/developer/msbuild/2003'

$imports = Select-Xml "//msb:Project/msb:Import[contains(@Project,'\TypeScript.targets')] | //msb:Project/msb:Import[contains(@Project,'TypeScript')]" $projectXml -Namespace @{msb = $namespace}
if ($imports)
{
}
else 
{
	$msbuild.Xml.AddImport($relativePath) | out-null	
}

$item = $project.ProjectItems | where-object {$_.Name -eq "helloworld.ts"} 
$item.Properties.Item("ItemType").Value = "TypeScriptCompile"

$project.Save()