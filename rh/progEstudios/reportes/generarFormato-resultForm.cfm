<cfset procesado_ok = false>
<cfif isdefined("Url.CSEid") and len(trim(Url.CSEid))>
	<cfset Form.CSEid = Url.CSEid>
</cfif>
<cfquery name="rsData" datasource="#session.dsn#">
	select convert(varchar,a.CSEfrecoge,103) as fecha, 
		b.DEid, b.DEidentificacion, 
		c.EFid, c.EFcodigo
	from CertificacionesEmpleado a
	inner join DatosEmpleado b
		on b.DEid = a.DEid
	inner join EFormato c
		on c.EFid = a.EFid
	where a.CSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSEid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FormatoGenerado"
	Default="Formato Generado"
	returnvariable="LB_FormatoGenerado"/> 

<cf_htmlReportsHeaders 
	irA="generarFormato.cfm"
	FileName="Certificacion.xls"
	title="#LB_FormatoGenerado#">
	<table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<cfif isdefined("rsData.EFid") and Len(Trim(rsData.EFid)) NEQ 0>
				
					<cfquery name="rsFormatos" datasource="#Session.DSN#">
						select a.EFcodigo, a.TFid, a.EFfecha, a.EFdescripcion, 
							   b.DFlinea, b.DFtexto, c.TFsql
						from EFormato a, DFormato b, TFormatos c
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and a.EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.EFid#">
						and a.EFid *= b.EFid
						and a.TFid = c.TFid
					</cfquery>
					<cfif rsFormatos.recordCount GT 0>
						
						<cfquery name="rsParamsList" datasource="#Session.DSN#">
							select convert(varchar, PFid) as PFid,
								   convert(varchar, TFid) as TFid,
								   PFcampo,
								   case PFtipodato when 1 then 'varchar(255)' when 2 then 'int' when 3 then 'datetime' when 4 then 'money' when 5 then 'numeric' when 6 then 'float' else '' end as TipoDato,
								   case PFtipodato when 1 then 'cf_sql_varchar' when 2 then 'cf_sql_integer' when 3 then 'cf_sql_varchar' when 4 then 'cf_sql_money' when 5 then 'cf_sql_numeric' when 6 then 'cf_sql_float' else '' end as CFtipodato
							from PFormato
							where TFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormatos.TFid#">
						</cfquery>
						
						<cfset salida = rsFormatos.DFtexto>
						
						<cfquery name="rsQuery" datasource="#Session.DSN#">
							<cfif rsParamsList.recordCount GT 0>
							declare 
								<cfloop query="rsParamsList">
									<cfif currentRow NEQ 1>, </cfif>
									@#PFcampo# #TipoDato#
								</cfloop>

							select 
								<cfloop query="rsParamsList">
									<cfif currentRow NEQ 1>, </cfif>
									@#PFcampo# = 
									<cfif rsParamsList.TipoDato EQ "datetime">
										convert(datetime, <cfqueryparam cfsqltype="#CFtipodato#" value="#Evaluate('rsData.#PFcampo#')#">, 103)
									<cfelse>
										<cfqueryparam cfsqltype="#CFtipodato#" value="#Evaluate('rsData.#PFcampo#')#">
									</cfif>
								</cfloop>
							</cfif>

							declare @Ecodigo numeric
							select @Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">

							#PreserveSingleQuotes(rsFormatos.TFsql)#
					
						</cfquery>
						<cfif rsQuery.Recordcount GT 0>
							<cfset metadata = rsQuery.getMetadata() >
							
							<cfloop list="#rsQuery.ColumnList#" index="c">
								<cfset valor = Evaluate('rsQuery.#Trim(c)#')>
								<cfif metadata.getColumnTypeName(rsQuery.findColumn("#trim(c)#")) EQ 'money'>
									<cfset valor = LSCurrencyFormat(valor, 'none')>
								</cfif>
								<cfset salida = replace(salida, '###metadata.getcolumnname(rsQuery.findColumn("#trim(c)#"))###', valor, 'all')>
							</cfloop>
							<!--- Variables del sistema --->
							<cfset salida = replace(salida, '##hoy##', LSDateFormat(Now(), 'dd/mm/yyyy'), 'all')>
							<cfset salida = replace(salida, '##usuario##', session.datos_personales.nombre & ' ' & session.datos_personales.apellido1 & ' ' & session.datos_personales.apellido2 , 'all')>
							<cfset pos = find('##letras(', salida)>
							<cfloop condition="pos GT 0">
								<cfset pos1 = find(')##', salida, pos)>
								<cfif pos1 GT 0>
									<cfset valor = Mid(salida, pos+8, pos1-(pos+8))>
									<cfset valor = replace(valor, ',', '', 'all')>
									<cfif Val(valor) NEQ 0>
										<!--- <cfquery name="rsConvert" datasource="#Session.DSN#">
											declare @montoletras varchar(255)
											exec sp_MontoLetras @Monto = #valor#, @Letras = @montoletras output
											select @montoletras as montoletras
										</cfquery> --->
										<cfinvoke component="rh.Componentes.sp_MontoLetras" method="MontoLetras" returnvariable="rsConvert.montoletras">
											<cfinvokeargument name="conexion" value="#session.DSN#">		
											<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
											<cfinvokeargument name="debug" value="false">
											<cfinvokeargument name="Monto" value="#valor#">
										</cfinvoke>
										<cfset salida = Mid(salida, 1, pos-1) & UCase(rsConvert.montoletras) & Mid(salida, pos1+2, Len(salida))>
									<cfelse>
										<cfset salida = Mid(salida, 1, pos-1) & UCase('CERO con 0/100 ctvos.') & Mid(salida, pos1+2, Len(salida))>
									</cfif>
								</cfif>
								<cfset pos = find('##letras(', salida, pos+1)>
							</cfloop>
							<cfoutput>
								#salida#
							</cfoutput>
							<cfset procesado_ok = true>
						<cfelse>
							<cfset empl1 = "seleccionado">
							<cfif isdefined("rsData.DEidentificacion")>
								<cfquery name="rsEmpl1" datasource="#Session.DSN#">
									select {fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ' )}, DEapellido2 )}, ' ' )}, DEnombre )} as NombreCompleto
									from DatosEmpleado where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsData.DEidentificacion)#">
								</cfquery>
								<cfif rsEmpl1.RecordCount GT 0>
									<cfset empl1 = rsEmpl1.NombreCompleto>
								</cfif>
							</cfif>
							<cf_translate key="LB_ElEmpleado">El Empleado</cf_translate> <cfoutput>#empl1#</cfoutput> <cf_translate key="LB_NoTieneDatosParaEsteFormato">no tiene datos para este formato</cf_translate>.
						</cfif>
					</cfif>
				<cfelse>
					<cf_translate key="LB_ElFormatoSolicitadoEsInvalido">El Formato solicitado es inv&aacute;lido</cf_translate>.
				</cfif>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>