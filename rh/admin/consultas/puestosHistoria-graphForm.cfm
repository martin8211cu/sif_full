<cfquery name="data" datasource="#session.DSN#">
<!---	select convert(varchar, a.HYERVfecha, 103) as HYERVfecha, --->
	select a.HYERVfecha as HYERVfecha, 
		   a.HYERVdescripcion,
		   b.RHPcodigo,	
		   b.ptsTotal
	from HYERelacionValoracion a, HYDRelacionValoracion b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	and HYERVestado = 1
	and a.HYERVid=b.HYERVid
</cfquery>

<cfquery name="rsPuesto" datasource="#session.DSN#">
	select RHPdescpuesto
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cfif data.RecordCount gt 0>
	<cfquery name="tope" dbtype="query">
		select max(ptsTotal) as ptsTotal
		from data
	</cfquery>
	<cfset vTope = tope.ptsTotal >

	<cfparam name="width" default="500">
	<cfparam name="height" default="300">
	
	<cfoutput>
	<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" >
		<tr>
			<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cf_translate key="LB_HistoricoDeValoracionDePuestos">Hist&oacute;rico de Valoraci&oacute;n de Puestos</cf_translate>
			</strong>
			</td>
		</tr>
		<tr>
			<td align="center">
				<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				#rsPuesto.RHPdescpuesto#
				</strong>
			</td>
		</tr>
		<tr>
			<td valign="top" align="center">
				<cfchart format="flash" chartWidth="#width#" chartHeight="#height#"
						 scaleFrom="0" scaleTo="#vTope+10#" gridLines="3" show3d="no">
					<cfchartseries type="LINE" query="data" itemColumn="HYERVfecha" valueColumn="ptsTotal">
				</cfchart>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>

				<input type="button" name="Regresar" value="#BTN_Regresar#" onClick="javascript:location.href='puestosHistoria.cfm';">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>
<cfelse>
	<cfoutput>
	<table width="100%">
		<tr>
			<td align="center">
				<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<cf_translate key="LB_HistoricoDeValoracionDePuestos">Hist&oacute;rico de Valoraci&oacute;n de Puestos</cf_translate>
				</strong>
			</td>
		</tr>
		<tr>
			<td align="center">
				<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					#rsPuesto.RHPdescpuesto#
				</strong>
			</td>
		</tr>
		<tr><td align="center"><font size="2"><cf_translate key="MSG_NoSeEncontraronDatos">No se encontraron datos</cf_translate></font></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>
				<input type="button" name="Regresar" value="#BTN_Regresar#" onClick="javascript:location.href='puestosHistoria.cfm';">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>
</cfif>