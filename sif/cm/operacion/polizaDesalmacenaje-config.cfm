<!--- Archivo de configuración de la pantalla de Captura de Datos para el Cálculo de las Importaciones. --->
<cfscript>
	
	/*Pasa valores que en determinado momento vienen por get en el url al form, porque generalmente vienen por post y son usados en el form.
	Estos parámetros viene por get cuando vienen del sql.*/
	if (isdefined("url.btnNuevo") and len(url.btnNuevo)) form.btnNuevo = url.btnNuevo;
	if (isdefined("url.EPDid") and len(url.EPDid)) form.EPDid = url.EPDid;
	if (isdefined("url.DPDlinea") and len(url.DPDlinea)) form.DPDlinea = url.DPDlinea;
	if (isdefined("url.FPid") and len(url.FPid)) form.FPid = url.FPid;
	if (isdefined("url.Icodigo") and len(url.Icodigo)) form.Icodigo = url.Icodigo;
	
	/*Definición del Modo*/
	if (isdefined("form.btnNuevo"))	modo = 'alta'; 
	else if (isdefined("form.EPDid") and len(form.EPDid) and form.EPDid) modo = 'cambio';
	else modo = 'lista';
	
	/*Definición del ModoDet*/
	if 	( 	(isdefined("form.DPDlinea") and len(form.DPDlinea) and form.DPDlinea)
		or 	(isdefined("form.FPid") and len(form.FPid) and form.FPid)
		or 	(isdefined("form.Icodigo") and len(form.Icodigo))
		)
		mododet = 'cambio';
	else mododet = 'alta';
	
	/*Definición de los Botones*/
	exclude='';
	include=''; 
	includevalues='';
	if (isdefined("modo") and lcase(modo) eq 'cambio') {
		include = 'DocsPoliza,Calcular'; 
		includevalues = 'Documentos de la Poliza,Calcular';
	}
	
	/*Pagenum de las listas*/
	
	if (isdefined("url.pagenum_lista2") and len(url.pagenum_lista2)) form.pagina2 = url.pagenum_lista2;
	else if (isdefined("form.pagenum2") and len(form.pagenum2)) form.pagina2 = form.pagenum2;
	else if (isdefined("url.pagina2") and len(url.pagina2)) form.pagina2 = url.pagina2;

	if (isdefined("url.pagenum_lista3") and len(url.pagenum_lista3)) form.pagina3 = url.pagenum_lista3;
	else if (isdefined("form.pagenum3") and len(form.pagenum3)) form.pagina3 = form.pagenum3;
	else if (isdefined("url.pagina3") and len(url.pagina3)) form.pagina3 = url.pagina3;

	if (isdefined("url.pagenum_lista4") and len(url.pagenum_lista4)) form.pagina4 = url.pagenum_lista4;
	else if (isdefined("form.pagenum4") and len(form.pagenum4)) form.pagina4 = form.pagenum4;
	else if (isdefined("url.pagina4") and len(url.pagina4)) form.pagina4 = url.pagina4;
	
</cfscript>