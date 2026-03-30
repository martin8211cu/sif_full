<cfif isdefined("Form.btnGenerar")>
	<cfset myArrayList = ListToArray(form.FCAperiodicidad)>
	<cfset cadenaPeriodicidad = "">	
	
	<cfif ArrayLen(myArrayList) EQ 1 >	<!--- Un solo check marcado --->
		<cfset cadenaPeriodicidad = "'" & form.FCAperiodicidad & "'">	
	<cfelseif ArrayLen(myArrayList) GT 1 >	<!--- Varios checks marcados --->
		<cfloop index = "LoopCount" from = "1" to = "#ArrayLen(myArrayList)#">   
			<cfif LoopCount NEQ ArrayLen(myArrayList)>
				<cfset cadenaPeriodicidad = cadenaPeriodicidad & "'" & myArrayList[LoopCount] & "',">		   						
			<cfelse>
				<cfset cadenaPeriodicidad = cadenaPeriodicidad & "'" & myArrayList[LoopCount] & "'">		   						
			</cfif>
		</cfloop>
	</cfif>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsContratos">
		Select distinct c.CEcontrato, c.CEcuenta, c.CEdescripcion, c.CEtitular, c.CEcodigo
		from ContratoEdu c, Alumnos a
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and c.CEcodigo = a.CEcodigo
		and c.CEcontrato = a.CEcontrato
		and not exists (select 1 from  EFactura x
						 where x.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						   and x.EFfechadoc = convert( datetime, <cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103)
						   and x.CEcontrato = c.CEcontrato
						)
		and (exists(select 1 from FactConceptosAlumno fca, FacturaConceptos fc
				    where a.Ecodigo = fca.Ecodigo
					  and a.CEcodigo = fca.CEcodigo
					  and fca.FCid = fc.FCid
					  and fca.FCAperiodicidad in (#PreserveSingleQuotes(cadenaPeriodicidad)#)
					  and fca.FCfechainicio <= convert( datetime, 	<cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103)
					  and fca.FCfechafin >= convert( datetime, 		<cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103)
					  and fca.FCmesinicio <= datepart( month,  convert( datetime, 		<cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103))
					  and fca.FCmesfin >= datepart( month,  convert( datetime, 		<cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103))
			) or
			exists(select 1 from Incidencias i
					where a.CEcodigo = i.CEcodigo
					  and a.Ecodigo = i.Ecodigo
			))
	</cfquery>
	<cfset codContrato = "">
	
	<cfif isdefined('rsContratos') and rsContratos.recordCount GT 0>
		<cftransaction>
			<cftry>
				<cfloop query="rsContratos"> 	<!--- Ciclo con todos los contratos existentes por Centro Educativo --->
					<cfset codContrato = rsContratos.CEcontrato>
					<!--- Insertar Encabezado de factura--->
						<cfquery name="qryFacturas" datasource="#Session.Edu.DSN#">
							set nocount on
								declare @maxFact numeric
								select @maxFact = (select (
									isnull(max(EFconsecutivo),0)
								 ) +1
								from EFactura)
							
								insert EFactura 
								(EFconsecutivo,  EFnumdoc, EFnombredoc, CEcontrato, CEcodigo, EFfechadoc,
									 EFfechavenc, EFfechasis, EFporcdesc, EFmontodesc, EFtotal,
									 EFestado, EFobservacion, Usucodigo, Ulocalizacion)
								values (
									@maxFact,
									convert(varchar,@maxFact),
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContratos.CEtitular#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsContratos.CEcontrato#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,															
									convert( datetime, <cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103 ),
									convert( datetime, <cfqueryparam value="#form.EFfechavenc#" cfsqltype="cf_sql_varchar">, 103 ),
									getDate(),
									0, 0, 0,'T',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EFobservacion#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
								)
								select @@identity as nFactura
							set nocount off
						</cfquery>
						<!--- Fin Insertar Encabezado de factura --->
						<!--- Query Alumnos con Conceptos--->
						<cfset nuevaFact = "">
						<cfif isdefined('qryFacturas') and qryFacturas.recordCount GT 0>	<!--- Logro hacer el ALTA del encabezado de la factura --->
							<cfset nuevaFact = qryFacturas.nfactura>
							<cfquery datasource="#Session.Edu.DSN#" name="rsContratoDET"> 	<!--- Seleccion de todos los alumnos del contrato actual --->	
								select CEcontrato, convert(varchar,a.Ecodigo) as Ecodigo, 
								convert(varchar,fca.FCid) as FCid, 
								FCAmontores, 
								FCdescripcion
								from Alumnos a,
									FactConceptosAlumno fca,
									FacturaConceptos fc
								where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
									and a.Ecodigo = fca.Ecodigo
									and a.CEcodigo = fca.CEcodigo
									and fca.FCid = fc.FCid
									and FCAperiodicidad in (#PreserveSingleQuotes(cadenaPeriodicidad)#)	
									and fca.FCfechainicio <= convert( datetime, <cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103 )	
									and fca.FCfechafin >= convert( datetime, <cfqueryparam value="#form.EFfechadoc#" cfsqltype="cf_sql_varchar">, 103 )	
									and CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(codContrato)#">
							</cfquery>
						</cfif>
						<!--- Fin Query Alumnos con Conceptos--->
				 		<!--- Insertar Lineas de Detalle --->
						<cfif isdefined('rsContratoDET') and rsContratoDET.recordCount GT 0>	<!--- Conceptos del contrato "X" --->
							<cfloop query="rsContratoDET">						
								<cfquery name="qryAltaConceptos" datasource="#Session.Edu.DSN#">
									set nocount on
									declare @key numeric

									insert DFactura 
										(EFid, CEcodigo, Ecodigo, FCid, DFdescripcion, DFmonto, DFcantidad, DFtotal, 
												DFdesc, Usucodigo, Ulocalizacion)
									values (
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevaFact#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDET.Ecodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDET.FCid#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContratoDET.FCdescripcion#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDET.FCAmontores#">,
											1,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratoDET.FCAmontores#">,
											0,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
										)							

									select @key = @@identity

									<!--- Actualizar el monto total --->
									update EFactura 
									set EFtotal = (select sum(b.DFtotal) from DFactura b where b.EFid = EFactura.EFid)
									where EFid = (select EFid from DFactura where DFlinea = @key)

									set nocount off
								</cfquery>
							</cfloop>
						</cfif>
						<!--- Fin Insertar Lineas de Detalle --->
						<cfset nuevoAlumno = "">
				 		<!--- Query Alumnos con Incidencias --->				
						<!--- <cfset nuevoAlumno = rsContratoDET.Ecodigo> --->	
						<cfquery datasource="#Session.Edu.DSN#" name="rsIncidenciasEstud"> <!--- Seleccion de todas las incidencias del alumno del encargado actual --->
							select i.* from Incidencias i, Alumnos a
							where i.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
								and convert(datetime,i.Ifecha,103) <= convert( datetime, <cfqueryparam value="#form.Ifecha#" cfsqltype="cf_sql_varchar">, 103 )
								and a.CEcodigo = i.CEcodigo
								and a.Ecodigo = i.Ecodigo
								and a.CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(codContrato)#">
						</cfquery>
						
				 		<!--- Fin Query Alumnos con Incidencias --->										
						<!--- Insercion de Incidencias del Estudiante --->
						<cfif isdefined('rsIncidenciasEstud') and rsIncidenciasEstud.recordCount GT 0>
							<cfloop query="rsIncidenciasEstud">
								<cfquery name="qryAltaIncidencias" datasource="#Session.Edu.DSN#">
									set nocount on
									declare @key numeric
								<!--- Error al grabar detalle de incidencias , el encabezado lo hace bien --->
									insert DFactura 
										(EFid, CEcodigo, Ecodigo, ITid, DFdescripcion, DFmonto, DFcantidad, DFtotal, 
												DFdesc, Usucodigo, Ulocalizacion)
									values (
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevaFact#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidenciasEstud.Ecodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidenciasEstud.ITid#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidenciasEstud.Idescripcion#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidenciasEstud.Imonto#">,
											1,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidenciasEstud.Imonto#">,
											0,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
										)
									
									select @key = @@identity
									
									<!--- Actualizar el monto total --->
									update EFactura 
									set EFtotal = (select sum(b.DFtotal) from DFactura b where b.EFid = EFactura.EFid)
									where EFid = (select EFid from DFactura where DFlinea = @key)
									
									<!--- Borrado de la incidencia anteriormente insertada --->

									delete Incidencias
									where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidenciasEstud.Iid#">							
									  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidenciasEstud.Ecodigo#">
									  and convert(datetime,Ifecha,103) <= convert( datetime, <cfqueryparam value="#form.Ifecha#" cfsqltype="cf_sql_varchar">, 103 )
									set nocount off
								</cfquery>
							</cfloop>
						</cfif>
						<!--- Fin Insercion de Incidencias del Estudiante --->						
				</cfloop>
			<cfcatch type="any">
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
			</cftry>
		</cftransaction>
	</cfif>		
</cfif>
<form action="generacion.cfm" method="post" name="sql">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
