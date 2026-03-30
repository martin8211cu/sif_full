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
	and a.CPtipo = 1
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
<!---=============== TRADUCCION =================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_que_desea_Eliminar_los_Registros_Seleccionados_Si_elimina_los_registros_seleccionados_eliminara_todos_los_datos_relacionados_con_la_nomina_y_tendra_que_recalcular_la_nomina"
	Default="¿Está seguro que desea Eliminar los Registros Seleccionados?\n\nSi elimina los registros seleccionados, eliminará todos los datos relacionados con la nómina \ny tendrá que recalcular la nómina. Las Nóminas en estado Pagado no serán borradas."	
	returnvariable="LB_ElimarRegistrosSeleccionados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Seleccione_el_Registro_que_desea_eliminar"
	Default="¡Seleccione el Registro que desea eliminar!"	
	returnvariable="LB_SeleccionarRegistros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_se_pueden_crear_nuevas_relaciones_de_calculo_de_nomina_porque_no_hay_calendarios_de_pago_definidos"
	Default="No se pueden crear nuevas relaciones de cálculo de nómina porque no hay calendarios de pago definidos"	
	returnvariable="LB_NoCalendariosDefinidos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_de_nomina"
	Default="Tipo de nómina"	
	returnvariable="LB_Tipo_de_nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo_Calendario"
	Default="Código Calendario"	
	returnvariable="LB_Codigo_Calendario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Relacion_de_Calculo"
	Default="Relación de Cálculo"	
	returnvariable="LB_Relacion_de_Calculo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Inicio"
	Default="Fecha Inicio"	
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Fecha_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_Hasta"
	Default="Fecha Hasta"	
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"	
	returnvariable="LB_Estado"/>
<!---Boton Eliminar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<!----Boton Nuevo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>

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

<cfquery name="rsRHPTUEt5L" datasource="#session.DSN#">
	select a.RHPTUEcodigo, a.RHPTUEdescripcion, a.FechaDesde, a.FechaHasta
    from RHPTUE a
    where a.RHPTUEid = #form.RHPTUEid#
</cfquery>

<cfoutput>
    <table width="90%" border="0" cellspacing="0" cellpadding="1"  align="center">
        <tr>
            <td>
                <table width="55%" border="0" cellspacing="0" cellpadding="1" align="center">
                    <tr>
                        <td width="19%" nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Detalle_Accion">Detalle PTU</cf_translate>:</div></td>
                        <td width="81%" nowrap >#rsRHPTUEt5L.RHPTUEcodigo# - #rsRHPTUEt5L.RHPTUEdescripcion#</td>
                    </tr>
                    <tr>
                        <td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate>:</div></td>
                        <td nowrap >#LSDateFormat(rsRHPTUEt5L.FechaDesde,'dd/mm/yyyy')#</td>
                    </tr>
                    <tr>
                        <td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta</cf_translate>:</div></td>
                        <td nowrap >#LSDateFormat(rsRHPTUEt5L.FechaHasta,'dd/mm/yyyy')#</td>
                    </tr>
                </table>			
            </td>		
        </tr>


		<tr>
			<td colspan="4">
				<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20" align="center">
						<tr>
							<td class="fileLabel">&nbsp;Lista de Relaciones de cálculo</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
</cfoutput>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td>
		<cfif rsRCNcount.RecordCount gt 0>
			<cfset botones = "Eliminar">
		<cfelse>
			<cfset botones = "">
		</cfif>
        
        <form name="listaRelaciones" method="post" action="PTU-RelacionCalculoTab5-listaSql.cfm">
        	<input name="RHPTUEid" value="<cfoutput>#form.RHPTUEid#</cfoutput>" type="hidden" />
            <input name="tab" value="5" type="hidden" />
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
                                                        and RCestado in (0,1,2,3) 
                                                        and a.Tcodigo = b.Tcodigo
                                                        and a.Ecodigo = b.Ecodigo	
                                                        and a.RCNid = c.CPid
                                                        and c.CPtipo = 4"/>
                <cfinvokeargument name="align" value="left, left, left, center, center, center"/>
                <cfinvokeargument name="ajustar" value="S"/>
                <cfinvokeargument name="checkboxes" value="S"/>
                <cfinvokeargument name="keys" value="RCNid"/>
                <cfinvokeargument name="botones" value="#botones#"/>
                <cfinvokeargument name="irA" value="PTU-RelacionCalculoTab5-listaSql.cfm"/>
                <cfinvokeargument name="MaxRows" value="0"/>
                <cfinvokeargument name="formName" value="listaRelaciones"/>
                <cfinvokeargument name="Cortes" value="Tdescripcion"/>
            </cfinvoke>
        
        </form>
	</td>
  </tr>
</table>
