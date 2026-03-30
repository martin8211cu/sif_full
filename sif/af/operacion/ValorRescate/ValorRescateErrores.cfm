<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>

<!--- No aplica esta validacion para garantias --->
<cfif LvarAFTRtipo NEQ 5>
<cfquery name="rsValida2" datasource="#Arguments.Conexion#">
	select d.Aid, d.Adescripcion
	from AFTRelacionCambioD d
	where AFTRid = #arguments.AFTRid#
	  and (
			select count(1)
			from AFTRelacionCambioD d2
			where d2.Aid              = d.Aid
			  and d2.AFTDperiodo      = #LvarPeriodo#
			  and d2.AFTDmes          = #LvarMes#
			  and d2.AFTDpermesdesde <> 0
			  and d2.AFTDpermeshasta <> 0
			  and d2.AFTRid          <> #arguments.AFTRid#
		  ) > 0
</cfquery>
</cfif>

<cfquery name="rsValida3" datasource="#Arguments.Conexion#">
	select d.Aid, d.Avalrescate, s.AFSvaladq, AFTDvalrescate
	from AFTRelacionCambioD d
		inner join AFSaldos s
		on s.Aid = d.Aid
		and s.AFSperiodo = #LvarPeriodo#
		and s.AFSmes     = #LvarMes#
	where d.AFTRid         = #arguments.AFTRid#
	  and d.AFTDvalrescate > 0
	  and d.AFTDvalrescate >  (s.AFSvaladq - s.AFSdepacumadq)
</cfquery>	

<cfquery name="rsValida4" datasource="#Arguments.Conexion#"><!---Se agrega para cambio por garantía RVD 04/06/2014--->
    select d.Aid, d.Adescripcion
    from AFTRelacionCambioD d
    where d.AFMMid IS NULL
    and d.AFTRid = #arguments.AFTRid#
</cfquery>	


<cf_htmlreportsheaders
	title="Errores Cambio Valor de Rescate" 
	filename="CamValResc.xls" 
	ira="ValorRescate.cfm?AFTRid=#arguments.AFTRid#">

<cfflush interval="64">		
<table width="100%" border="1">
	<tr>
		<td align="center" bgcolor="#BBBBBB">
			<strong>Se presentaron los siguientes errores en los datos</strong>
		</td>
	</tr>
</table>
	<cfif rsValida1.recordcount GT 0>
		<table width="100%" border="1">
			<tr>
				<td align="left" colspan="3" bgcolor="#DDDDDD">
					&nbsp;&nbsp;<strong>Activos Duplicados:</strong>
				</td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td><strong>Placa</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
				<td><strong>Cantidad</strong></td>
			</tr>				
			<cfloop query="rsValida1">
				<cfset LvarAid = rsValida1.Aid>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select Aplaca, Adescripcion
					from Activos
					where Aid = #LvarAid#
				</cfquery>
				<cfoutput>
					<tr>
						<td>
							#rs.Aplaca#
						</td>
						<td>
							#rs.Adescripcion#:
						</td>
						<td>
							#rsValida1.Cantidad# veces
						</td>
					</tr>
				</cfoutput>
			</cfloop>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
		</table>
	</cfif>

	<!--- No aplica esta validacion para garantias --->
	<cfif LvarAFTRtipo NEQ 5>
	<cfif rsValida2.recordcount GT 0>
		<table width="100%" border="1">
			<tr bgcolor="#DDDDDD">
				<td colspan="2">
					<strong>Activos ya modificados en el mes:</strong>
				</td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td><strong>Placa</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
			</tr>
			<cfloop query="rsValida2">
				<cfset LvarAid = rsValida2.Aid>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select Aplaca, Adescripcion
					from Activos
					where Aid = #LvarAid#
				</cfquery>
				<cfoutput>
					<tr>
						<td>
							#rs.Aplaca# 
						</td>
						<td>
							#rs.Adescripcion#
						</td>
					</tr>
				</cfoutput>
			</cfloop>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	</cfif>
	</cfif>

	<cfif rsValida3.recordcount GT 0>
		<table width="100%" border="1">
			<tr bgcolor="#DDDDDD">
				<td colspan="4">
					<strong>Activos con Valor de Rescate superior al Valor de Adquisicion:</strong>
				</td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td><strong>Placa</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
				<td align="right"><strong>Valor Adquisicion</strong></td>
				<td align="right"><strong>Valor Rescate</strong></td>
			</tr>
			<cfloop query="rsValida3"> 
				<cfset LvarAid = rsValida3.Aid>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select Aplaca, Adescripcion
					from Activos
					where Aid = #LvarAid#
				</cfquery>
				<cfoutput>
					<tr>
						<td>
							#rs.Aplaca# 
						</td>
						<td>
							#rs.Adescripcion# 
						</td>
						<td align="right">
							#numberformat(rsValida3.AFSvaladq, ',9.00')# 
						</td>
						<td align="right">
							#numberformat(rsValida3.AFTDvalrescate,',9.00')#
						</td>
					</tr>
				</cfoutput>
			</cfloop>
		</table>
	</cfif>
    
    
    
    <cfif rsValida4.recordcount GT 0> <!---Se agrega para cambio por garantía RVD 04/06/2014--->
		<table width="100%" border="1">
			<tr bgcolor="#DDDDDD">
				<td colspan="4">
					<strong>Activos sin Modelo Definido:</strong>
				</td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td><strong>Placa</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
			</tr>
			<cfloop query="rsValida4"> 
				<cfset LvarAid = rsValida4.Aid>
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select Aplaca, Adescripcion
					from Activos
					where Aid = #LvarAid#
				</cfquery>
				<cfoutput>
					<tr>
						<td>
							#rs.Aplaca# 
						</td>
						<td>
							#rs.Adescripcion# 
						</td>
					
					</tr>
				</cfoutput>
			</cfloop>
		</table>
	</cfif>
    
    
    
	<cfabort>


<body>
</body>
</html>
