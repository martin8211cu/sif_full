<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="El_Dato_variable_ya_ha_sido_asignado_al_puesto"
Default="El Dato variable ya ha sido asignado al puesto"
returnvariable="MG_DatoYaExiste"/> 

<cfparam name="action" default="Puestos.cfm">
<cfparam name="modo" default="ALTA">

<cfif isdefined("form.btnAgregar")>
	
	<cfquery name="existe" datasource="#session.DSN#">
		select count(RHEDVid) as registros 
		from RHDVPuesto a, RHPuestos b 
		where a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo
		and b.RHPcodigo = '#form.RHPcodigo#'
		and a.RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
		and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">	
	</cfquery>

	<cfif existe.registros NEQ 0>		
		<cfset Request.Error.Backs = 1>
		<cf_throw message="#MG_DatoYaExiste#" errorcode="2160">
		<cfset modo = 'ALTA'>
	<cfelse>
	     <cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
			select RHPcodigo from RHPuestos
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			and RHPcodigo = '#form.RHPcodigo#'
		</cfquery>					
		
		<cfquery name="insert" datasource="#session.DSN#">		
			insert into RHDVPuesto(Ecodigo, RHEDVid, RHDDVlinea, BMUsucodigo, fechaalta, RHDVPorden, RHPcodigo, RHDDVvalor) 
			values (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,				
					<cfif len(trim(form.RHEDVid))><cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
					<cfif len(trim(form.RHDDVlinea))><cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
					<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					<cf_dbfunction name="now">,
                   	<cf_jdbcquery_param value="#form.RHDVPorden#" cfsqltype="cf_sql_integer" voidnull>,
					<cfqueryparam value="#RHPuestoObtenerCodigo.RHPcodigo#" cfsqltype="cf_sql_char">,
					<cfif isdefined("Form.RHDDVvalor") and Len(Trim(Form.RHDDVvalor))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(Form.RHDDVvalor)#">
					<cfelse>
						null
					</cfif>
			)		
		</cfquery>	
		<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
			update RHPuestos 
			set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 	 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo = '#form.RHPcodigo#' 
		</cfquery>		
	</cfif>
	<cfset modo = 'ALTA'>
</cfif>	

<cfif isdefined("form.borrar")>
	<cfquery name="delete" datasource="#session.DSN#">
		delete from RHDVPuesto
		where RHPcodigo = (select RHPcodigo from RHPuestos
						   where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						   and RHPcodigo ='#form.RHPcodigo#') 
		and RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
		and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">	
	</cfquery>
	<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
		update RHPuestos 
		set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and RHPcodigo = '#form.RHPcodigo#' 
	</cfquery>		
	<cfset modo = 'ALTA'> 
</cfif>

<cfif isdefined("form.btnModificar")>				
	<cfquery name="update" datasource="#session.DSN#">
		update RHDVPuesto set 
			RHDVPorden = <cfif len(trim(form.RHDVPorden))><cfqueryparam value="#form.RHDVPorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
			RHDDVvalor = <cfif isdefined("Form.RHDDVvalor") and Len(Trim(Form.RHDDVvalor))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDDVvalor#"><cfelse>null</cfif>
		where RHPcodigo = (select RHPcodigo from RHPuestos
						   where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						   and RHPcodigo ='#form.RHPcodigo#') 
		and RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
		and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">	
	</cfquery>
	<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
		update RHPuestos 
		set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and RHPcodigo = '#form.RHPcodigo#' 
	</cfquery>		
	<cfset modo = 'CAMBIO'> 
</cfif>
<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="sel"    type="hidden" value="1">
	<input name="o" type="hidden" value="4">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#">
	<cfif modo eq 'CAMBIO'>
		<input name="RHDDVlinea" type="hidden" value="#form.RHDDVlinea#">		
		<input name="RHDVPorden" type="hidden" value="#form.RHDVPorden#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>