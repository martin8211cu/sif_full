<cfset modo = 'ALTA'>
<cfif isdefined("url.AccionAEjecutar") and len(trim(url.AccionAEjecutar)) gt 0 and not isdefined("form.AccionAEjecutar")  >
	<cfset form.AccionAEjecutar = url.AccionAEjecutar>
</cfif>
<cfif isdefined("form.AccionAEjecutar") and len(trim(form.AccionAEjecutar)) gt 0>
	<cfif not form.AccionAEjecutar eq 'NUEVO' >
		<cfif form.AccionAEjecutar eq 'AGREGAR' >
			<cf_direccion action="readform" name="direccion">
			<cf_direccion action="insert" data="#direccion#" name="direccion">
			<cftransaction>
				<cfquery name="ABC_EmpresasTLC" datasource="#Session.DSN#">
					insert into EmpresasTLC (
						ETLCpatrono, 		
						ETLCnomPatrono,
						ETLCcomercial,
						ETLCdireccionEmp,
						ETLCcodigoElectoral,
						ETLCdescripcion,
						ETLCcantidadEmpleados,
						ETLCubicacion,
						ETLCplanilla,
						ETLCtelefonoL1,
						ETLCtelefonoL2,
						ETLCtelefonoE1,
						ETLCtelefonoE2,
						ETLCtelefonoE3,
						ETLCotrassenasE1,
						ETLCotrassenasE2,
						ETLCotrassenasE3,
						ETLCnomRepresentante,
						ETLCcedRepresentante,
						ETLCtel1Representante,
						ETLCtel2Representante,
						ETLCtel3Representante,
						ETLCdir1Representante,
						ETLCdir2Representante,
						ETLCdir3Representante,
                        ETLCreferencia,
						Ecodigo,
						BMUsucodigo,
						BMfechaalta
					)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCpatrono#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCnomPatrono#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCcomercial#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCcodigoElectoral#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_float" 	 value="#replace(form.ETLCcantidadEmpleados, ',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCubicacion#">,
						<cfqueryparam cfsqltype="cf_sql_float" 	 value="#replace(form.ETLCplanilla, ',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoL1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoL2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoE1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoE2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoE3#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCotrassenasE1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCotrassenasE2#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCotrassenasE3#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCnomRepresentante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCcedRepresentante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtel1Representante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtel2Representante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtel3Representante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdir1Representante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdir2Representante#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdir3Representante#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCreferencia#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
					)
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_EmpresasTLC">
			</cftransaction>
			<cfset form.ETLCid = ABC_EmpresasTLC.identity>
			<cfset modo = 'CAMBIO'>
		<cfelseif  form.AccionAEjecutar eq 'MODIFICAR' >
			<cfif  isdefined("direccion.id_direccion") and len(trim(direccion.id_direccion))>
				<cf_direccion action="readform" name="direccion">
				<cf_direccion action="update" data="#direccion#" name="direccion">
			<cfelse>
				<cf_direccion action="readform" name="direccion">
				<cf_direccion action="insert" data="#direccion#" name="direccion">
			</cfif>
			<cftransaction>
			<cfquery name="updateEmpresasTLC" datasource="#Session.DSN#">
				update  EmpresasTLC
				set 
					ETLCpatrono  			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCpatrono#">,
					ETLCnomPatrono 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCnomPatrono#">,
					ETLCcomercial 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCcomercial#">,
					ETLCdireccionEmp		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">, 
					ETLCcodigoElectoral		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCcodigoElectoral#">,
					ETLCdescripcion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdescripcion#">,
					ETLCcantidadEmpleados 	= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.ETLCcantidadEmpleados, ',','','all')#">,
					ETLCubicacion 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCubicacion#">,
					ETLCplanilla			= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.ETLCplanilla, ',','','all')#">,
					ETLCtelefonoL1 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoL1#">,
					ETLCtelefonoL2 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoL2#">,
					ETLCtelefonoE1  		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoE1#">,
					ETLCtelefonoE2  		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoE2#">,
					ETLCtelefonoE3  		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtelefonoE3#">,
					ETLCotrassenasE1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCotrassenasE1#">,
					ETLCotrassenasE2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCotrassenasE2#">,
					ETLCotrassenasE3		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCotrassenasE3#">,
					ETLCnomRepresentante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCnomRepresentante#">,
					ETLCcedRepresentante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCcedRepresentante#">,
					ETLCtel1Representante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtel1Representante#">,
					ETLCtel2Representante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtel2Representante#">,
					ETLCtel3Representante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCtel3Representante#">,
					ETLCdir1Representante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdir1Representante#">,
					ETLCdir2Representante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdir1Representante#">,
					ETLCdir3Representante 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCdir1Representante#">,
                    ETLCreferencia			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCreferencia#">
				where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
			</cfquery>
			<cfif isdefined("form.FTLCid") and len(trim(form.FTLCid)) gt 0 >
				<cfquery name="updateformato" datasource="#Session.DSN#">
					update  EmpFormatoTLC
						set
							<cfif isdefined("form.FTLCcedula")>
								FTLCcedula = 1 ,
							<cfelse>
								FTLCcedula = 0 ,
							</cfif>
							<cfif isdefined("form.FTLCnombreCKC")>
								FTLCnombreCKC = 1 ,
							<cfelse>
								FTLCnombreCKC = 0 ,
							</cfif>
							<cfif isdefined("form.FTLCapellido1CKC")>
								FTLCapellido1CKC = 1 ,
							<cfelse>
								FTLCapellido1CKC = 0 ,
							</cfif>
							<cfif isdefined("form.FTLCapellido2CKC")>
								FTLCapellido2CKC = 1 ,
							<cfelse>
								FTLCapellido2CKC = 0 ,
							</cfif>
							FTLCopcion1 = 1 ,
							<cfif isdefined("form.FTLCopcion2")>
								FTLCopcion2 = 1 ,
							<cfelse>
								FTLCopcion2 = 0 ,
							</cfif>
							<cfif isdefined("form.FTLCopcion3")>
								FTLCopcion3 = 1 ,
							<cfelse>
								FTLCopcion3 = 0 ,
							</cfif>
							<cfif isdefined("form.FTLCopcion4")>
								FTLCopcion4 = 1 ,
							<cfelse>
								FTLCopcion4 = 0 ,
							</cfif>
							FTLCdescricion1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCreferencia#">,
							FTLCdescricion2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCdescricion2#">,
							FTLCdescricion3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCdescricion3#">,
							FTLCdescricion4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCdescricion4#">,
							FTLCformato 	    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCformato#">
					where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
					and    FTLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FTLCid#">
				</cfquery>
			<cfelse>
				<cfquery name="insertformato" datasource="#Session.DSN#">
				   insert into  EmpFormatoTLC (
								ETLCid,
								FTLCcedula,
								FTLCnombreCKC,
								FTLCapellido1CKC,
								FTLCapellido2CKC,
								FTLCopcion1,
								FTLCopcion2,
								FTLCopcion3,
								FTLCopcion4,
								FTLCdescricion1,
								FTLCdescricion2,
								FTLCdescricion3,
								FTLCdescricion4,
								FTLCformato,
								BMUsucodigo,
								BMfechaalta)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">,
						<cfif isdefined("form.FTLCcedula")>
								 1 ,
							<cfelse>
								 0 ,
							</cfif>
							<cfif isdefined("form.FTLCnombreCKC")>
								 1 ,
							<cfelse>
								0 ,
							</cfif>
							<cfif isdefined("form.FTLCapellido1CKC")>
								 1 ,
							<cfelse>
								 0 ,
							</cfif>
							<cfif isdefined("form.FTLCapellido2CKC")>
								 1 ,
							<cfelse>
								0 ,
							</cfif>
							1 ,
							<cfif isdefined("form.FTLCopcion2")>
								1 ,
							<cfelse>
								0 ,
							</cfif>
							<cfif isdefined("form.FTLCopcion3")>
								1 ,
							<cfelse>
								0 ,
							</cfif>
							<cfif isdefined("form.FTLCopcion4")>
								1 ,
							<cfelse>
								 0 ,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETLCreferencia#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCdescricion2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCdescricion3#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCdescricion4#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTLCformato#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)
				</cfquery>
			</cfif>	 
			</cftransaction>
			<cfset modo = 'CAMBIO'>
		
		<cfelseif  form.AccionAEjecutar eq 'ELIMINAR' >
			<cftransaction>
				<cfquery name="deleteEmpresasTLC" datasource="#Session.DSN#">
					delete EmpFormatoTLC
					where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
				</cfquery>
				<cfquery name="deleteEmpresasTLC" datasource="#Session.DSN#">
					delete EmpresasTLC
					where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETLCid#">
				</cfquery>
			</cftransaction>
			<cfset modo = 'ALTA'>
		</cfif>
	</cfif>
</cfif>
<cfoutput>
	<form action="Empresas.cfm" method="post" name="sql">
		<cfif not modo eq 'ALTA'>
			<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0>
				<input name="ETLCid" type="hidden" value="#Form.ETLCid#">
			</cfif>
		</cfif>
	</form>
</cfoutput>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>