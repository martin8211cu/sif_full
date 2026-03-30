<!--- <cfdump var="#form#">
CIEcodigo <cfdump var="#CIEcodigo#"><br>
CILcodigo <cfdump var="#CILcodigo#"><br>
timestampD <cfdump var="#timestampD#"><br>
<cfabort>  --->
<cfset action = "CicloLectivo.cfm">
<cfparam name="form.CILhorasLeccion" default="1">
<cfif not isdefined("form.btnNuevoD") and not isdefined("form.btnNuevoE")>
	<cftry>
		<cfset modo="CAMBIO">
		<cfquery name="ABC_CicloLectivo" datasource="#Session.DSN#">
			set nocount on
			<!--- Caso 1: Agregar Encabezado --->
	
			<cfif isdefined("Form.btnAgregarE")>
				declare @CILcodigo numeric
				
				insert CicloLectivo (Ecodigo, CILnombre, CILcicloLectivo,CLTcicloEvaluacion, CILciclos, CILtipoCalificacion,
					  CILpuntosMax, CILunidadMin,CILredondeo, TEcodigo, 
					  TRcodigo, CILtipoCicloDuracion, PEVcodigo, CILhorasLeccion,TTcodigoMatricula,TTcodigoCurso)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CILnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CILcicloLectivo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CILciclos#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.CILtipoCalificacion#">,
							<cfif form.CILtipoCalificacion EQ '2'>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILpuntosMax#" scale="2">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILunidadMin#" scale="2">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILredondeo#" scale="3">,
								null,
							<cfelseif form.CILtipoCalificacion EQ '1'>
								100,0.01,0,null,
							<cfelseif form.CILtipoCalificacion EQ 'T'>
								null,null,null,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#">,	
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TRcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.CILtipoCicloDuracion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEVcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILhorasLeccion#" scale="2">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TTcodigoMatricula#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TTcodigoCurso#">)
														
					select @CILcodigo = @@identity
					
					<cfloop index="i" from="1" to=#form.CILciclos#>
						insert into CicloEvaluacion(CILcodigo, CIEnombre, CIEcorto, CIEextraordinario, CIEsemanas, CIEvacaciones, CIEsecuencia)
						values (@CILcodigo, 
						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#"> + ' <cfoutput>#i#</cfoutput>',
						  substring(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#">,1,3) + ' <cfoutput>#i#</cfoutput>',
						  0,
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CLTsemanas#">,
						  <cfif i EQ form.CILciclos>
							  0,
						  <cfelse>
							  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CLTvacaciones#">,
						  </cfif>
						  <cfoutput>#i#</cfoutput>)
					</cfloop>
	
				select @CILcodigo as id
				<!--- <cfset action = "CicloLectivo.cfm"> --->
				<cfset modoDet="ALTA">
			
			<!--- Caso 1.1: Cambia Encabezado --->
			<cfelseif isdefined("Form.btnCambiarE")>
				  
				update CicloLectivo
				set CILnombre = <cfqueryparam value="#form.CILnombre#" cfsqltype="cf_sql_varchar">
				   	,CILcicloLectivo = <cfqueryparam value="#form.CILcicloLectivo#" cfsqltype="cf_sql_varchar">
				   	,CLTcicloEvaluacion = <cfqueryparam value="#form.CLTcicloEvaluacion#" cfsqltype="cf_sql_varchar">
				   	,CILciclos = <cfqueryparam value="#form.CILciclos#" cfsqltype="cf_sql_integer">
   				   	,CILtipoCalificacion = <cfqueryparam value="#form.CILtipoCalificacion#" cfsqltype="cf_sql_char">
				   	<cfif form.CILtipoCalificacion EQ 'T'>
						, CILpuntosMax = null
						, CILunidadMin = null
						, CILredondeo = null
				   		, TEcodigo = <cfqueryparam value="#form.TEcodigo#" cfsqltype="cf_sql_numeric">
					<cfelse>	
						, CILpuntosMax = <cfqueryparam value="#form.CILpuntosMax#" cfsqltype="cf_sql_numeric" scale="2">
						, CILunidadMin = <cfqueryparam value="#form.CILunidadMin#" cfsqltype="cf_sql_numeric" scale="2">
						, CILredondeo = <cfqueryparam value="#form.CILredondeo#" cfsqltype="cf_sql_numeric" scale="3">
				   		, TEcodigo = null
				   	</cfif>
					,TRcodigo = <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_numeric">
					,CILtipoCicloDuracion = <cfqueryparam value="#form.CILtipoCicloDuracion#" cfsqltype="cf_sql_varchar">
					,PEVcodigo = <cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
					,CILhorasLeccion=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILhorasLeccion#" scale="2">
					,TTcodigoMatricula = <cfqueryparam value="#form.TTcodigoMatricula#" cfsqltype="cf_sql_numeric">					
					,TTcodigoCurso = <cfqueryparam value="#form.TTcodigoCurso#" cfsqltype="cf_sql_numeric">					
				where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
				  and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	  
				  
				delete CicloEvaluacion 
				where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
				  and CIEsecuencia > #form.CILciclos#
					  
				<cfloop index="i" from="1" to=#form.CILciclos#>
				  if not exists (select 1 from CicloEvaluacion
									where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
									  and CIEsecuencia = #i#)
					insert into CicloEvaluacion(CILcodigo, CIEnombre, CIEcorto, CIEextraordinario, CIEsemanas, CIEvacaciones, CIEsecuencia)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">, 
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#"> + ' <cfoutput>#i#</cfoutput>',
					  substring(rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#">)),1,3) + ' <cfoutput>#i#</cfoutput>',
					  0,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CLTsemanas#">,
					  <cfif i EQ form.CILciclos>
						  0,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CLTvacaciones#">,
					  </cfif>
					  <cfoutput>#i#</cfoutput> )
				</cfloop>					  
					  
				<cfset modoDet="ALTA">
			
			<!--- Caso 2: Borrar un Encabezado del CicloLectivo --->
			<cfelseif isdefined("Form.btnBorrarE")>			
				<cfif isdefined("Form.CILcodigo") AND Form.CILcodigo NEQ "" >
				  	delete CicloEvaluacion
					where CILcodigo = <cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">

					delete CicloLectivo 
					where CILcodigo=<cfqueryparam value="#form.CILcodigo#" cfsqltype="cf_sql_numeric">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">				
					
					<cfset modoDet="ALTA">									
				</cfif>
			<!--- Caso 3: Agregar Detalle de CicloLectivo y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
											
			<!--- Caso 4: Modificar Detalle del CicloLectivo y modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>
					  
					update CicloLectivo
					set CILnombre = <cfqueryparam value="#form.CILnombre#" cfsqltype="cf_sql_varchar">
					where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
					  and ts_rversion = convert(varbinary,#lcase(form.timestampE)#) 
					  
					update CicloEvaluacion 
					set CIEnombre = <cfqueryparam value="#form.CIEnombre#" cfsqltype="cf_sql_varchar">,
					 	CIEcorto = <cfqueryparam value="#form.CIEcorto_text#" cfsqltype="cf_sql_varchar">,
					<cfif isdefined("Form.CIEextraordinario")>
						CIEextraordinario = 1,
					<cfelse>
						CIEextraordinario = 0,
					</cfif>
					  CIEsemanas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIEsemanas#">
					  ,CIEvacaciones = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIEvacaciones#">
					where CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
					  and CIEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CIEcodigo#">
					  and ts_rversion = convert(varbinary,#lcase(form.timestampD)#) 
					
				<cfset modoDet="CAMBIO">				
				
			<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
			<cfelseif isdefined("Form.btnBorrarD")>
				<cfset modoDet="ALTA">								
			</cfif>					
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorpages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelse>
	<cfif isdefined("form.btnNuevoE")>
		<cfset modo = "ALTA" >
		<cfset modoDet = "ALTA">
	<cfelseif isdefined("form.btnNuevoD")>
		<cfset modo = "CAMBIO" >
		<cfset modoDet = "ALTA">
	</cfif>
</cfif>

<cfif isdefined("Form.btnAgregarE")>
	<cfset form.CILcodigo_alta = "#ABC_CicloLectivo.id#">
</cfif>

<cfoutput>

<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">

	<cfif modo eq "CAMBIO">
		<cfif not isdefined('form.btnBorrarE')>
			<input name="CILcodigo"  type="hidden" value="<cfif isdefined("Form.btnAgregarE")>#Form.CILcodigo_alta#<cfelse>#Form.CILcodigo#</cfif>">
		</cfif>
		<input name="CIEcodigo"  type="hidden" value="<cfif isdefined("Form.CIEcodigo")>#Form.CIEcodigo#</cfif>">
	</cfif>
	

	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
