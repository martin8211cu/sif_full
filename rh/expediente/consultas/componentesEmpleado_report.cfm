
<cfquery name="reporte" datasource="#Session.DSN#">
	select 	{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as empleado,
			{fn concat({fn concat(rtrim(cs.CScodigo) , ' - ' )},  cs.CSdescripcion)}  as componente, 
			dl.DLTmonto as monto
	from 	ComponentesSalariales	cs
	
			inner join DLineaTiempo dl
				on dl.CSid = cs.CSid
		
			inner join LineaTiempo lt
				on lt.Ecodigo = cs.Ecodigo
				and lt.LTid = dl.LTid
				and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta 
				
			inner join DatosEmpleado de
				on de.Ecodigo = cs.Ecodigo
				and de.DEid = lt.DEid
				and de.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion1#">
				 	and  <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion2#"> 
	where 
			cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 		
	order by de.DEidentificacion, de.DEnombre, de.DEapellido1,de.DEapellido2, cs.CScodigo, cs.CSdescripcion 

</cfquery>

<cfif reporte.recordCount gt 0 >
		
		<cfreport format="#url.formato#" template= "componentesEmpleado.cfr" query="reporte">
			<cfreportparam name="Edescripcion" value="#Session.Enombre#">
			<cfreportparam name="Edesde" value="#url.DEidentificacion1# - #url.NombreEmp1#">
			<cfreportparam name="Ehasta" value="#url.DEidentificacion2# - #url.NombreEmp2#">
		</cfreport>
<cfelse>
	<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="3px" cellspacing="0">
					<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td align="center"><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td  align="center"><font size="+1"><cf_translate  key="LB_DetalleDeComponentesPorEmpleado">Detalle de Componentes por Empleado</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>
