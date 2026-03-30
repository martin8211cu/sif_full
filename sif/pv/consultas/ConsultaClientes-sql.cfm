<!--- Creado por: 	  Rebeca Corrales Alfaro  --->
<!--- Fecha: 		  01/06/2005 11:00 a.m. --->
<!--- Modificado por: --->
<!--- Fecha: 		  --->
	<cfif isdefined("url.formato")>
		<cfset form.formato=url.formato>
	</cfif>
	<cfif isdefined("url.CDCcodigo")>
		<cfset form.CDCCodigo=url.CDCCodigo>
	</cfif>
	<cfif isdefined("url.Ppais")>
		<cfset form.Ppais=url.Ppais>
	</cfif>
	<cfset url.formato=form.formato>
	<cfset url.CDCCodigo=form.CDCCodigo>
	<cfset url.Ppais=form.Ppais>
    
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select
			 case A.CDCtipo
				when 'F' then 'Físico'
				when 'J' then 'Jurídico'	
				when 'E' then 'Extranjero'
				else '???'
			 end as tipo,	
			 ltrim(rtrim(CDCidentificacion)) as Identificacion,
			 ltrim(rtrim(CDCnombre)) as Nombre,
			 ltrim(rtrim(CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(CDCnombre)) as Cliente,
			 substring(A.CDCdireccion, 1, 60) as direccion, 
			 A.CDCtelefono as telefono,
			 A.CDCemail as email,  
			 coalesce((select B.Pnombre from Pais B where B.Ppais = A.Ppais), 'N/A') as Pais,
			 A.CDCfechaNac as fechanac, 
			 A.CDCFax as fax,
			 A.CDCporcdesc as descuento,
			 case A.CDCExentoImp
				when 1 then 'Si'	
				when 0 then 'No'
			 end as exento, 
			 A.LOCidioma as idioma
		 from ClientesDetallistasCorp as A
		 where A.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo))>
			and A.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
		</cfif>
		<cfif isdefined("url.Ppais") and len(trim(url.Ppais))>
			and A.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ppais#">
		</cfif>
	</cfquery>
	
	<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
		select e.Edescripcion
		from Empresas e
		where e.Ecodigo = #session.Ecodigo#
	</cfquery>

	<cfif url.Formato NEQ "HTML" and rsReporte.recordcount GT 30>
		<cf_templateheader title="Punto de Venta - Consulta de Clientes">
		<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<html>
				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>#rsNombreEmpresa.EDescripcion#</strong>	
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Consulta de Clientes</strong>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>					
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<table width="100%">
					<tr><td align="center">&nbsp;</td></tr>
					<tr><td align="center">&nbsp;</td></tr>
					<tr><td align="center">El reporte genera #rsReporte.recordcount# registros de clientes.</td></tr>
					<tr><td align="center">&nbsp;</td></tr>
					<tr><td align="center">Por Favor seleccione la opción 'HTML' como formato de salida.</td></tr>
				</table>
			</html>
	
			</cfoutput>
			<cf_templatefooter>	  

			<cfabort>
	</cfif>

	<cfif rsReporte.recordcount GT 30 or url.Formato EQ "HTML">
		<!--- Salida en HTML --->
		<!--- pintar los headers para impresion y pantalla --->

		<cf_htmlreportsheaders
			title="Consulta de Clientes" 
			filename="ConsultaClientesPOS-#Session.Usucodigo#.xls" 
			ira="ConsultaClientes.cfm">
		<cf_templatecss>
		
		<!--- Empieza a pintar el reporte en el usuario cada 512 bytes. --->
		<cfflush interval="128">

		<html>
			<cfoutput>
				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##E4E4E4">
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>#rsNombreEmpresa.EDescripcion#</strong>	
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Consulta de Clientes</strong>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>					
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
			</cfoutput>
			</tr>
			<tr>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr  bgcolor="#E4E4E4">
						<td nowrap><strong>Tipo</strong></td>
						<td nowrap><strong>Identificacion</strong></td>
						<td nowrap><strong>Nombre</strong></td>
						<td nowrap><strong>Telefono</strong></td>
						<td nowrap><strong>Fax</strong></td>
						<td nowrap><strong>Correo</strong></td>
						<td ><strong>Direccion</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfoutput query="rsReporte">
						<tr>
							<td nowrap>#tipo#</td>
							<td nowrap>#Identificacion#</td>
							<td nowrap>#nombre#</td>
							<td nowrap>#telefono#</td>
							<td nowrap>#fax#</td>
							<td nowrap>#email#</td>
							<td >#direccion#</td>
						</tr>
					</cfoutput>
				</table>
		</html>
	<cfelse>
		<!--- INVOCA EL REPORTE --->
		<cfreport format="#formato#" template= "ConsultaClientes.cfr" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edescripcion" value="#session.Enombre#">
		</cfreport>
	</cfif>
