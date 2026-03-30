<!--- modificado en notepad --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CodigoCalendario"
	Default="C&oacute;digo Calendario"
	returnvariable="LB_CodigoCalendario"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RelacionDeCalculo"
	Default="Relaci&oacute;n de C&aacute;lculo"
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
<!---Query que que se le envia al tak de calendario pagos para que no pierda los valores seleccionados. CarolRS--->
<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo)) or isdefined("form.CPid") and len(trim(form.CPid))>	
	<cfquery name="rsCP" datasource="#Session.DSN#">
		select distinct 
		
		<cfif isdefined("form.CPid") and len(trim(form.CPid))>
		c.CPid,c.CPcodigo,
		case when coalesce(c.CPdescripcion,'') = '' 
		then (select x.RCDescripcion from HRCalculoNomina x where x.Ecodigo = b.Ecodigo and x.RCNid = #form.CPid#)
		else c.CPdescripcion end as CPdescripcion,
		<cfelse>
			0 as CPid, '' as CPcodigo, '' as CPdescripcion
		</cfif>
		
		<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo))>
		rtrim(b.Tcodigo) as Tcodigo, b.Tdescripcion
		<cfelse>
			'' as Tcodigo, '' as Tdescripcion
		</cfif>	
		
		from TiposNomina b
			
			inner join CalendarioPagos c
				on b.Tcodigo = c.Tcodigo
				and b.Ecodigo = c.Ecodigo
				
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo))>
			and b.Tcodigo = '#form.Tcodigo#'
			</cfif>
			<cfif isdefined("form.CPid") and len(trim(form.CPid))>
			and c.CPid = #form.CPid#
			</cfif>
	</cfquery>
</cfif>



<form name="form2" action="RepDedCargas.cfm" method="post" onSubmit="return validar(this);">
	
	<table width="100%"  border="0" cellspacing="2" cellpadding="2" align="center">
		<tr>
			<td class="tit" valign="top" align="right">Fecha Inicial:</td>
			<td>
				<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
					<cf_sifcalendario form="form2" value="#form.Fdesde#" name="Fdesde" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="form2" value="" name="Fdesde" tabindex="1">
				</cfif>
			</td>
			<td class="tit" valign="top" align="right">Fecha Final:</td>
				<td>
				<cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
					<cf_sifcalendario form="form2" value="#form.Fhasta#" name="Fhasta" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="form2" value="" name="Fhasta" tabindex="1">
				</cfif>
				</td>
		</tr>
		<tr>
			<td colspan="1" class="tit" valign="top" align="right">Calendario de Pago:&nbsp;</td>
			<td colspan="3">
				<cfif isdefined("rsCP")>
					<cf_rhcalendariopagos form="form2" historicos="true" tcodigo="true" orientacion="1" size="10" descsize="30" conMes="false" conPeriodo="false" query="#rsCP#">
				<cfelse>
					<cf_rhcalendariopagos form="form2" historicos="true" tcodigo="true" orientacion="1" size="10" descsize="30" conMes="false" conPeriodo="false">
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="4">
				<input type="submit" id="consultar" name="consultar" value="Consultar" class="btnAplicar"/>
			</td>
		</tr>
	</table>
</form>
<script language="javascript">
	function validar(formulario)	{
	
	var error_input;
	var error_msg = '';
	
		if (formulario.Fdesde.value == "" && formulario.Fhasta.value=="" && formulario.Tcodigo.value=="") {
		error_msg += "\n - Debe de seleccionar algún filtro.";
		error_input = formulario.Fdesde;
		error_input = formulario.Fhasta;
		error_input = formulario.Tcodigo;
		}	
		if (formulario.Fdesde.value != "" && formulario.Fhasta.value=="") {
		error_msg += "\n - La Fecha Final no puede quedar en blanco.Debe de definir un rango de fechas";
		error_input = formulario.Fhasta;
		}		
		if (formulario.Fdesde.value == "" && formulario.Fhasta.value!="") {
		error_msg += "\n - La Fecha Inicial no puede quedar en blanco.Debe de definir un rango de fechas";
		error_input = Fdesde.McodigoOri;
		}	
			if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		return true		
		}
</script>
 <cfif isdefined("form.consultar")>
  <tr>
    <td class="SubTitulo" align="center"><cf_translate  key="LB_HistoricoDeNominasQueNoHanSidoContabilizadas">Hist&oacute;rico de N&oacute;minas que no han sido Contabilizadas</cf_translate></td>
  </tr>
 </cfif> 
</table>

<cfset filtroLista = ''>
<cfif isdefined('form.Fdesde') and len(trim(form.Fdesde))>
	<cfset filtroLista = filtroLista & "  and  a.RCdesde >=  '#LSDateFormat(form.Fdesde)#'">
</cfif>
<cfif isdefined('form.Fhasta') and len(trim(form.Fhasta))>
	<cfset filtroLista = filtroLista & " and  a.RChasta <= '#LSDateFormat(form.Fhasta)#'">
</cfif>
<cfif isdefined('form.Tcodigo') and len(trim(form.Tcodigo))>
	<cfset filtroLista = filtroLista & " and  c.Tcodigo = '#form.Tcodigo#'">
</cfif>
<cfif isdefined('form.CPid') and len(trim(form.CPid))>
	<cfset filtroLista = filtroLista & " and  b.CPid = #form.CPid#">
</cfif>

<cfif isdefined("form.consultar")>
	<cfinvoke 
	 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="HRCalculoNomina a
													inner join CalendarioPagos b
														on b.CPid = a.RCNid
														and b.Ecodigo = a.Ecodigo
													inner join TiposNomina c
														on c.Tcodigo = b.Tcodigo"/>
			<cfinvokeargument name="columnas" value=" distinct a.RCNid, 
												  	a.Ecodigo, 
												   	rtrim(a.Tcodigo) as Tcodigo, 
												   	b.CPcodigo,
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
												   	c.Tdescripcion
											"/>
			<cfinvokeargument name="desplegar" value="CPcodigo, RCDescripcion, RCdesde, RChasta"/>
			<cfinvokeargument name="etiquetas" value="#LB_CodigoCalendario#,#LB_RelacionDeCalculo#,#LB_FechaInicio#,#LB_FechaHasta#"/>
			<cfinvokeargument name="formatos" value="S,S,D,D"/>
			<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
													 and IDcontable is null
													 and RCestado > 2
													 #filtroLista#
													 order by RCdesde desc"/>
			<cfinvokeargument name="align" value="left, left, left,left"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="keys" value="RCNid"/>
			<cfinvokeargument name="irA" value="RepDedCargas.cfm"/>
			<cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="Cortes" value="Tdescripcion"/>
			<cfinvokeargument name="mostrar_filtro" value="true"/>
			<cfinvokeargument name="filtrar_automatico" value="true"/>
			<cfinvokeargument name="showEmptyListMsg" value="true" />
		</cfinvoke>
	<br>
</cfif>
