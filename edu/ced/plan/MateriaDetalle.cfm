<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
 ---> 
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0>
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfparam name="Form.Tipo" default="#arreglo[1]#">
		<cfparam name="Form.CodAct" default="#arreglo[2]#">
		<cfparam name="Form.Mconsecutivo" default="#arreglo[3]#">
		<cfparam name="Form.PEcodigo" default="#arreglo[4]#">
		<cfparam name="Form.modoDet" default="CAMBIO">
	</cfif>

	<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
		<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">
	<cfelseif not isdefined("Form.Mconsecutivo")>
		<cfparam name="Form.Mconsecutivo" default="0">
	</cfif>
	<cfif isdefined("Url.Tipo") and not isdefined("Form.Tipo")>
		<cfparam name="Form.Tipo" default="#Url.Tipo#">
	</cfif>
	<cfif isdefined("Url.CodAct") and not isdefined("Form.CodAct")>
		<cfparam name="Form.CodAct" default="#Url.CodAct#">
	</cfif>
	<cfset modoDet="ALTA">
	<cfif isdefined("form.Mconsecutivo") and form.Mconsecutivo NEQ '' and isdefined("form.CodAct") and form.CodAct NEQ ''>
			<cfset modoDet="CAMBIO">
	</cfif>
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
	<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
		<cfset form.Pagina = url.Pagina>
	</cfif>		
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
	<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
		<cfset form.Pagina = url.PageNum_Lista>
	</cfif>					
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
	<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
		<cfset form.Pagina = form.PageNum>
	</cfif>
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
	<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
		<cfset form.Pagina2 = url.Pagina2>
	</cfif>		
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
	<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
		<cfset form.Pagina2 = url.PageNum_Lista2>
	</cfif>					
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
	<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
		<cfset form.Pagina2 = form.PageNum2>
	</cfif>

	<cfset Session.Edu.RegresarUrl = "Materias.cfm?Mconsecutivo=#Form.Mconsecutivo#">
	<cfif isdefined('form.Pagina') and LEN(TRIM(form.Pagina))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl & "&Pagina=#form.Pagina#">
	</cfif>
	<cfif isdefined('form.Filtro_Mcodigo') and LEN(TRIM(form.Filtro_Mcodigo))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&Filtro_Mcodigo=#form.Filtro_Mcodigo#">
	</cfif>
	<cfif isdefined('form.Filtro_MTdescripcion') and LEN(TRIM(form.Filtro_MTdescripcion))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&Filtro_MTdescripcion=#form.Filtro_MTdescripcion#">
	</cfif>
	<cfif isdefined('form.Filtro_Melectiva') and LEN(TRIM(form.Filtro_Melectiva))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&Filtro_Melectiva=#form.Filtro_Melectiva#">
	</cfif>
	<cfif isdefined('form.Filtro_Mnombre') and LEN(TRIM(form.Filtro_Mnombre))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&Filtro_Mnombre=#form.Filtro_Mnombre#">
	</cfif>
	<cfif isdefined('form.FNcodigoC') and LEN(TRIM(form.FNcodigoC))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&FNcodigoC=#form.FNcodigoC#">
	</cfif>
	<cfif isdefined('form.FGcodigoC') and LEN(TRIM(form.FGcodigoC))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&FGcodigoC=#form.FGcodigoC#">
	</cfif>
	<cfif isdefined('form.HFiltro_Mcodigo') and LEN(TRIM(form.HFiltro_Mcodigo))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&HFiltro_Mcodigo=#form.HFiltro_Mcodigo#">
	</cfif>
	<cfif isdefined('form.HFiltro_MTdescripcion') and LEN(TRIM(form.HFiltro_MTdescripcion))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&HFiltro_MTdescripcion=#form.HFiltro_MTdescripcion#">
	</cfif>
	<cfif isdefined('form.HFiltro_Melectiva') and LEN(TRIM(form.HFiltro_Melectiva))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&HFiltro_Melectiva=#form.HFiltro_Melectiva#">
	</cfif>
	<cfif isdefined('form.HFiltro_Mnombre') and LEN(TRIM(form.HFiltro_Mnombre))>
		<cfset Session.Edu.RegresarUrl = Session.Edu.RegresarUrl& "&HFiltro_Mnombre=#form.HFiltro_Mnombre#">
	</cfif>
	<cfif isdefined('url.Filtro_Actividad') and not isdefined('form.Filtro_Actividad')>
		<cfparam name="form.Filtro_Actividad" default="#url.Filtro_Actividad#">
	</cfif>
	<cfif isdefined('url.Filtro_Leccion') and not isdefined('form.Filtro_Leccion')>
		<cfparam name="form.Filtro_Leccion" default="#url.Filtro_Leccion#">
	</cfif>
	<cfif isdefined('url.Filtro_Secuencia') and not isdefined('form.Filtro_Secuencia')>
		<cfparam name="form.Filtro_Secuencia" default="#url.Filtro_Secuencia#">
	</cfif>
	<cfif isdefined('url.Filtro_Mcodigo') and LEN(TRIM(url.Filtro_Mcodigo))>
		<cfparam name="form.Filtro_Mcodigo" default="#url.Filtro_Mcodigo#">
	</cfif>
	<cfif isdefined('url.Filtro_MTdescripcion') and LEN(TRIM(url.Filtro_MTdescripcion))>
		<cfparam name="form.Filtro_MTdescripcion" default="#url.Filtro_MTdescripcion#">
	</cfif>
	<cfif isdefined('url.Filtro_Melectiva') and LEN(TRIM(url.Filtro_Melectiva))>
		<cfparam name="form.Filtro_Melectiva" default="#url.Filtro_Melectiva#">
	</cfif>
	<cfif isdefined('url.Filtro_Mnombre') and LEN(TRIM(url.Filtro_Mnombre))>
		<cfparam name="form.Filtro_Mnombre" default="#url.Filtro_Mnombre#">
	</cfif>
	<cfif isdefined('url.FNcodigoC') and LEN(TRIM(url.FNcodigoC))>
		<cfparam name="form.FNcodigoC" default="#url.FNcodigoC#">
	</cfif>
	<cfif isdefined('url.FGcodigoC') and LEN(TRIM(url.FGcodigoC))>
		<cfparam name="form.FGcodigoC" default="#url.FGcodigoC#">
	</cfif>
	<cfif isdefined('url.HFiltro_Mcodigo') and LEN(TRIM(url.HFiltro_Mcodigo))>
		<cfparam name="form.HFiltro_Mcodigo" default="#url.HFiltro_Mcodigo#">
	</cfif>
	<cfif isdefined('url.HFiltro_MTdescripcion') and LEN(TRIM(url.HFiltro_MTdescripcion))>
		<cfparam name="form.HFiltro_MTdescripcion" default="#url.HFiltro_MTdescripcion#">
	</cfif>
	<cfif isdefined('url.HFiltro_Melectiva') and LEN(TRIM(url.HFiltro_Melectiva))>
		<cfparam name="form.HFiltro_Melectiva" default="#url.HFiltro_Melectiva#">
	</cfif>
	<cfif isdefined('url.HFiltro_Mnombre') and LEN(TRIM(url.HFiltro_Mnombre))>
		<cfparam name="form.HFiltro_Mnombre" default="#url.HFiltro_Mnombre#">
	</cfif>
	
	<cfinclude template="formMateriaDetalle.cfm">