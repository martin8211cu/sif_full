<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desea_revertir_la_aplicacion_del_lote_seleccionado"
	Default="Desea revertir la aplicación del lote seleccionado"
	returnvariable="LB_Mensaje"/>

<cf_dbtemp name="data" returnvariable="data">
	<cf_dbtempcol name="DEid" 			type="numeric"	mandatory="yes" >
	<cf_dbtempcol name="lote" 			type="numeric"	mandatory="yes" >
	<cf_dbtempcol name="desde" 		 	type="datetime"	mandatory="no" >
	<cf_dbtempcol name="hasta" 		 	type="datetime"	mandatory="no" >
	<cf_dbtempcol name="valido" 		type="int"		mandatory="no" >
	<cf_dbtempcol name="fecha_nomina"	type="datetime"	mandatory="no" >
</cf_dbtemp>

<!--- 1. Regla 1: los lotes que se pueden eliminar son los que tienen estado de aplicado --->
<cfquery datasource="#session.DSN#">
	insert into #data#( DEid, lote, desde, hasta, valido, fecha_nomina)
	select	de.DEid,
			a.EIDlote, 
			b.DIDfechaini,
			b.DIDfechafin,
			1,
			coalesce((  select max(b.RChasta)
						from HSalarioEmpleado a, HRCalculoNomina b
						where a.DEid=de.DEid
						  and b.RCNid=a.RCNid	 ), <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(1900,1,1)#">)
	
		from EIDeducciones  a, DIDeducciones b, DatosEmpleado de
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.EIDestado = 1		<!--- lotes aplicados --->
			and b.EIDlote=a.EIDlote
			and de.DEidentificacion=b.DIDidentificacion
			and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by a.EIDlote
</cfquery>

<!--- 2. Regla 2: los lotes que se pueden eliminar, son aquellos cuya fecha de inicio de sus detalles por empleado, son TODOS mayores 
				a la ultima nomina historica donde se reporto el empleado. Si hay al menos un empleado cuya fecha de inicio en el lote 
				es menor a la fecha de su ultima nomina historica, entonces todos los demas detalles de ese lote se marcan como no 
				eliminables (valido = 0). No importa tipo de nomina, ni tipo de deduccion, SOLO la validacion de la fecha. 
--->
<cfquery datasource="#session.DSN#">
	update #data#
	set valido = 0
	where exists (	select 1
				   	from #data# a
				  	where a.lote=#data#.lote
					  and a.desde <= a.fecha_nomina )
</cfquery>

<!--- 3. Regla 3: Los empleados del lote, que esten actualmente en una nomina en proceso y en Recepcion de Pagos (estado > 3)
				  evitan que el lote pueda eliminarse --->
<cfquery datasource="#session.DSN#">
	update #data#
	set valido = 0
	where exists (  select 1
					from SalarioEmpleado a, RCalculoNomina b
					where a.DEid=#data#.DEid
							and b.RCNid=a.RCNid
					and #data#.desde <= b.RChasta
						and #data#.hasta >= b.RCdesde
					and b.RCestado >= 3	
		 )
</cfquery>

<!--- 4. Elimina de la tabla temporal los lotes que no se pueden eliminar --->
<cfquery datasource="#session.DSN#">
	delete from #data#
	where valido = 0
</cfquery>

<!--- 5. Listado --->
<cf_dbfunction name="to_char" args="d.SNcodigo" returnvariable="sncodigo">
<cfquery name="rs_datos" datasource="#session.DSN#">
	select 	lote, 
			<cf_dbfunction name="concat" args="c.TDcodigo|' - '|c.TDdescripcion" delimiters="|"> as TDdescripcion,
			<cf_dbfunction name="concat" args="#sncodigo#|' - '|d.SNnombre" delimiters="|"> as SNcodigo
	from #data# a, EIDeducciones b, TDeduccion c, SNegocios d
	where b.EIDlote = a.lote
	and c.TDid=b.TDid
	and d.SNcodigo=b.SNcodigo
	and d.Ecodigo=b.Ecodigo
	order by lote
</cfquery>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td width="35%" valign="top">
			<table width="100%" bgcolor="#fafafa" style="border: black thin solid;">
				<tr><td><strong>Proceso de Reversion de Lotes de Deducciones</strong></td></tr>
				<tr><td>Este proceso va a reversar la aplicaci&oacute;n de Lotes de Deducciones. 
					    Los lotes que pueden ser reversados deben cumplir lo siguiente: 
						<li><strong>Todas</strong> las fechas de inicio incluidas en el detalle del lote, deben ser mayores a la fecha de la &uacute;ltima n&oacute;mina aplicada del empleado respectivo.</li>
						<li><strong>Ning&uacute;n</strong> empleado en el detalle del lote, debe estar inclu&iacute;do en una n&oacute;mina en proceso y que haya sido pasada a Recepci&oacute;n de Pagos.</li>
						<br />
						Si un empleado en el detalle del lote esta inclu&iacute;do en una n&oacute;mina en proceso y esta a&uacute;n no ha sido pasada a Recepci&oacute;n de Pagos, el proceso de reversi&oacute;n se ejecutar&aacute; y la n&oacute;mina deber&aacute; ser recalculada.
						<br /><br />
						Para iniciar el proceso seleccione el lote que desea reversar en la lista de la derecha.
						</td></tr>
			</table>
		</td>
		<td valign="top">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td class="tituloListas">Listado de lotes para reversi&oacute;n</td></tr>
				<tr><td>
					<cfinvoke component="rh.Componentes.pListas"
							  method="pListaQuery"
							  returnvariable="pListaRet" >
						<cfinvokeargument name="query" value="#rs_datos#"/>
						<cfinvokeargument name="desplegar" value="lote,TDdescripcion,SNcodigo"/>
						<cfinvokeargument name="etiquetas" value="Lote,Tipo de Deduccion,Socio de Negocios"/>
						<cfinvokeargument name="formatos" value="V,V,V"/>
						<cfinvokeargument name="align" value="left,left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="radios" value="N"/>
						<cfinvokeargument name="showlink" value="true"/>
						<!---<cfinvokeargument name="botones" value="Eliminar"/>--->
						<cfinvokeargument name="irA" value="EliminarLoteDeduccionesDetalle.cfm"/>
						<cfinvokeargument name="keys" value="lote"/>
						<cfinvokeargument name="MaxRows" value="0"/>
						<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>--->
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="showEmptyListMsg" value="yes"/>
						<cfinvokeargument name="EmptyListMsg" value="No se encontraron registros"/>
					</cfinvoke>
				</td></tr>
				<tr><td align="center"><input type="button" class="btnAnterior" name="btnRegresar" value="Regresar" onclick="javascript:location.href='ListaDeducciones.cfm';" /></td></tr>
			</table>			
		</td>
	</tr>
	<tr><td >&nbsp;</td></tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcEliminar(){
		return confirm('<cfoutput>#LB_Mensaje#</cfoutput>?');
	}
</script>