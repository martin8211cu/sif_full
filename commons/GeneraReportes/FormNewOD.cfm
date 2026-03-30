
<cfquery  name="rsROOD" datasource="#session.dsn#">
	SELECT a.RPTOId, a.RPTId, b.ODId, b.ODCodigo, b.ODDescripcion
	FROM RT_ReporteOrigen a
	right join RT_OrigenDato b
	 on a.ODId = b.ODId and a.RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
	where a.RPTId is null
</cfquery>

<form method="post" action="" name="FormODGE" id="FormODGE">
	<div class="container" style="width: 500px;">
		<table width="100%" class="table table-hover">
			<tr>
				<td>Reporte	</td>
				<td>Origen de datos	</td>
				<td>Descripcion	</td>
				<td>Agregar</td>
			</tr>
			<cfoutput query = "rsROOD">
				<tr>
					<td>#url.RPTId#</td>
					<td>#rsROOD.ODCodigo#</td>
					<td>#rsROOD.ODDescripcion#</td>
					<td><i class="fa fa-plus" style="cursor:pointer;" onclick="AgregarODGE(#url.RPTId#,#rsROOD.ODId#)"></i></td>
				</tr>
			</cfoutput>
		</table>
	</div>
</form>