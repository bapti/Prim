param($installPath, $toolsPath, $package, $project)

$project.Save()

$projectXml = New-Object System.Xml.XmlDocument
$projectXml.Load($project.FullName)
$namespace = 'http://schemas.microsoft.com/developer/msbuild/2003'

$imports = Select-Xml "//msb:Project/msb:Import[contains(@Project,'\TypeScript.targets')] | //msb:Project/msb:Import[contains(@Project,'TypeScript')]" $projectXml -Namespace @{msb = $namespace}
if ($imports)
{
    foreach ($import in $imports)
    {
        $import.Node.ParentNode.RemoveChild($import.Node)
    }
}

$project.Save()
$projectXml.Save($project.FullName)