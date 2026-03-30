<cfif isdefined("url.CMSid") and not isdefined("form.CMSid")>
	<cfset form.CMSid= url.CMSid >
</cfif>

<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,desc) {
	if (window.opener != null) {
		window.opener.document.form1.CMElinea.value   = id;
		window.opener.document.form1.CMEdescripcion.value = desc;
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<html>
<head>
<title>Lista de Especializaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<!--- Centros Funcionales asociados al Solicitante --->
<cfquery name="rsCF" datasource="#session.DSN#">
	select distinct CFid 
	from CMSolicitantesCF
	where CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
</cfquery>
<cfset cf = ''>
<cfloop query="rsCF">
	<cfset cf = cf & rsCF.CFid & ",">
</cfloop>

<!--- Especializaciones ya asignadas --->
<cfquery name="rsLineas" datasource="#session.DSN#">
	select CMElinea 
	from CMESolicitantes
	where CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
</cfquery>
<cfset lineas = ''>
<cfloop query="rsLineas">
	<cfset lineas = lineas & rsLineas.CMElinea & ",">
</cfloop>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td><strong>Listado de Especializaciones</strong><hr width="100%" color="#CCCCCC" size="1"></td>
	</tr>
</table>

<cfif len(trim(cf))>
	<cfset cf = mid(cf, 1,len(cf)-1) >
	<cfif len(trim(lineas))><cfset lineas = mid(lineas, 1,len(lineas)-1) ></cfif>

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.CMElinea, a.CFid, g.CFdescripcion, a.CMTScodigo, h.CMTSdescripcion, 
			   a.ACcodigo, a.ACid, a.Ccodigo, a.CCid, 
			   g.CFdescripcion#_Cat#'/'#_Cat#h.CMTSdescripcion as descripcion1,
			   case when CMEtipo = 'A' then 'Artículo' when CMEtipo = 'S' then 'Servicio' when CMEtipo='F' then 'Activo Fijo' end as CMEtipo,
			   case when CMEtipo = 'A' then Cdescripcion when CMEtipo = 'S' then d.CCdescripcion when CMEtipo='F' then e.ACdescripcion#_Cat#'/'#_Cat#f.ACdescripcion end as descripcion	
		from CMEspecializacionTSCF a
		
		inner join CMTSolicitudCF b
		on a.CFid=b.CFid
		   and a.Ecodigo=b.Ecodigo
		   and a.CMTScodigo=b.CMTScodigo
		   and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		inner join CFuncional g
		on a.CFid=g.CFid
		   and g.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		inner join CMTiposSolicitud h
		on a.CMTScodigo=h.CMTScodigo
		   and h.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
		left outer join Clasificaciones c
		on a.Ccodigo=c.Ccodigo
		   and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
		left outer join CConceptos d
		on a.CCid=d.CCid
		   and d.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		left outer join ACategoria e
		on a.ACcodigo=e.ACcodigo
		   and e.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		left outer join AClasificacion f
		on a.ACid=f.ACid
		   and f.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.CFid in (#cf#)
		  
		  <cfif len(trim(lineas))>
			  and a.CMElinea not in (#lineas#)
		  </cfif>
		  
		order by CFdescripcion, CMTSdescripcion, CMEtipo, descripcion
	</cfquery>
	
	<cfif rsLista.RecordCount gt 0>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="CMTSdescripcion, CMEtipo,descripcion"/>
			<cfinvokeargument name="etiquetas" value="Tipo de Solicitud,Tipo,Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left, left"/>
			<cfinvokeargument name="formName" value="listaDetalle"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="conlisEspecializacion.cfm"/>
			<cfinvokeargument name="keys" value="CMElinea"/>
			<cfinvokeargument name="Cortes" value="descripcion1"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CMElinea, descripcion"/>
		</cfinvoke>
	<cfelse>
		<table width="100%">
			<tr><td><strong>No se encontraron registros.</strong></td></tr>
			<tr><td><strong>Debe revisar lo siguiente:</strong></td></tr>
			<tr>
				<td><ul><li>El Solicitante debe estar asignado al menos a un Centro Funcional.</li></ul></td>
			</tr>
			<tr>
				<td><ul><li>El &oacute; los Centros Funcionales asignados al Solicitante, deben estar asociados al menos a un Tipo de Solicitud de Compra.</li></ul></td>
			</tr>
			<tr>
				<td><ul><li>Para la relaci&oacute;n Centro Funcional/Tipo de Solicitud debe haberse definido la especializaci&oacute;n.</li></ul></td>
			</tr>
			<tr>
				<td><ul><li>Ya ha asignado todas las especializaciones existentes al Solicitante.</li></ul></td>
			</tr>
		</table>
	</cfif>

<cfelse>
	<table width="100%">
		<tr>
			<td><strong><ul><li>El Solicitante no ha sido asignado a ning&uacute;n Centro Funcional.</li></ul></strong></td>
		</tr>
	</table>
</cfif>

</body>
</html>