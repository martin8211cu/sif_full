<cfif isDefined("url.PlayVideo") and len(trim(url.PlayVideo))>
		 <video width="100%" height="100%" controls>
		  <source src="/cfmx/home/public/manual/files/<cfoutput>#url.PlayVideo#</cfoutput>" type="video/mp4">
			Your browser does not support the video tag.
		 </video>
	<cfabort>
</cfif> 
<cfif isDefined("form.urldown") and len(trim(form.urldown))>
<cfset delimi='/'>
<cfif findNoCase('\', form.urldown)>
	<cfset delimi = '\'>
</cfif>	
<cfset nombreFile = listLast(form.urldown,delimi)>
<cfheader name="Content-Disposition" value="inline; filename='#nombreFile#'">  
    <cfcontent type="application/vnd.ms-excel" file="#form.urldown#"> 
<cfabort>
</cfif> 
 
<cfif not isDefined("invokePreferencias")>
	<!doctype html>
	<html>
	<head>
	   <meta charset="UTF-8">
	   <link rel="shortcut icon" href="/cfmx/home/public/manual/.favicon.ico">
	   <title>Manuales Sapiens</title>
		<link rel="stylesheet" href="/cfmx/home/public/manual/.style.css">
	   <script src="/cfmx/home/public/manual/.sorttable.js"></script>
	</head>
	<body>
<cfelse> 
	<link rel="stylesheet" href="/cfmx/home/public/manual/.stylePreferencias.css">
	 <script src="/cfmx/home/public/manual/.sorttable.js"></script>
</cfif>
<style type="text/css">
.btnDedo{cursor: pointer;}
</style>
<form name="formD" id="formD" method="post">
	<input type="hidden" name="urldown" id="urldown">
</form>

<div id="container">
	<cfif not isDefined("invokePreferencias")>
	<h1>Manuales Sapiens</h1>
	</cfif>

	<cfdirectory action="list" directory="#ExpandPath("/home/public/manual/files")#" name="dir"> 
    	
	<cfquery dbtype="query" name="dir">
		select *  from dir where upper(name) not in('INDEX.CFM','APPLICATION.CFC')
	</cfquery>
	<cfif dir.recordcount>
		
	
	<table class="sortable" id="AyudaTabla">
	    <thead>
		<tr>
			<th><cf_translate key="LB_Archivo" xmlFile="/rh/generales.xml">Archivo</cf_translate></th>
			<th><cf_translate key="LB_Tipo" xmlFile="/rh/generales.xml">Tipo</cf_translate></th>
			<th><cf_translate key="LB_Tamanno" xmlFile="/rh/generales.xml">Tamaño</cf_translate></th>
			<th><cf_translate key="LB_FechaModificacion" xmlFile="/rh/generales.xml">Fecha de Modificación</cf_translate></th>
			<th></th>
			<th></th>
		</tr>
	    </thead>
	    <tbody>

 

 
	<cfoutput query="dir">
		
	
	<cfset name= dir.name>
	<cfset extension= listLast(dir.name, '.')>
	<cfset urlFile= dir.directory>
	<cfset fechaModificado= dir.datelastmodified>
	<cfset tam= dir.size>

	
 
	<cfif findNoCase('\', urlFile)>
		<cfset urlFile = urlFile & '\' & name>
	<cfelse>	
		<cfset urlFile = urlFile & '/' & name>
	</cfif>

	<cfif tam GT "1000000">
	    <cfset tam= numberformat(tam*.000001, 9.99) & ' Mb'>
	<cfelse>
	    <cfset tam= numberformat(tam*.001, 9)  & ' kb' >
	</cfif>
			 
			<cfswitch expression="#extension#">
				<cfcase value="png" > <cfset icon="PNG Image"></cfcase>
				<cfcase value="mp4" > <cfset icon="Video"></cfcase>
				<cfcase value="jpg,jpeg" delimiters=","> <cfset icon="JPEG Image"></cfcase>
				<cfcase value="svg"> <cfset icon="SVG Image"></cfcase>
				<cfcase value="gif"> <cfset icon="GIF Image"></cfcase>
				<cfcase value="ico"> <cfset icon="Windows Icon"></cfcase>
				<cfcase value="txt"> <cfset icon="Text File"></cfcase>
				<cfcase value="log"> <cfset icon="Log File"></cfcase>
				<cfcase value="htm,html,xhtml,shtml" delimiters=","> <cfset icon="HTML File"></cfcase>
				<cfcase value="php"> <cfset icon="PHP Script"></cfcase>
				<cfcase value="js"> <cfset icon="Javascript File"></cfcase>
				<cfcase value="css"> <cfset icon="Stylesheet"></cfcase>
				<cfcase value="pdf"> <cfset icon="PDF Document"></cfcase>
				<cfcase value="xls,xlsx" delimiters=","> <cfset icon="Spreadsheet"></cfcase>
				<cfcase value="pptx,ppx" delimiters=","> <cfset icon="Microsoft PowerPoint Document"></cfcase>
				<cfcase value="doc,docx"  delimiters=","> <cfset icon="Microsoft Word Document"></cfcase>
				<cfcase value="zip"> <cfset icon="ZIP Archive"></cfcase>
				<cfcase value="htaccess"> <cfset icon="Apache Config File"></cfcase>
				<cfcase value="exe"> <cfset icon="Windows Executable"></cfcase>
				<cfdefaultcase>
					<cfset icon="File">
				</cfdefaultcase>
			 
			</cfswitch> 
 
	 		<cfif dir.type eq 'FILE'>
	 			<tr class="file" o>
	 		<cfelse>	
	 			<tr class="dir">
	 		</cfif>		
				<td><a href='##dsds.#extension#' class='name'>#name#</a></td>
				<td><a href='##' >#icon#</a></td>
				<td sorttable_customkey='#dir.size#'><a href='##' >#tam#</a></td>
				<td sorttable_customkey='#fechaModificado#'><a href='##' >#LSdateformat(fechaModificado,'yyyy/mm/dd')#  #LSTimeFormat(fechaModificado,'HH:mm:ss')#</a></td>
				<td class="btnDedo" onclick='download(#currentrow#);'><a>Descargar</a></td>
				<cfif listFindNoCase("mp4",extension) or listFindNoCase("mov",extension)>
					<td class="btnDedo" onclick="PlayVideo('#name#');"><a>Reproducir</a></td>
				<cfelse>
					<td></td>		
				</cfif>
			
			</tr>  
		<script type="text/javascript">
			var a#currentrow#='#JSStringFormat(urlFile)#';
		</script>
	</cfoutput>

	    </tbody>
	</table>
	<cfelse>
		<div class="alert alert-dismissable alert-info text-center">
             <p><h4><cf_translate key="LB_NoExisteDocumentacionQueMostrar">No existe Documentación que mostrar</cf_translate></h4></p>
            </div>
		<div> 
	</cfif>
</div>
<cfif not isDefined("invokePreferencias")>
	</body>
</cfif>


<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_EspereMientrasCarga = t.Translate('LB_EspereMientrasCarga','Espere mientras carga')>
<cfsavecontent variable="LvarLoad"><div class="well well-large well-transparent lead"><i class="fa fa-spinner fa-spin fa"></i> <cfoutput>#LB_EspereMientrasCarga#</cfoutput>...</div></cfsavecontent>

<cf_Confirm width="50" height="50" importLibs="false"  index="1"><cfoutput>#LvarLoad#</cfoutput></cf_Confirm>
<script type="text/javascript">
function download(e){
	document.getElementById("urldown").value=eval('a'+e);
	document.formD.submit();
}

 
function PlayVideo(e){
	$("#contenidoConfirm1").html('<cfoutput>#trim(LvarLoad)#</cfoutput>');
  	 $("#contenidoConfirm1").load('/cfmx/home/public/manual/index.cfm?PlayVideo='+e);
	PopUpAbrir1();
}

function fnCerrar(){
	$("#contenidoConfirm1").html('');
	PopUpCerrar1();
}

$('#myModal1').one('hidden.bs.modal', function(e) {$("#contenidoConfirm1").html('');});
 
</script>
<cfif not isDefined("invokePreferencias")>
	</html>
</cfif>
