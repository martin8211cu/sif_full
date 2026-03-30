	<cfquery datasource="#session.dsn#" name="rsForm">
		select
			GEAid,
			TESid,
			Ecodigo,
			GEAnumero,
			GEAtipo,
			TESSPid,
			<!---TESSPnumero,--->
			GEAestado,
			GEAfechaPagar,
			Mcodigo,
			GEAmanual,
			CFid,
			GEAtotalOri,
			GEAdescripcion,
			GEAfechaSolicitud,
			UsucodigoSolicitud,
			GEAidDuplicado,
			TESBid,
			CFcuenta,
			BMUsucodigo,
			ts_rversion,
			GEAdesde,
			GEAhasta
			from GEanticipo a	
				 where a.Ecodigo			= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  
		</cfquery>


<!---ANTICIPOS--->
<table width="100%" align="center" summary="Tabla de entrada" border="0"> 
<form method="post" name="form1" action="DetLiquidaciones.cfm">
<!---<td>  <input type="text" name="empleado" maxlength="50" value="68" id="empleado"></td>
<td>  <input type="button" value="Listo" maxlength="50"></td> --->

<!---numeroanticipo--->
<tr>
<td width="173" align="right" valign="top"><strong>Número de Anticipo:</strong></td>
<!---<td>  <input type="text" name="NumAnticipo" maxlength="50" id="NumAnticipo"></td>--->
<!---  <input type="submit"  name="boton" value="Buscar" maxlength="15" id="boton" >--->
<td>
<cf_sifAnticipos form="form1" DEid="DEid"  tabindex="1"></td>
<!---<td><cf_sifAnticipos form="form1" DEid="DEid" tabindex="1"   ></td>
---></tr>
<!---montototal--->
<tr>
<td width="173" align="right" valign="top"><strong>Monto Total:</strong></td>
 <td width="792"> <input type="text" name="MontoTotal" maxlength="50" /></td>
</tr>
<!---montoanticipo--->
<tr>
<td width="173" align="right" valign="top"><strong>Monto Anticipo:</strong></td>
<td> <input type="text" name="MontoAnticipo" maxlength="50" id="MontoAnticipo" /></td>
</tr>
<!---empleado--->
<tr>
<td width="173" align="right" valign="top"><strong>Empleado Solicitante:</strong></td>
<td> <input type="text" name="Empleado" maxlength="50" /></td>
</tr>
<!---botones--->
<tr>
<td></td>
<td> <input type="button" name="AltaAnt" value="Agregar" id="AltaAnt" align="right"/>
<input type="button" name="LimpiarAnt" value="Limpiar" id="LimAnt" /></td>
</tr>
<td></td>
</tr>
</form>
<cfif isdefined("form.boton")>
	<cfquery datasource="#session.dsn#" name="consulta">
		select GEAtotalOri from GEanticipo 
		where GEAnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumAnticipo#">
	</cfquery>
<script language="javascript">
alert("ya");
</script>
</cfif>

<cfset titulo = 'Solicitudes de Anticipo del Empleado'>
	<cfquery datasource="#session.dsn#" name="listaDet">
		select GEAnumero,GEAdescripcion, GEAtotalOri
		from GEanticipo
</cfquery>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDet#"
			desplegar="GEAnumero,GEAdescripcion, GEAtotalOri"
			etiquetas="Sol.Anticipo,Descripcion,Total"
			formatos="I,S,I"
			align="left,left,left"
			ira="DetLiquiTag1.cfm"
			form_method="post"	
			showEmptyListMsg="yes"
			keys="GEAnumero"
			incluyeForm="yes"
			showLink="yes"
			maxRows="0"
		/>	
			
</table>

