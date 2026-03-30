<cfquery name="rsRCNcount" datasource="#Session.DSN#">
	select 1
	from RCalculoNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and RCestado in (0,1,2)
</cfquery>
<cfquery name="rsCalendarios" datasource="#Session.DSN#">
	select rtrim(a.Tcodigo) as Tcodigo, a.CPid, a.CPdesde, a.CPhasta
	from CalendarioPagos a
	where a.CPfcalculo is null
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.CPtipo = 3
	and not exists (
		select 1
		from RCalculoNomina b
		where a.Ecodigo = b.Ecodigo
		and a.Tcodigo = b.Tcodigo
		and a.CPid = b.RCNid
		and a.CPdesde = b.RCdesde
		and a.CPhasta = b.RChasta
	)
	group by a.Tcodigo, a.CPid, a.CPdesde, a.CPhasta
	having a.CPdesde = min(a.CPdesde)
</cfquery>

<script language="JavaScript" type="text/javascript">
	//Eliminar Relaciones de Cálculo
	function funcEliminar() {
		var form = document.listaRelaciones;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (result) {
			<cfoutput>
			if (!confirm('#LB_ElimarRegistrosSeleccionados#'))
				result = false;
			</cfoutput>
		}
		else
			<cfoutput>alert('#LB_SeleccionarRegistros#');</cfoutput>
		return result;
	}
	//validación al intentar crear un nuevo registro
	function funcNuevo() {
	<cfif rsCalendarios.recordCount EQ 0>
		<cfoutput>alert('#LB_NoCalendariosDefinidos#')</cfoutput>;
		return false;
	<cfelse>
		return true;
	</cfif>
	}
</script>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td>
		<cfif rsRCNcount.RecordCount gt 0>
			<cfset botones = "Nuevo,Eliminar">
		<cfelse>
			<cfset botones = "Nuevo">
		</cfif>
		<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="RCalculoNomina a, TiposNomina b, CalendarioPagos c"/>
			<cfinvokeargument name="columnas" value="a.RCNid,
												   a.Ecodigo,
												   rtrim(a.Tcodigo) as Tcodigo,
												   c.CPcodigo,
												   a.RCDescripcion,
												   a.RCdesde,
												   a.RChasta,
												   (case a.RCestado
														when 0 then 'Proceso'
														when 1 then 'Cálculo'
														when 2 then 'Terminado'
														when 3 then 'Pagado'
														else ''
												   end) as RCestado,
												   a.Usucodigo,
												   a.Ulocalizacion,
												   b.Tdescripcion
											"/>
			<cfinvokeargument name="desplegar" value="Tdescripcion, CPcodigo, RCDescripcion, RCdesde, RChasta, RCestado"/>
			<cfinvokeargument name="etiquetas" value="#LB_Tipo_de_nomina#, #LB_Codigo_Calendario#,#LB_Relacion_de_Calculo#, #LB_Fecha_Inicio#,#LB_Fecha_Hasta#, #LB_Estado#"/>
			<cfinvokeargument name="formatos" value="S,S,S,D,D,S"/>
			<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
													and RCestado in (0,1,2)
													and a.Tcodigo = b.Tcodigo
													and a.Ecodigo = b.Ecodigo
													and a.RCNid = c.CPid
													and c.CPtipo = 3"/>
			<cfinvokeargument name="align" value="left, left, left, center, center, center"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="keys" value="RCNid"/>
			<cfinvokeargument name="botones" value="#botones#"/>
			<cfinvokeargument name="irA" value="RelacionCalculoRetro-listaSql.cfm"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="listaRelaciones"/>
			<cfinvokeargument name="Cortes" value="Tdescripcion"/>
		</cfinvoke>
	</td>
  </tr>
</table>
