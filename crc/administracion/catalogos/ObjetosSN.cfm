<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("url.SNcodigo") and form.SNcodigo GTE 0>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
<cfquery name="rsSNegociosObj" datasource="#session.DSN#">
	select a.SNOid, a.SNcodigo,a.SNOTipoArchivo , a.SNOdescripcion, a.SNOarchivo as nombre_archivo,
	'<img alt=''Descargar Archivo'' border=''0'' src=''/cfmx/sif/imagenes/descargar.png'' height=''16'' width=''16'' onClick=''javascript:descargar('
	#_Cat# <cf_dbfunction name="to_char" args="SNOid" datasource="#Session.DSN#">
	#_Cat# ','
	#_Cat# <cf_dbfunction name="to_char" args="a.SNcodigo" datasource="#Session.DSN#">
	#_Cat# ');''>' as imagen,
	a.SNOcontenttype as extencion
	from SNegociosObjetos a
		inner join SNegocios b
			on a.Ecodigo = #session.Ecodigo#
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and a.Ecodigo = b.Ecodigo
			and a.SNcodigo = b.SNcodigo
</cfquery>

<cfquery name="rsSocioNegocios" datasource="#session.DSN#">
	select SNnumero, SNnombre
	from SNegocios
	where Ecodigo = #session.Ecodigo#
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_DESCRIPCION = t.Translate('LB_DESCRIPCION','Descripci&oacute;n','/sif/generales.xml')>
<cfset LB_TipoArchivo = t.Translate('LB_TipoArchivo','Tipo de Archivo','/sif/generales.xml')>
<cfset LB_FileName = t.Translate('LB_FileName','Nombre del archivo')>
<cfset LB_Descar = t.Translate('LB_Descar','Descargar')>
<cfset MSG_Primero 	= t.Translate('MSG_Primero','Primero&nbsp;debe&nbsp;ingresar&nbsp;los','Anotaciones.cfm')>
<cfset MSG_DatGral 	= t.Translate('MSG_DatGral','Datos&nbsp;Generales','Anotaciones.cfm')>
<cfset MSG_delSNeg 	= t.Translate('MSG_delSNeg','del&nbsp;Socio&nbsp;de&nbsp;Negocios','Anotaciones.cfm')>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td>
	</tr>
	<tr>
		<td valign="top" width="50%">
		<cfif isdefined("LvarReadOnly")>
			<cfset Lvartab = 'DatosGSocio.cfm?tabs=6&Ocodigo_F=#form.Ocodigo_F#'>
		<cfelse>
			<cfset Lvartab = 'Socios.cfm?tab=6'>
		</cfif>
			<cfinvoke
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsSNegociosObj#"/>
				<cfinvokeargument name="desplegar" value="nombre_archivo,SNOTipoArchivo, SNOdescripcion, imagen"/>
				<cfinvokeargument name="etiquetas" value="#LB_FileName#,#LB_TipoArchivo#, #LB_DESCRIPCION#, #LB_Descar#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S"/>
				<cfinvokeargument name="align" value="left,left, left, center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="#Lvartab#"/>
				<cfinvokeargument name="formname" value="listaObjetos"/>
				<cfinvokeargument name="showEmptyListMsg" value="1"/>
				<cfinvokeargument name="keys" value="SNOid,SNcodigo"/>
			</cfinvoke>
		</td>
		<td valign="top" width="50%">
			<cfif isdefined("LvarReadOnly")>
				&nbsp;
			<cfelse>
				<cfinclude template="ObjetosSN-form.cfm">
			</cfif>
		</td>
	</tr>
</table>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		function descargar(SNOid, SNcodigo){
			var param  = "SNOid=" + SNOid + "&SNcodigo=" + SNcodigo;
			document.listaObjetos.nosubmit=true;

			if ((SNOid != "") && (SNcodigo != "")) {
				document.listaObjetos.action = 'AbrirArchivoSN.cfm?' + param;
				document.listaObjetos.submit();
			}
			return false;
		}
	</script>
</cfoutput>
<cfelse>
	<table align="center">
		<tr>
			<td>#MSG_Primero#&nbsp;<strong>#MSG_DatGral#</strong>&nbsp;#MSG_delSNeg#</td>
		</tr>
	</table>
</cfif>