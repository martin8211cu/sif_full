<cfparam name="modo" default="CAMBIO">
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset CFSolicitud = ObtenerDato(3200)>
<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif CFSolicitud.Recordcount GT 0 and len(trim(CFSolicitud.Pvalor)) gt 0><cfset hayCFSolicitud = 1 ><cfelse><cfset hayCFSolicitud = 0 ></cfif>

<cfset rsNumGar = ObtenerDato(4000)>
<cfif rsNumGar.Recordcount GT 0 and len(trim(rsNumGar.Pvalor)) gt 0><cfset hayNumGar = 1 ><cfelse><cfset hayNumGar = 0 ></cfif>
<cfquery name="rsConseGarantiaH" datasource="#session.DSN#">
	select coalesce(max(COEGReciboGarantia),1) as consecutivo
	from COHEGarantia
	where COEGVersionActiva = 1 <!--- Activa --->
	  and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsConseGarantia" datasource="#session.DSN#">
	select coalesce(max(COEGReciboGarantia),1) as consecutivo
	from COEGarantia
	where COEGVersionActiva = 1 <!--- Activa --->
	  and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfif rsConseGarantia.consecutivo gt rsConseGarantiaH.consecutivo>
	<cfset LvarConsecutivoSugerido = rsConseGarantia.consecutivo>
<cfelse>
	<cfset LvarConsecutivoSugerido = rsConseGarantiaH.consecutivo>
</cfif>
<cf_templateheader title="Garantías">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start titulo="Par&aacute;metros Generales">
<cfoutput>
<form action="parametros_SQL.cfm" name="form1" method="post" onSubmit="return fnValidar(this);">
	<table border="0" width="100%">
	<tr>
		<td width="50%" align="right">Centro Funcional Para las Solicitudes:</td>
		<td width="50%" align="left">
			<cfset valuesArray = ListtoArray('')>
			<cfif hayCFSolicitud>
				<cfquery name="CFuncional" datasource="#Session.DSN#">
					select CFid,CFcodigo,CFdescripcion
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">  
					  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFSolicitud.Pvalor#">
				</cfquery>
				<cfset valuesArray = ListtoArray('#CFuncional.CFid# ¬ #CFuncional.CFcodigo# ¬ #CFuncional.CFdescripcion#', '¬')>
			</cfif>
			<cf_conlis
				Campos="CFid,CFcodigo,CFdescripcion"
				valuesArray="#valuesArray#"
				tabindex="1"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				form="form1"
				Size="0,15,35"
				Title="Lista de Centros Funcionales"
				Tabla="CFuncional cf"
				Columnas="CFid,CFcodigo,CFdescripcion"
				Filtro="cf.Ecodigo = #Session.Ecodigo# order by CFcodigo,CFdescripcion"
				Desplegar="CFcodigo,CFdescripcion"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CFcodigo,CFdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="CFid,CFcodigo,CFdescripcion"
				Asignarformatos="I,S,S"/>
			<input type="hidden" name="hayCFSolicitud" value="#hayCFSolicitud#" />
		</td>
	</tr>
	<tr>
		<td width="50%" align="right">Consecutivo Recibo Número de Garantia:</td>
		<td width="50%" align="left">
			<cf_inputNumber name="consecutivo" value="#rsNumGar.Pvalor#" comas="false">
		</td>
	</tr>
	<tr>
		<td colspan="2">	                    
			<cf_botones modo=#modo# exclude='BAJA,NUEVO'>
		</td>
	</tr></table>
</form>
<script language="javascript1.2" type="text/javascript">
	
	function fnValidar(f){
		msg = "";
		if(trim(f.consecutivo.value).length == 0){
			msg  = " - El campo Consecutivo Recibo Número de Garantia es requerido.";
		}
		if(qf(f.consecutivo.value) <= #LvarConsecutivoSugerido#){
			msg  = " - El valor del Consecutivo Recibo Número de Garantia debe ser mayor a #LvarConsecutivoSugerido#.";
			f.consecutivo.value = #LvarConsecutivoSugerido + 1#;
		}
		if(msg.length > 0){
			alert("Se presentaron los siguientes errores:\n"+msg);
			return false;
		}
		f.consecutivo.value = qf(f.consecutivo)
		return true;
	}

</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>