<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<cfquery name="rsOficinas" datasource="minisif">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = 1
</cfquery>
<body>
<cfquery name="rs" datasource="minisif">
	select 
		'<select name=''cajita'||convert(varchar(50),Mcodigo)||'''>
			<cfoutput query="rsOficinas">
				<option value=''#Ocodigo#''>#Odescripcion#</option>
			</cfoutput>
		 </select>' as campo, Mcodigo from Monedas where Ecodigo = 1
</cfquery>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<!--- ESTE ES EL TRABAJO DEL FORM --->
		<cfinvoke 
			component="sif.rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rs#"
			desplegar="campo"
			etiquetas="Oficina"
			formatos="S"
			align="left"
			ajustar="N"
			keys="Mcodigo"
			showlink="false"
			botones="Modificar"
			irA=""
			/>
		</td>
    <td>
		<!--- ESTE ES EL TRABAJO DEL SQL --->
		<cfquery name="rs2" datasource="minisif">
			select Mcodigo from Monedas where Ecodigo = 1
		</cfquery>
		<cfoutput query="rs">
			<!--- AQUI VAN LOS UPDATES --->
			<cfif isdefined('form.cajita'&rs.Mcodigo)>
				<cfif Evaluate('form.cajita'&rs.Mcodigo) neq rs.Mnombre>
					<cfquery datasource="minisif">
						update Monedas
						set Mnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('form.cajita'&rs.Mcodigo)#">
						where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Mcodigo#">
						and Ecodigo = 1
					</cfquery>
				</cfif>
			</cfif>
		</cfoutput>
		<!--- VER RESULTADOS --->
		<cfquery name="rs2" datasource="minisif">
			select Mcodigo from Monedas where Ecodigo = 1
		</cfquery>
		<cfoutput query="rs">
			<!--- AQUI VAN LOS UPDATES --->
			<cfif isdefined("cajita"&Mcodigo)>
				#Evaluate("form.cajita"&Mcodigo)#<br>
			</cfif>
		</cfoutput>
	</td>
  </tr>
</table>
</body>
</html>
