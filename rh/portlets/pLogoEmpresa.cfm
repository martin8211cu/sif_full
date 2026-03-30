<cfparam name="rsLogos2.Lident" default="">
<cfhttp method="GET" url="" resolveurl="yes"></cfhttp>
<cflocation url="http://200.30.158.243/Upload/DownloadServlet/EmpresaLogo2?Lident=#rsLogos2.Lident#">