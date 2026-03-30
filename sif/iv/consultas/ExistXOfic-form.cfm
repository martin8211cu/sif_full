<script language="JavaScript" type="text/javascript">
	function Regresar() {
		location.href='/cfmx/sif/iv/MenuIV.cfm';
		return false;
	}
</script>
<form name="consulta" method="post" action="">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="4"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td></tr>
		<tr>
			<td colspan="6">
				<table width="98%" align="center">
					<tr>
						<td width="22%">
							<div align="right">
								<input name="rbFiltro"  id="rbFiltro_T" type="radio" value="T"  checked>
							</div>
						</td>
						<td width="13%">Todos</td>
						<td width="8%">
							<div align="right">
								<input name="rbFiltro"  id="rbFiltro_1" type="radio" value="1">
							</div>
						</td>
						<td width="26%">Con Advertencia</td>
						<td width="3%">
							<div align="right">
								<input name="rbFiltro"  id="rbFiltro_2" type="radio" value="2">
							</div>
						</td>
						<td width="28%">Solo Urgencias</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-----		
		<td width="11%">Tipo Producto</td>
		<td width="49%"><cf_sifclasificacion form="consulta" frame="cli" id="Ccodigo" name="Ccodigoclas" desc="Cdescripcion"></td>
		
		</tr>
			<td nowrap colspan="6" align="center">
				<!----
				<input name="btnConsultar" type="submit" value="Consultar">
				<input type="reset" name="Reset" value="Limpiar">
				---->
				<input name="btnRegresar" type="button" value="Regresar" onClick="javascript: Regresar();">
			</td>
			<td width="1%">&nbsp;</td>
		</tr>
		----->		
	</table>
 </form>	
<table width="100%" cellpadding="2" cellspacing="0">
	<!----<cfif isdefined("btnConsultar")>---->
	<tr><td colspan="6" align="center"><font size="2"><strong>Lista de Estaciones</strong></font></td></tr>
	<tr align="center">
		<td colspan="6">
			<cfquery name = "rsOficinas" datasource="#session.DSN#">
				select Ocodigo, LPid, id_zona, Oficodigo, Odescripcion, id_direccion, telefono, 
					responsable, pais, BMUsucodigo, Onumpatronal
				from   Oficinas
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value= "#session.Ecodigo#">
			</cfquery>
			
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsOficinas#"/>
				<cfinvokeargument name="desplegar" value="Oficodigo, Odescripcion"/>
				<cfinvokeargument name="etiquetas" value="Codigo,Estación de Servicio"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N,N"/>
				<cfinvokeargument name="irA" value="ExistXOficDet.cfm"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Ocodigo"/>
		  </cfinvoke>
		</td>			
	</tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<tr><td colspan="6" align="center"><input name="btnRegresar" type="button" value="Regresar" onClick="javascript: Regresar();"></td></tr>
	<!----</cfif>---->
</table>