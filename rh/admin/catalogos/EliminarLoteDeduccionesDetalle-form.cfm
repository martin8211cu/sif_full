<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desea_revertir_la_aplicacion_del_lote_seleccionado"
	Default="Desea revertir la aplicación del lote seleccionado"
	returnvariable="LB_Mensaje"/>

<cfquery datasource="#session.DSN#" name="rs_datos">
	select	de.DEid,
			a.EIDlote as lote,
			a.EIDfecha as fecha,
			td.TDcodigo, 
			td.TDdescripcion,
			sn.SNcodigo,
			sn.SNnombre,
			b.DIDfechaini,
			b.DIDfechafin,
			de.DEidentificacion,
			<cf_dbfunction name="concat" args="de.DEapellido1|' '|de.DEapellido2|', '|de.DEnombre" delimiters="|" > as Empleado,
			b.DIDvalor as valor,
			b.DIDmonto as monto,
			b.DIDfechaini as inicio,
			b.DIDfechafin as final
	
		from EIDeducciones a, DIDeducciones b, DatosEmpleado de, TDeduccion td, SNegocios sn

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.EIDestado = 1
			and b.EIDlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.lote#">
			and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			and b.EIDlote=a.EIDlote
			and de.DEidentificacion=b.DIDidentificacion
			and td.TDid = a.TDid
			and sn.SNcodigo=a.SNcodigo
			and sn.Ecodigo=a.Ecodigo

		order by a.EIDlote
</cfquery>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table width="100%" cellpadding="4" cellspacing="0" >
				<tr>
					<td width="1%"><strong>Lote:&nbsp;</strong></td>
					<td width="40%">#rs_datos.lote#</td>
					<td width="1%" nowrap="nowrap"><strong>Fecha de importaci&oacute;n:</strong>&nbsp;</td>
					<td>#LSDateFormat(rs_datos.fecha, 'dd/mm/yyyy')#</td>					
				</tr>
				<tr>
					<td width="1%" nowrap="nowrap"><strong>Tipo de Deducci&oacute;n:&nbsp;</strong></td>
					<td>#trim(rs_datos.TDcodigo)# - #rs_datos.TDdescripcion#</td>
					<td width="1%" nowrap="nowrap"><strong>Socio de Negocios:&nbsp;</strong></td>
					<td>#trim(rs_datos.SNcodigo)# - #rs_datos.SNnombre#</td>
				</tr>
			</table>
			</cfoutput>
		</td>
	</tr>

	<cfif rs_datos.recordcount gt 30>
		<tr>
			<td align="center">
				<form name="form1" method="post" action="EliminarLoteDeducciones-sql.cfm">
					<input type="submit" name="btnAplicar" value="Aplicar" class="btnAplicar" />
				</form>
			</td>
		</tr>
	</cfif>
	<tr><td></td></tr>
	<tr><td class="tituloListas" ><strong>Listado de empleados incluidos en el lote</strong></td></tr>
	<tr>
		<td>
			<cfinvoke component="rh.Componentes.pListas"
					  method="pListaQuery"
					  returnvariable="pListaRet" >
				<cfinvokeargument name="query" value="#rs_datos#"/>
				<cfinvokeargument name="desplegar" value="lote,DEidentificacion,Empleado,inicio,final,valor,monto"/>
				<cfinvokeargument name="etiquetas" value="Lote,Identificaci&oacute;n,Empleado,Desde,Hasta,Valor,Monto"/>
				<cfinvokeargument name="formatos" value="V,V,V,D,D,M,M"/>
				<cfinvokeargument name="align" value="left,left,left,left,left,right,right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="showlink" value="false"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
				<cfinvokeargument name="EmptyListMsg" value="No se encontraron registros"/>
			</cfinvoke>
		</td>
	</tr>

	<tr>
		<td align="center">
			<form name="form2" method="post" action="EliminarLoteDeducciones-sql.cfm">
				<input type="hidden" name="chk" value="<cfoutput>#form.lote#</cfoutput>" />
				<input type="submit" name="btnAplicar" value="Aplicar" class="btnAplicar" onclick="javascript: return confirm('Esta seguro(a) de reversar la aplicación del lote?');" />
			</form>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>