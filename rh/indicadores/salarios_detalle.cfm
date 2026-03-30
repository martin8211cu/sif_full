<cf_web_portlet_start titulo="Salarios vs Encuesta" skin="portlet" width="700" >

	<cfquery datasource="sifpublica" name="encuesta" maxrows="100">
	
		select e.Eid, e.Edescripcion,
			ea.EAid, ea.EAdescripcion,
			ep.EPid, ep.EPdescripcion,
			es.ESp25, es.ESp50, es.ESp75
		from Encuesta e
			join EncuestaSalarios es
				on es.Eid = e.Eid
			join EncuestaPuesto ep
				on ep.EPid = es.EPid
			join EmpresaArea ea
				on ea.EAid = es.EAid
		order by e.Eid, e.Edescripcion,
			ea.EAid, ea.EAdescripcion,
			ep.EPid, ep.EPdescripcion
	</cfquery>
	
<table width="600">
	<cfoutput query="encuesta" group="Eid">
		<tr><td colspan="4" style="background-color:navy;color:white;font-weight:bold;font-size:16px ">Encuesta: #Edescripcion#</td>
		<cfoutput group="EAid">
		<tr><td colspan="4"><strong>Area: #EAdescripcion#</strong></td>
			<cfoutput>
				<tr><td>#EPdescripcion#</td>
					<td align="right">#NumberFormat(ESp25,',0.00')#</td>
					<td align="right">#NumberFormat(ESp50,',0.00')#</td>
					<td align="right">#NumberFormat(ESp75,',0.00')#</td>
					</tr>
			</cfoutput>
		</cfoutput>
	</cfoutput>
</table>

<cf_web_portlet_end>