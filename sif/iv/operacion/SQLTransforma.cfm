<cfset modo="ALTA">
<cfset modoDet="ALTA">
<cfset Action="">
<cfset Action="Transforma.cfm">

<cftry>
<!---BORRAR ENCABEZADO--->
	<cfif isdefined("Form.btnBorrarE")>
	
		<cfquery datasource="#Session.DSN#">
			delete from TransformacionProducto
			where ETid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
		</cfquery>
		
		<cfquery datasource="#Session.DSN#">
			delete from CPGastosProduccion
			where ETid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
		</cfquery>
		
	    <cfquery datasource="#Session.DSN#">
			delete from DTransformacion
			where ETid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
		</cfquery>
		
		<cfquery datasource="#Session.DSN#">	
			delete from ETransformacion
			where Ecodigo = #Session.Ecodigo# 
			  and ETid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
		</cfquery>
		
		<cfset modo="ALTA">
		<cfset modoDet="ALTA">
<!---BORRAR DETALLE--->
<cfelseif isdefined("Form.btnBorrarD")>
		<cfquery datasource="#Session.DSN#">
			delete from DTransformacion
			where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			  and DTlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTlinea#">
		</cfquery>
		
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">	
<!---CAMBIAR ENCABEZADO--->							  
<cfelseif isdefined("Form.btnCambiarE")>
		<cf_dbtimestamp
					datasource="#session.dsn#"
					table="ETransformacion" 
					redirect="Transforma-form2.cfm"
					timestamp="#Form.timestampE#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="ETid,numeric,#Form.ETid#">
					
		<cfquery datasource="#Session.DSN#">
			update ETransformacion set 			
				ETdocumento   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETdocumento#">,
				ETobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ETobservacion)#">
			where Ecodigo = #Session.Ecodigo#
			  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">				
		</cfquery>
		
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">								  
		<cfset Action="Transforma-form2.cfm">
<!---CAMBIO DETALLE--->		
<cfelseif isdefined("Form.btnCambiarD")>		
		<cf_dbtimestamp
					datasource="#session.dsn#"
					table="ETransformacion" 
					redirect="Transforma-form2.cfm"
					timestamp="#Form.timestampE#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="ETid,numeric,#Form.ETid#">
					
		<cfquery datasource="#Session.DSN#">
			update ETransformacion set 
				ETdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETdocumento#">,
				ETobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ETobservacion)#">
			where Ecodigo =  #Session.Ecodigo# 
			  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">				
		</cfquery>
		
			<cf_dbtimestamp
					datasource="#session.dsn#"
					table="DTransformacion" 
					redirect="Transforma-form2.cfm"
					timestamp="#Form.timestampE#"
					field1="ETid,numeric,#form.ETid#"
					field2="DTlinea,numeric,#Form.DTlinea#">
					
		<cfquery datasource="#Session.DSN#">	
			update DTransformacion set		
				DTinvinicial = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTinvinicial#">, 
				DTrecepcion = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTrecepcion#">, 
				DTprodcons = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTprodcons#">, 
				DTembarques = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTembarques#">, 
				DTconsumopropio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTconsumopropio#">, 
				DTperdidaganancia = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTperdidaganancia#">, 
				DTinvfinal = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DTinvfinal#">, 						
				DTobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DTobservacion#">			
			where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			  and DTlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTlinea#">
		  </cfquery>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
<!---NUEVO--->		
<cfelseif isDefined("btnNuevo")>		
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">	
<!---NUEVO DETALLE--->
<cfelseif isDefined("btnNuevoD")>		
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
<!---CONCILIACION--->
<cfelseif isDefined("btnConcilia")>		
	<cfset Action="/cfmx/sif/iv/consultas/ConciliaTransito-SQL.cfm?ETid=#Form.ETid#">	
<!---CONCEPTOS--->
<cfelseif isDefined("btnConceptos")>		
	<cfset Action="/cfmx/sif/iv/operacion/GastosProduccion.cfm?ETid=#Form.ETid#">	
<!---SUMARIO--->	
<cfelseif isDefined("btnSumario")>		
	<cfset Action="/cfmx/sif/iv/consultas/Sumario-SQL.cfm?ETid=#Form.ETid#">	
</cfif>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<form action="<cfoutput>#Action#</cfoutput>" method="post" name="sql">
	<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">		
	<cfif isDefined("btnNuevo")>
		<input name="ETid" type="hidden" value="">
	<cfelse>
		<input name="ETid" type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
	</cfif>
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>