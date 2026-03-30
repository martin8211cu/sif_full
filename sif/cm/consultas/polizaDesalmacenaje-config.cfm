<cfscript>
	//form.EPDid=1;
	if (isdefined("url.EPDid") and len(url.EPDid)) form.EPDid = url.EPDid;
	
	if (isdefined("form.EPDid") and len(form.EPDid) and form.EPDid) modo = 'reporte';
	else modo = 'lista';
</cfscript>