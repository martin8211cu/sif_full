<cfset btnNameArriba = "">
<cfset btnValuesArriba= "">
<cfset btnNameAbajo = "">
<cfset btnValuesAbajo= "">
<!---Montos--->

<cfif isdefined ('url.Mensaje')>
	<script language="javascript">
		alert("No se puede ingresar un monto mayor al Monto Solicitado o el saldo de este");
	</script>
</cfif>
<cfif isdefined ('url.Mensaje1')>
	<script language="javascript">
		alert("Este anticipo fue utilizado en una liquidacion y no ha sido aprobado por lo tanto no se puede utilizar");
	</script>
</cfif>

<!---Querys del conlis--->
	<cfquery name="filtronombre" datasource="#session.dsn#">
			select a.TESSAnumero,a.TESSAid,a.TESBid from GASTOE_SoliAnticipos a where TESBid=(select TESBid from TESbeneficiario            where DEid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Benef.emple#">)
	</cfquery>

	<cfquery name="verifica" datasource="#session.dsn#">
		   select count(1) as cantidad  from GASTOE_SoliAnticipos
		   where TESBid=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.TESBid#">
	</cfquery>
		

<cfif isdefined ('url.NumAnticipo')>
<cfset form.NumAnticipo=#url.NumAnticipo#>
	
</cfif>
<cfif isdefined('url.NumAnticipo') and len(trim(url.NumAnticipo) or isdefined('form.TESSANumero'))>
<!---Modos--->
	<cfif isdefined('form.TESSAnumero')>
		<cfset modo = 'CAMBIO'>
		</cfif>
	<cfelse>
		<cfset modo = 'ALTA'>
	</cfif>

<cfif modo EQ 'CAMBIO'>	
		<cfquery datasource="#session.dsn#" name="rsForm">
					select
					TESSAid,
					TESid,
					Ecodigo,
					TESSAnumero,
					TESSAtipoDocumento,
					TESSPid,
					TESSAestado,
					TESSAfechaPagar,
					Mcodigo,
					TESSAtipoCambioManual,
					CFid,
					TESSAtotalPagarOri,
					TESSADescrip,
					TESSAfechaSolicitud,
					UsucodigoSolicitud,
					TESSAidDuplicado,
					TESBid,
					CFcuenta,
					BMUsucodigo,
					ts_rversion,
					M_aplicado,
					TESSAdesde,
					TESSAhasta,
					TESSAsaldo
					from GASTOE_SoliAnticipos a	
					where a.Ecodigo		= #session.Ecodigo#
					and TESSAnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSANumero#">
		</cfquery>
</cfif>

<!---ANTICIPOS--->
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfoutput>
	<table width="85%" align="right" summary="Tabla de entrada" border="0">
 <form method="post" name="form4" action="DetLiquiTag1_sql.cfm"onSubmit="return validarAnt(this);" id="form4"/ >	
<input type="hidden" name="ID_liquidacion" id="ID_liquidacion" value="<cfif isdefined ("form.ID_liquidacion")>#form.ID_liquidacion#</cfif>"/>



<tr>
<td  nowrap="nowrap" align="right" valign="top"><strong>Número de Anticipo:</strong></td>
<td>  

<cfset valuesArrayAnt = ArrayNew(1)>
	<cfif modo EQ "CAMBIO">
		<cfquery datasource="#Session.DSN#" name="rsAnt">
				select a.TESBid,a.TESSAid,a.TESSAnumero,a.TESSAtotalPagarOri,a.TESSAestado,a.TESSADescrip,b.CFcuenta,b.TESSAMonto
				from GASTOE_SoliAnticipos a inner join GASTOE_SoliAntiD b
				on b.TESSAid=a.TESSAid
				where Ecodigo =  #session.Ecodigo#
				and a.TESSAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSAid#">
		</cfquery>
		<cfset ArrayAppend(valuesArrayAnt, rsAnt.TESSAid)>
		<cfset ArrayAppend(valuesArrayAnt, rsAnt.TESSAnumero)>
    	<cfset ArrayAppend(valuesArrayAnt, rsAnt.TESSADescrip)>
		<cfset ArrayAppend(valuesArrayAnt, rsAnt.CFcuenta)>
		<cfset ArrayAppend(valuesArrayAnt, rsAnt.TESSAMonto)>
	</cfif>

		
		<cfif verifica.cantidad eq 0>		
				***No hay anticipos relacionados con ese empleado***
		<cfelse>
				<cf_conlis title="LISTA DE ANTICIPO  EMPLEADO"
				campos = "CFcuenta,ID_concepto_gasto,TESSAMonto,DESC_concepto_gasto,TESSAid,TESSADid" 
				desplegables = "S,N,N,S,N,N" 
				modificables = "S,N,N,S,N,N" 
				size = "10,0,0,40,0,0"
				asignar="CFcuenta,ID_concepto_gasto,TESSAMonto,DESC_concepto_gasto,TESSAid,TESSADid"
				asignarformatos="S,S,M,S,S,S"
				tabla="GASTOE_SoliAntiD a,GASTOE_Cconceptos_degasto b,GASTOE_SoliAnticipos c"
				columnas="a.CFcuenta,a.ID_concepto_gasto,a.TESSAMonto,a.TESSADid,b.DESC_concepto_gasto,b.ID_concepto_gasto,c.TESSAid,a.TESSAid,c.Ecodigo,c.TESSAestado,c.TESBid"
				filtro="c.Ecodigo=#session.Ecodigo# and a.TESSAid=c.TESSAid and c.TESBid=#filtronombre.TESBid# and c.TESSAestado=2 and a.ID_concepto_gasto=b.ID_concepto_gasto "
				desplegar="CFcuenta,TESSAMonto,DESC_concepto_gasto"
				etiquetas="CUENTA FINANCIERA,MONTO,CONCEPTO,"
				formatos="S,S,S"
				align="left,left,left"
				showEmptyListMsg="true"
				EmptyListMsg="El empleado no tiene anticipos cancelados en este momento"
				form="form4"
				width="800"
				height="500"
				valuesarray="#valuesArrayAnt#"
				left="70"
				top="20"
				filtrar_por="CFcuenta,TESSAMonto,DESC_concepto_gasto"
				index="3"			
				funcion="funcCargaMto"
                fparams="TESSAMonto"
				debug="false"/>	</td>
		</cfif>
</tr>

<!---MONTOSaldo--->
<tr>

<td width="173" align="right" valign="top"><strong>Monto Saldo:</strong></td>
<td width="800"> 
<cfif modo EQ 'CAMBIO'>
		<cfquery name="busqueda" datasource="#session.dsn#">
				select TESSAtotalPagarOri,TESSAsaldo from GASTOE_SoliAnticipos
				where TESSAnumero= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.TESSANumero#">
		</cfquery>
		<cfset mivariable=#busqueda.TESSAsaldo#>
		<input type="text" align="left" name="MontoTotal" maxlength="50" value="<cfif modo eq 'CAMBIO'><cfif #mivariable# lte 0>         #NumberFormat(rsForm.TESSAtotalPagarOri,"0.00")#<cfelse>#NumberFormat(rsForm.TESSAsaldo,"0.00")#</cfif></cfif>" onfocus=          "this.value=qf(this); this.select();" tabindex="1" />
		<cfelse>
			  <input type="text" align="center" name="MontoTotal" maxlength="50" disabled="disabled" value=""/>
</cfif>	 </td>
</tr>
<!---MONTOANTICIPO--->
<tr>
<td  nowrap="nowrap" align="right" valign="top"><strong>Monto a Liquidar:</strong></td>
<td> <input type="text" 
name="MontoAnticipo" 
maxlength="50" id="MontoAnticipo"
value="<cfif modo eq 'CAMBIO'><cfif #mivariable# lte 0>#NumberFormat(rsForm.TESSAtotalPagarOri,"0.00")#<cfelse>			              #NumberFormat(rsForm.M_aplicado,"0.00")#</cfif></cfif>" 
onFocus="this.value=qf(this); this.select();" 
tabindex="1" /></td>
</tr>
</table>
<!---BOTONES--->
<table align="right">
<tr><td>
	<cfif modo EQ "ALTA">
		<cfset btnNameArriba 			= "AltaAnt,">
		<cfset btnValuesArriba			= "Agregar,">
		<cfset btnNameArriba 			= btnNameArriba & "Limpiar">
		<cfset btnValuesArriba			= btnValuesArriba &"Limpiar">
		<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">	
		<cfset btnExcluirArriba			=btnExcluirAbajo>
		<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#" >
	<cfelse>
		<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">
		<cfset btnNameAbajo				= btnNameAbajo&",BajaAnt">
		<cfset btnValuesAbajo			= btnValuesAbajo&",Eliminar">
		<cfset btnNameAbajo				= btnNameAbajo&",CambioAnt">
		<cfset btnValuesAbajo			= btnValuesAbajo&",Modificar">
		<cfset btnNameAbajo				= btnNameAbajo&",NuevoAnt">
		<cfset btnValuesAbajo			= btnValuesAbajo&",Nuevo">
		<cf_botones modo="#modo#" includevalues="#btnValuesAbajo#" include="#btnNameAbajo#" exclude="#btnExcluirAbajo#" >
	</cfif>

<!---<cf_botones values="Aprobar,Rechazar" 
								functions="return confirm('Confirma Aprobar?');,return funcRechazar();">--->


</td></tr></table>

</cfoutput>
</form>
<cfoutput>
<script type="text/javascript">
	<!--
		function validarAnt(formulario)	{
			if (!btnSelected('NuevoAnt',document.form4) && !btnSelected('BajaAnt',document.form4)){
				var error_input = null;;
				var error_msg = '';
				if (formulario.MontoAnticipo.value == "") 
				{
					error_msg += "\n - El monto a liquidar no puede quedar en blanco.";
					if (error_input == null) error_input = formulario.MontoAnticipo;
				}
					else if (parseFloat(formulario.MontoAnticipo.value) <= 0)
				{
					error_msg += "\n - El monto del anticipo debe ser mayor que cero.";
					if (error_input == null) error_input = formulario.MontoAnticipo;
				}
				if (formulario.TESSAnumero.value == "") 
				{
					error_msg += "\n - El numero de anticipo no puede quedar en blanco.";
					if (error_input == null) error_input = formulario.TESSAnumero;
				}
				if (formulario.TESSAtotalPagarOri.value == "") 
				{
					error_msg += "\n - El monto del anticipo no puede quedar en blanco.";
					if (error_input == null) error_input = formulario.TESSAtotalPagarOri;
				}
				
				
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					try 
					{
						error_input.focus();
					} 
					catch(e) 
					{}
					
					return false;
				}
				
			}
			
			
			
			return true;
		}

	//-->

	</script>
		
	<script type="text/javascript">

function funcCargaMto(parametro){
document.form4.MontoAnticipo.value = parametro;
document.form4.MontoTotal.value='';
}
</script>

</cfoutput>






