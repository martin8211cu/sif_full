<!--- modificado en notepad --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CodigoCalendario"
	Default="Código Calendario"
	returnvariable="LB_CodigoCalendario"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RelacionDeCalculo"
	Default="Relación de Cálculo"
	returnvariable="LB_RelacionDeCalculo"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicio"
	Default="Fecha Inicio"
	returnvariable="LB_FechaInicio"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Contabilizar"
	Default="Contabilizar"
	returnvariable="_botones"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConfirmeQueDeseaContabilizarLasNominasMarcadas"
	Default="Confirme que desea Contabilizar las Nóminas Marcadas."
	returnvariable="LB_ConfirmeQueDeseaContabilizarLasNominasMarcadas"/> 			
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeleccioneElRegistroQueDeseaContabilizar"
	Default="¡Seleccione el Registro que desea Contabilizar!"
	returnvariable="LB_SeleccioneElRegistroQueDeseaContabilizar"/>
</cfsilent>
<cfquery name="pQuery" datasource="#Session.DSN#">
	select a.RCNid, rtrim(a.Tcodigo) as Tcodigo, a.RCDescripcion, a.RCdesde, a.RChasta, 
		b.Tdescripcion, c.CPcodigo
	from HRCalculoNomina a
		inner join TiposNomina b
			on a.Tcodigo = b.Tcodigo
			and a.Ecodigo = b.Ecodigo
		inner join CalendarioPagos c
			on a.RCNid = c.CPid
			and a.Ecodigo = c.Ecodigo	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and IDcontable is null
		and RCestado > 2
	order by b.Tdescripcion
</cfquery>
<cfset _botones = "">
<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="SubTitulo" align="center"><cf_translate  key="LB_HistoricoDeNominasQueNoHanSidoContabilizadas">Hist&oacute;rico de N&oacute;minas que no han sido Contabilizadas</cf_translate></td>
  </tr>
</table>
<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" value="#pQuery#" />
	<cfinvokeargument name="cortes" value="Tdescripcion" />
	<cfinvokeargument name="desplegar" value="CPcodigo, RCDescripcion, RCdesde, RChasta"/>
	<cfinvokeargument name="etiquetas" value="#LB_CodigoCalendario#,#LB_RelacionDeCalculo#,#LB_FechaInicio#,#LB_FechaHasta#"/>
	<cfinvokeargument name="formatos" value="S,S,D,D"/>
	<cfinvokeargument name="align" value="left, left, center, center"/>
	<cfinvokeargument name="ajustar" value="S" />
	<cfinvokeargument name="irA" value="contabilizaNominaH-sql.cfm" />
	<cfinvokeargument name="botones" value="Contabilizar" />
	<cfinvokeargument name="formName" value="form1" />
	<cfinvokeargument name="checkboxes" value="S" />
	<cfinvokeargument name="keys" value="RCNid" />
	<cfinvokeargument name="showEmptyListMsg" value="true" />
</cfinvoke>
<br>
<script language="javascript" type="text/javascript">
	<!--//
	function funcContabilizar(){
		var form = document.form1;
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
			if (!confirm('<cfoutput>#LB_ConfirmeQueDeseaContabilizarLasNominasMarcadas#</cfoutput>'))
				result = false;
		}
		else
			alert('<cfoutput>#LB_SeleccioneElRegistroQueDeseaContabilizar#</cfoutput>');
		return result;
	}
	//-->
</script>