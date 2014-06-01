<#
.SYNOPSIS
  Gets the owner of an IP address.
 
.DESCRIPTION
  The script returns the owner of the supplied IP address using the web API of arin.net.
 
.PARAMETER IP
  The IP address to run the whois against.
 
.OUTPUTS
  Returns the name of the owner of the IP address.

.EXAMPLE
  Get-WhoIs -IP "8.8.8.8"
#>


Param(
    [Parameter(Mandatory=$true)]
    [string]$IP
)


try
{
    $WhoIsWebRequest = (Invoke-WebRequest "http://whois.arin.net/rest/ip/$IP").content
}
catch [System.Net.WebException]
{
    $WhoIsWebRequest = "<?xml version='1.0' encoding='UTF-8'?><net><orgRef name='No WhoIs Result'></orgRef></net>"
}


[xml]$WhoIsXML = New-Object System.Xml.XmlDocument
$WhoIsXML.LoadXml(($WhoIsWebRequest))

if ($WhoIsXML.net.orgRef.name)
{
    return $WhoIsXML.net.orgRef.name
}
else
{
    return $WhoIsXML.net.customerRef.name
}