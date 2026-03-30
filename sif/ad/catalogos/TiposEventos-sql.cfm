<cfparam name="Param" 	default="">
<cfparam name="form.TEVEdefault_chk" default="0">
<cfparam name="form.TEVENotifica_chk" default="0">

<cfif not isdefined('Form.BAJADETE') and isdefined('url.BAJADETE')>
	<cfset Form.BAJADETE = url.BAJADETE>
</cfif>

<cfif not isdefined('Form.TEVid') and isdefined('url.TEVid')>
	<cfset Form.TEVid = url.TEVid>
</cfif>
<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="ALTA_Tipo_Evento" returnvariable="TEVid">
		<cfinvokeargument name="TEVcodigo" 		value="#form.TEVcodigo#">
		<cfinvokeargument name="TEVDescripcion"  value="#form.TEVDescripcion#">
	</cfinvoke>
	
	<cfset Param = "TEVid=#TEVid#">
	<cflocation url="TiposEventos.cfm?TEVid=#TEVid#&TEVcodigo=#form.TEVcodigo#" addtoken="no">

<cfelseif isdefined('NUEVO')>	
		<cflocation url="TiposEventos.cfm?Nuevo=nuevo" addtoken="no">
	
	
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="CAMBIO_Tipo_Evento">
		<cfinvokeargument name="TEVid" 			value="#form.TEVid#">
		<cfinvokeargument name="TEVcodigo" 		value="#form.TEVcodigo#">
		<cfinvokeargument name="TEVDescripcion"  value="#form.TEVDescripcion#">
	</cfinvoke>
	<cfset Param = "TEVid=#form.TEVid#">
		<cflocation url="TiposEventos.cfm?TEVid=#form.TEVid#&TEVcodigo=#form.TEVcodigo#" addtoken="no">
	
	
	
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="BAJA_Tipo_Evento">
		<cfinvokeargument name="TEVid" 			value="#form.TEVid#">
		<cfinvokeargument name="TEVcodigo" 		value="#rtrim(form.TEVcodigo)#">
	</cfinvoke>
	<cflocation url="TiposEventos.cfm" addtoken="no">
	
<cfelseif isdefined('ALTADET')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="ALTALISTA_Estado">
		<cfinvokeargument name="TEVid" 				value="#form.idTEV#">
		<cfinvokeargument name="TEVECodigo" 		value="#form.codigo#">
		<cfinvokeargument name="TEVEDescripcion"  value="#form.descripcion#">
		<cfinvokeargument name="TEVEdefault"  	value="#form.TEVEdefault_chk#">
		<cfinvokeargument name="TEVENotifica" 	value="#form.TEVENotifica_chk#">
	</cfinvoke>
	<cfset Param = "TEVid=#form.TEVid#&TEVECodigo=#form.TEVECodigo#">
		<cflocation url="TiposEventos.cfm?TEVid=#form.idTEV#&Codigo=#Codigo#&TEVECodigo=#TEVECodigo#" addtoken="no">
	
<cfelseif isdefined('BAJADET')>
		
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 
				TEVEdefault 
			from TipoEventoEstado  
			where TEVECodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.codigo#"> 	
			and TEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.idTEV#">
	</cfquery>
		

		<cfinvoke component="sif.Componentes.ControlEventos" method="BAJALISTA_Estado">
			<cfinvokeargument name="TEVid" 				value="#form.idTEV#">
			<cfinvokeargument name="TEVECodigo" 		value="#form.codigo#">
			<cfinvokeargument name="TEVEDescripcion"	value="#form.descripcion#">
		</cfinvoke>

	<cfset Param = "TEVid=#form.idTEV#&CodigoTEVE=#form.TEVECodigo#">
		<cflocation url="TiposEventos.cfm?TEVid=#form.idTEV#&Codigo=#Codigo#&TEVECodigo=#TEVECodigo#" addtoken="no">
		
<cfelseif isdefined('CAMBIODET')>
	<cfinvoke component="sif.Componentes.ControlEventos" method="CAMBIOLISTA_Estado">
		<cfinvokeargument name="TEVid" 				value="#form.idTEV#">
		<cfinvokeargument name="TEVECodigo" 		value="#form.codigo#">
		<cfinvokeargument name="TEVEDescripcion" 	value="#form.descripcion#">
		<cfinvokeargument name="TEVENotifica" 		value="#form.TEVENotifica_chk#">
	</cfinvoke>
	<cfset Param = "TEVid=#form.idTEV#&CodigoTEVE=#form.TEVECodigo#">
		<cflocation url="TiposEventos.cfm?TEVid=#form.idTEV#&Codigo=#Codigo#&TEVECodigo=#TEVECodigo#" addtoken="no">
		
		

	<cfelseif isdefined('NUEVODET')>	
		<cflocation url="TiposEventos.cfm?TEVid=#form.idTEV#&Codigo=#Codigo#&TEVECodigo=#TEVECodigo#&Nuevo=nuevo" addtoken="no">
	
	
<cfelseif isdefined('ALTADETE')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="ALTAConfig">
		<cfinvokeargument name="DVTcodigo" 			value="TEV">
		<cfinvokeargument name="DVid"  	    		value="#form.DVid#">
		<cfinvokeargument name="DVCidTablaCnf" 	value="#form.TEVid#">
	</cfinvoke>
		<cflocation url="TiposEventos.cfm?TEVid=#form.TEVid#" addtoken="no">
		
<cfelseif isdefined('BAJADETE')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="BAJAConfig">
		<cfinvokeargument name="DVTcodigo" 			value="TEV">
		<cfinvokeargument name="DVid"  		 		value="#form.idDatoVariable#">
		<cfinvokeargument name="DVCidTablaCnf"	   value="#form.TEVid#">
</cfinvoke>
		<cflocation url="TiposEventos.cfm?TEVid=#form.TEVid#" addtoken="no">

</cfif>

<cflocation url="TiposEventos.cfm?TEVid=#form.TEVid#" addtoken="no">
